import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/bank/repo/bank_repo.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/services/network/network.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/snackbar.dart';

class BankController extends GetxController {
  BankRepo repo = BankRepo();

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  TextEditingController fullName = TextEditingController();
  TextEditingController bankAccountNumber = TextEditingController();
  TextEditingController ifsc = TextEditingController();

  Map<String, dynamic>? bankDetails;
  RxBool isLoadingBank = false.obs;
  var bankFormKey = GlobalKey<FormState>();

  validateBankForm() {
    final isValid = bankFormKey.currentState!.validate();
    if (!isValid) {
      return null;
    } else {
      addBank();
    }

    update();
  }

  getUserData() async {}

  addBank() async {
    try {
      isLoadingBank.value = true;
      update();
      final response = await repo.addBankAccount(
        // name: fullName.text,
        accountNumber: bankAccountNumber.text.toString(),
        ifsc: ifsc.text.toString(),
      );

      if (response is ApiSuccess) {
        final data = response.data;
        if (data['status'] == 1) {
          bankDetails = data['data'];
        } else {
          _showError(data['msg']);
        }
      } else if (response is ApiFailure) {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoadingBank.value = false;
      update();
    }
  }

  _showError(String message) {
    fullName.clear();
    bankAccountNumber.clear();
    ifsc.clear();
    update();
    showSnackBar(
      message: message,
      title: "Payhive",
      color: appColors.red,
    );
  }
}
