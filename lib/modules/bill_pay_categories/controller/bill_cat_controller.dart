import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/snackbar.dart';

class BillCategoriesController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    getAllCategories();
  }




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
}
