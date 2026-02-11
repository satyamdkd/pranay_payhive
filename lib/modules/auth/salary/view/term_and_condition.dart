import 'package:flutter/material.dart';
import 'package:payhive/services/di/di.dart';
import 'package:payhive/utils/theme/apptheme.dart';

class TermAndCondition extends ModalRoute<void> {
  TermAndCondition();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.2);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation animation,
    Animation secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }


  Widget _buildOverlayContent(BuildContext context) {
    return Center(
        child: Container(
      height: MediaQuery.of(context).size.height / 1.7,
      width: MediaQuery.of(context).size.width / 1.1,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height / 1.2,
        width: MediaQuery.of(context).size.width / 1.11,
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.width / 20,
            left: MediaQuery.of(context).size.width / 20,
            right: MediaQuery.of(context).size.width / 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(MediaQuery.of(context).size.width / 20),
            bottomRight:
                Radius.circular(MediaQuery.of(context).size.width / 20),
            bottomLeft: Radius.circular(MediaQuery.of(context).size.width / 20),
            topRight: Radius.circular(MediaQuery.of(context).size.width / 20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              body(context),
              SizedBox(height: MediaQuery.of(context).size.width / 40),
              Align(
                alignment: Alignment.centerRight,
                child: IntrinsicWidth(
                  child: InkWell(
                    onTap: () async {
                      salariedController.isTermChecked.value = true;
                      salariedController.update();
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: appColors.primaryColor,
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width / 60)),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 40,
                          vertical: MediaQuery.of(context).size.width / 120),
                      child: Text(
                        " DONE  ",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: appColors.white,
                            fontFamily: "Inter",
                            fontSize: MediaQuery.of(context).size.height / 58),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
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
          const SizedBox(height: 12),
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
            "Your use of Payhive is also governed by our Privacy Policy, which explains how we collect, use, and protect your personal data.",
            style: textStyle,
          ),
          const SizedBox(height: 20),
          Text("6. Limitation of Liability",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            "Payhive is not liable for any indirect, incidental, special, or consequential damages arising out of or in connection with the use of our services. We do not guarantee uninterrupted service or the accuracy of third-party information.",
            style: textStyle,
          ),
          const SizedBox(height: 20),
          Text("7. Termination",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            "Payhive may suspend or terminate your access to services at any time without prior notice for any breach of these terms or unlawful conduct.",
            style: textStyle,
          ),
          const SizedBox(height: 20),
          Text("8. Governing Law",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            "These terms are governed by the laws of the jurisdiction where Payhive is registered. Disputes will be subject to the exclusive jurisdiction of the courts in that jurisdiction.",
            style: textStyle,
          ),
          const SizedBox(height: 20),
          Text("9. Changes to Terms",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            "Payhive reserves the right to update or modify these terms at any time. Changes will be posted on this page with an updated revision date.",
            style: textStyle,
          ),
          const SizedBox(height: 20),
          Text("10. Contact Us",
              style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text("For any questions about these terms, please contact:",
              style: textStyle),
          Text("admin@payhive.in", style: textStyle),
        ],
      ),
    );
  }


  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    /// const begin = Offset(0, -1.0);
    /// const end = Offset.zero;
    /// const curve = Curves.ease;
    /// final tween = Tween(begin: begin, end: end);
    /// final curvedAnimation = CurvedAnimation(
    ///   parent: animation,
    ///   curve: curve,
    /// );
    /// return FadeTransition(
    ///     opacity: animation,
    ///     child: SlideTransition(
    ///       position: tween.animate(curvedAnimation),
    ///       child: child,
    ///     )
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
