import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/auth/salary/controller/salaried_controller.dart';
import 'package:payhive/modules/auth/salary/view/aadhar_verify.dart';
import 'package:payhive/modules/auth/salary/view/pan_verify_salary.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DigiLockerAadhar extends GetView<SalariedController> {
  const DigiLockerAadhar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (ctx) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (b, t) {
              Get.offAll(() => AadharVerifySalaried());
            },
            child: Scaffold(
              backgroundColor: appColors.white,
              body: controller.isAadharLoading.value
                  ? Center(
                      child: CupertinoActivityIndicator(
                        color: appColors.primaryLight,
                        radius: height / 10,
                      ),
                    )
                  : SafeArea(
                      child: Center(
                        child: WebViewWidget(
                            controller: controller.webViewController!),
                      ),
                    ),
            ),
          );
        });
  }
}
