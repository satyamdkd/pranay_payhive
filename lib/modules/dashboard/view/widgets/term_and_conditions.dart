import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';

class TermAndConditions extends StatelessWidget {
  const TermAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appColors.bgColorHome,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          appBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [body(context)],
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
            Image.asset('assets/images/flare_two.png', fit: BoxFit.fitHeight),
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
                children: [backButton()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector backButton() {
    return GestureDetector(
      onTap: () => Get.back(),
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
                'Term & Conditions',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.white,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w300,
                  fontSize: height / 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  body(context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;

    final textStyle = theme.textTheme.labelMedium?.copyWith(
      color: Colors.black,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w300,
      fontSize: height / 48,
    );
    return Padding(
      padding: EdgeInsets.all(height / 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Terms and Conditions of Payhive",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text("Last Updated: September 10, 2025", style: textStyle),
          const SizedBox(height: 16),
          Text(
            "Welcome to Payhive. By accessing or using our website, mobile app, or services, you agree to comply with and be bound by the following terms and conditions. Please read them carefully.",
            style: textStyle,
          ),
          const SizedBox(height: 20),
          Text("1. Services",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            "Payhive provides an online platform for booking flights, hotels, buses, bill payments, and travel visa assistance. We act as an intermediary between you and travel service providers or billers.",
            style: textStyle,
          ),
          const SizedBox(height: 20),
          Text("2. Booking and Payments",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
              "- Booking confirmations are subject to availability and acceptance by third-party service providers.",
              style: textStyle),
          Text(
              "- All payments made through Payhive are processed securely with authorized payment gateways.",
              style: textStyle),
          Text(
              "- Prices and availability are subject to change without notice. Payhive is not responsible for pricing errors or changes made by service providers.",
              style: textStyle),
          Text(
              "- Refunds and cancellations are governed by the policies of the respective travel or bill payment service providers.",
              style: textStyle),
          const SizedBox(height: 20),
          Text("3. User Responsibilities",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
              "- Users must provide accurate and complete information during booking and payments.",
              style: textStyle),
          Text(
              "- Users are responsible for compliance with applicable travel regulations, visa requirements, and payment obligations.",
              style: textStyle),
          Text(
              "- Users must keep their account credentials confidential and notify Payhive immediately of any unauthorized use.",
              style: textStyle),
          const SizedBox(height: 20),
          Text("4. Intellectual Property",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            "All content on the Payhive platform, including text, graphics, logos, images, and software, is the property of Paylix or its licensors and protected by intellectual property laws.",
            style: textStyle,
          ),
          const SizedBox(height: 20),
          Text("5. Privacy",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            "Your use of Paylix is also governed by our Privacy Policy, which explains how we collect, use, and protect your personal data.",
            style: textStyle,
          ),
          const SizedBox(height: 20),
          Text("6. Limitation of Liability",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            "Paylix is not liable for any indirect, incidental, special, or consequential damages arising out of or in connection with the use of our services. We do not guarantee uninterrupted service or the accuracy of third-party information.",
            style: textStyle,
          ),
          const SizedBox(height: 20),
          Text("7. Termination",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            "Paylix may suspend or terminate your access to services at any time without prior notice for any breach of these terms or unlawful conduct.",
            style: textStyle,
          ),
          const SizedBox(height: 20),
          Text("8. Governing Law",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            "These terms are governed by the laws of the jurisdiction where Paylix is registered. Disputes will be subject to the exclusive jurisdiction of the courts in that jurisdiction.",
            style: textStyle,
          ),
          const SizedBox(height: 20),
          Text("9. Changes to Terms",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            "Paylix reserves the right to update or modify these terms at any time. Changes will be posted on this page with an updated revision date.",
            style: textStyle,
          ),
          const SizedBox(height: 20),
          Text("10. Contact Us",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text("For any questions about these terms, please contact:",
              style: textStyle),
          Text("admin@paylix.in", style: textStyle),
        ],
      ),
    );
  }
}
