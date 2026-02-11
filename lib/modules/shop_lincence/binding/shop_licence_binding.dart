import 'package:get/get.dart';
import '../controller/shop_licence_controller.dart';

class ShopLicenceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShopLicenceController());
  }
}
