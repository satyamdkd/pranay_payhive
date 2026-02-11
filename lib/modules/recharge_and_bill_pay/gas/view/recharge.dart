import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';

import '../../../../utils/widgets/button.dart';
import '../controller/gas_controller.dart';

class Recharge extends GetView<GasController> {
  const Recharge({super.key});

  Container consentCard(double height) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(height / 50),
      ),
      padding: EdgeInsets.all(height / 30),
      margin: EdgeInsets.symmetric(horizontal: height / 26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: height / 120),
            child: Image.asset(
              'assets/icons/bbps_logo.png',
              height: height / 24,
            ),
          ),
          SizedBox(width: height / 60),
          Expanded(
            child: Text(
                'By proceeding further, you allow Payhive to store your bill details, fetch current and future bills, and send you reminders',
                style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w400, fontSize: height / 40)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appColors.bgColorHome,
      bottomNavigationBar: poweredBySetu(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          appBar(),
          SliverToBoxAdapter(
            child: GetBuilder(
              init: controller,
              builder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [body(context)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding poweredBySetu() {
    return Padding(
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
    );
  }

  Widget _billDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.black54, fontWeight: FontWeight.w500)),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  body(context) {
    final theme = Theme.of(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        color: Colors.grey[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with bill number, provider logo, and Edit
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  controller.logo != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(controller.logo!),
                          radius: 28,
                          backgroundColor: Colors.white,
                        )
                      : CircleAvatar(
                          radius: 28, backgroundColor: Colors.grey.shade200),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.mobileNumber.text,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          controller.selectedBiller,
                          style: theme.textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1.0, color: Color(0xFFE7E8EC)),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bill details",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (controller.custName != null)
                    _billDetailRow("Customer name:", controller.custName!),
                  if (controller.consumerNumber != null) const SizedBox(height: 6),
                  _billDetailRow("Consumer number:", controller.consumerNumber!),
                ],
              ),
            ),
            const Divider(height: 1.0, color: Color(0xFFE7E8EC)),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.22),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 21.0, horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Payable amount",
                        style: theme.textTheme.labelMedium
                            ?.copyWith(color: Colors.black54, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "₹ ",
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: appColors.primaryColor,
                              fontSize: 30,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: controller.amount,
                              enabled: controller.enableAmountTextField,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              textAlign: TextAlign.left,
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: appColors.primaryColor,
                                fontSize: 30,
                              ),
                              decoration: const InputDecoration(
                                hintText: "0.00",
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}')),
                              ],
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),





            consentCard(height),
            SizedBox(height: height / 36),

            controller.loader.value
                ? Center(
                    child: Lottie.asset(
                      'assets/lottie/wave_loading.json',
                      width: width,
                      height: height / 4,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: height / 26),
                    child: customButton(
                      title: 'Confirm',
                      onTap: () async {
                        if (controller.amountRupees != null) {
                          controller.billPaymentRequest();
                        }
                      },
                      context: context,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: appColors.white,
                        fontSize: height / 24,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

            SizedBox(height: height / 30),
          ],
        ),
      )
    ]);
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
                  backButton(),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Icon(
                Icons.arrow_back_ios_rounded,
                size: height / 18,
                color: appColors.primaryExtraLight,
              ),
              SizedBox(width: width / 80),
              Text(
                'Electricity',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.white,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w300,
                  fontSize: height / 20,
                ),
              ),
            ],
          ),
          SizedBox(width: width / 2.7),
          Image.asset(
            'assets/home/bbps_white_logo.png',
            height: height / 10,
          ),
        ],
      ),
    );
  }
}
