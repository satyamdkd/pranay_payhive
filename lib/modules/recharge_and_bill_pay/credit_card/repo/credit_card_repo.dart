import 'package:payhive/constants/urls.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/services/network/network.dart';
import 'package:payhive/utils/helper/date_time.dart';
import 'package:payhive/utils/helper/text_capitalization.dart';

class CreditCardRepo {
  Network network = Network();

  Future<ApiResults> getAllCreditCardBillers({
    required String catName,
  }) async {
    return await network.postDataWithJson(
        endPoint: "${URLs.bbpsGetAllBillers}?categoryName=$catName");
  }

  Future<ApiResults> getCreditCardBillFetchRequest({
    required String ip,
    required String billerId,
    required String mobile,
    required String last4Digit,
    required String lastFourDigitParams,
    required String regMobileParams,
    required String os,
  }) async {
    return await network
        .postDataWithJson(endPoint: URLs.bbpsBillFetchRequest, data: {
      "agent": {
        "channel": "MOB",

        /// "id": "AS01AS77MOBBAM216659",
        "ip": ip,
        "app": "Payhive",
        "imei": "123456789012345",
        "os": os
      },
      "biller": {"id": billerId},
      "customer": {
        "customerParams": [
          {"name": regMobileParams, "value": mobile.trim()},
          {"name": lastFourDigitParams, "value": last4Digit.trim()}
        ],
        "mobile": mobile.trim()
      }
    });
  }

  Future<ApiResults> getCreditCardBillFetchResponse({
    required String refId,
  }) async {
    return await network.postDataWithJson(
        endPoint: URLs.bbpsBillFetchResponse, data: {"refId": refId});
  }

  Future<ApiResults> billPaymentRequest({
    required String refId,
    required String amountInPaise,
    context,
    required String ip,
    required String os,
  }) async {
    if (int.parse(
            '${double.parse(amountInPaise) * 100}'.trim().split('.').first) ==
        0) {
      return ApiFailure('Please enter valid amount');
    }

    int paise = int.parse(
        '${double.parse(amountInPaise) * 100}'.trim().split('.').first);

    return await network
        .postDataWithJson(endPoint: URLs.bbpsPaymentRequest, data: {
      "agent": {
        "channel": "MOB",
        "ip": ip,
        "app": "Payhive",
        "imei": "123456789012345",
        "os": os
      },
      "refId": refId,
      "paymentDetails": {
        "mode": "UPI",
        "paymentRefId": generateIdTimestampBased(),
        "amount": paise,
        "timestamp": formatNowUtcIso8601()
      }
    });
  }

  Future<ApiResults> billPaymentResponse({
    required String refId,
  }) async {
    return await network.postDataWithJson(
        endPoint: URLs.bbpsPaymentResponse, data: {"refId": refId});
  }
}
