import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:payhive/routes/pages.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/services/network/bb_auth_token.dart';
import 'package:payhive/utils/helper/text_capitalization.dart';
import 'package:payhive/utils/widgets/error.dart';

import '../repo/credit_card_repo.dart';
import '../view/fetched_credit_card_bill.dart';

class CredCardController extends GetxController {
  CreditCardRepo? repo;

  TextEditingController searchedText = TextEditingController();
  TextEditingController lastFourDigitOfCreditCard = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();

  String selectedCreditCard = '';

  @override
  void onInit() {
    super.onInit();

    getAllCreditCardBillers();
    getIPAddress();
  }

  String ip = '';

  getIPAddress() async {
    for (var interface in await NetworkInterface.list()) {
      for (var address in interface.addresses) {
        if (address.type == InternetAddressType.IPv4) {
          ip = address.address.toString();

          if (kDebugMode) {
            print('IP Address: ${address.address}');
          }
        }
      }
    }
  }

  var loader = false.obs;
  Map<String, dynamic>? allCredCardRes;

  getAllCreditCardBillers() async {
    loader.value = true;
    update();
    await BBPSAuthToken.getBBPSAuthToken();
    repo = CreditCardRepo();
    try {
      final response =
          await repo!.getAllCreditCardBillers(catName: 'Credit Card');
      if (response is ApiSuccess) {
        allCredCardRes = response.data;
      } else if (response is ApiFailure) {
        errorDialog(
            context: Get.context!, message: response.message, title: 'Oops');
      }
    } catch (e) {
      if (e is ApiFailure) {
        errorDialog(context: Get.context!, message: e.message, title: 'Oops');
      }

      debugPrint(e.toString());
    } finally {
      loader.value = false;
      update();
    }
  }

  /// --------------------------------------------------------------------------
  /// --------------------------------------------------------------------------
  /// --------------------------------------------------------------------------

  Map<String, dynamic>? billFetchRequestRes;

  getCreditCardBillFetchRequest(
      {required String billerId,
      required String customerParams,
      required String regMobileParams}) async {
    await BBPSAuthToken.getBBPSAuthToken();
    repo = CreditCardRepo();
    try {
      loader.value = true;
      update();

      final response = await repo!.getCreditCardBillFetchRequest(
        ip: ip,
        billerId: billerId,
        mobile: mobileNumber.text,
        last4Digit: lastFourDigitOfCreditCard.text,
        lastFourDigitParams: customerParams,
        os: Platform.isAndroid ? 'Android' : 'iOS',
        regMobileParams: regMobileParams,
      );
      if (response is ApiSuccess) {
        billFetchRequestRes = response.data;
        if (billFetchRequestRes != null &&
            billFetchRequestRes!['data']['data']['refId'] != null) {
          refId = billFetchRequestRes!['data']['data']['refId'];
          Future.delayed(const Duration(seconds: 2), () {
            getCreditCardBillFetchResponse();
          });
        }
      } else if (response is ApiFailure) {
        errorDialog(
            context: Get.context!, message: response.message, title: 'Oops');
        loader.value = false;
        update();
      }
    } catch (e, stack) {
      if (e is ApiFailure) {
        errorDialog(context: Get.context!, message: e.message, title: 'Oops');
      }

      debugPrint(e.toString() + stack.toString());
      loader.value = false;
      update();
    }
  }

  Timer? _timer;

