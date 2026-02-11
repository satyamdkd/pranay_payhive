import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/dashboard/controller/dashboard_controller.dart';

class PersonalDetailsController extends GetxController {
  DashBoardController? dashboardController;

  @override
  void onInit() {
    super.onInit();
    dashboardController = Get.arguments;
    setData();
  }

  RxDouble maxHeight = 0.0.obs;
  onClicked() {
    if (maxHeight.value != 300.0) {
      maxHeight.value = 300.0;
    } else {
      maxHeight.value = 0.0;
    }
    update();
  }

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController incomeSource = TextEditingController();
  TextEditingController accountType = TextEditingController();
  TextEditingController businessType = TextEditingController();
  TextEditingController formOfBusiness = TextEditingController();
  TextEditingController turnover = TextEditingController();
  TextEditingController gst = TextEditingController();
  TextEditingController pan = TextEditingController();
  TextEditingController aadhar = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController bank = TextEditingController();
  TextEditingController ifsc = TextEditingController();

  setData() async {
    name.text = dashboardController!.userDetails!['data']['name'] ?? '';
    phone.text = dashboardController!.userDetails!['data']['phone'] ?? '';
    email.text = dashboardController!.userDetails!['data']['email'] ?? '';
    incomeSource.text = dashboardController!.userDetails!['data']['name'] ?? '';
    accountType.text =
        dashboardController!.userDetails!['data']['account_type'] ?? '';
    businessType.text =
        dashboardController!.userDetails!['data']['bussiness_type'] ?? '';
    formOfBusiness.text =
        dashboardController!.userDetails!['data']['form_bussiness'] ?? '';
    turnover.text = dashboardController!.userDetails!['data']['turnover'] ?? '';
    gst.text = dashboardController!.userDetails!['data']['gst'] ?? '';
    pan.text =
        dashboardController!.userDetails!['data']['panno']['pan_number'] ?? '';
    if (dashboardController!.userDetails!['data']['address'] != null) {
      address.text =
          dashboardController!.userDetails!['data']['address']['address'] ?? '';
    }

    aadhar.text =
        dashboardController!.userDetails!['data']['aadhar']['aadhar'] ?? '';
    if (dashboardController!.userDetails!['data']['bank'] != null) {
      bank.text = dashboardController!.userDetails!['data']['bank']
              ['accountnumber'] ??
          '';
      ifsc.text =
          dashboardController!.userDetails!['data']['bank']['ifsc'] ?? '';
    }
  }

  getData() async {}
}
