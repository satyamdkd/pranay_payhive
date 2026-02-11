import 'package:get/get.dart';
import 'package:payhive/modules/bill_pay_categories/controller/bill_cat_controller.dart';

class BillCatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BillCategoriesController());
  }
}
