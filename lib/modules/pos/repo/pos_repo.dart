import 'dart:io';

import 'package:dio/dio.dart';
import 'package:payhive/constants/urls.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/services/network/network.dart';

class POSRepo {
  Network network = Network();

  Future<ApiResults> posRequest({
    String? posReqId,
    required String date,
    required String cardTypeId,
    required String posCardId,
    required String amount,
    required String serialNumberId,
    required String bankId,
    required String tid,
    required String cardType,
    required String rrn,
    required File? doc,
  }) async {
    final Map<String, dynamic> data = {
      "transaction_date": date,
      "amount": amount,
      'serialno': serialNumberId,
      'bankid': bankId,
      'tid': tid,
      'cardtypeid': cardTypeId,
      'poscardid': posCardId,
      'cardtype': cardType,
      'rrn_number': rrn,
      "charge_slip": doc != null && doc.path.isNotEmpty
          ? await MultipartFile.fromFile(
              doc.path,
              filename: 'charge_slip.${doc.path.split('.').last}',
            )
          : "",
    };

    if (posReqId != null && posReqId.trim().isNotEmpty) {
      data['posreqid'] = posReqId;
    }

    final formData = FormData.fromMap(data);

    return await network.postDataWithFilesNew(
      endPoint: URLs.posRequest,
      formData: formData,
    );
  }

  Future<ApiResults> getBankList(serialNumberId) async {
    return await network
        .getData(endPoint: URLs.getPosBankList, queryParameters: {
      'serialid': serialNumberId.toString(),
    });
  }

  Future<ApiResults> getCardTYPE(bankid) async {
    return await network.getData(endPoint: URLs.getCardType, queryParameters: {
      'bankid': bankid.toString(),
    });
  }

  Future<ApiResults> getAllCards(cardID, bankId) async {
    return await network.getData(endPoint: URLs.getAllCards, queryParameters: {
      'cardtypeid': cardID.toString(),
      'posbankid': bankId.toString(),
    });
  }

  Future<ApiResults> getSerialNumberList() async {
    return await network.getData(
      endPoint: URLs.serialNumberList,
    );
  }
}
