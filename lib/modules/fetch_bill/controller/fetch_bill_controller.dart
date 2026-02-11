import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/snackbar.dart';

class FetchBillController extends GetxController {
  late final String billCategory;

  List items = [
    {'assets/temp/tata_power_logo.png', 'Tata Power - Delhi'},
    {'assets/temp/tata_power_logo.png', 'Tata Power - Mumbai'},
    {'assets/temp/bses_logo.png', 'BSES Yamuna'},
  ];

  @override
  void onInit() {
    super.onInit();

    billCategory = Get.arguments;
    update();
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
      title: "Payhive",
      color: appColors.red,
    );
  }
}
