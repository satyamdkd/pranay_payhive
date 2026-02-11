import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/modules/auth/salary/controller/salaried_controller.dart';
import 'package:payhive/modules/auth/salary/view/aadhar_verify.dart';
import 'package:payhive/modules/auth/salary/view/email_verification.dart';
import 'package:payhive/modules/auth/salary/view/term_and_condition.dart';
import 'package:payhive/services/native_code/get_phone_number.dart';
import 'package:payhive/utils/helper/form_validation.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/snackbar.dart';
import 'package:payhive/utils/widgets/textfield.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginRegViaPhone extends GetView<SalariedController> {
  const LoginRegViaPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appColors.primaryColor,
        body: body(context));
  }

  SafeArea body(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: height / 100),
        alignment: Alignment.center,
        decoration: const BoxDecoration(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              progress(),
              if (controller.isLoginScreenDisabled.value)
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: width / 20),
                  child: Container(
                    height: height / 12,
                    width: height / 4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width / 100),
                      border: Border.all(
                        color: appColors.white,
                        width: 0.4,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.offAll(EmailVerification(),
                            transition: Transition.rightToLeft,
                            duration: const Duration(milliseconds: 500));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            " Next ",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: appColors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: height / 25,
                            color: appColors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  welcomeText(),
                  Container(
                    width: width,
                    padding:
                        EdgeInsets.only(left: width / 20, right: width / 20),
                    height: MediaQuery.sizeOf(context).height / 1.4,
                    decoration: boxDecorationMainMobileWidget(),
                    child: GetBuilder<SalariedController>(
                        init: controller,
                        builder: (cxt) {
                          return Form(
                            key: controller.formKeyLogin,
                            child: Column(
                              children: [
                                spacing(),
                                enterMobileText(),
                                spacing(passedHeight: height / 60),
                                enterMobileTextfield(context),
                                spacing(),
                                allCreditCardsImage(),
                                if (!controller.isLoginScreenDisabled.value)
                                  if (controller.isOTPShotPhone.value &&
                                      !controller.isPhoneLoading.value &&
                                      !controller.isEditingPhone.value)
                                    otpWidget(),
                                spacer(),
                                if (!controller.isLoginScreenDisabled.value)
                                  if (!controller.isPhoneOTPSubmitLoading.value)
                                    termAndConditionWidget(context),
                                spacing(passedHeight: height / 50),
                                if (!controller.isLoginScreenDisabled.value)
                                  !controller.isPhoneOTPSubmitLoading.value
                                      ? customButton(
                                          title: controller.isOTPShotPhone.value
                                              ? "Submit"
                                              : "Verify",
                                          context: context,
                                          onTap: () {
                                            if (controller
                                                .isTermChecked.value) {
                                              if (controller
                                                  .isOTPShotPhone.value) {
                                                if (controller
                                                        .otpControllerPhone
                                                        .text
                                                        .length <
                                                    6) {
                                                  showSnackBar(
                                                      message:
                                                          "OTP must be of 6 digits",
                                                      title: "Payhive");
                                                } else {
                                                  controller.salariedAPI(
                                                      step: '2');
                                                }
                                              } else {
                                                controller.validatePhoneForm();
                                              }
                                            } else {
                                              showSnackBar(
                                                  message:
                                                      "Please accept term & condition.",
                                                  title: "Payhive",
                                                  color: appColors.red,
                                                  duration: const Duration(
                                                      seconds: 3));
                                            }
                                          },
                                        )
                                      : Lottie.asset(
                                          'assets/lottie/wave_loading.json',
                                          width: width / 2,
                                          height: height / 3.5),
                                spacing(passedHeight: height / 8),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding termAndConditionWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3.0),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              controller.termChecked();
            },
            child: Image.asset(
              controller.isTermChecked.value
                  ? "assets/icons/checkbox.png"
                  : "assets/icons/blank_checkbox.png",
              height: height / 22,
              fit: BoxFit.contain,
              color: controller.isTermChecked.value == false
                  ? appColors.primaryLight.withOpacity(0.35)
                  : null,
            ),
          ),
          SizedBox(width: width / 60),
          InkWell(
            onTap: () {
              Future.delayed(Duration.zero, () {
                Navigator.of(context).push(
                  TermAndCondition(),
                );
              });
            },
            child: Row(
              children: [
                Text(
                  "I accept the terms & conditions and privacy policy",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xff222222),
                    fontSize: height / 36,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column otpWidget() {
    return Column(
      children: [
        spacing(passedHeight: height / 20),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: width / 80),
          child: Text(
            "OTP code has been sent to +91 ${controller.mobileController.text} enter the code below to continue.",
            style: theme.textTheme.labelLarge?.copyWith(
              color: appColors.textDark,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        spacing(passedHeight: height / 60),
        Center(
          child: PinFieldAutoFill(
            controller: controller.otpControllerPhone,
            currentCode: controller.otpControllerPhone.text,
            decoration: BoxLooseDecoration(
              gapSpace: height / 50,
              textStyle: TextStyle(
                fontSize: height / 16,
                color: const Color.fromRGBO(30, 60, 87, 1),
                fontWeight: FontWeight.w600,
              ),
              strokeColorBuilder: PinListenColorBuilder(
                Colors.grey.shade500,
                Colors.grey.shade500,
              ),
            ),
            codeLength: 6,
            onCodeChanged: (code) {
              debugPrint("onCodeChanged $code");
              controller.otpControllerPhone.text = code.toString();
              controller.update();
            },
            onCodeSubmitted: (val) {
              debugPrint("onCodeChanged $val");
              if (controller.otpControllerPhone.text.length == 6) {
                controller.salariedAPI(step: '2');
              }
            },
          ),
        ),
        spacing(passedHeight: height / 60),
        InkWell(
          onTap: () {
            controller.otpControllerPhone.clear();
            controller.update();
            controller.salariedAPI(step: '1');
          },
          child: Text(
            "Resend code",
            style: theme.textTheme.labelLarge?.copyWith(
                color: appColors.textLight,
                fontWeight: FontWeight.w300,
                fontSize: height / 32,
                decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }

  Image allCreditCardsImage() {
    return Image.asset(
      "assets/images/all_credit_cards.png",
      width: width / 1.2,
    );
  }

  InkWell enterMobileTextfield(BuildContext context) {
    return InkWell(
      onTap: () async {},
      child: IgnorePointer(
        ignoring: false,
        child: customTextField(
          textEditingController: controller.mobileController,
          title: "",
          fullTag: "Please enter your mobile number",
          fontSize: height / 26,
          maxLength: 10,
          prefixIcon: Container(
            padding: EdgeInsets.symmetric(
              vertical: height / 30,
              horizontal: width / 40,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.phone,
                  color: appColors.textExtraLight,
                ),
                Text(
                  "  +91",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: appColors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                    fontSize: height / 26,
                  ),
                ),
              ],
            ),
          ),
          validator: (value) => FormValidation.phoneValidator(
            controller.mobileController.text,
          ),
          readOnly: !controller.isEditingPhone.value,
          keyboardType: TextInputType.phone,
          suffixIcon: controller.isLoginScreenDisabled.value
              ? Container(
                  padding: EdgeInsets.symmetric(
                    vertical: height / 30,
                    horizontal: width / 30,
                  ),
                  child: Image.asset(
                    "assets/icons/successmark.png",
                    height: height / 18,
                  ),
                )
              : controller.isPhoneLoading.value
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        vertical: height / 30,
                        horizontal: width / 30,
                      ),
                      child: CupertinoActivityIndicator(
                        color: appColors.primaryLight,
                      ),
                    )
                  : controller.isOTPShotPhone.value
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            vertical: height / 30,
                            horizontal: width / 30,
                          ),
                          child: customButton(
                            passedHeight: height / 14,
                            passedWidth: width / 5.8,
                            title: "Change",
                            context: context,
                            onTap: () {
                              controller.isOTPShotPhone.value = false;
                              controller.isEditingPhone.value = true;
                              controller.update();
                            },
                          ),
                        )
                      : null,
        ),
      ),
    );
  }

  Container enterMobileText() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: width / 80),
      child: Text(
        "Enter the mobile number linked with this device",
        style: theme.textTheme.labelLarge?.copyWith(
          color: appColors.textDark,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Container welcomeText() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        top: width / 20,
        left: width / 20,
        right: width / 20,
        bottom: height / 50,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to",
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: appColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                " \"Payhive\"",
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: appColors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          Text(
            "Let’s get started",
            style: theme.textTheme.headlineSmall?.copyWith(
              color: appColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration boxDecorationMainMobileWidget() {
    return BoxDecoration(
      image: const DecorationImage(
        image: AssetImage("assets/images/bg_drop_down.png"),
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(height / 16),
        topLeft: Radius.circular(height / 16),
      ),
    );
  }

  SizedBox spacing({passedHeight}) =>
      SizedBox(height: passedHeight ?? height / 20);

  LinearPercentIndicator progress() {
    return LinearPercentIndicator(
      width: width,
      animation: true,
      animationDuration: 2000,
      padding: EdgeInsets.zero,
      lineHeight: height / 100,
      percent: 0.1,
      backgroundColor: appColors.primaryExtraLight,
      progressColor: appColors.green,
    );
  }

  Spacer spacer() => const Spacer();

  Future getPhoneNumber() async {
    if (Platform.isAndroid) {
      try {
        var number = await PhoneNumberPicker.getPhoneNumber();

        if (number != null) {
          controller.mobileController.text =
              number.toString().startsWith('+91', 0)
                  ? number.split('+91').elementAt(1).toString()
                  : number.toString();
        } else {
          controller.isIgnoringMobile.value = false;
        }
      } catch (e) {
        controller.isIgnoringMobile.value = false;
      }
    } else {
      controller.isIgnoringMobile.value = false;
    }

    controller.update();
  }
}
