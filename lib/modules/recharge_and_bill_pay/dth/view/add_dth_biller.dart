import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/modules/recharge_and_bill_pay/dth/controller/dth_controller.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/textfield.dart';
import 'package:flutter/services.dart';

class AddNewDTHBill extends GetView<DthController> {
  const AddNewDTHBill(this.billerName, this.billerData, {super.key});

  final Map<String, dynamic> billerData;
  final String billerName;

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
    final config =
        controller.getInputFieldConfigDynamic(billerData['customerParams'])!;

    log('Customer param : ${config['paramName1']}, ${config['paramName2']}');

    final stringList = '${config['paramName1']}'.split('/');

    final filteredList = stringList.where((item) {
      final lower = item.toLowerCase().trim();

      return !(lower.contains('mobile number') ||
          lower.contains('registered telephone no') ||
          lower.contains('phone number'));
    }).toList();

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
                billerName.toUpperCase(),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ' ${filteredList[0]}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: appColors.textDark.withValues(alpha: 0.8),
                      letterSpacing: 1,
                      fontWeight: FontWeight.w500,
                      fontSize: height / 32,
                    ),
                  ),
                  SizedBox(height: height / 80),
                  customTextField(
                    textEditingController: controller.mobileOrSubId,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width / 50),
                      borderSide: BorderSide(
                        color: appColors.black.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[!@#$%^&*(),.?":{}|<>-]'))
                    ],
                    title: '',
                    fullTag: '',
                    keyboardType: TextInputType.text,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: appColors.primaryColor,
                      fontSize: height / 26,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height / 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ' Registered mobile number',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: appColors.textDark.withValues(alpha: 0.8),
                      letterSpacing: 1,
                      fontWeight: FontWeight.w500,
                      fontSize: height / 32,
                    ),
                  ),
                  SizedBox(height: height / 80),
                  customTextField(
                    textEditingController: controller.mobileNumber,
                    maxLength: 10,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width / 50),
                      borderSide: BorderSide(
                        color: appColors.black.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    onChanged: (v) {
                      controller.update();
                    },
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    title: '',
                    fullTag: '',
                    keyboardType: TextInputType.phone,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: appColors.primaryColor,
                      fontSize: height / 26,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              if (controller.mobileOrSubId.text.isNotEmpty &&
                  controller.mobileNumber.text.length == 10)
                SizedBox(height: height / 6),
              if (controller.mobileOrSubId.text.isNotEmpty &&
                  controller.mobileNumber.text.length == 10)
                consentCard(height),
              SizedBox(height: height / 36),
              if (controller.mobileOrSubId.text.isNotEmpty &&
                  controller.mobileNumber.text.length == 10)
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
                        onTap: () {
                          final param = config['paramName1'];

                          controller.validateNew(
                            firstTitle: filteredList[0],
                            params: param,
                            billerData: billerData,
                          );
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
