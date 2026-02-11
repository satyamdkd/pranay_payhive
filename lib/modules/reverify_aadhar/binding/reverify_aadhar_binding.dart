import 'package:get/get.dart';

import '../controller/reverify_aadhar_controller.dart';

class ReverifyAadharBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ReverifyAadharController());
  }
}
