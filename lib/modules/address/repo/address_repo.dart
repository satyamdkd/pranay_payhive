import 'dart:io';

import 'package:dio/dio.dart';
import 'package:payhive/constants/urls.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/services/network/network.dart';

class AddressRepo {
  Network network = Network();

  Future<ApiResults> addAddress({
    required String address,
    required String completeAddress,
    required String city,
    required String state,
    required String country,
    required String pincode,
    required String landmark,
    required String latitude,
    required String longitude,
    required File? addressproof,
  }) async {
    FormData formData = FormData.fromMap(
      {
        "address": address,
        "complete_address": completeAddress,
        "city": city,
        'state': state,
        "country": country,
        "pincode": pincode.toString(),
        'landmark': landmark,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        "addressproof": addressproof != null && addressproof.path != ''
            ? await MultipartFile.fromFile(
                addressproof.path,
                filename: 'profile${".${addressproof.path.split('.').last}"}',
              )
            : "",
      },
    );

    return await network.postDataWithFilesNew(
      endPoint: URLs.addAddress,
      formData: formData,
    );
  }

  Future<ApiResults> deleteAddress({
    required String addressId,
  }) async {
    FormData formData = FormData.fromMap({"addressid": addressId});

    return await network.postDataWithFilesNew(
      endPoint: URLs.deleteAddress,
      formData: formData,
    );
  }

  Future<ApiResults> defaultAddress({
    required String addressId,
  }) async {
    FormData formData = FormData.fromMap({"addressid": addressId});

    return await network.postDataWithFilesNew(
      endPoint: URLs.defaultAddress,
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
