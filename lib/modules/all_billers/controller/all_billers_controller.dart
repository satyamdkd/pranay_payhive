import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/bank/repo/bank_repo.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/snackbar.dart';

class AllBillersController extends GetxController {
  BankRepo repo = BankRepo();

  @override
  void onInit() {
    super.onInit();
    getAllCategories();
  }

  TextEditingController search = TextEditingController();

  Map<String, dynamic>? bankDetails;
  RxBool isLoading = false.obs;
  var bankFormKey = GlobalKey<FormState>();

  getAllCategories() {}

  _showError(String message) {
    update();
    showSnackBar(
      message: message,
      title: "Payhive",
      color: appColors.red,
    );
  }
}
