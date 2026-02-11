import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/pay_vendor/controller/vendor_payment_controller.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/error.dart';
import 'package:pinput/pinput.dart';

pinBottomSheet(context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => CustomBottomSheet(),
  );
}

class CustomBottomSheet extends StatelessWidget {
  CustomBottomSheet({super.key});

  final myController = Get.find<VendorPaymentController>();

  final defaultPinTheme = PinTheme(
    width: height / 7.5,
    height: height / 7.5,
    textStyle: TextStyle(
        fontSize: height / 16,
        color: const Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(8),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets, // Important
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Enter PIN to Confirm",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.primaryColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Sora',
                  fontSize: height / 28,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: height / 30),
              Center(
                child: Pinput(
                  controller: myController.pinController,
                  defaultPinTheme: PinTheme(
                    width: height / 7.5,
                    height: height / 7.5,
                    textStyle: TextStyle(
                        fontSize: height / 16,
                        color: const Color.fromRGBO(30, 60, 87, 1),
                        fontWeight: FontWeight.w600),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey.shade400, width: 1.0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  length: 4,
                  focusedPinTheme: defaultPinTheme.copyDecorationWith(
                    border:
                        Border.all(color: appColors.primaryColor, width: 1.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration?.copyWith(
                      color: const Color.fromRGBO(234, 239, 243, 1),
                    ),
                  ),
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onChanged: (pin) {},
                  onCompleted: (pin) {},
                ),
              ),
              SizedBox(height: height / 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customButton(
                      passedHeight: height / 10,
                      passedWidth: width / 3.4,
                      title: 'Confirm',
                      onTap: () {
                        if (myController.pinController.text.isEmpty &&
                            myController.pinController.text.length != 4) {
                          errorDialog(
                              context: context,
                              message: "Please enter your 4 Digit PIN",
                              title: "PIN");
                        } else {
                          myController.transferMoney(context);
                        }
                      },
                      context: context),
                  SizedBox(width: width / 60),
                  SizedBox(
                    height: height / 10,
                    width: width / 3.4,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: appColors.primaryLight,
                        side: BorderSide(
                          color: appColors.primaryLight.withAlpha(64),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(height / 40),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "Cancel",
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: appColors.primaryLight,
                          fontWeight: FontWeight.w600,
                          fontSize: height / 32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height / 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 10),
                child: Divider(
                  thickness: 1,
                  color: appColors.black.withAlpha(38),
                ),
              ),
              SizedBox(height: height / 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 20),
                child: headerText(
                  "CAUTION: Are you sure you want to proceed with the transfer by clicking 'Confirm'? Your default PIN is the last four digits of your mobile number.",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text headerText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: theme.textTheme.labelMedium?.copyWith(
        color: appColors.red,
        fontWeight: FontWeight.w400,
        fontFamily: 'Sora',
        fontSize: height / 38,
        letterSpacing: 1,
      ),
    );
  }
}
