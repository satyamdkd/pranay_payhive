import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../routes/pages.dart';
import '../../../../utils/helper/text_capitalization.dart';
import '../repo/electricity_repo.dart';

import 'package:flutter/cupertino.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/services/network/bb_auth_token.dart';
import 'package:payhive/utils/widgets/error.dart';

import '../view/recharge.dart';

class ElectricityController extends GetxController {
  clearAllFields() {
    subId.clear();
    subIdSec.clear();
    subIdThird.clear();
    mobileNumber.clear();
    billFetchRequestRes = null;

    paramName = [];
    values = {};

    isMobileNumberAvailableInParams = false;
  }

  RxInt selectedIndex = (-1).obs;

  ElectricityRepo? repo;
  TextEditingController subId = TextEditingController();
  TextEditingController subIdSec = TextEditingController();
  TextEditingController subIdThird = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController searchedText = TextEditingController();
  TextEditingController amount = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getIPAddress();
    getAllElectricityBillers();
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
  Map<String, dynamic>? allElectricityBillers;
  Map<String, dynamic>? tempElectricityBillers;

  String selectedBiller = '';

  getAllElectricityBillers() async {
    loader.value = true;
    update();

    await BBPSAuthToken.getBBPSAuthToken();

    repo = ElectricityRepo();

    try {
      final response =
          await repo!.getAllCreditCardBillers(catName: 'Electricity');
      if (response is ApiSuccess) {
        allElectricityBillers = response.data;
        tempElectricityBillers = response.data;
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

  getElectricityBillFetchRequest({
    required String billerId,
    required customerParams,
  }) async {
    await BBPSAuthToken.getBBPSAuthToken();
    repo = ElectricityRepo();
    try {
      loader.value = true;
      update();

      final response = await repo!.getCreditCardBillFetchRequest(
        ip: ip,
        billerId: billerId,
        customerParams: customerParams,
        mobileNumber: mobileNumber.text,
        os: Platform.isAndroid ? 'Android' : 'iOS',
      );
      if (response is ApiSuccess) {
        billFetchRequestRes = response.data;
        if (billFetchRequestRes != null &&
            billFetchRequestRes!['data']['data']['refId'] != null) {
          refId = billFetchRequestRes!['data']['data']['refId'];
          Future.delayed(const Duration(seconds: 2), () {
            getElectricityBillFetchResponse();
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

  Future<void> getElectricityBillFetchResponse() async {
    await BBPSAuthToken.getBBPSAuthToken();
    repo = ElectricityRepo();

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
      if (root['data']['data']['status'] == "Failure") {
        return warningDialog(
            message: root['data']['data']['failureReason']['message'] ==
                    'No bill data available'
                ? " There is no pending bills for the entered details. either the bill already paid, or new bill is unavailable"
                : root['data']['data']['failureReason']['message'],
            context: Get.context!,
            title: "No bill due");
      }

      log(jsonEncode(response.data));

      parseBillResponse(response.data);
    } catch (e, st) {
      final msg = (e is ApiFailure)
          ? e.message
          : 'Something went wrong. Please try again.\n$e';
      _showError(msg);
      debugPrint('Electricity Bill Fetch Response API : $e\n$st');
    } finally {
      loader.value = false;
      update();
    }
  }

  String? custName;
  String? dueD;
  double? amountRupees;
  String? billD;

  bool enableAmountTextField = false;

  void parseBillResponse(Map<String, dynamic> response) {
    try {
      if (response['status'] != 1 || response['data'] == null) {
        _showError('Something went wrong, please try again later');
        debugPrint('Error: Invalid response or no data');
        return;
      }

      final data = response['data']['data'];
      if (data == null ||
          data['status'].toString().toLowerCase() != "success") {
        _showError('Something went wrong, please try again later');

        debugPrint('Error: Fetch was not successful');
        return;
      }

      if (data['additionalInfo'] != null) {
        for (var item in data['additionalInfo']) {
          if (item['name'].toString().toLowerCase() == "bill type" &&
              item['value'].toString().toLowerCase() == "prepaid") {
            enableAmountTextField = true;
            debugPrint(".\n\n\n\n${item['value']}\n\n\n\n.");
          }
        }
      } else {
        enableAmountTextField = false;
      }

      final bills = data['bills'];
      if (bills == null || bills.isEmpty) {
        _showError('Something went wrong, please try again later');

        debugPrint('No bills available');
        return;
      }

      /// Loop through bills (in case there are multiple)
      for (var bill in bills) {
        /// Amount in paisa → convert to rupees
        final amountPaisa = bill['amount'];
        double amountRupee = 0;
        if (amountPaisa != null) {
          amountRupee = amountPaisa / 100;
        }

        /// Get bill date and due date safely
        final billDate = bill['billDate'] ?? 'N/A';
        final dueDate = bill['dueDate'] ?? 'N/A';

        /// Customer name if present
        final customerName = (bill['customerName'] != null &&
                bill['customerName'].toString().trim().isNotEmpty)
            ? bill['customerName']
            : 'N/A';

        /// Print / show in UI
        debugPrint('Amount: ₹$amountRupee');
        debugPrint('Bill Date: $billDate');
        debugPrint('Due Date: $dueDate');
        debugPrint('Customer Name: $customerName');

        amountRupees = amountRupee;
        billD = billDate;
        dueD = dueDate;
        custName = customerName;
        amount.text = amountRupees!.toStringAsFixed(2).toString();
        Get.to(() => const Recharge(), transition: Transition.leftToRight);

        update();
      }
    } catch (e, stack) {
      _showError('Something went wrong, please try again later');

      debugPrint('Exception while parsing bill: $e');
      debugPrint(stack.toString());
    }
  }

  Map<String, dynamic>? billFetchResponse;

  String? logo;

  String? refId;

  /// ---- Helper methods ----

  void _showError(String message) {
    errorDialog(
      context: Get.context!,
      message: message,
      title: 'Oops',
    );
  }

  String? billerName;

  Map<String, dynamic>? billPaymentRequestRes;
  var paymentRequestLoader = false.obs;

  billPaymentRequest() async {
    await BBPSAuthToken.getBBPSAuthToken();
    repo = ElectricityRepo();
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
    repo = ElectricityRepo();
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
              '${capitalizeFirstCharacter(selectedBiller)} bill payment has been successfully paid $formattedAmount  with payment reference id $paymentRefId',
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

  List paramName = [];
  Map<String, List<String>> values = {};

  bool isMobileNumberAvailableInParams = false;

  getParams(params) {
    final List<dynamic> customerParams = params['customerParams'] ?? [];

    /// Extract valuesMap (paramName -> list of values)
    final Map<String, List<String>> valuesMap = {};

    for (final param in customerParams) {
      final paramName = param['paramName'];
      final values = param['values'];

      if (paramName != null &&
          values != null &&
          values.toString().trim().isNotEmpty) {
        valuesMap[paramName] =
            values.toString().split(',').map((v) => v.trim()).toList();
      }
    }

    /// Extract all valid paramNames (without dropdowns or 'Amount')
    final List<String> paramNames = customerParams
        .map((param) => param['paramName']?.toString())
        .where((name) =>
            name != null &&
            !valuesMap.keys.contains(name) && // skip if in dropdowns
            !name.toLowerCase().contains('amount')) // skip if name has 'amount'
        .cast<String>()
        .toList();

    paramName = paramNames;

    if (paramName.length > 1) {
      if (paramName[1].toString().toLowerCase().contains('mobile')) {
        isMobileNumberAvailableInParams = true;
      }
    }
    values = valuesMap;

    debugPrint("Param Names (excluding dropdown + Amount):");
    debugPrint(paramNames.toString());

    debugPrint("\n Values Map (dropdowns):");
    debugPrint(valuesMap.isEmpty.toString());
  }
}
