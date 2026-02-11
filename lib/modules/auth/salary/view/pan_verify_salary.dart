import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/modules/auth/salary/controller/salaried_controller.dart';
import 'package:payhive/modules/auth/salary/view/aadhar_verify.dart';
import 'package:payhive/modules/auth/salary/view/account_type.dart';
import 'package:payhive/modules/auth/salary/view/annual_income.dart';
import 'package:payhive/modules/auth/salary/view/digilocker_aadhar.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/textfield.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../widgets/aadhar_field.dart';

class PanVerifySalary extends GetView<SalariedController> {
  const PanVerifySalary({super.key});

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
                          Get.offAll(AccountType(),
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
                  if (controller.isPanScreenDisabled.value)
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
                            if (controller.aadharDetails == null) {
                              Get.offAll(
                                AadharVerifySalaried(),
                                transition: Transition.rightToLeft,
                                duration: const Duration(milliseconds: 500),
                              );

                              /// controller
                              ///     .loadAadharUrl(controller.digiLockerUrl);
                              /// Get.offAll(() => const DigiLockerAadhar(),
                              ///     transition: Transition.rightToLeft,
                              ///     duration: const Duration(milliseconds: 500));
                            } else {
                              Get.offAll(AadharVerifySalaried(),
                                  transition: Transition.rightToLeft,
                                  duration: const Duration(milliseconds: 500));
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
              IgnorePointer(
                ignoring: controller.isPanScreenDisabled.value,
                child: pan(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  Spacer spacer() => const Spacer();

  Container pan(BuildContext context) {
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
      child: GetBuilder<SalariedController>(
          init: controller,
          builder: (cxt) {
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: width / 20, right: width / 20),
                  child: Form(
                    key: controller.formKeyPan,
                    child: Column(
                      children: [
                        spacing(passedHeight: height / 20),

                        panGstTextField(
                          controller: controller.panController,
                          allowGst: controller.accountTypeIndex != 0,
                          onChanged: (val) {
                            controller.update();
                          },
                        ),
                        // customTextField(
                        //   textEditingController: controller.panController,
                        //   title: "",
                        //   fullTag: controller.accountTypeIndex != 0
                        //       ? "Kindly enter your PAN / GST number"
                        //       : "Kindly enter your pan number",
                        //   keyboardType: TextInputType.text,
                        //   onChanged: (val) {
                        //     controller.panController.value = TextEditingValue(
                        //       text: val.toUpperCase(),
                        //       selection: controller.panController.selection,
                        //     );
                        //     controller.update();
                        //   },
                        // ),
                        spacing(passedHeight: height / 20),
                        if (controller.panDetails == null &&
                            controller.gstDetails == null)
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: InkWell(
                              onTap: () {
                                controller.isPanTermChecked.value =
                                    !controller.isPanTermChecked.value;
                                controller.update();
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    controller.isPanTermChecked.value
                                        ? "assets/icons/checkbox.png"
                                        : "assets/icons/blank_checkbox.png",
                                    height: height / 24,
                                    fit: BoxFit.contain,
                                    color: controller.isPanTermChecked.value ==
                                            false
                                        ? appColors.primaryLight
                                            .withOpacity(0.35)
                                        : null,
                                  ),
                                  SizedBox(width: width / 60),
                                  Expanded(
                                    child: Text(
                                      "I am aware that my details will be submitted to NSDL to verify my ${controller.accountTypeIndex != 0 ? 'PAN / GST' : 'PAN'}. I have read and understood all terms.",
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: const Color(0xff222222),
                                        fontSize: height / 30,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (controller.gstDetails == null &&
                            controller.panDetails != null)
                          panDetails(context),
                        if (controller.gstDetails != null &&
                            controller.panDetails == null)
                          gstDetails(context),
                        if (controller.panDetails == null) spacer(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: height / 18,
                  left: height / 18,
                  right: height / 18,
                  child: SizedBox(
                    width: width / 1.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (!controller.isPanScreenDisabled.value)
                          if (controller.isPanLoading.value == false)
                            customButton(
                                title: controller.panDetails != null
                                    ? "Continue"
                                    : "Verify",
                                context: context,
                                onTap: () async {
                                  controller.panGstNumberSorted = controller
                                      .panController.text
                                      .toString()
                                      .replaceAll('-', '');
                                  debugPrint(controller.panController.text);
                                  debugPrint(controller.panGstNumberSorted);

                                  if (controller.panDetails != null ||
                                      controller.gstDetails != null) {
                                    controller.isPanScreenDisabled.value = true;
                                    controller.update();
                                    Get.offAll(AadharVerifySalaried(),
                                        transition: Transition.rightToLeft,
                                        duration:
                                            const Duration(milliseconds: 500));
                                  } else {
                                    controller.validatePanForm();
                                  }
                                }),
                        if (controller.isPanLoading.value)
                          Lottie.asset('assets/lottie/wave_loading.json',
                              width: width / 2, height: height / 3.5),
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
            );
          }),
    );
  }

  Widget panDetails(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 2,
      width: width,
      child: Padding(
        padding: EdgeInsets.only(left: width / 20, right: width / 20),
        child: Column(
          children: [
            spacing(passedHeight: height / 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Pan Verified ",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: appColors.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: height / 18,
                  ),
                ),
                Image.asset(
                  "assets/icons/successmark.png",
                  height: height / 18,
                ),
              ],
            ),
            spacing(passedHeight: height / 20),
            Padding(
              padding: const EdgeInsets.only(left: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width / 2.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pan Type",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                            fontSize: height / 22,
                          ),
                        ),
                        Text(
                          "${controller.panDetails!['response']['type']}"
                                  .toLowerCase()
                                  .contains('individual')
                              ? 'Individual'
                              : "${controller.panDetails!['response']['type']}",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: height / 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width / 2.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Status",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                            fontSize: height / 22,
                          ),
                        ),
                        Text(
                          "${controller.panDetails!['status']}",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: height / 18,
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
                    width: width / 2.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PAN Number",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                            fontSize: height / 22,
                          ),
                        ),
                        Text(
                          "${controller.panDetails!['pan_number']}",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: height / 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width / 2.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "DOB",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                            fontSize: height / 22,
                          ),
                        ),
                        Text(
                          "${controller.panDetails!['response']['date_of_birth']}",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: height / 18,
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
                    width: width / 1.34,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                            fontSize: height / 22,
                          ),
                        ),
                        Text(
                          "${controller.panDetails!['name_on_card']}",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: height / 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            spacing(passedHeight: height / 20),
          ],
        ),
      ),
    );
  }

  Widget gstDetails(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 1.8,
      width: width,
      child: Padding(
        padding: EdgeInsets.only(left: width / 20, right: width / 20),
        child: Column(
          children: [
            spacing(passedHeight: height / 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "GST Verified ",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: appColors.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: height / 18,
                  ),
                ),
                Image.asset(
                  "assets/icons/successmark.png",
                  height: height / 18,
                ),
              ],
            ),
            spacing(passedHeight: height / 20),
            Padding(
              padding: const EdgeInsets.only(left: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width / 2.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "GST Number",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w200,
                            fontSize: height / 26,
                          ),
                        ),
                        Text(
                          "${controller.gstDetails!['gst_number']}",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w300,
                            fontSize: height / 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width / 2.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Status",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w200,
                            fontSize: height / 26,
                          ),
                        ),
                        Text(
                          "${controller.gstDetails!['gst_status']}",
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
            spacing(passedHeight: height / 20),
            Padding(
              padding: const EdgeInsets.only(left: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Legal name of business",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w200,
                            fontSize: height / 26,
                          ),
                        ),
                        Text(
                          "${controller.gstDetails!['legal_name_of_business']}",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w300,
                            fontSize: height / 26,
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
                    width: width / 2.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "GST Number",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w200,
                            fontSize: height / 26,
                          ),
                        ),
                        Text(
                          "${controller.gstDetails!['gst_number']}",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w300,
                            fontSize: height / 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width / 2.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Status",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w200,
                            fontSize: height / 26,
                          ),
                        ),
                        Text(
                          "${controller.gstDetails!['gst_status']}",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w300,
                            fontSize: height / 26,
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Address",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w200,
                            fontSize: height / 28,
                          ),
                        ),
                        Text(
                          "${controller.gstDetails!['address']}",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w300,
                            fontSize: height / 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            spacing(passedHeight: height / 80),
            Padding(
              padding: const EdgeInsets.only(left: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width / 2.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "City",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w200,
                            fontSize: height / 28,
                          ),
                        ),
                        Text(
                          "${controller.gstDetails!['city']}",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w300,
                            fontSize: height / 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width / 2.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "State",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w200,
                            fontSize: height / 28,
                          ),
                        ),
                        Text(
                          "${controller.gstDetails!['state']}",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w300,
                            fontSize: height / 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            spacing(passedHeight: height / 80),
            Padding(
              padding: const EdgeInsets.only(left: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width / 2.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Zipcode",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w200,
                            fontSize: height / 28,
                          ),
                        ),
                        Text(
                          "${controller.gstDetails!['zipcode']}",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w300,
                            fontSize: height / 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            spacing(passedHeight: height / 20),
          ],
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
        controller.accountTypeIndex != 0
            ? "Enter Your\nPAN/GST Number"
            : "Enter Your\nPAN Number",
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
      percent: 0.6,
      backgroundColor: appColors.primaryExtraLight,
      progressColor: appColors.green,
    );
  }
}
