import 'package:get/get.dart';
import 'package:payhive/modules/transaction_history_bill_pay/controller/transaction_history_bill_pay_controller.dart';

class TransactionHistoryBillPayBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TransactionHistoryBillPayController());
  }
}
