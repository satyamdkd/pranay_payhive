import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import '../../../utils/screen_size.dart';
import '../../../utils/theme/apptheme.dart';
import '../../../utils/widgets/button.dart';
import '../../../utils/widgets/textfield.dart';
import '../controller/reverify_aadhar_controller.dart';

class ReverifyAadharView extends GetView<ReverifyAadharController> {
  ReverifyAadharView({super.key});

  final defaultPinTheme = PinTheme(
    width: height / 7.5,
    height: height / 7.5,
    textStyle: TextStyle(
        fontSize: height / 16,
        color: const Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
      borderRadius: BorderRadius.circular(8),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.primaryColor,
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
            children: [text(), spacer(), aadhar(context)],
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
        "Enter Your\nAadhar Number",
        style: theme.textTheme.headlineSmall
            ?.copyWith(color: appColors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  aadhar(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (ctx) {
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
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: width / 20, right: width / 20),
                  child: Form(
                    child: Column(
                      children: [
                        spacing(passedHeight: height / 10),
                        spacer(),
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
            ),
          );
        });
  }
}
