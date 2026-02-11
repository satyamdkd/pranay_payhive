import 'package:get/get.dart';
import 'package:payhive/modules/all_billers/controller/all_billers_controller.dart';

class AllBillersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AllBillersController());
  }
}
