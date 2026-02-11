import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/dashboard/controller/dashboard_controller.dart';
import 'package:payhive/routes/pages.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/snackbar.dart';
import 'package:payhive/utils/widgets/textfield.dart';

import '../../../../constants/string_constants.dart';
import '../../widget/upload_aadhar.dart';

class Home extends GetView<DashBoardController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.all(height / 30),
      child: GetBuilder<DashBoardController>(
          init: controller,
          builder: (ctx) {
            return Column(
              children: [
                Image.asset('assets/home/static_icons/check_cibil.png'),
                spacing(passedHeight: height / 30),

                recharge(),
                spacing(passedHeight: height / 30),

                /// transfer(),Card.png
                /// spacing(passedHeight: height / 30),
                /// if (controller.isPosAssigned.value) pos(),

                Image.asset('assets/home/static_icons/insurance.png'),
                spacing(passedHeight: height / 30),

                Image.asset('assets/home/static_icons/loan.png'),
                spacing(passedHeight: height / 5),

              ],
            );
          }),
    );
  }

  Container banner() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: width / 40),
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
        child: Image.asset('assets/home/banner.png'));
  }

  recharge() {
    return Container(
      padding: EdgeInsets.all(width / 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            // blurRadius: 1,
            spreadRadius: 0.5,
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
              ],
            ),
          ),
          spacing(passedHeight: height / 24),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            mainAxisSpacing: height / 40,
            crossAxisCount: 4,
            children: rechargeCategories
                .map(
                  (item) => InkWell(
                    onTap: () => utilityBillNavigation(item),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          item["icon"],
                          fit: BoxFit.contain,
                          height: item["id"] == 0 ? height / 9 : height / 11,
                          width: item["id"] == 0 ? height / 9 : height / 11,
                        ),
                        Text(
                          item["title"],
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: appColors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: height / 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          spacing(passedHeight: height / 32),
        ],
      ),
    );
  }

  void utilityBillNavigation(item) {
    if (controller.accountStatus.value == 'inactive') {
      return;
    }
    controller.dashboardApi();

    if (item["id"] == 0) {
      Get.toNamed(Routes.creditCardBillPay);
    }
    if (item["id"] == 1) {
      Get.toNamed(Routes.dthRecharge);
    }
    if (item["id"] == 2) {
      Get.toNamed(Routes.electricity);
    }
    if (item["id"] == 3) {
      Get.toNamed(Routes.fastTag);
    }
    if (item["id"] == 4) {
      Get.toNamed(Routes.gasBooking);
    }
  }

  void posNavigation(item) {
    controller.dashboardApi();

    if (item["id"] == 0) {
      Get.toNamed(Routes.posRequest);
    } else {
      Get.toNamed(Routes.listPosRequest);
    }
  }

  void transferNavigation(item) {
    controller.dashboardApi();

    if (item["id"] == 0) {
      Get.toNamed(Routes.vendorPay);
    }
  }

  pos() {
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
                  "Point of Sale (POS)",
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: appColors.textDark,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                    fontSize: height / 24,
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
            mainAxisSpacing: height / 40,
            crossAxisCount: 4,
            children: posCategories
                .map(
                  (item) => InkWell(
                    onTap: () => posNavigation(item),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          item["icon"],
                          fit: BoxFit.contain,
                          height: height / 8,
                          width: height / 8,
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
                  ),
                )
                .toList(),
          ),
          spacing(passedHeight: height / 32),
        ],
      ),
    );
  }

  transfer() {
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
                  "Transfers",
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: appColors.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: height / 24,
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
            mainAxisSpacing: height / 40,
            crossAxisCount: 4,
            children: transferCategories
                .map(
                  (item) => InkWell(
                    onTap: () => transferNavigation(item),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          item["icon"],
                          fit: BoxFit.contain,
                          scale: 3.6,
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
                  ),
                )
                .toList(),
          ),
          spacing(passedHeight: height / 32),
        ],
      ),
    );
  }
}
