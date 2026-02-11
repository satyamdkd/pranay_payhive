import 'package:get/get.dart';
import 'package:payhive/modules/fetch_bill/controller/fetch_bill_controller.dart';

class FetchBillBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FetchBillController());
  }
}
