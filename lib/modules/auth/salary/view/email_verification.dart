import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/modules/auth/salary/controller/salaried_controller.dart';
import 'package:payhive/modules/auth/salary/view/account_type.dart';
import 'package:payhive/modules/auth/salary/view/login_reg_phone.dart';
import 'package:payhive/utils/helper/form_validation.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/snackbar.dart';
import 'package:payhive/utils/widgets/textfield.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pinput/pinput.dart';

import '../../../../utils/screen_size.dart';

class EmailVerification extends GetView<SalariedController> {
  EmailVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (v, t) {
        Get.offAll(() => const LoginRegViaPhone());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appColors.primaryColor,
        body: body(context),
      ),
    );
  }

  SafeArea body(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: height / 100),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage("assets/images/splash_bg.png"),
            //   fit: BoxFit.cover,
            // ),
            ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              progress(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(left: width / 20, top: width / 20),
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
                          Get.offAll(const LoginRegViaPhone(),
                              transition: Transition.leftToRight,
                              duration: const Duration(milliseconds: 500));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_back_ios_rounded,
                              size: height / 25,
                              color: appColors.white,
                            ),
                            Text(
                              " Back ",
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: appColors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (controller.isEmailScreenDisabled.value)
                    Container(
                      alignment: Alignment.centerRight,
                      margin:
                          EdgeInsets.only(right: width / 20, top: width / 20),
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
                            Get.offAll(AccountType(),
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
                ],
              ),
              IgnorePointer(
                ignoring: controller.isEmailScreenDisabled.value,
                child: Column(
                  children: [
                    spacing(passedHeight: height / 12),
                    emailVerificationText(),
                    spacing(passedHeight: height / 80),
                    email(context)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Spacer spacer() => const Spacer();

  final defaultPinTheme = PinTheme(
    width: height / 7.5,
    height: height / 7.5,
    textStyle: TextStyle(
        fontSize: height / 16,
        color: const Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(8),
    ),
  );

  Container email(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height / 1.35,
      width: width,
      decoration: BoxDecoration(
        color: appColors.white,
        image: const DecorationImage(
          image: AssetImage("assets/images/bg_drop_down.png"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(height / 16),
          topLeft: Radius.circular(height / 16),
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: width / 20, right: width / 20),
            child: GetBuilder<SalariedController>(
                init: controller,
                builder: (cxt) {
                  return Form(
                    key: controller.formKeyEmail,
                    child: Column(
                      children: [
                        spacing(),
                        spacing(passedHeight: height / 60),
                        customTextField(
                          textEditingController: controller.emailController,
                          title: "email",
                          fullTag: "email",
                          prefixIcon: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: height / 30,
                              horizontal: width / 30,
                            ),
                            child: Icon(
                              CupertinoIcons.mail_solid,
                              color: appColors.primaryColor,
                            ),
                          ),
                          validator: (value) => FormValidation.emailValidator(
                            controller.emailController.text,
                          ),
                          readOnly: controller.isEditingEmail.value,
                          keyboardType: TextInputType.emailAddress,
                          suffixIcon: controller.isEmailScreenDisabled.value
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
                              : controller.isEmailLoading.value
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: height / 30,
                                        horizontal: width / 30,
                                      ),
                                      child: CupertinoActivityIndicator(
                                        color: appColors.primaryLight,
                                      ),
                                    )
                                  : controller.isOTPShotEmail.value
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
                                              controller.isOTPShotEmail.value =
                                                  false;
                                              controller.isEditingEmail.value =
                                                  false;
                                              controller.update();
                                            },
                                          ),
                                        )
                                      : null,
                        ),
                        if (!controller.isEmailScreenDisabled.value)
                          if (controller.isOTPShotEmail.value &&
                              !controller.isEmailLoading.value &&
                              !controller.isEditingEmail.value)
                            Column(
                              children: [
                                spacing(passedHeight: height / 20),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: width / 80),
                                  child: Text(
                                    "OTP code has been sent to ${controller.emailController.text} enter the code below to continue.",
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: appColors.textDark,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                spacing(passedHeight: height / 60),
                                Center(
                                  child: Pinput(
                                    controller: controller.otpControllerEmail,
                                    defaultPinTheme: PinTheme(
                                      width: height / 7.5,
                                      height: height / 7.5,
                                      textStyle: TextStyle(
                                          fontSize: height / 16,
                                          color: const Color.fromRGBO(
                                              30, 60, 87, 1),
                                          fontWeight: FontWeight.w600),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1.0),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    length: 6,
                                    focusedPinTheme:
                                        defaultPinTheme.copyDecorationWith(
                                      border: Border.all(
                                          color: appColors.primaryColor,
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    submittedPinTheme: defaultPinTheme.copyWith(
                                      decoration:
                                          defaultPinTheme.decoration?.copyWith(
                                        color: const Color.fromRGBO(
                                            234, 239, 243, 1),
                                      ),
                                    ),
                                    pinputAutovalidateMode:
                                        PinputAutovalidateMode.onSubmit,
                                    showCursor: true,
                                    onChanged: (pin) {},
                                    onCompleted: (pin) {},
                                  ),
                                ),
                                spacing(passedHeight: height / 60),
                                InkWell(
                                  onTap: () {
                                    controller.otpControllerEmail.clear();
                                    controller.update();
                                    controller.salariedAPI(step: '3');
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
                            ),
                        spacer(),
                        if (!controller.isEmailScreenDisabled.value)
                          !controller.isEmailOTPSubmitLoading.value
                              ? customButton(
                                  title: controller.isOTPShotEmail.value
                                      ? "Submit"
                                      : "Verify",
                                  context: context,
                                  onTap: () {
                                    if (controller.isOTPShotEmail.value) {
                                      if (controller
                                              .otpControllerEmail.text.length <
                                          6) {
                                        showSnackBar(
                                          message: "OTP must be of 6 digits",
                                          title: "PayHive",
                                        );
                                      } else {
                                        controller.salariedAPI(step: '4');
                                      }
                                    } else {
                                      controller.validateEmailForm();
                                    }
                                  })
                              : Lottie.asset('assets/lottie/wave_loading.json',
                                  width: width / 2, height: height / 3.5),
                        spacing(passedHeight: height / 8),
                      ],
                    ),
                  );
                }),
          ),
          Positioned(
            bottom: -height / 8,
            child: IgnorePointer(
              ignoring: true,
              child: Image.asset(
                "assets/images/home_flare.png",
                width: width,
                height: height / 1.75,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container emailVerificationText() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        top: width / 20,
        left: width / 20,
        right: width / 20,
      ),
      child: Text(
        "Email verification",
        style: theme.textTheme.headlineSmall
            ?.copyWith(color: appColors.white, fontWeight: FontWeight.w600),
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
      percent: 0.2,
      backgroundColor: appColors.primaryExtraLight,
      progressColor: appColors.green,
    );
  }
}
