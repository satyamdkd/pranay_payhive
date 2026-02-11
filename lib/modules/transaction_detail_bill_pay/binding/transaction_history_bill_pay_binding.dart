import 'package:get/get.dart';
import 'package:payhive/modules/transaction_detail_bill_pay/controller/transaction_detail_bill_pay_controller.dart';
import 'package:payhive/modules/transaction_history_bill_pay/controller/transaction_history_bill_pay_controller.dart';

class TransactionDetailBillPayBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TransactionDetailBillPayController());
  }
}
