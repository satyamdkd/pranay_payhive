import 'dart:io';

import 'package:dio/dio.dart';
import 'package:payhive/constants/urls.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/services/network/network.dart';

class ShopLicenceRepo {
  Network network = Network();

  Future<ApiResults> addShopLicence({
    required String licence,
    required File? shoplicence,
  }) async {
    FormData formData = FormData.fromMap(
      {
        "licence": licence,
        "shoplicence": shoplicence != null && shoplicence.path.isNotEmpty
            ? await MultipartFile.fromFile(
                shoplicence.path,
                filename: 'charge_slip.${shoplicence.path.split('.').last}',
              )
            : "",
      },
    );

    return await network.postDataWithFilesNew(
      endPoint: URLs.shopLicence,
      formData: formData,
    );
  }
}
