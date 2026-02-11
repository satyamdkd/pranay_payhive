import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:payhive/modules/recharge_and_bill_pay/dth/view/recharge.dart';
import '../../../../routes/pages.dart';
import '../../../../utils/helper/text_capitalization.dart';
import '../repo/dth_repo.dart';

import 'package:flutter/cupertino.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/services/network/bb_auth_token.dart';
import 'package:payhive/utils/widgets/error.dart';

class DthController extends GetxController {
  String selectedBiller = '';

  DthRepo? repo;
  TextEditingController mobileOrSubId = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController amount = TextEditingController();

  final List<String> amounts = ["₹200", "₹250", "₹300", "₹400", "₹500"];
  RxInt selectedIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    getIPAddress();
    getAllDTHdBillers();
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
  Map<String, dynamic>? allDTHBillers;

  getAllDTHdBillers() async {
    loader.value = true;
    update();

    await BBPSAuthToken.getBBPSAuthToken();
    repo = DthRepo();

    try {
      final response = await repo!.getAllCreditCardBillers(catName: 'DTH');
      if (response is ApiSuccess) {
        allDTHBillers = response.data;
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

  validateNew({
    firstTitle,
    params,
    billerData,
  }) {
    final inputOne = mobileOrSubId.text.trim();
    final inputTwo = mobileNumber.text.trim();

    if (inputOne.isEmpty) {
      _showError('Please enter $firstTitle.');
      return;
    }
    if (inputTwo.isEmpty) {
      _showError('Please enter registered mobile number.');
      return;
    }

    getDTHBillFetchRequest(
      billerId: billerData['id'],
      params: params,
      subId: inputOne,
      mobile: inputTwo,
    );
  }

  int checkMobileParam(String? paramName, int paramIndex) {
    if (paramName == null) return 2;
    final lowerCaseParam = paramName.toLowerCase();
    if (lowerCaseParam.contains('mobile') ||
        lowerCaseParam.contains('tele') ||
        lowerCaseParam.contains('phone')) {
      return paramIndex;
    }
    return 2;
  }

  Map<String, dynamic>? checkNumberType({
    required String pattern1,
    required String pattern2,
    required int isMobile,
  }) {
    final input = mobileOrSubId.text.trim();
    final map = <String, dynamic>{};

    late RegExp mobileRegex;
    late RegExp subscriberRegex;

    if (isMobile == 1) {
      map['pattern'] = "1";
      mobileRegex = RegExp(pattern1);
      subscriberRegex = RegExp(pattern2);
    } else if (isMobile == 2) {
      map['pattern'] = "2";
      mobileRegex = RegExp(pattern2);
      subscriberRegex = RegExp(pattern1);
    } else {
      return null;
    }

    if (mobileRegex.hasMatch(input)) {
      map['value'] = "Mobile";
    } else if (subscriberRegex.hasMatch(input)) {
      map['value'] = "Subscriber";
    } else {
      return null;
    }

    return map;
  }

  Map<String, dynamic>? billFetchRequestRes;

  Future<void> getDTHBillFetchRequest({
    required String billerId,
    required String params,
    required String subId,
    required String mobile,
  }) async {
    await BBPSAuthToken.getBBPSAuthToken();
    repo = DthRepo();

    try {
      loader.value = true;
      update();

      final response = await repo!.getCreditCardBillFetchRequest(
        ip: ip,
        billerId: billerId,
        params: params,
        subId: subId,
        mobile: mobile,
        os: Platform.isAndroid ? 'Android' : 'iOS',
      );

      if (response is ApiSuccess) {
        billFetchRequestRes = response.data;

        final ref = billFetchRequestRes?['data']?['data']?['refId'];
        if (ref != null) {
          refId = ref;
          Future.delayed(const Duration(seconds: 1), getDTHBillFetchResponse);
        }
      } else if (response is ApiFailure) {
        errorDialog(
          context: Get.context!,
          message: response.message,
          title: 'Oops',
        );
        loader.value = false;
        update();
      }
    } catch (e, stack) {
      debugPrint('DTH Bill Fetch Request API : $e $stack');

      if (e is ApiFailure) {
        errorDialog(context: Get.context!, message: e.message, title: 'Oops');
      }

      loader.value = false;
      update();
    }
  }

  Map<String, dynamic>? billFetchResponse;

  String? billerName;
  Map<String, dynamic>? billerData;

  Future<void> getDTHBillFetchResponse() async {
    await BBPSAuthToken.getBBPSAuthToken();
    repo = DthRepo();

    try {
      loader.value = true;
      update();

      final response =
          await repo!.getCreditCardBillFetchResponse(refId: refId!);

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

      Get.to(() => const Recharge(), transition: Transition.leftToRight);
    } catch (e, st) {
      final msg = (e is ApiFailure)
          ? e.message
          : 'Something went wrong. Please try again.\n$e';
      _showError(msg);
      debugPrint('Credit Card Bill Fetch Response API : $e\n$st');
    } finally {
      loader.value = false;
      update();
    }
  }

  String? logo;

  String? refId;

  void _showError(String message) {
    errorDialog(
      context: Get.context!,
      message: message,
      title: 'Oops',
    );
  }

  Map<String, dynamic>? billPaymentRequestRes;
  var paymentRequestLoader = false.obs;

  billPaymentRequest() async {
    await BBPSAuthToken.getBBPSAuthToken();
    repo = DthRepo();
    try {
      paymentRequestLoader.value = true;
      update();

      final response = await repo!.billPaymentRequest(
        refId: refId!,
        amountInPaise: amount.text,
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
    repo = DthRepo();
    try {
      paymentRequestLoader.value = false;
      update();

      final response = await repo!.billPaymentResponse(refId: refId!);

      if (response is ApiFailure) {
        paymentRequestLoader.value = false;
        update();
        return _showError(
            response.message ?? 'Something went wrong. Please try again.');
      }
      if (response is! ApiSuccess) {
        paymentRequestLoader.value = false;
        update();
        return _showError('Unexpected response received. Please try again.');
      }

      /// ---- Parse root ----

      final Map<String, dynamic>? root = response.data;
      if (root == null || root.isEmpty) {
        paymentRequestLoader.value = false;
        update();
        return _showError('Empty response from server.');
      }

      /// Expected top-level: { success: bool, traceId: ..., data: {...} }

      if (root['status'].toString() != '1') {
        paymentRequestLoader.value = false;
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
              '${capitalizeFirstCharacter(selectedBiller)} bill payment has been successfully paid ₹ $formattedAmount  with payment reference id $paymentRefId',
          onTap: () => Get.offAllNamed(Routes.dashboard),
        );
      } else {
        paymentRequestLoader.value = false;
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
      paymentRequestLoader.value = false;
      update();
    }
  }

  String get rupee => '₹';

  String moneyFromPaise(int paise) {
    final amount = paise / 100.0;
    final f = NumberFormat.decimalPattern();

    return '$rupee ${f.format(amount)}';
  }

  Map<String, dynamic>? getInputFieldConfigDynamic(
      List<dynamic> customerParams) {
    if (customerParams.isEmpty) return null;

    List<dynamic> visibleParams = customerParams.where((p) {
      final paramName = (p['paramName'] as String).toLowerCase();
      return p['visibility'] == true && !paramName.contains('amount');
    }).toList();

    List<int>? parseLengthFromRegex(String? regex) {
      if (regex == null) return null;
      final lengthMatch = RegExp(r'\{(\d+),(\d+)\}').firstMatch(regex);
      if (lengthMatch != null && lengthMatch.groupCount == 2) {
        final min = int.tryParse(lengthMatch.group(1) ?? '');
        final max = int.tryParse(lengthMatch.group(2) ?? '');
        if (min != null && max != null) return [min, max];
      }
      final fixedLengthMatch = RegExp(r'\{(\d+)\}').firstMatch(regex);
      if (fixedLengthMatch != null && fixedLengthMatch.groupCount == 1) {
        final len = int.tryParse(fixedLengthMatch.group(1) ?? '');
        if (len != null) return [len, len];
      }
      return null;
    }

    List<dynamic> numericFixedLengthParams = visibleParams.where((p) {
      return p['dataType'] == 'NUMERIC' &&
          p['minLength'] != null &&
          p['maxLength'] != null;
    }).toList();

    List<dynamic> selectedParams = numericFixedLengthParams.isNotEmpty
        ? numericFixedLengthParams.take(2).toList()
        : visibleParams.take(2).toList();

    String getLength(dynamic param) {
      if (param['minLength'] != null &&
          param['maxLength'] != null &&
          param['minLength'] == param['maxLength']) {
        return param['maxLength'].toString();
      }
      List<int>? lengthRange = parseLengthFromRegex(param['regex']);
      if (lengthRange != null && lengthRange.length == 2) {
        return lengthRange[0] == lengthRange[1]
            ? lengthRange[0].toString()
            : '${lengthRange[0]}-${lengthRange[1]}';
      }
      return '';
    }

    if (selectedParams.length == 2) {
      var param1 = selectedParams[0];
      var param2 = selectedParams[1];

      String type1 = param1['dataType'] == 'NUMERIC' ? 'number' : 'text';
      String type2 = param2['dataType'] == 'NUMERIC' ? 'number' : 'text';

      String length1 = getLength(param1);
      String length2 = getLength(param2);

      String? regex1 = param1['regex'];
      String? regex2 = param2['regex'];

      return {
        'paramName1': param1['paramName'],
        'tobenetered1': type1,
        'length1': length1,
        if (regex1 != null) 'regex1': regex1,
        'paramName2': param2['paramName'],
        'tobenetered2': type2,
        'length2': length2,
        if (regex2 != null) 'regex2': regex2,
      };
    } else if (selectedParams.length == 1) {
      var param = selectedParams[0];
      String type = param['dataType'] == 'NUMERIC' ? 'number' : 'text';

      String length = getLength(param);
      String? regex = param['regex'];

      return {
        'paramName1': param['paramName'],
        'tobenetered1': type,
        'length1': length,
        if (regex != null) 'regex1': regex,
      };
    }

    return null;
  }

  String getLastValue(String input) {
    if (input.contains('-')) {
      final parts = input.split('-');
      return parts.last.trim();
    }
    return input.trim();
  }
}
