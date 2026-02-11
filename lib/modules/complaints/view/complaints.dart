import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';

class Complaints extends StatefulWidget {
  const Complaints({super.key});

  @override
  State<Complaints> createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
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
              (context, index) => body(context),
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
              selectedBiller(),
              SizedBox(height: height / 34),
              transactionDetailsWidget(),
              SizedBox(height: height / 40),
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
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "Failed",
                  style: TextStyle(
                    color: Colors.red,
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
            'Complaints Details',
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
            "Reported issue",
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.textDark,
              fontWeight: FontWeight.w300,
              fontFamily: 'Sora',
              fontSize: height / 32,
            ),
          ),
          Text(
            "Reference Id : ABCDE1234E",
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