  Future<void> callAPIIntervalForProcessingStatus() async {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getCreditCardBillFetchResponse();
    });
  }

  Map<String, dynamic>? billFetchResponse;

  String? logo;

  getCreditCardBillFetchResponse() async {
    await BBPSAuthToken.getBBPSAuthToken();
    repo = CreditCardRepo();
    try {
      loader.value = true;
      update();

      final response =
          await repo!.getCreditCardBillFetchResponse(refId: refId!);

      /// ---- Handle transport layer ----
      if (response is ApiFailure) {
        return _showError(
            response.message ?? 'Something went wrong. Please try again.');
      }
      if (response is! ApiSuccess) {
        return _showError('Unexpected response received. Please try again.');
      }

      final root = response.data as Map<String, dynamic>?;
      if (root == null) {
        return _showError('Empty response from server.');
      }

      if (root['data']['status'] == 'Processing') {
        callAPIIntervalForProcessingStatus();
        return;
      }

      if (root['data']['status'] == 'Success') {
        _timer?.cancel();
      }

      /// ---- Top-level ----
      final int topStatus =
          (root['status'] is num) ? (root['status'] as num).toInt() : -1;
      final level1 = root['data'] is Map<String, dynamic>
          ? root['data'] as Map<String, dynamic>
          : null;
      if (topStatus != 1 || level1 == null) {
        final msg = (root['msg'] ?? 'Unable to fetch bill details.').toString();
        return _showError(_mapSpecialError(msg));
      }

      /// ---- Mid-level ----
      final bool midSuccess = (level1['success'] == true);
      final level2 = level1['data'] is Map<String, dynamic>
          ? level1['data'] as Map<String, dynamic>
          : null;
      final failureReason = level2?['failureReason'] as Map<String, dynamic>?;

      if (!midSuccess || level2 == null) {
        final msg = failureReason?['message']?.toString() ??
            (level1['message'] ?? level1['msg'] ?? 'Failed to fetch bill.')
                .toString();
        return _showError(_mapSpecialError(msg));
      }

      /// ---- Nested status ----
      if ((level2['status'] ?? '').toString().toLowerCase() != 'success') {
        return _showError(_mapSpecialError(
          _composeFailureMessage(failureReason),
        ));
      }

      /// ---- Bill validation ----
      final bills = level2['bills'];
      if (bills is! List ||
          bills.isEmpty ||
          bills.first is! Map<String, dynamic>) {
        return _showError('No bill data found for the provided details.');
      }

      final bill = bills.first as Map<String, dynamic>;
      if (bill['amount'] == null ||
          bill['billDate'] == null ||
          bill['dueDate'] == null) {
        return _showError(
            'Bill details are incomplete. Please try again later.');
      }

      /// ---- Success ----
      billFetchResponse = response.data;

      /// ---- Default value ----
      var paise = (bill['amount'] is num) ? (bill['amount'] as num).toInt() : 0;
      amountCtrl.text = moneyFromPaise(paise);
      amountCtrl.text =
          amountCtrl.text.replaceAll('₹', '').replaceAll(',', '').trim();

      Get.to(
        () => FetchedCreditCardBill(
          bankName: selectedCreditCard,
          last4Digits: lastFourDigitOfCreditCard.text,
          logo: logo,
        ),
        transition: Transition.leftToRight,
      );
    } catch (e, st) {
      final msg = (e is ApiFailure)
          ? e.message
          : 'Something went wrong. Please try again.\n$e';
      _showError(_mapSpecialError(msg));
      debugPrint('getCreditCardBillFetchResponse error: $e\n$st');
    } finally {
      loader.value = false;
      update();
    }
  }

  /// ---- Helper methods ----

  void _showError(String message) {
    errorDialog(
      context: Get.context!,
      message: message,
      title: 'Oops',
    );
  }

  /// Maps special error messages to user-friendly messages
  String _mapSpecialError(String message) {
    if (message.contains("Invalid combination of Customer parameters")) {
      return "Please enter valid credit card details";
    }
    return message;
  }

  String _composeFailureMessage(Map<String, dynamic>? failureReason) {
    if (failureReason == null) {
      return 'Unable to fetch bill. Please verify details and try again.';
    }

    final parts = <String>[
      failureReason['message']?.toString() ?? '',
      failureReason['code']?.toString() ?? '',
      failureReason['type']?.toString() ?? ''
    ].where((e) => e.isNotEmpty).toList();

    final msg = parts.isEmpty
        ? 'Unable to fetch bill. Please verify details and try again.'
        : parts.join(' • ');

    return _mapSpecialError(msg);
  }

  /// Helpers to read from Map safely

  Map<String, dynamic> get root =>
      (billFetchResponse ?? const {})['data'] is Map<String, dynamic>
          ? (billFetchResponse!['data'] as Map<String, dynamic>)
          : const {};

  Map<String, dynamic> get data => root['data'] is Map<String, dynamic>
      ? (root['data'] as Map<String, dynamic>)
      : const {};

  Map<String, dynamic> get firstBill {
    final bills = data['bills'];
    if (bills is List &&
        bills.isNotEmpty &&
        bills.first is Map<String, dynamic>) {
      return bills.first as Map<String, dynamic>;
    }
    return const {};
  }

  /// Values
  String get customerName => (firstBill['customerName'] ?? '').toString();
  String get billNumber => (firstBill['billNumber'] ?? '').toString();
  String get billDateStr => (firstBill['billDate'] ?? '').toString();
  String get dueDateStr => (firstBill['dueDate'] ?? '').toString();
  int get amountPaise =>
      (firstBill['amount'] is num) ? (firstBill['amount'] as num).toInt() : 0;

  String? get minimumDueFromAdditional {
    final addL = data['additionalInfo'];
    if (addL is List) {
      for (final e in addL) {
        if (e is Map &&
            (e['name'] ?? '').toString().trim().toLowerCase() ==
                'minimum amount due') {
          return (e['value'] ?? '').toString();
        }
      }
    }
    return null;
  }

  String? get maxAmtPermissibleFromAdditional {
    final addL = data['additionalInfo'];
    if (addL is List) {
      for (final e in addL) {
        if (e is Map &&
            (e['name'] ?? '').toString().trim().toLowerCase() ==
                'maximum permissible amount') {
          return (e['value'] ?? '').toString();
        }
      }
    }
    return null;
  }

  String? get currentOutStandingFromAdditional {
    final addL = data['additionalInfo'];

    if (addL is List) {
      for (var item in addL) {
        if (item['name'] != null &&
            item['name'].toString().toLowerCase().contains('outstanding')) {
          return '${item['value']}';
        }
      }
    }
    return null;
  }

  /// Formatting
  String _formatDate(String ymd) {
    if (ymd.isEmpty) return '';
    try {
      final d = DateTime.parse(ymd);
      return DateFormat('dd-MMM-yyyy').format(d);
    } catch (_) {
      return ymd;
    }
  }

  String get billDateUi => _formatDate(billDateStr);
  String get dueDateUi => _formatDate(dueDateStr);

  String get rupee => '₹';

  String moneyFromPaise(int paise) {
    final amount = paise / 100.0;
    final f = NumberFormat.decimalPattern();

    return '$rupee ${f.format(amount)}';
  }

  String moneyFromString(String? str) {
    if (str == null || str.isEmpty) return '$rupee 0';
    final val = double.tryParse(str) ?? 0.0;
    final f = NumberFormat.decimalPattern();

    return '$rupee${f.format(val)}';
  }

  final amountCtrl = TextEditingController();
  String selectedPill = '';

  void setAmountFrom(String source, String numericValue) {
    selectedPill = source;
    amountCtrl.text = numericValue;
    update();
  }

  Map<String, dynamic>? billPaymentRequestRes;
  var paymentRequestLoader = false.obs;

  String? refId;

  billPaymentRequest() async {
    await BBPSAuthToken.getBBPSAuthToken();
    repo = CreditCardRepo();
    try {
      paymentRequestLoader.value = true;
      update();

      final response = await repo!.billPaymentRequest(
        refId: refId!,
        amountInPaise: amountCtrl.text,
        context: Get.context!,
        ip: ip,
        os: Platform.isAndroid ? 'Android' : 'iOS',
      );
      if (response is ApiSuccess) {
        billFetchRequestRes = response.data;
        Future.delayed(const Duration(seconds: 2), () {
          billPaymentResponse();
        });
      } else if (response is ApiFailure) {
        paymentRequestLoader.value = false;
        update();

        errorDialog(
            context: Get.context!,
            message: response.message,
            title: 'Oops',
            onTap: () {
              Get.offAllNamed(Routes.dashboard);
            });
      }
    } catch (e, stack) {
      paymentRequestLoader.value = false;
      update();

      if (e is ApiFailure) {
        errorDialog(
            context: Get.context!,
            message: e.message,
            title: 'Oops',
            onTap: () {
              Get.offAllNamed(Routes.dashboard);
            });
      }

      debugPrint(e.toString() + stack.toString());
    }
  }

  Future<void> billPaymentResponse() async {
    await BBPSAuthToken.getBBPSAuthToken();
    repo = CreditCardRepo();
    try {
      loader.value = true;
      update();

      final response = await repo!.billPaymentResponse(refId: refId!);

      if (response is ApiFailure) {
        loader.value = false;
        update();
        return _showError(
            response.message ?? 'Something went wrong. Please try again.');
      }
      if (response is! ApiSuccess) {
        loader.value = false;
        update();
        return _showError('Unexpected response received. Please try again.');
      }

      /// ---- Parse root ----

      final Map<String, dynamic>? root = response.data;
      if (root == null || root.isEmpty) {
        loader.value = false;
        update();
        return _showError('Empty response from server.');
      }

      /// Expected top-level: { success: bool, traceId: ..., data: {...} }

      if (root['status'].toString() != '1') {
        loader.value = false;
        update();
        _showError('Payment failed, Please try again later');
      }

      /// If top-level success is false OR data missing, try to infer message and exit.

      if (root['data']['data']['status'].toString().toLowerCase() ==
          'success') {
        final Map<String, dynamic>? paymentDetails =
            root['data']['data']['paymentDetails'] is Map<String, dynamic>
                ? root['data']['data']['paymentDetails'] as Map<String, dynamic>
                : null;

        final int? amountPaise = paymentDetails?['amount'] is num
            ? (paymentDetails!['amount'] as num).toInt()
            : null;
        final String? paymentRefId =
            paymentDetails?['paymentRefId']?.toString();
        final String? txnId = root['data']['data']['transactionId']?.toString();

        /// Format amount for UI (you likely already have helpers in controller)

        String formattedAmount;
        try {
          formattedAmount = moneyFromPaise(amountPaise!);
        } catch (_) {
          final amount = (amountPaise! / 100).toStringAsFixed(2);
          formattedAmount = '₹ $amount';
        }

        successDialog(
          context: Get.context!,
          title: 'Payment Successful',
          message:
              '${capitalizeFirstCharacter(selectedCreditCard)} bill payment has been successfully paid ₹ $formattedAmount with payment reference id $paymentRefId and transactions id : $txnId',
          onTap: () => Get.offAllNamed(Routes.dashboard),
        );
      } else {
        loader.value = false;
        update();
        _showError('Payment failed, Please try again later');
      }
    } catch (e, st) {
      final msg = (e is ApiFailure)
          ? (e.message ?? 'Something went wrong. Please try again.')
          : 'Something went wrong. Please try again.\n$e';
      _showError(msg);
      debugPrint('billPaymentResponse error: $e\n$st');
    } finally {
      loader.value = false;
      update();
    }
  }
}
