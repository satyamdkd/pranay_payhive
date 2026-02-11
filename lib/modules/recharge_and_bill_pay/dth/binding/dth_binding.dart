import 'package:get/get.dart';
import '../controller/dth_controller.dart';

class DthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DthController());
  }
}
