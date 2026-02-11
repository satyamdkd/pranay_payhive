import 'package:get/get.dart';
import '../controller/fastag_controller.dart';

class FastagBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FastagController());
  }
}
