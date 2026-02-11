import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/complaints/view/complaints.dart';
import 'package:payhive/routes/pages.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/error.dart';
import 'package:payhive/utils/widgets/snackbar.dart';

class TransactionHistoryBillPayController extends GetxController {
  List items = [
    {'assets/temp/tata_power_logo.png', 'Tata Power - Delhi'},
    {'assets/temp/tata_power_logo.png', 'Tata Power - Mumbai'},
    {'assets/temp/bses_logo.png', 'BSES Yamuna'},
  ];

  @override
  void onInit() {
    super.onInit();
    isReportClicked.value = false;
    getAllCategories();
  }

  TextEditingController searchedText = TextEditingController();

  Map<String, dynamic>? bankDetails;
  RxBool isLoading = false.obs;
  var bankFormKey = GlobalKey<FormState>();

  getAllCategories() {}

  _showError(String message) {
    update();
    showSnackBar(
      message: message,
      title: "PayLix",
      color: appColors.red,
    );
  }

  RxBool isReportClicked = false.obs;

  reportAnIssue(context) {
    if (isReportClicked.value = true) {
      successDialog(
          context: context,
          message:
              'In case money was debited from your bank account, you will get a refund within 3-4 working days.',
          title: 'Issue Reported!',
          onTap: () {
            Get.to(()=> const Complaints());
          });
    } else {
      isReportClicked.value = true;
      update();
    }
  }
}
