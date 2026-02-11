import 'package:get/get.dart';
import 'package:payhive/modules/list_pos_req/controller/list_pos_controller.dart';

class ListPosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListPosController>(() => ListPosController(), fenix: true);
  }
}
