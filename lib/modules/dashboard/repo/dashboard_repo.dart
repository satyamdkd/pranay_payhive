import 'package:payhive/constants/urls.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/services/network/network.dart';
import 'package:payhive/services/di/di.dart';

class DashboardRepo {
  Network network = Network();

  Future<ApiResults> userData({mobileNumber}) async {
    return await network.getData(
      endPoint: URLs.getUserData,
      queryParameters: {'mobileno': mobileNumber.toString()},
    );
  }

  Future<ApiResults> getDashboardData() async {
    return await network.getData(
      endPoint: URLs.getDashboardData,
    );
  }

  Future<ApiResults> getWalletHistory() async {
    return await network.getData(
      endPoint: URLs.walletHistory,
    );
  }

  Future<ApiResults> generateRazorPayOrderId(amount) async {
    return await network
        .postData(endPoint: URLs.generateRazorPayOrderId, data: {
      'amount': amount,
    });
  }

  Future<ApiResults> generateCashfreeOrderId(amount) async {
    return await network
        .postDataWithJson(endPoint: URLs.generateCashfreeOrderId, data: {
      "order_currency": "INR",
      "order_amount": amount,
      "customer_details": {
        "customer_id": userId.toString(),
        "customer_phone": phoneNumber.toString(),
        "customer_email": userEmail.toString(),
        "customer_name": userName.toString()
      }
    });
  }

  Future<ApiResults> getCashfreeOrderById(id) async {
    return await network.getData(
      endPoint: '${URLs.getCashfreeOrderById}/$id',
    );
  }

  Future<ApiResults> sendPaymentDetails({
    required String method,
    required String status,
    required String amount,
    required String orderId,
    required String paymentCat,
    required String settlementType,
    String? paymentId,
  }) async {
    return await network.postDataWithJson(
      endPoint: URLs.sendPaymentDetailToServer,
      data: {
        "payment_method": method,
        "payment_status_from_app": status,
        "amount": amount,
        "currency": "INR",
        "pay_id": paymentId.toString(),
        "order_id": orderId.toString(),
        "settlement_type": settlementType.toString(),
      },
    );
  }

  Future<ApiResults> sendDataToApi(lat, long, city, state, country) async {
    return await network.postDataWithJson(endPoint: URLs.storeLocation, data: {
      "lat": lat,
      "long": long,
      "city": city,
      "state": state,
      "country": country,
    });
  }

  Future<ApiResults> getBBPSCategories() async {
    return await network
        .postDataWithJson(endPoint: URLs.bbpsGetAllCategories);
  }
}
