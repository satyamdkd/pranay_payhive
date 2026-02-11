import 'package:get/get.dart';
import 'package:payhive/modules/pay_vendor/controller/vendor_payment_controller.dart';
import 'package:payhive/modules/pos/controller/pos_controller.dart';

class VendorPayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorPaymentController>(() => VendorPaymentController(),
        fenix: true);
  }
}
