import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/modules/auth/salary/widgets/aadhar_field.dart';
import 'package:payhive/modules/pos/view/view_doc.dart';
import 'package:payhive/modules/reverify_pan/controller/reverify_pan_controller.dart';
import 'package:payhive/utils/helper/form_validation.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../utils/screen_size.dart';
import '../../../utils/theme/apptheme.dart';
import '../../../utils/widgets/button.dart';
import '../../../utils/widgets/textfield.dart';

class ReverifyPanView extends GetView<ReverifyPanController> {
  ReverifyPanView({super.key});

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
              pan(context),
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
        controller.isAccountTypeSalaried.value
            ? "Enter Your\nPAN Number"
            : "Enter Your\nPAN/GST Number",
        style: theme.textTheme.headlineSmall
            ?.copyWith(color: appColors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

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
      child: GetBuilder<ReverifyPanController>(
          init: controller,
          builder: (cxt) {
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: width / 20, right: width / 20),
                  child: Form(
                    key: controller.reverifyformKeyPan,
                    child: Column(
                      children: [
                        spacing(passedHeight: height / 20),
                        panGstTextField(
                          controller: controller.panTextController,
                          allowGst: !controller.isAccountTypeSalaried.value,
                          onChanged: (val) {
                            controller.update();
                          },
                        ),
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
                                      "I am aware that my details will be submitted to NSDL to verify my ${!controller.isAccountTypeSalaried.value ? 'PAN / GST' : 'PAN'}. I have read and understood all terms.",
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
                        if (controller.isPanLoading.value == false)
                          customButton(
                              title: controller.panDetails != null
                                  ? "Continue"
                                  : "Verify",
                              context: context,
                              onTap: () async {
                                controller.panGstNumberSorted = controller
                                    .panTextController.text
                                    .toString()
                                    .replaceAll('-', '');
                                debugPrint(controller.panTextController.text);
                                debugPrint(controller.panGstNumberSorted);

                                if (controller.panDetails != null ||
                                    controller.gstDetails != null) {
                                  controller.update();
                                  Get.back();
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
                  bottom: height / 18,
                  left: height / 18,
                  right: height / 18,
                  child: SizedBox(
                    width: width / 1.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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

  // Padding aadharTextfield() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 12.0),
  //     child: aadharTextField(
  //       controller: controller.aadhaarTextController,
  //       onChanged: (val) {
  //         controller.update();
  //       },
  //     ),
  //   );
  // }

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
