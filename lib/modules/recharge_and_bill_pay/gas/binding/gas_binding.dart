import 'package:get/get.dart';
import '../controller/gas_controller.dart';

class GasBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GasController());
  }
}
