
import 'package:dio/dio.dart';
import 'package:payhive/constants/urls.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/services/network/network.dart';

import '../../../services/di/di.dart';

class VendorPayRepo {
  Network network = Network();

  Future<ApiResults> addBeneficiary({
    required String ifsc,
    required String accountNumber,
    required String phone,
    String? id,
    String? reason,
  }) async {
    final Map<String, dynamic> data = {
      "ifsc": ifsc.trim(),
      "accountNumber": accountNumber.trim(),
      'phone': phone.trim(),
    };

    if (reason != null && reason.trim().isNotEmpty) {
      data['beneficiaryid'] = id;
      data['reason'] = reason;
    }

    final formData = FormData.fromMap(data);

    return await network.postDataWithFilesNew(
      endPoint: URLs.addBeneficiary,
      formData: formData,
    );
  }

  Future<ApiResults> getBeneficiaryList() async {
    return await network.getData(endPoint: URLs.getBeneficiaryBankList);
  }

  Future<ApiResults> addRemoveFavouriteBeneficiary(favorite) async {
    return await network
        .getData(endPoint: URLs.getBeneficiaryBankList, queryParameters: {
      'favorite': favorite.toString(),
    });
  }

  Future<ApiResults> deleteBeneficiary(id) async {
    final Map<String, dynamic> data = {"beneficiaryid": id};
    final formData = FormData.fromMap(data);

    return await network.postDataWithFilesNew(
      endPoint: URLs.deleteBeneficiary,
      formData: formData,
    );
  }

  Future<ApiResults> transferMoneyToVendor({
    required String amount,
    required String id,
  }) async {
    return await network.postDataWithJson(
      endPoint: URLs.walletPayout,
      data: {
        "fund_account_id": id,
        "amount": double.parse(amount),
        "currency": "INR",
        "mode": "IMPS",
        "purpose": "refund",
        "queue_if_low_balance": true,
        "reference_id": "Acme Transaction ID 12345",
        "narration": "Acme Corp Fund Transfer",
        "notes": {
          "notes_key_1": "Tea, Earl Grey, Hot",
          "notes_key_2": "Tea, Earl Grey… decaf."
        }
      },
    );
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
}
