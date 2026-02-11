import 'dart:io';

import 'package:dio/dio.dart';
import 'package:payhive/constants/urls.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/services/network/network.dart';

import '../../../services/di/di.dart';

class BankRepo {
  Network network = Network();

  Future<ApiResults> addBankAccount({
    // required String name,
    required String ifsc,
    required String accountNumber,
  }) async {
    FormData formData = FormData.fromMap(
      {
        "fullname": userName,
        "phone": phoneNumber,
        // "fullname": name,
        "ifsc": ifsc,
        'accountNumber': accountNumber,
      },
    );

    return await network.postDataWithFilesNew(
      endPoint: URLs.addBank,
      formData: formData,
    );
  }

  Future<ApiResults> userUserData({mobileNumber}) async {
    return await network.getData(
      endPoint: URLs.getUserData,
      queryParameters: {'mobileno': mobileNumber.toString()},
    );
  }
}
