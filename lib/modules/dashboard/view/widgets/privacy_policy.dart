import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

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
                'Privacy Policy',
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
          Text("Privacy Policy of Payhive",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text("Last Updated: September 10, 2025", style: textStyle),
          const SizedBox(height: 16),
          Text(
            "Payhive (“we,” “our,” or “us”) is committed to protecting the privacy and security of our users’ personal information. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our travel booking and bill payment services through our website and mobile app.",
            style: textStyle,
          ),
          const SizedBox(height: 20),
          Text("Information We Collect",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
              "We collect various types of information to provide and improve our services, including:",
              style: textStyle),
          const SizedBox(height: 8),
          Text(
              "- Personal Identification: Name, email address, phone number, billing address",
              style: textStyle),
          Text(
              "- Travel Information: Passport numbers, trip dates, destinations, ticket and hotel booking details",
              style: textStyle),
          Text(
              "- Payment Data: Credit/debit card details, bank account information (collected securely through payment processors)",
              style: textStyle),
          Text(
              "- Technical Data: IP address, device type, browser details, cookies, and usage analytics",
              style: textStyle),
          const SizedBox(height: 20),
          Text("How We Use Your Information",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text("- Process bookings and payments securely", style: textStyle),
          Text(
              "- Communicate important updates and confirmations regarding your travel and bills",
              style: textStyle),
          Text("- Provide customer support and resolve inquiries or issues",
              style: textStyle),
          Text("- Improve and personalize your experience on our platform",
              style: textStyle),
          Text("- Comply with legal and regulatory obligations",
              style: textStyle),
          const SizedBox(height: 20),
          Text("Information Sharing",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text("We may share your information with:", style: textStyle),
          Text(
              "- Travel partners such as airlines, hotels, and bus operators to fulfill bookings",
              style: textStyle),
          Text("- Payment processors to process transactions securely",
              style: textStyle),
          Text(
              "- Service providers who assist us in operating the platform and marketing efforts",
              style: textStyle),
          Text("- Legal or regulatory authorities when required by law",
              style: textStyle),
          const SizedBox(height: 8),
          Text(
              "We do not sell or rent your personal information to third parties.",
              style: textStyle),
          const SizedBox(height: 20),
          Text("Data Security",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            "Payhive employs industry-standard security measures including encryption and secure servers to protect your personal data. We retain your data only as long as necessary for service delivery and legal compliance.",
            style: textStyle,
          ),
          const SizedBox(height: 20),
          Text("Your Rights",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text("Depending on your jurisdiction, you may have rights to:",
              style: textStyle),
          Text("- Access, correct, or delete your personal data",
              style: textStyle),
          Text("- Opt out of marketing communications", style: textStyle),
          Text("- Withdraw consent for data processing", style: textStyle),
          Text("- Lodge complaints with data protection authorities",
              style: textStyle),
          const SizedBox(height: 8),
          Text("Please contact us to exercise these rights at admin@payhive.in",
              style: textStyle),
          const SizedBox(height: 20),
          Text("Cookies and Tracking",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            "We use cookies and similar technologies to enhance user experience, analyze website traffic, and support marketing activities. You can manage cookie preferences via your browser settings.",
            style: textStyle,
          ),
          const SizedBox(height: 20),
          Text("Children’s Privacy",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            "Our services are not directed to children under 13 years old. We do not knowingly collect personal data from children without parental consent.",
            style: textStyle,
          ),
          const SizedBox(height: 20),
          Text("Changes to This Policy",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            "We may update this Privacy Policy periodically. Any changes will be posted on this page with an updated revision date.",
            style: textStyle,
          ),
          const SizedBox(height: 20),
          Text("Contact Us",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
              "For any questions or concerns about this Privacy Policy or your data privacy, please contact:",
              style: textStyle),
          Text("Privacy Team, Paylix", style: textStyle),
          Text("Email: admin@paylix.in", style: textStyle),
        ],
      ),
    );
  }
}
