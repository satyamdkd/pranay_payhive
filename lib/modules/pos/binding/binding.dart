import 'package:get/get.dart';
import 'package:payhive/modules/pos/controller/pos_controller.dart';

class PosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosController>(() => PosController(), fenix: true);
  }
}
