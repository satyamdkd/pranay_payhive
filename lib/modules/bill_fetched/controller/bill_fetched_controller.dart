import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/routes/pages.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/error.dart';
import 'package:payhive/utils/widgets/snackbar.dart';

class BillFetchedController extends GetxController {
  Map<String, dynamic>? args;

  @override
  void onInit() {
    super.onInit();
    args = Get.arguments;
    isBillFetched.value = false;
    getAllCategories();
  }

  Map<String, dynamic>? bankDetails;
  RxBool isLoading = false.obs;
  var bankFormKey = GlobalKey<FormState>();

  TextEditingController textEditingController = TextEditingController();

  getAllCategories() {}

  _showError(String message) {
    update();
    showSnackBar(
      message: message,
      title: "PayLix",
      color: appColors.red,
    );
  }

  RxBool isBillFetched = false.obs;

  fetchBill() {
    isBillFetched.value = true;
  }

  payNow(context) {
    successDialog(
        context: context,
        message:
            'Payment of ₹5,000 has been successfully made to account number ABCDE1234E.',
        title: '${args!['category']}',
        onTap: () {
          Get.toNamed(Routes.transactionHistoryBillPay);
        });
  }
}
