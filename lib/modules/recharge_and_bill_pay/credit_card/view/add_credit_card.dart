import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/textfield.dart';
import '../controller/credit_card_controller.dart';
import 'package:flutter/services.dart';

class AddNewCreditCard extends GetView<CredCardController> {
  const AddNewCreditCard(this.bankName, this.creditCardData, {super.key});

  final Map<String, dynamic> creditCardData;
  final String bankName;

  Container consentCard(double height) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(height / 50),
      ),
      padding: EdgeInsets.all(height / 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: height / 120),
            child: Image.asset(
              'assets/icons/bbps_logo.png',
              height: height / 24,
            ),
          ),
          SizedBox(width: height / 60),
          Expanded(
            child: Text(
                'By proceeding further, you allow Payhive to store your bill details, fetch current and future bills, and send you reminders',
                style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w400, fontSize: height / 40)),
          ),
        ],
      ),
    );
  }

  dottedDigits(double h) {
    return IntrinsicWidth(
      child: Container(
        margin: EdgeInsets.all(h / 100),
        height: h * 0.056,
        decoration: BoxDecoration(
          color: appColors.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(h * 0.01),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: h * 0.014),
        child: Row(
          children: List.generate(
            12,
            (_) => Container(
              margin: EdgeInsets.symmetric(horizontal: h * 0.003),
              width: h * 0.01,
              height: h * 0.01,
              decoration: BoxDecoration(
                color: appColors.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    log(jsonEncode(creditCardData));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appColors.bgColorHome,
      bottomNavigationBar: poweredBySetu(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          appBar(),
          SliverToBoxAdapter(
            child: GetBuilder(
              init: controller,
              builder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [body(context)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding poweredBySetu() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Powered by  ',
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.primaryColor,
              letterSpacing: 1,
              fontWeight: FontWeight.w200,
              fontSize: height / 28,
            ),
          ),
          Image.asset(
            'assets/temp/settu_logo.png',
            height: height / 14,
          )
        ],
      ),
    );
  }

  body(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: appColors.primaryColor.withValues(alpha: 0.2),
          padding: EdgeInsets.symmetric(vertical: height / 50),
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: height / 18),
              Text(
                bankName.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.primaryColor,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w500,
                  fontSize: height / 32,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(height / 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last 4 digits of credit card',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.textDark.withValues(alpha: 0.8),
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                  fontSize: height / 30,
                ),
              ),
              SizedBox(height: height / 80),
              customTextField(
                textEditingController: controller.lastFourDigitOfCreditCard,
                prefixIcon: dottedDigits(MediaQuery.sizeOf(context).height),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(width / 50),
                  borderSide: BorderSide(
                    color: appColors.black.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                inputFormatter: [
                  FilteringTextInputFormatter.deny(
                      RegExp(r'[!@#$%^&*(),.?":{}|<>-]'))
                ],
                fullTag: '0 0 0 0',
                title: '0 0 0 0',
                onChanged: (v) {
                  controller.update();
                },
                keyboardType: TextInputType.number,
                maxLength: 4,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: appColors.primaryColor,
                  fontSize: height / 18,
                  letterSpacing: 4,
                ),
              ),
              SizedBox(height: height / 20),
              Text(
                'Mobile number (Linked to credit card)',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.textDark.withValues(alpha: 0.8),
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                  fontSize: height / 30,
                ),
              ),
              SizedBox(height: height / 80),
              customTextField(
                textEditingController: controller.mobileNumber,
                maxLength: 10,
                onChanged: (v) {
                  controller.update();
                },
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(width / 50),
                  borderSide: BorderSide(
                    color: appColors.black.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
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
                        color: appColors.primaryColor,
                      ),
                      Text(
                        "  +91",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: appColors.primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: height / 26,
                        ),
                      ),
                    ],
                  ),
                ),
                inputFormatter: [
                  FilteringTextInputFormatter.deny(
                      RegExp(r'[!@#$%^&*(),.?":{}|<>-]'))
                ],
                title: 'Enter mobile number',
                keyboardType: TextInputType.number,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: appColors.textDark,
                  fontSize: height / 24,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: height / 6),
              consentCard(height),
              SizedBox(height: height / 36),
              if (controller.mobileNumber.text.length == 10 &&
                  controller.lastFourDigitOfCreditCard.text.length == 4)
                controller.loader.value
                    ? Center(
                        child: Lottie.asset(
                          'assets/lottie/wave_loading.json',
                          width: width,
                          height: height / 4,
                        ),
                      )
                    : customButton(
                        title: 'Confirm',
                        onTap: () async {
                          String last4DigitOfCreditCardKey = "";
                          String mobileNumberKey = "";

                          for (var item in creditCardData['customerParams']) {
                            final name = (item["paramName"] ?? "")
                                .toString()
                                .toLowerCase();

                            if (name.contains("4") ||
                                name.contains("four") ||
                                name.contains("card")) {
                              last4DigitOfCreditCardKey = item["paramName"];
                            } else if (name.contains("mobile") ||
                                name.contains("phone") ||
                                name.contains("tele") ||
                                name.contains("registered")) {
                              mobileNumberKey = item["paramName"];
                            }
                          }

                          controller.logo = creditCardData['logo'];

                          controller.selectedCreditCard = bankName;

                          await controller.getCreditCardBillFetchRequest(
                              billerId: creditCardData['id'],
                              customerParams: last4DigitOfCreditCardKey,
                              regMobileParams: mobileNumberKey);
                        },
                        context: context,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: appColors.white,
                          fontSize: height / 24,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
            ],
          ),
        ),
      ],
    );
  }

  SliverAppBar appBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: appColors.primaryColor,
      expandedHeight: height / 4.6,
      floating: false,
      pinned: true,
      forceElevated: true,
      stretch: true,
      title: null,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: appColors.primaryColor),
            Image.asset(
              'assets/images/flare_two.png',
              fit: BoxFit.fitHeight,
            ),
            Container(
              margin: EdgeInsets.only(
                left: width / 30,
                bottom: width / 20,
                right: width / 30,
              ),
              alignment: Alignment.bottomLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  backButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector backButton() {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Icon(
                Icons.arrow_back_ios_rounded,
                size: height / 18,
                color: appColors.primaryExtraLight,
              ),
              SizedBox(width: width / 80),
              Text(
                'Add new',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.white,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w300,
                  fontSize: height / 20,
                ),
              ),
            ],
          ),
          SizedBox(width: width / 2.35),
          Image.asset(
            'assets/home/bbps_white_logo.png',
            height: height / 10,
          ),
        ],
      ),
    );
  }
}
