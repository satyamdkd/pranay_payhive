import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/modules/auth/face_detections/face_detector_view.dart';
import 'package:payhive/modules/auth/salary/controller/salaried_controller.dart';
import 'package:flutter/material.dart';
import 'package:payhive/modules/auth/salary/view/digilocker_aadhar.dart';
import 'package:payhive/modules/auth/salary/view/pan_verify_salary.dart';
import 'package:payhive/modules/auth/salary/widgets/aadhar_field.dart';
import 'package:payhive/utils/helper/form_validation.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/error.dart';
import 'package:payhive/utils/widgets/snackbar.dart';
import 'package:payhive/utils/widgets/textfield.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';

class AadharVerifySalaried extends GetView<SalariedController> {
  AadharVerifySalaried({super.key});

  final defaultPinTheme = PinTheme(
    width: height / 7.5,
    height: height / 7.5,
    textStyle: TextStyle(
        fontSize: height / 16,
        color: const Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
      borderRadius: BorderRadius.circular(8),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appColors.primaryColor,
      body: body(context),
    );
  }

  SafeArea body(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: height / 100),
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage("assets/images/splash_bg.png"),
            //   fit: BoxFit.cover,
            // ),
            ),
        child: SafeArea(
          child: Column(
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
                          Get.offAll(const PanVerifySalary(),
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
                  if (controller.isAadharScreenDisabled.value)
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
                            if (controller.compareWhetherAadharIsSame()) {
                              controller.isAadharScreenDisabled.value = true;
                              controller.update();
                              Get.offAll(const FaceDetectorView(),
                                  transition: Transition.rightToLeft,
                                  duration: const Duration(milliseconds: 500));
                            } else {
                              showSnackBar(
                                message:
                                    'The Aadhaar number you entered does not match the fetched Aadhaar details.',
                                title: 'Aadhar verification',
                                color: appColors.red,
                                duration: const Duration(seconds: 5),
                              );
                            }
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
              text(),
              spacer(),
              aadhar(context)
            ],
          ),
        ),
      ),
    );
  }

  Spacer spacer() => const Spacer();

  aadhar(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (ctx) {
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
                  child: Form(
                    key: controller.formKeyAadhar,
                    child: Column(
                      children: [
                        spacing(passedHeight: height / 10),
                        aadharTextfield(),

                        /// If otp shot then only show OTP widget otherwise user
                        /// can edit his/her aadhar (on error also)

                        /// If Aadhar verified successfully & got the aadhar
                        /// details then user can not edit his/her aadhar
                        /// number make it uneditable & show success mark on
                        /// aadhar text field & hide OTP widget

                        if (controller.isAadharOTPShot == false &&
                            (controller.aadharDetails.runtimeType == Null ||
                                controller.aadharDetails == null))
                          consent(),
                        if (controller.isAadharOTPShot &&
                            (controller.aadharDetails.runtimeType == Null ||
                                controller.aadharDetails == null))
                          otpAndSpacing(),
                        if (controller.aadharDetails.runtimeType != Null &&
                            controller.aadharDetails != null)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: aadharDetails(context),
                          ),
                        spacer(),

                        if (controller.isAadharTermChecked.value &&
                            controller.aadharController.text.length == 14 &&
                            (controller.aadharDetails.runtimeType == Null ||
                                controller.aadharDetails == null))
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: controller.isAadharLoading.value
                                ? Center(
                                    child: Lottie.asset(
                                        'assets/lottie/wave_loading.json',
                                        width: width / 2,
                                        height: height / 3.5),
                                  )
                                : customButton(
                                    title: "Continue",
                                    context: context,
                                    onTap: () {
                                      controller.aadharNumberSorted = controller
                                          .aadharController.text
                                          .toString()
                                          .replaceAll('-', '');
                                      debugPrint(controller.aadharNumberSorted);
                                      if (controller.isAadharOTPShot == true) {
                                        controller.aadharStep = '2';
                                        if (controller.aadharOTP.text.length !=
                                            6) {
                                          errorDialog(
                                              context: context,
                                              message:
                                                  'Please enter valid aadhar OTP');
                                        } else {
                                          controller.validateAadharForm();
                                        }
                                      } else {
                                        controller.validateAadharForm();
                                      }
                                    },
                                  ),
                          ),

                        spacing(),
                      ],
                    ),
                  ),
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
        });
  }

  Padding otpAndSpacing() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          spacing(),
          otpWidget(),
        ],
      ),
    );
  }

  Padding aadharTextfield() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: aadharTextField(
        controller: controller.aadharController,
        readOnly: !controller.isEditingAadhar.value,
        suffixIcon: controller.aadharDetails != null
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
            : null,
        onChanged: (val) {
          controller.update();
        },
      ),
    );
  }

  InkWell consent() {
    return InkWell(
      onTap: () {
        controller.isAadharTermChecked.value =
            !controller.isAadharTermChecked.value;
        controller.update();
      },
      child: Column(
        children: [
          spacing(passedHeight: 12.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 12.0,
              ),
              Image.asset(
                controller.isAadharTermChecked.value
                    ? "assets/icons/checkbox.png"
                    : "assets/icons/blank_checkbox.png",
                height: height / 24,
                fit: BoxFit.contain,
                color: controller.isAadharTermChecked.value == false
                    ? appColors.primaryLight.withOpacity(0.35)
                    : null,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 8.0),
                  child: Text(
                    "I hereby consent to the verification of my Aadhaar details for authentication purposes. I confirm that the information provided by me is accurate and I have read and understood all applicable terms and conditions.",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xff222222),
                      fontSize: height / 32,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
          spacing(),
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
            "OTP code has been sent to your registered mobile number linked with your aadhar.",
            style: theme.textTheme.labelLarge?.copyWith(
              color: appColors.textDark,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        spacing(passedHeight: height / 60),
        Center(
          child: PinFieldAutoFill(
            controller: controller.aadharOTP,
            currentCode: controller.aadharOTP.text,
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
              controller.aadharOTP.text = code.toString();
              controller.update();
            },
            onCodeSubmitted: (val) {
              debugPrint("onCodeChanged $val");
              if (controller.aadharOTP.text.length == 6) {
                controller.salariedAPI(step: '2');
              }
            },
          ),
        ),
        spacing(passedHeight: height / 60),
        InkWell(
          onTap: () {
            controller.aadharOTP.clear();
            controller.update();
            controller.salariedAPI(step: '8');
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

  Container text() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        top: width / 20,
        left: width / 20,
        right: width / 20,
      ),
      child: Text(
        "Enter Your\nAadhar Number",
        style: theme.textTheme.headlineSmall
            ?.copyWith(color: appColors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  SizedBox aadharDetails(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 1.7,
      width: width,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: width / 20, right: width / 20),
            child: Column(
              children: [
                spacing(passedHeight: height / 20),
                Image.asset(
                  "assets/icons/successmark.png",
                  height: height / 12,
                ),
                spacing(passedHeight: height / 90),
                Text(
                  "Aadhar Verified",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: appColors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: height / 24,
                  ),
                ),
                spacing(passedHeight: height / 20),
                spacing(passedHeight: height / 20),
                Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      /// if (controller.aadharImageBytes != null)
                      ///   Image.memory(
                      ///     controller.aadharImageBytes!,
                      ///     fit: BoxFit.contain,
                      ///     height: height / 8,
                      ///   ),

                      if (controller.aadharBase64Image != '')
                        Image.network(
                          controller.aadharBase64Image,
                          fit: BoxFit.contain,
                          height: height / 8,
                        ),
                      if (controller.aadharBase64Image != '')
                        SizedBox(width: width / 30),
                      SizedBox(
                        width: width / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: appColors.black.withOpacity(0.6),
                                fontWeight: FontWeight.w200,
                                fontSize: height / 26,
                              ),
                            ),
                            Text(
                              controller.aadharDetails!['name'] ?? '',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: appColors.black.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                                fontSize: height / 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                spacing(passedHeight: height / 20),
                Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width / 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Gender",
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: appColors.black.withOpacity(0.6),
                                fontWeight: FontWeight.w200,
                                fontSize: height / 26,
                              ),
                            ),
                            Text(
                              controller.aadharDetails!['gender'] == 'M'
                                  ? 'Male'
                                  : 'Female',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: appColors.black.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                                fontSize: height / 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width / 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date Of Birth",
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: appColors.black.withOpacity(0.6),
                                fontWeight: FontWeight.w200,
                                fontSize: height / 26,
                              ),
                            ),
                            Text(
                              controller.aadharDetails!['dateOfBirth'] ?? '',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: appColors.black.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                                fontSize: height / 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                spacing(passedHeight: height / 20),
                if (controller.aadharDetails!['address'] != null &&
                    controller.aadharDetails!['address'].toString().trim() !=
                        '')
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width / 1.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Address",
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: appColors.black.withOpacity(0.6),
                                  fontWeight: FontWeight.w200,
                                  fontSize: height / 26,
                                ),
                              ),
                              Text(
                                controller.aadharDetails!['address'] ?? '',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: appColors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.w300,
                                  fontSize: height / 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                spacer(),
                customButton(
                    title: "Continue",
                    context: context,
                    onTap: () {
                      if (controller.compareWhetherAadharIsSame()) {
                        controller.isAadharScreenDisabled.value = true;
                        controller.update();
                        Get.to(() => const FaceDetectorView());
                      } else {
                        showSnackBar(
                          message:
                              'The Aadhaar number you entered does not match the fetched Aadhaar details.',
                          title: 'Aadhar verification',
                          color: appColors.red,
                          duration: const Duration(seconds: 5),
                        );
                      }
                    }),
                spacing(passedHeight: height / 8),
              ],
            ),
          ),
        ],
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
      percent: 0.8,
      backgroundColor: appColors.primaryExtraLight,
      progressColor: appColors.green,
    );
  }
}
