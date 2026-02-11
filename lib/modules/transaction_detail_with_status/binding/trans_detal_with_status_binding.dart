import 'package:get/get.dart';
import '../controller/trans_detal_with_status_controller.dart';

class TransactionDetailWithStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TransactionDetailWithStatusController());
  }
}
