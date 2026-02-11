import 'dart:io';

import 'package:dio/dio.dart';
import 'package:payhive/constants/urls.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/services/network/network.dart';

class ListPOSRepo {
  Network network = Network();

  Future<ApiResults> posRequest({
    required String date,
    required String amount,
    required String bankId,
    required String mid,
    required String cardType,
    required String rrn,
    required File? doc,
  }) async {
    FormData formData = FormData.fromMap(
      {
        "transaction_date": date,
        "amount": amount,
        'bankid': bankId,
        'mid': mid,
        'cardtype': cardType,
        'rrn_number': rrn,
        "charge_slip": doc != null && doc.path != ''
            ? await MultipartFile.fromFile(
                doc.path,
                filename: 'charge_slip${".${doc.path.split('.').last}"}',
              )
            : "",
      },
    );

    return await network.postDataWithFilesNew(
      endPoint: URLs.posRequest,
      formData: formData,
    );
  }

  Future<ApiResults> getPosRequestList() async {
    return await network.getData(
      endPoint: URLs.getPosRequestList,
    );
  }
}
