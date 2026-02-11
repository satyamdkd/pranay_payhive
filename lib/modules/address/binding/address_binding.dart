import 'package:get/get.dart';
import 'package:payhive/modules/address/controller/address_controller.dart';
import 'package:payhive/modules/bank/controller/bank_controller.dart';

class AddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddressController());
  }
}
