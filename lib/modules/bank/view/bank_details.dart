import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/modules/bank/controller/bank_controller.dart';
import 'package:payhive/utils/helper/form_validation.dart';
import 'package:payhive/utils/helper/text_capitalization.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/textfield.dart';

class BankDetailsPage extends GetView<BankController> {
  const BankDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appColors.primaryDark,
        body: body(context));
  }

  SafeArea body(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.center,

        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/images/splash_bg.png",),
        //     fit: BoxFit.cover,
        //   ),
        // ),

        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              appColors.primaryDark,
              appColors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              bankDetailText(),
              addBank(context),
            ],
          ),
        ),
      ),
    );
  }

  Container addBank(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.only(left: width / 20, right: width / 20),
      height: MediaQuery.sizeOf(context).height / 1.4,
      decoration: boxDecorationMainMobileWidget(),
      child: GetBuilder<BankController>(
          init: controller,
          builder: (cxt) {
            return controller.bankDetails != null &&
                    controller.isLoadingBank.value == false
                ? bankDetail(context)
                : Form(
                    key: controller.bankFormKey,
                    child: Column(
                      children: [
                        spacing(),
                        // enterFullName(
                        //   controller.fullName,
                        //   Icons.person_outline_rounded,
                        //   onChange: (v) {
                        //     controller.fullName.text =
                        //         capitalizeFirstCharacter(v.toString());
                        //     controller.update();
                        //   },
                        //   'Full name',
                        //   (value) =>
                        //       FormValidation.name(controller.fullName.text),
                        // ),
                        // spacing(passedHeight: height / 30),
                        enterFullName(
                            controller.bankAccountNumber,
                            Icons.badge_outlined,
                            'Account number',
                            (value) => FormValidation.name(
                                controller.bankAccountNumber.text),
                            keyboardType: TextInputType.number),
                        spacing(passedHeight: height / 30),
                        enterFullName(
                          controller.ifsc,
                          Icons.account_balance_outlined,
                          'IFSC code',
                          onChange: (val) {
                            controller.ifsc.value = TextEditingValue(
                              text: val.toUpperCase(),
                              selection: controller.ifsc.selection,
                            );
                            controller.update();
                          },
                          (value) => FormValidation.name(controller.ifsc.text),
                        ),
                        spacing(passedHeight: height / 30),
                        pennyDropOneRupeeText(),
                        spacer(),
                        spacing(passedHeight: height / 50),
                        !controller.isLoadingBank.value
                            ? customButton(
                                title: controller.bankDetails != null
                                    ? "Submit"
                                    : "Verify",
                                context: context,
                                onTap: () {
                                  controller.validateBankForm();
                                },
                              )
                            : Lottie.asset('assets/lottie/wave_loading.json',
                                width: width / 2, height: height / 3.5),
                        spacing(passedHeight: height / 8),
                      ],
                    ),
                  );
          }),
    );
  }

  Container pennyDropOneRupeeText() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: width / 80),
      child: Text(
        "Complete verification with a penny drop of ₹1 to customer provided bank account details.",
        style: theme.textTheme.labelLarge?.copyWith(
          color: appColors.textDark,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget bankDetailText() {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.only(left: width / 40, bottom: height / 40),
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                margin: EdgeInsets.only(top: height / 20),
                child: Icon(
                  CupertinoIcons.back,
                  color: appColors.white,
                  size: height / 10,
                ),
              ),
            ),
            Text(
              controller.bankDetails != null
                  ? "  Your Bank Details"
                  : "  Enter Your Bank Account Details",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: appColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
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

  Spacer spacer() => const Spacer();

  Widget bankDetail(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 2.7,
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
                  "Bank Verified ",
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
                          "Bank Number",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w200,
                            fontSize: height / 26,
                          ),
                        ),
                        Text(
                          controller.bankAccountNumber.text,
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
                          "IFSC Code",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w200,
                            fontSize: height / 26,
                          ),
                        ),
                        Text(
                          "${controller.bankDetails!['ifsc']}",
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
            if (controller.bankDetails!['name'] != null)
              spacing(passedHeight: height / 20),
            if (controller.bankDetails!['name'] != null)
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width / 2.4,
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
                            "${controller.bankDetails!['name']}",
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
          ],
        ),
      ),
    );
  }

  InkWell enterFullName(
      textEditingController, icon, tag, String? Function(Object?)? validator,
      {onChange, TextInputType? keyboardType}) {
    return InkWell(
      onTap: () async {},
      child: customTextField(
        textEditingController: textEditingController,
        title: "",
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
            color: appColors.black.withOpacity(0.6),
          ),
        ),
        keyboardType: keyboardType ?? TextInputType.text,
      ),
    );
  }
}
