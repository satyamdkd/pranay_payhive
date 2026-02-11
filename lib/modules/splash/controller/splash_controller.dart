import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:payhive/services/native_code/lock_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:get/get.dart';
import 'package:payhive/services/di/di.dart';

import '../../../routes/pages.dart';
import '../widgets/biometric_try_again_sheet.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    setToken();
  }

  setToken() async {
    try {
      var tokenMap = await sharedPref.getToken();
      token = tokenMap.toString();
    } finally {
      navigate();
    }
  }

  navigate() async {
    Timer(const Duration(milliseconds: 2800), () async {
      var userMap = await sharedPref.getUser();

      debugPrint('USER TOKEN & ID FROM SPLASH SCREEN : $token $userMap');

      debugPrint(userMap.toString());
      if (userMap != null && userMap.toString() != "null") {
        if (jsonDecode(userMap)['id'] != null &&
            jsonDecode(userMap)['id'].toString() != "" &&
            token.toString() != 'null' &&
            token.toString() != '') {
          Get.offAllNamed(Routes.dashboard);

          /// authenticateBiometric();
        }
      } else {
        if (await sharedPref.getTempMobile() == null) {
          PermissionStatus permission = await Permission.phone.request();

          salariedController.isPhonePermissionGranted.value =
              permission.isGranted;

          if (salariedController.isPhonePermissionGranted.value == false) {
            salariedController.isIgnoringMobile.value = true;
          }

          salariedController.update();

          Get.offAllNamed(Routes.salaryReg);
        }
      }
    });
  }

  bool? authenticated;

  authenticateBiometric() async {
    try {
      AuthResult result = await NativeBiometricAuthService.authenticate();

      if (result.isSuccess == true) {
        authenticated = true;
      } else if (result.errorCode == 'USER_CANCEL') {
        authenticated = false;
      } else if (result.errorCode != 'USER_CANCEL' &&
          result.encounteredError == true) {
        authenticated = null;
        Get.offAllNamed(Routes.dashboard);
        return;
      } else {
        authenticated = null;
      }
    } catch (e) {
      Get.offAllNamed(Routes.dashboard);
    }

    if (authenticated == true) {
      Get.offAllNamed(Routes.dashboard);
    } else if (authenticated == false) {
      showUnlockBottomSheet();
    } else {
      Get.offAllNamed(Routes.dashboard);
    }
  }

  void showUnlockBottomSheet() {
    showModalBottomSheet(
      context: Get.context!,
      useSafeArea: true,
      isScrollControlled: false,
      enableDrag: false,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) => AnimatedUnlockBottomSheet(
        onTryAgain: () {
          Get.back();
          authenticateBiometric();
        },
        onCancel: () async {
          exit(0);
        },
      ),
    );
  }

  autoLogout() async {
    salariedController.mobileController.clear();
    salariedController.isLoginScreenDisabled.value = false;
    salariedController.isOTPShotPhone.value = false;
    salariedController.isIgnoringMobile.value = false;
    salariedController.isEditingPhone.value = true;
    await sharedPref.logout();
    Get.offAllNamed(Routes.splash);
  }
}
