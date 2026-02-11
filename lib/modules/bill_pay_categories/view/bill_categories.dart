import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/bill_pay_categories/controller/bill_cat_controller.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';

import '../../../constants/string_constants.dart';
import '../../../utils/widgets/textfield.dart';

class BillPayCategories extends GetView<BillCategoriesController> {
  const BillPayCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appColors.bgColorHome,
      bottomNavigationBar: Padding(
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
      ),
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          appBar(),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => GetBuilder(
                  init: controller,
                  builder: (ctx) {
                    return body(context);
                  }),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }

  body(context) {
    return Padding(
      padding: EdgeInsets.all(height / 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          insurance(),
        ],
      ),
    );
  }

  insurance() {
    return Container(
      padding: EdgeInsets.all(width / 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recharges & Bill Pay",
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: appColors.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: height / 24,
                  ),
                ),
                Text(
                  "",
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: appColors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: height / 32,
                  ),
                ),
              ],
            ),
          ),
          spacing(passedHeight: height / 24),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            mainAxisSpacing: height / 20,
            crossAxisCount: 4,
            children: allBillPayCategories
                .map(
                  (item) => Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        item["icon"],
                        fit: BoxFit.contain,
                        height: item["title"] == 'Credit Card\nBill Payment'
                            ? height / 8
                            : item["title"] == 'LPG Gas\nCylinder' ||
                                    item["title"] == 'Gas\nPayment'
                                ? height / 9
                                : height / 10,
                        width: item["title"] == 'Credit Card\nBill Payment'
                            ? height / 8
                            : item["title"] == 'LPG Gas\nCylinder' ||
                                    item["title"] == 'Gas\nPayment'
                                ? height / 9
                                : height / 10,
                      ),
                      Text(
                        item["title"],
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: appColors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: height / 36,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          spacing(passedHeight: height / 32),
        ],
      ),
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
                "All Categories",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.white,
                  fontWeight: FontWeight.w200,
                  fontSize: height / 20,
                ),
              ),
            ],
          ),
          SizedBox(width: width / 3.1),
          Image.asset(
            'assets/home/bbps_white_logo.png',
            height: height / 10,
          ),
        ],
      ),
    );
  }
}
