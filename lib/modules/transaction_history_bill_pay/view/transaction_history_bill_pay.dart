import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/transaction_history_bill_pay/controller/transaction_history_bill_pay_controller.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/textfield.dart';

class TransactionHistoryBillPay
    extends GetView<TransactionHistoryBillPayController> {
  const TransactionHistoryBillPay({super.key});

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

  Widget selectedBiller() {
    return Container(
      width: width,
      margin: EdgeInsets.all(height / 60),
      padding: EdgeInsets.all(height / 30),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Biller : Tata Power - Delhi",
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.textDark,
              fontWeight: FontWeight.w300,
              fontFamily: 'Sora',
              fontSize: height / 32,
            ),
          ),
          Text(
            "Transaction Ref. Id. : ABCDE1234E",
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.textDark,
              fontWeight: FontWeight.w300,
              fontFamily: 'Sora',
              fontSize: height / 32,
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
          child: Column(
            children: [
              selectedBiller(),

              /// transactionDetailsWidget(),
              SizedBox(height: height / 40),
              if (controller.isReportClicked.value)
                Padding(
                  padding: EdgeInsets.all(height / 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height / 40),
                      Text(
                        "Raised Complaint via mobile no :",
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: appColors.textDark,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Sora',
                          fontSize: height / 32,
                        ),
                      ),
                      SizedBox(height: height / 40),
                      textField(TextEditingController(), 1,
                          fullTag: 'Kindly Enter Mobile Number'),
                      SizedBox(height: height / 40),
                      textField(TextEditingController(), 1,
                          fullTag: 'Kindly Select Date'),
                      SizedBox(height: height / 40),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.purple.withValues(alpha: 0.25),
                              thickness: 1,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "  Or  ",
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: appColors.textDark,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Sora',
                                fontSize: height / 28,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.purple.withValues(alpha: 0.25),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height / 40),
                      Text(
                        "Raised Complaint via Transaction Id :",
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: appColors.textDark,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Sora',
                          fontSize: height / 32,
                        ),
                      ),
                      SizedBox(height: height / 40),
                      textField(TextEditingController(), 1,
                          fullTag: 'Transaction Id'),
                      SizedBox(height: height / 40),
                      textField(TextEditingController(), 1,
                          fullTag: 'Choose a reason',
                          suffixIcon:
                              const Icon(Icons.keyboard_arrow_down_rounded)),
                      SizedBox(height: height / 40),
                      textField(TextEditingController(), 4,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: width / 30, vertical: height / 40),
                          fullTag: 'Tell us more about your issue'),
                    ],
                  ),
                ),
              SizedBox(height: height / 40),

              Padding(
                padding: EdgeInsets.all(height / 60),
                child: customButton(
                  title: 'Report an issue',
                  context: context,
                  onTap: () {
                    controller.reportAnIssue(context);
                  },
                  style: theme.textTheme.headlineSmall!.copyWith(
                    color: appColors.white,
                    fontSize: height / 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: height / 2),
            ],
          ),
        ),
      ],
    );
  }

  Container transactionDetailsWidget() {
    return Container(
      padding: EdgeInsets.all(height / 20),
      margin: EdgeInsets.all(height / 60),
      decoration: BoxDecoration(
        color: Colors.white, // Card-like contrast
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Bill details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Image.asset(
                'assets/home/electricity.png',
                height: height / 10,
                width: height / 10,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Tata Power\nDelhi",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LabelValue("Transaction date", "12th June, 2025"),
              _LabelValue("Amount", "₹5,000", bold: true),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LabelValue("Bill category", "Electricity bill"),
              _LabelValue("Account number", "ABCDE1234E"),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            "Payment details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _LabelValue("Transaction ID", "973456783956"),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "SUCCESSFUL",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              )
            ],
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
            'Complaint Registration',
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

  Widget textField(textEditingController, maxLine,
      {contentPadding, fullTag, suffixIcon}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width / 30),
        color: appColors.white,
      ),
      child: customTextField(
        textEditingController: textEditingController,
        border: true,
        contentPadding: contentPadding,
        maxLines: maxLine,
        suffixIcon: suffixIcon,
        onChanged: (v) {},
        fullTag: fullTag,
        title: "",
        keyboardType: TextInputType.text,
      ),
    );
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _LabelValue(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
