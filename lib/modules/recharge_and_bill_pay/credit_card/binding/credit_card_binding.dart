import 'package:get/get.dart';
import '../controller/credit_card_controller.dart';

class CreditCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CredCardController());
  }
}
