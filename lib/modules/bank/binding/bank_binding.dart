import 'package:get/get.dart';
import 'package:payhive/modules/bank/controller/bank_controller.dart';

class BankBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BankController());
  }
}
