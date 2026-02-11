import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/auth/salary/view/pan_verify_salary.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/textfield.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CompleteYourKYC extends StatefulWidget {
  const CompleteYourKYC({super.key});

  @override
  State<CompleteYourKYC> createState() => _CompleteYourKYCState();
}

class _CompleteYourKYCState extends State<CompleteYourKYC> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appColors.primaryColor,
      body: body(),
    );
  }

  LinearPercentIndicator progress() {
    return LinearPercentIndicator(
      width: width,
      animation: true,
      animationDuration: 2000,
      padding: EdgeInsets.zero,
      lineHeight: height / 100,
      percent: 0.5,
      backgroundColor: appColors.primaryExtraLight,
      progressColor: appColors.green,
    );
  }

  Container text() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        top: width / 40,
        left: width / 18,
        right: width / 20,
      ),
      child: Text(
        "Complete Your KYC",
        style: theme.textTheme.headlineSmall?.copyWith(
            color: appColors.primaryColor, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget body() {
    return SafeArea(
      child: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          color: const Color(0xffF8F2FF),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin:
                            EdgeInsets.only(top: height / 20, left: width / 30),
                        child: Icon(
                          CupertinoIcons.back,
                          color: appColors.primaryColor,
                          size: height / 10,
                        ),
                      ),
                    ),
                    spacing(passedHeight: height/2),
                    text(),
                    spacing(passedHeight: height / 60),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: width / 16),
                      child: Text(
                        "Complete your KYC to unlock secured and seamless transactions of Payhive",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: appColors.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    spacing(passedHeight: height / 12),
                    // Container(
                    //   padding: EdgeInsets.all(height / 10),
                    //   decoration: BoxDecoration(
                    //       color: appColors.primaryExtraLight,
                    //       borderRadius: BorderRadius.circular(20)),
                    //   height: height / 1,
                    //   width: width / 1.1,
                    //   child: Image.asset(
                    //     "assets/images/complete_kyc.png",
                    //     fit: BoxFit.fitHeight,
                    //   ),
                    // ),
                    /// spacing(passedHeight: height ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width / 20.0, right: width / 20.0),
                      child: customButton(
                          title: "Continue",
                          context: context,
                          onTap: () {
                            Get.to(() => const PanVerifySalary(), transition: Transition.leftToRight,);
                          }),
                    ),
                    spacing(passedHeight: height / 50),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding:
                          EdgeInsets.only(left: width / 16, right: width / 16),
                      child: Text(
                        "Keep Your PAN , Aadhar and Account Number Handy, This will take Only Few Minutes",
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: appColors.textDark,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
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
          )),
    );
  }

  List list = [
    "assets/temp/employee-benefit.png",
    "assets/temp/employment.png",
    "assets/temp/people.png",
  ];
  List listTitle = [
    "Salaried",
    "Self Employed",
    "Others",
  ];
  List listSubtitle = [
    "with salaried status",
    "with self employed status",
    "If you are not Salaried or Self employed.",
  ];

  Widget item(path, index, title, subtitle) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: width,
      margin: EdgeInsets.only(bottom: width / 40, left: 1, right: 1),
      padding:
          EdgeInsets.symmetric(vertical: width / 30, horizontal: width / 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: appColors.white,
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                index == 0
                    ? "assets/icons/checkbox.png"
                    : "assets/icons/blank_checkbox.png",
                height: height / 18,
                fit: BoxFit.contain,
              ),
              SizedBox(width: width / 40),
              Container(
                decoration: BoxDecoration(
                  color: appColors.primaryLight.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(1000.0),
                ),
                padding: const EdgeInsets.all(25),
                child: SizedBox(
                  height: height / 14,
                  width: height / 14,
                  child: Image.asset(
                    path,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: appColors.textDark,
                        fontWeight: FontWeight.w500,
                        fontSize: width / 26,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: appColors.textDark,
                        fontWeight: FontWeight.w400,
                        fontSize: width / 36,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
