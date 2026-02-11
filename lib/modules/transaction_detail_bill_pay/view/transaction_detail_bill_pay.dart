/* -----------------------------------------------------------------------------

                            Dummy BBPS Page

----------------------------------------------------------------------------- */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/transaction_detail_bill_pay/controller/transaction_detail_bill_pay_controller.dart';
import 'package:payhive/routes/pages.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/textfield.dart';

class TransactionDetailBillPay
    extends GetView<TransactionDetailBillPayController> {
  const TransactionDetailBillPay({super.key});

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
          child: Column(
            children: [
              buildSearchBar(),
              SizedBox(
                height: 600,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.paymentData.length,
                  itemBuilder: (context, index) {
                    final data = controller.paymentData[index];
                    return _paymentCard(
                      title: data["title"],
                      amount: data["amount"],
                      date: data["date"],
                      isFailed: data["status"] == "failed",
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentCard({
    required String title,
    required String amount,
    required String date,
    bool isFailed = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: Colors.black.withOpacity(0.02),
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.flash_on, color: Colors.pink, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Paid to",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  date,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Transaction Ref. Id. ABCDE1234E",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              if (isFailed)
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "FAILED",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
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
              'assets/icons/payhive_logo.png',
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
        fullTag: "Search by Trans. Ref. Id | Date | Mobile",
        title: "",
        keyboardType: TextInputType.text,
      ),
    );
  }
}
