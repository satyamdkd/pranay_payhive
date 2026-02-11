import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/fetch_bill/controller/fetch_bill_controller.dart';
import 'package:payhive/routes/pages.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/textfield.dart';

class FetchBillPage extends GetView<FetchBillController> {
  const FetchBillPage({super.key});

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
          padding: EdgeInsets.all(width / 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height / 16),
              buildSearchBar(),
              SizedBox(height: height / 16),
              Text(
                'All Billers',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: height / 26,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: height / 16),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height / 50, horizontal: width / 30),
                child: Row(
                  children: [
                    Container(
                      height: height / 8,
                      width: height / 8,
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: appColors.white,
                        borderRadius: BorderRadius.circular(1000),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            spreadRadius: 2,
                            blurRadius: 9,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      // child: Image.asset(
                      //   'assets/temp/bses_logo.png',
                      //   fit: BoxFit.contain,
                      // ),
                    ),
                    SizedBox(width: width / 20),
                    Text(
                      'Andhra Pradesh Central\nPower Distribution Limited',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: appColors.primaryColor,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: height / 28,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),


              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height / 50, horizontal: width / 30),
                child: Row(
                  children: [
                    Container(
                      height: height / 8,
                      width: height / 8,
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: appColors.white,
                        borderRadius: BorderRadius.circular(1000),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            spreadRadius: 2,
                            blurRadius: 9,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      // child: Image.asset(
                      //   'assets/temp/bses_logo.png',
                      //   fit: BoxFit.contain,
                      // ),
                    ),
                    SizedBox(width: width / 20),
                    Text(
                      'Eastern Power Distribution\nCo Ltd (APEPDCL)',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: appColors.primaryColor,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: height / 28,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height / 50, horizontal: width / 30),
                child: Row(
                  children: [
                    Container(
                      height: height / 8,
                      width: height / 8,
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: appColors.white,
                        borderRadius: BorderRadius.circular(1000),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            spreadRadius: 2,
                            blurRadius: 9,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      // child: Image.asset(
                      //   'assets/temp/bses_logo.png',
                      //   fit: BoxFit.contain,
                      // ),
                    ),
                    SizedBox(width: width / 20),
                    Text(
                      'Southern Power Distribution\nCo Ltd (APSPDCL)',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: appColors.primaryColor,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: height / 28,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height / 50, horizontal: width / 30),
                child: Row(
                  children: [
                    Container(
                      height: height / 8,
                      width: height / 8,
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: appColors.white,
                        borderRadius: BorderRadius.circular(1000),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            spreadRadius: 2,
                            blurRadius: 9,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      // child: Image.asset(
                      //   'assets/temp/bses_logo.png',
                      //   fit: BoxFit.contain,
                      // ),
                    ),
                    SizedBox(width: width / 20),
                    Text(
                      'TTD Electricity',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: appColors.primaryColor,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: height / 28,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),



              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height / 50, horizontal: width / 30),
                child: Row(
                  children: [
                    Container(
                      height: height / 8,
                      width: height / 8,
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: appColors.white,
                        borderRadius: BorderRadius.circular(1000),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            spreadRadius: 2,
                            blurRadius: 9,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      // child: Image.asset(
                      //   'assets/temp/bses_logo.png',
                      //   fit: BoxFit.contain,
                      // ),
                    ),
                    SizedBox(width: width / 20),
                    Text(
                      'Department of power,\nGovernment of Arunachal\nPradesh',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: appColors.primaryColor,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: height / 28,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),



              InkWell(
                onTap: () {
                  Get.toNamed(Routes.fetchedBill, arguments: {
                    'category': controller.billCategory,
                    'biller': 'Tata Power - Delhi'
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: height / 50, horizontal: width / 30),
                  child: Row(
                    children: [
                      Container(
                        height: height / 8,
                        width: height / 8,
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: appColors.white,
                          borderRadius: BorderRadius.circular(1000),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              spreadRadius: 2,
                              blurRadius: 9,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        // child: Image.asset(
                        //   'assets/temp/tata_power_logo.png',
                        //   fit: BoxFit.contain,
                        // ),
                      ),
                      SizedBox(width: width / 20),
                      Text(
                        'Tata Power - Delhi',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: appColors.primaryColor,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: height / 26,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),


            ],
          ),
        )
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
                  headersBBPSandPaylix(),
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
        children: [
          Icon(
            Icons.arrow_back_ios_rounded,
            size: height / 18,
            color: appColors.white,
          ),
          SizedBox(width: width / 40),
          Text(
            controller.billCategory,
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

  Widget buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width / 30),
        color: appColors.white,
      ),
      child: customTextField(
        textEditingController: controller.searchedText,
        border: false,
        prefixIcon: Container(
          padding: EdgeInsets.all(width / 26),
          child: Icon(
            CupertinoIcons.search,
            size: height / 18,
          ),
        ),
        suffixIcon: controller.searchedText.text.isNotEmpty
            ? InkWell(
                onTap: () {
                  controller.update();
                },
                child: Container(
                  padding: EdgeInsets.all(width / 26),
                  child: Icon(
                    CupertinoIcons.clear_circled,
                    color: appColors.red,
                    size: height / 18,
                  ),
                ),
              )
            : null,
        onChanged: (v) {},
        fullTag: "Search for your biller",
        title: "",
        keyboardType: TextInputType.text,
      ),
    );
  }
}
