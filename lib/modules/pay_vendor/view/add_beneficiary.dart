import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/modules/pay_vendor/controller/vendor_payment_controller.dart';
import 'package:payhive/services/di/di.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/error.dart';
import 'package:payhive/utils/widgets/textfield.dart';

class AddBeneficiary extends GetView<VendorPaymentController> {
  const AddBeneficiary({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.bgColorHome,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
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
                left: height / 30,
                bottom: width / 30,
                right: height / 30,
              ),
              alignment: Alignment.bottomLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1000.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: appColors.white,
                            borderRadius: BorderRadius.circular(1000.0),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: SizedBox(
                            height: height / 14,
                            width: height / 14,
                            child: Image.asset(
                              "assets/icons/payhive_logo.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: width / 40),
                      Text(
                        "Hi, $userName",
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: appColors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: height / 24,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/wallet.png',
                        scale: 4,
                      ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      Image.asset(
                        'assets/images/notification.png',
                        scale: 3.6,
                      ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      Image.asset(
                        'assets/images/support.png',
                        scale: 4,
                      ),
                    ],
                  ),
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
            color: appColors.primaryExtraLight,
          ),
          SizedBox(width: width / 80),
          Text(
            "",
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.white,
              fontWeight: FontWeight.w200,
              fontSize: height / 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget body(BuildContext context) {
    return Container(
      color: appColors.bgColorHome,
      child: Padding(
        padding: EdgeInsets.all(height / 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height / 30),
            _buildHeader(),
            controller.confirmBankVisible.value == false
                ? fillBankDetails(context)
                : confirmAndEnterReason(context),
          ],
        ),
      ),
    );
  }

  Column fillBankDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height / 10),
        Text(
          "Account Number",
          style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.textDark.withOpacity(0.7),
              fontWeight: FontWeight.w500,
              fontSize: height / 32,
              letterSpacing: 0.6),
        ),
        SizedBox(height: height / 110),
        customTextField(
          textEditingController: controller.accountNumber,
          fullTag: 'Enter 12-digit account number',
          title: '',
          keyboardType: TextInputType.number,
          fillColor: appColors.white,
          filled: true,
        ),
        SizedBox(height: height / 30),
        Text(
          "IFSC Code",
          style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.textDark.withOpacity(0.7),
              fontWeight: FontWeight.w500,
              fontSize: height / 32,
              letterSpacing: 0.6),
        ),
        SizedBox(height: height / 110),
        customTextField(
          textEditingController: controller.ifsc,
          fullTag: 'Enter your IFSC code',
          title: '',
          onChanged: (val) {
            controller.ifsc.value = TextEditingValue(
              text: val.toUpperCase(),
              selection: controller.ifsc.selection,
            );
          },
          fillColor: appColors.white,
          filled: true,
        ),
        SizedBox(height: height / 30),
        Text(
          "Phone Number",
          style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.textDark.withOpacity(0.7),
              fontWeight: FontWeight.w500,
              fontSize: height / 32,
              letterSpacing: 0.6),
        ),
        SizedBox(height: height / 110),
        customTextField(
          textEditingController: controller.phone,
          fullTag: 'Enter phone number',
          title: '',
          maxLength: 10,
          keyboardType: TextInputType.number,
          fillColor: appColors.white,
          filled: true,
        ),
        SizedBox(height: height / 8),
        controller.isAddingBeneficiary.value
            ? Center(
                child: Lottie.asset(
                  'assets/lottie/wave_loading.json',
                  width: width,
                  height: height / 5,
                ),
              )
            : customButton(
                title: "Verify Account",
                context: context,
                onTap: () {
                  controller.validateBeneficiaryForm(context: context);
                },
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  fontSize: height / 24,
                ),
              ),
      ],
    );
  }

  Column confirmAndEnterReason(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height / 30),
        _bankVerified(),
        SizedBox(height: height / 10),
        Text(
          " Reason for Adding Beneficiary",
          style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.textDark.withOpacity(0.7),
              fontWeight: FontWeight.w500,
              fontFamily: 'Sora',
              fontSize: height / 32,
              letterSpacing: 0.6),
        ),
        SizedBox(height: height / 110),
        customTextField(
          textEditingController: controller.reason,
          fullTag: '\ne.g.., Vendor payment, Rent transfer, etc.',
          title: '',
          maxLines: 3,
          fillColor: appColors.white,
          filled: true,
        ),
        SizedBox(height: height / 8),
        controller.isAddingBeneficiary.value
            ? Center(
                child: Lottie.asset(
                  'assets/lottie/wave_loading.json',
                  width: width,
                  height: height / 5,
                ),
              )
            : customButton(
                title: "Add Beneficiary",
                context: context,
                onTap: () {
                  if (controller.reason.text.isEmpty) {
                    errorDialog(
                      context: context,
                      message: "Please enter reason for adding beneficiary",
                      title: 'Add Beneficiary',
                    );
                  } else {
                    controller.addBeneficiary(
                      context: context,
                      isReasonAvailable: true,
                      id: controller.responseOfAddBeneficiary?['data']['id']
                          .toString(),
                    );
                  }
                },
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  fontSize: height / 24,
                ),
              ),
      ],
    );
  }

  Column addBeneficiary(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height / 20),
        _buildHeader(shouldPop: true),
        SizedBox(height: height / 8),
        customButton(
          title: "Verify Account",
          context: context,
          onTap: () {},
        ),
        SizedBox(height: height / 6),
      ],
    );
  }

  Widget _buildHeader({bool shouldPop = false}) {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Container(
        padding: EdgeInsets.all(height / 30),
        decoration: BoxDecoration(
          color: const Color(0xffEAE0F4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icons/add_beneficiary_doc.png',
                  height: height / 22,
                ),
                SizedBox(width: width / 30),
                Text(
                  "Add Beneficiary",
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: appColors.textDark,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Sora',
                    fontSize: height / 28,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.clear_rounded,
              size: height / 18,
              color: appColors.primaryColor,
            )
          ],
        ),
      ),
    );
  }

  Widget _bankVerified() {
    return Container(
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
              Row(
                children: [
                  Image.asset(
                    'assets/icons/add_beneficiary_doc.png',
                    height: height / 22,
                  ),
                  SizedBox(width: width / 30),
                  Text(
                    "Bank Verification",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: appColors.textDark,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Sora',
                      fontSize: height / 28,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: height / 20),
          Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: height / 20,
                color: Colors.green,
              ),
              Text(
                " Account verified",
                style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sora',
                    fontSize: height / 32,
                    letterSpacing: 0.6),
              ),
            ],
          ),
          SizedBox(height: height / 60),
          Row(
            children: [
              Text(
                " Account Holder : ",
                style: theme.textTheme.labelMedium?.copyWith(
                    color: appColors.textDark,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sora',
                    fontSize: height / 32,
                    letterSpacing: 0.6),
              ),
              Text(
                " ${controller.responseOfAddBeneficiary?['data']['name']}",
                style: theme.textTheme.labelMedium?.copyWith(
                    color: appColors.textDark,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sora',
                    fontSize: height / 32,
                    letterSpacing: 0.6),
              ),
            ],
          ),
          SizedBox(height: height / 60),
          Row(
            children: [
              Text(
                " IFSC Code : ",
                style: theme.textTheme.labelMedium?.copyWith(
                    color: appColors.textDark,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sora',
                    fontSize: height / 32,
                    letterSpacing: 0.6),
              ),
              Text(
                " ${controller.responseOfAddBeneficiary?['data']['ifsc']}",
                style: theme.textTheme.labelMedium?.copyWith(
                    color: appColors.textDark,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sora',
                    fontSize: height / 32,
                    letterSpacing: 0.6),
              ),
            ],
          ),
          SizedBox(height: height / 60),
          Row(
            children: [
              Text(
                " Phone : ",
                style: theme.textTheme.labelMedium?.copyWith(
                    color: appColors.textDark,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sora',
                    fontSize: height / 32,
                    letterSpacing: 0.6),
              ),
              Text(
                " ${controller.phone.text}",
                style: theme.textTheme.labelMedium?.copyWith(
                    color: appColors.textDark,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sora',
                    fontSize: height / 32,
                    letterSpacing: 0.6),
              ),
            ],
          ),
          SizedBox(height: height / 60),
        ],
      ),
    );
  }

  Widget _buildSearchBar(title, controller, prefix) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width / 50),
        color: appColors.white,
        border: Border.all(
            color: appColors.primaryColor.withValues(alpha: 0.4), width: 0.5),
      ),
      child: customTextField(
        textEditingController: controller,
        border: false,
        prefixIcon: prefix
            ? null
            : Container(
                padding: EdgeInsets.all(width / 26),
                child: Icon(
                  CupertinoIcons.search,
                  size: height / 18,
                ),
              ),
        fullTag: title,
        title: "",
        keyboardType: TextInputType.text,
      ),
    );
  }
}
