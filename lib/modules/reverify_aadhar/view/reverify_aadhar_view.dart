import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/auth/salary/widgets/aadhar_field.dart';
import 'package:payhive/modules/pos/view/view_doc.dart';
import 'package:payhive/utils/helper/form_validation.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../utils/screen_size.dart';
import '../../../utils/theme/apptheme.dart';
import '../../../utils/widgets/button.dart';
import '../../../utils/widgets/textfield.dart';
import '../controller/reverify_aadhar_controller.dart';

class ReverifyAadharView extends GetView<ReverifyAadharController> {
  ReverifyAadharView({super.key});

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
      backgroundColor: appColors.primaryColor,
      appBar: AppBar(
        backgroundColor: appColors.primaryColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: appColors.white,
          ),
        ),
      ),
      body: getBody(context),
    );
  }

  Spacer spacer() => const Spacer();

  Widget getBody(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: height / 100),
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        alignment: Alignment.center,
        child: SafeArea(
          child: Column(
            children: [
              text(),
              spacer(),
              aadhar(context),
            ],
          ),
        ),
      ),
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
                    key: controller.reverifyformKeyAadhar,
                    child: Column(
                      children: [
                        spacing(passedHeight: height / 10),
                        aadharTextfield(),
                        otpAndSpacing(),
                        spacing(passedHeight: height / 10),
                        uploadAadharDocWidget(),
                        spacing(passedHeight: height / 30),
                        if (controller.file != null ||
                            controller.document.text.isNotEmpty)
                          SizedBox(height: height / 60),
                        if (controller.file != null ||
                            controller.document.text.isNotEmpty)
                          viewOrDelete(context),

                        /// If otp shot then only show OTP widget otherwise user
                        /// can edit his/her aadhar (on error also)

                        /// If Aadhar verified successfully & got the aadhar
                        /// details then user can not edit his/her aadhar
                        /// number make it uneditable & show success mark on
                        /// aadhar text field & hide OTP widget

                        // if (controller.isAadharOTPShot == false &&
                        //     (controller.aadharDetails.runtimeType == Null ||
                        //         controller.aadharDetails == null))
                        //   consent(),
                        // if (controller.isAadharOTPShot &&
                        //     (controller.aadharDetails.runtimeType == Null ||
                        //         controller.aadharDetails == null))
                        //   otpAndSpacing(),
                        // if (controller.aadharDetails.runtimeType != Null &&
                        //     controller.aadharDetails != null)
                        //   Padding(
                        //     padding:
                        //         const EdgeInsets.symmetric(horizontal: 12.0),
                        //     child: aadharDetails(context),
                        //   ),
                        spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: customButton(
                            title: "Continue",
                            context: context,
                            onTap: () {
                              // controller.aadharNumberSorted = controller
                              //     .aadharController.text
                              //     .toString()
                              //     .replaceAll('-', '');
                              // debugPrint(controller.aadharNumberSorted);
                              // if (controller.isAadharOTPShot == true) {
                              //   controller.aadharStep = '2';
                              //   if (controller.aadharOTP.text.length !=
                              //       6) {
                              //     errorDialog(
                              //         context: context,
                              //         message:
                              //             'Please enter valid aadhar OTP');
                              //   } else {
                              //     controller.validateAadharForm();
                              //   }
                              // } else {
                              //   controller.validateAadharForm();
                              // }
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

  Padding aadharTextfield() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: aadharTextField(
        controller: controller.aadhaarTextController,
        onChanged: (val) {
          controller.update();
        },
      ),
    );
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
              // controller.aadharOTP.text = code.toString();
              // controller.update();
            },
            onCodeSubmitted: (val) {
              debugPrint("onCodeChanged $val");
              // if (controller.aadharOTP.text.length == 6) {
              //   controller.salariedAPI(step: '2');
              // }
            },
          ),
        ),
        spacing(passedHeight: height / 60),
        InkWell(
          onTap: () {
            // controller.aadharOTP.clear();
            // controller.update();
            // controller.salariedAPI(step: '8');
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

  Widget uploadAadharDocWidget() {
    return InkWell(
      onTap: () {
        controller.pickDocument();
      },
      child: IgnorePointer(
        ignoring: true,
        child: enterFullName(
          controller.document,
          Icons.document_scanner_rounded,
          'Document',
          onChange: (val) {},
          (value) => FormValidation.name(controller.document.text),
        ),
      ),
    );
  }

  InkWell enterFullName(
    textEditingController,
    icon,
    tag,
    String? Function(Object?)? validator, {
    onChange,
    TextInputType? keyboardType,
  }) {
    return InkWell(
      onTap: () async {},
      child: customTextField(
        textEditingController: textEditingController,
        title: '',
        fullTag: tag,
        onChanged: onChange,
        fontSize: height / 26,
        prefixIcon: Container(
          padding: EdgeInsets.symmetric(
            vertical: height / 30,
            horizontal: width / 40,
          ),
          child: Icon(
            icon,
            color: appColors.black.withValues(alpha: 0.6),
          ),
        ),
        keyboardType: keyboardType ?? TextInputType.text,
      ),
    );
  }

  Row viewOrDelete(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            controller.file = null;
            controller.document.clear();
            controller.update();
          },
          child: Text(
            "DELETE",
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.redAccent,
              letterSpacing: 1,
              fontSize: height / 30,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          width: width / 30,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              ViewDocument(
                docPath: controller.document.text,
                file: controller.file,
              ),
            );
          },
          child: Text(
            "VIEW  ",
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.green,
              letterSpacing: 2,
              fontSize: height / 30,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
