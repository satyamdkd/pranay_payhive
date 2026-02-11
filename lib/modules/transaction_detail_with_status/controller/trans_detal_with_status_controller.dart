import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repo/trans_detal_with_status_repo.dart';

import 'package:flutter/cupertino.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/utils/widgets/error.dart';

class TransactionDetailWithStatusController extends GetxController {
  TransactionDetailWithStatusRepo repo = TransactionDetailWithStatusRepo();

  String? orderId;
  String? source;

  @override
  void onInit() {
    super.onInit();

    final id = Get.arguments;
    if (id != null) {
      orderId = id['id'];
      source = id['source'];

      getTransactionWithStatus();
    }
  }

  var loader = false.obs;
  Map<String, dynamic>? transactionDetails;

  getTransactionWithStatus() async {
    loader.value = true;
    update();

    try {
      final response = await repo.getTransDetail(
        id: orderId!,
        source: source!,
      );

      if (response is ApiSuccess) {
        transactionDetails = response.data;
        log(jsonEncode(response.data));
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

  Timer? _timer;

  Future<void> callAPIIntervalForProcessingStatus() async {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {});
  }

  void _showError(String message) {
    errorDialog(
      context: Get.context!,
      message: message,
      title: 'Oops',
    );
  }
}
