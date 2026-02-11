import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/modules/recharge_and_bill_pay/dth/controller/dth_controller.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/error.dart';
import 'package:payhive/utils/widgets/textfield.dart';
import 'package:flutter/services.dart';

class Recharge extends GetView<DthController> {
  const Recharge({super.key});

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

  @override
  Widget build(BuildContext context) {
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
                controller.billerName!.toUpperCase(),
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
          child: GetBuilder(
              init: controller,
              builder: (ctx) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height / 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' Enter amount',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: appColors.textDark.withValues(alpha: 0.8),
                            letterSpacing: 1,
                            fontWeight: FontWeight.w500,
                            fontSize: height / 32,
                          ),
                        ),
                        SizedBox(height: height / 80),
                        customTextField(
                          textEditingController: controller.amount,
                          maxLength: 10,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(width / 50),
                            borderSide: BorderSide(
                              color: appColors.black.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          onChanged: (v) {
                            controller.amount.text = v.toString().trim();
                            controller.selectedIndex.value = -1;
                            controller.update();
                          },
                          inputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          title: '',
                          fullTag: '',
                          keyboardType: TextInputType.number,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.primaryColor,
                            fontSize: height / 26,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height / 20),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          List.generate(controller.amounts.length, (index) {
                        final selected =
                            controller.selectedIndex.value == index;
                        return GestureDetector(
                          onTap: () {
                            controller.selectedIndex.value = index;
                            final amt = controller.amounts[index].split('₹')[1];
                            controller.amount.text = amt.toString();
                            controller.update();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selected
                                  ? appColors.primaryColor
                                  : appColors.bgColorHome,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: selected
                                    ? appColors.primaryColor
                                    : Colors.grey,
                                width: 0.5,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            child: Text(
                              controller.amounts[index],
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    if (controller.amount.text.isNotEmpty)
                      SizedBox(height: height / 8),
                    if (controller.amount.text.isNotEmpty) consentCard(height),
                    SizedBox(height: height / 36),
                    if (controller.amount.text.isNotEmpty)
                      controller.paymentRequestLoader.value
                          ? Center(
                              child: Lottie.asset(
                                'assets/lottie/wave_loading.json',
                                width: width,
                                height: height / 4,
                              ),
                            )
                          : customButton(
                              title: 'Proceed to pay',
                              onTap: () {
                                if (double.parse(
                                        controller.amount.text.trim()) >=
                                    200) {
                                  controller.billPaymentRequest();
                                } else {
                                  errorDialog(
                                      context: context,
                                      message:
                                          'Please enter an amount greater than or equal to ₹200.');
                                }
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
                );
              }),
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
                'DTH Recharge',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.white,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w300,
                  fontSize: height / 20,
                ),
              ),
            ],
          ),
          SizedBox(width: width / 3.5),
          Image.asset(
            'assets/home/bbps_white_logo.png',
            height: height / 10,
          ),
        ],
      ),
    );
  }
}
