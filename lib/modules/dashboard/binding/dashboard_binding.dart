import 'package:get/get.dart';
import 'package:payhive/modules/dashboard/controller/dashboard_controller.dart';

class DashBoardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashBoardController());
  }
}
