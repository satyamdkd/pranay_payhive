import 'package:get/get.dart';
import 'package:payhive/modules/reverify_pan/controller/reverify_pan_controller.dart';

class ReverifyPanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ReverifyPanController());
  }
}
