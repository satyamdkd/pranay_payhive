import 'package:get/get.dart';
import 'package:payhive/modules/personal_details/controller/personal_detail_controller.dart';

class PersonalDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PersonalDetailsController());
  }
}
