import 'package:get/get.dart';
import 'package:payhive/modules/bill_fetched/controller/bill_fetched_controller.dart';
import 'package:payhive/modules/fetch_bill/controller/fetch_bill_controller.dart';

class BillFetchedBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BillFetchedController());
  }
}
