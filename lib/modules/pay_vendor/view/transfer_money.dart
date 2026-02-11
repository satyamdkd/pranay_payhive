import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/modules/pay_vendor/controller/vendor_payment_controller.dart';
import 'package:payhive/services/di/di.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/textfield.dart';

class TransferMoney extends ModalRoute<void> {
  TransferMoney({required this.myController});

  final VendorPaymentController? myController;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black.withAlpha(50);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: _buildOverlayContent(context),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Align(
          alignment: Alignment.center,
          child: Material(
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.width / 30),
            child: Container(
              height: MediaQuery.of(context).size.height / 1.18,
              width: MediaQuery.of(context).size.width / 1.11,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width / 30),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: GetBuilder(
                            init: myController,
                            builder: (ctx) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: height / 10,
                                    width: width,
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                      color: appColors.primaryExtraLight
                                          .withAlpha(90),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                            MediaQuery.of(context).size.width /
                                                30),
                                        topRight: Radius.circular(
                                            MediaQuery.of(context).size.width /
                                                30),
                                      ),
                                    ),
                                    child: IntrinsicWidth(
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin:
                                            EdgeInsets.only(right: width / 40),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width / 30),
                                        height: height / 16,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            height / 30,
                                          ),
                                          border: Border.all(
                                              color: appColors.red, width: 0.6),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            "Close",
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.bodyLarge
                                                ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: appColors.red
                                                  .withValues(alpha: 0.8),
                                              fontSize: height / 34,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(height / 30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        headerText("Account Holder"),
                                        SizedBox(height: height / 110),
                                        textField(TextEditingController(
                                          text:
                                              myController!.payeeDetails!.name,
                                        )),
                                        SizedBox(height: height / 30),
                                        headerText("Account Holder Mobile No."),
                                        SizedBox(height: height / 110),
                                        textField(TextEditingController(
                                          text:
                                              myController!.payeeDetails!.phone,
                                        )),
                                        SizedBox(height: height / 30),
                                        headerText("Bank Account Number"),
                                        SizedBox(height: height / 110),
                                        textField(TextEditingController(
                                          text: myController!
                                              .payeeDetails!.accountnumber,
                                        )),
                                        SizedBox(height: height / 30),
                                        headerText("IFSC Code"),
                                        SizedBox(height: height / 110),
                                        textField(TextEditingController(
                                          text:
                                              myController!.payeeDetails!.ifsc,
                                        )),
                                        SizedBox(height: height / 30),
                                        headerText("Amount"),
                                        SizedBox(height: height / 110),
                                        customTextField(
                                          textEditingController:
                                              myController!.amount,
                                          fullTag: '',
                                          title: '',
                                          borderRadius: width / 80,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            decorationThickness: 0.0,
                                            color: appColors.textDark,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Sora',
                                            fontSize: height / 30,
                                            letterSpacing: 1,
                                          ),
                                          fillColor: appColors.primaryExtraLight
                                              .withAlpha(90),
                                          border: false,
                                          filled: true,
                                          onChanged: (v) {
                                            myController!.update();
                                          },
                                          inputFormatter: [
                                            FilteringTextInputFormatter.deny(
                                                RegExp(
                                                    r'[!@#$%^&*(),.?":{}|<>-]'))
                                          ],
                                        ),
                                        SizedBox(height: height / 100),
                                        headerText(
                                          "Transaction charges : ₹${double.parse(marginPerTransaction).toStringAsFixed(2)}",
                                          color: appColors.primaryColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: height / 38,
                                        ),
                                        SizedBox(height: height / 60),
                                        headerText(
                                          "Total deductible = Withdrawal amount + Transaction charges.",
                                          color: appColors.primaryColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: height / 44,
                                        ),
                                        SizedBox(height: height / 200),
                                        headerText(
                                          "(e.g. ₹${double.parse(myController!.amount.text.isEmpty ? '0' : myController!.amount.text.toString())} + ₹${double.parse(marginPerTransaction).toStringAsFixed(2)} = ₹${double.parse(myController!.amount.text.isEmpty ? '0' : myController!.amount.text.toString()) + double.parse(marginPerTransaction)})",
                                          color: appColors.primaryColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: height / 38,
                                        ),
                                        SizedBox(height: height / 20),
                                        myController!.isLoadingTransfer.value
                                            ? Center(
                                                child: Lottie.asset(
                                                  'assets/lottie/wave_loading.json',
                                                  width: width,
                                                  height: height / 5,
                                                ),
                                              )
                                            : customButton(
                                                title: 'Transfer',
                                                context: context,
                                                onTap: () {
                                                  myController
                                                      ?.validateTransfer(
                                                          context);
                                                },
                                                style: TextStyle(
                                                  decorationThickness: 0.0,
                                                  color: appColors.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Sora',
                                                  fontSize: height / 28,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                        SizedBox(height: height / 20),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          child: Divider(
                                            thickness: 1,
                                            color: appColors.black
                                                .withValues(alpha: 0.15),
                                          ),
                                        ),
                                        SizedBox(height: height / 24),
                                        headerText(
                                          "CAUTION: Transfers for illegal activities, gambling, or to unknown recipients are prohibited. User bears full responsibility for unauthorized transactions. Amounts cannot be reversed once transferred.",
                                          color: appColors.red,
                                          fontWeight: FontWeight.w400,
                                          fontSize: height / 38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Text headerText(text, {color, fontWeight, fontSize}) {
    return Text(
      text,
      style: theme.textTheme.labelMedium?.copyWith(
        color: color ?? appColors.textDark.withAlpha(180),
        fontWeight: fontWeight ?? FontWeight.w400,
        fontFamily: 'Sora',
        fontSize: fontSize ?? height / 32,
        letterSpacing: 0.6,
      ),
    );
  }

  Widget textField(controller) {
    return customTextField(
      textEditingController: controller,
      fullTag: '',
      title: '',
      borderRadius: width / 80,
      readOnly: true,
      keyboardType: TextInputType.number,
      style: TextStyle(
        decorationThickness: 0.0,
        color: appColors.textDark,
        fontWeight: FontWeight.w400,
        fontFamily: 'Sora',
        fontSize: height / 30,
        letterSpacing: 1,
      ),
      fillColor: appColors.primaryExtraLight.withAlpha(90),
      border: false,
      filled: true,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
