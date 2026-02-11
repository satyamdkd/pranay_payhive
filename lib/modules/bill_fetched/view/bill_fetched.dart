import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/bill_fetched/controller/bill_fetched_controller.dart';
import 'package:payhive/routes/pages.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/textfield.dart';

class BillFetchedPage extends GetView<BillFetchedController> {
  const BillFetchedPage({super.key});

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          color: appColors.primaryColor.withValues(alpha: 0.2),
          padding: EdgeInsets.symmetric(vertical: height / 60),
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: width / 16),
              Text(
                'Bharat Connect  ',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.primaryColor,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w400,
                  fontSize: height / 28,
                ),
              ),
              const Spacer(),
              Image.asset(
                'assets/icons/bbps_logo.png',
                height: height / 14,
              ),
              SizedBox(
                width: width / 16,
              ),
            ],
          ),
        ),


        Padding(
          padding: EdgeInsets.all(height / 30),
          child: Column(children: [

            SizedBox(height: height / 16),
            selectedBiller(context),
            SizedBox(height: height / 16),
            Obx(() => controller.isBillFetched.value == false
                ? textField()
                : billDetails()),
            SizedBox(height: height / 8),
            Text(
              " The payment will reflect at biller's end after 2-3 working days",
              style: theme.textTheme.labelMedium?.copyWith(
                color: appColors.textDark.withValues(alpha: 0.8),
                fontWeight: FontWeight.w400,
                fontFamily: 'Sora',
                fontSize: height / 36,
              ),
            ),
            SizedBox(height: height / 90),
            Obx(
                  () => customButton(
                title: controller.isBillFetched.value == false
                    ? 'Continue'
                    : 'Pay now',
                style: theme.textTheme.headlineSmall!.copyWith(
                  color: appColors.white,
                  fontSize: height / 24,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w400,
                ),
                context: context,
                onTap: () {
                  controller.isBillFetched.value == false
                      ? controller.fetchBill()
                      : controller.payNow(context);
                },
              ),
            )

          ],),
        ),



      ],
    );
  }

  Widget billDetails() => Container(
        width: width,
        padding: EdgeInsets.all(height / 30),
        decoration: BoxDecoration(
          color: const Color(0xffEAE0F4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Wrap(
          spacing: 40,
          runSpacing: 20,
          children: [
            _labelValue('Amount', '₹5,000', bold: true),
            _labelValue('Customer name', 'Satyam kumar'),
            _labelValue('Account number', 'ABCDE1234E'),
            _labelValue('Bill number', '1001'),
            _labelValue('Bill date', '10 June, 2025'),
            _labelValue('Due date', '15 June, 2025'),
          ],
        ),
      );

  Widget _labelValue(String label, String value, {bool bold = false}) {
    return SizedBox(
      width: width / 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.textDark.withValues(alpha: 0.8),
              fontWeight: FontWeight.w400,
              fontFamily: 'Sora',
              fontSize: height / 36,
            ),
          ),
          SizedBox(height: height / 80),
          Text(
            value,
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.textDark.withValues(alpha: 0.8),
              fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
              fontFamily: 'Sora',
              fontSize: height / 36,
            ),
          ),
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
                  headersBBPSandPaylix(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width / 30),
        color: appColors.white,
      ),
      child: customTextField(
        textEditingController: controller.textEditingController,
        border: true,
        onChanged: (v) {},
        fullTag: "Enter ca number.",
        title: "",
        keyboardType: TextInputType.text,
      ),
    );
  }





  GestureDetector backButton() {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_ios_rounded,
            size: height / 18,
            color: appColors.white,
          ),
          SizedBox(width: width / 40),
          Text(
            controller.args!['category'],
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.white,
              fontWeight: FontWeight.w700,
              fontSize: height / 20,
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector headersBBPSandPaylix() {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: SizedBox(
        width: width - width / 12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [

            backButton(),
            Image.asset(
              'assets/icons/paylix_logo.png',
              height: height / 9,
              color: appColors.white,
            ),

          ],
        ),
      ),
    );
  }

  Widget selectedBiller(context) {
    return Container(
      width: width,
      padding: EdgeInsets.all(height / 30),
      decoration: BoxDecoration(
        color: const Color(0xffEAE0F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Selected Biller",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.textDark,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Sora',
                  fontSize: height / 28,
                ),
              ),
              Obx(
                () => controller.isBillFetched.value == false
                    ? InkWell(
                        onTap: () {
                          Get.offNamed(
                            Routes.fetchBill,
                            arguments: controller.args!['category'],
                          );
                        },
                        child: Text(
                          "Change",
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Sora',
                            fontSize: height / 36,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
          SizedBox(height: height / 60),
          Text(
            "${controller.args!['biller']}",
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.textDark,
              fontWeight: FontWeight.w600,
              fontFamily: 'Sora',
              fontSize: height / 28,
            ),
          ),
        ],
      ),
    );
  }
}
