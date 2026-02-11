import 'package:get/get.dart';
import 'package:payhive/modules/wallet_history/controller/wallet_history_controller.dart';

class WalletHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WalletHistoryController());
  }
}
