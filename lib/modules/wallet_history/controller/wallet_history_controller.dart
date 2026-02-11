import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/wallet_history/repo/wallet_history_repo.dart';
import 'package:payhive/services/network/api_result.dart';

class WalletHistoryController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    walletHistory();
  }
  int selectedIndex = 0;

  RxBool moreInfoClicked = false.obs;

  double height = 0;

  double width = 0;

  WalletHistoryRepo repo = WalletHistoryRepo();

  RxBool walletHistoryLoading = false.obs;

  Map<String, dynamic>? walletHistoryRes;

  walletHistory() async {
    try {
      walletHistoryLoading.value = true;
      update();

      final response = await repo.getWalletHistory();

      if (response is ApiSuccess) {
        walletHistoryRes = response.data;
      } else if (response is ApiFailure) {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      walletHistoryLoading.value = false;
      update();
    }
  }
}
