import 'package:get/get.dart';
import '../controller/electricity_controller.dart';

class ElectricityBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ElectricityController());
  }
}
