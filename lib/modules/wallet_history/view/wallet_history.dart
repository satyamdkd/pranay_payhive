import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/modules/wallet_history/controller/wallet_history_controller.dart';
import 'package:payhive/routes/pages.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';

class WalletHistoryScreen extends GetView<WalletHistoryController> {
  const WalletHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.height = MediaQuery.sizeOf(context).height;
    controller.width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: appColors.bgColorHome,
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          appBar(),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => GetBuilder(
                  init: controller,
                  builder: (ctx) {
                    return controller.walletHistoryLoading.value
                        ? Container(
                            height: controller.height - 100,
                            width: controller.width,
                            alignment: Alignment.center,
                            child: Lottie.asset(
                              'assets/lottie/wave_loading.json',
                              height: controller.height / 6.5,
                            ),
                          )
                        : body(context);
                  }),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget body(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.walletHistory();
      },
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          _buildBalanceCard(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: controller.height / 50),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(controller.height / 60),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 5)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _tabButton("All Payment", true),

                /// _buildTabBar(),
                if (controller.walletHistoryRes != null &&
                    controller.walletHistoryRes?['data'] != [])
                  _buildTransactionList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: EdgeInsets.all(controller.height / 50),
      padding: EdgeInsets.all(controller.height / 50),
      decoration: BoxDecoration(
        color: appColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(controller.height / 60),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/wallet_svgrepo.com.png",
            width: controller.height / 20,
          ),
          const SizedBox(height: 10),
          Text(
            "Total Balance",
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.textDark,
              fontWeight: FontWeight.w700,
              fontSize: controller.height / 46,
            ),
          ),
          Text(
            "₹${controller.walletHistoryRes?['availableBalance']}",
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.primaryLight,
              fontWeight: FontWeight.w700,
              fontSize: controller.height / 32,
            ),
          ),
          SizedBox(height: controller.height / 60),
          Image.asset(
            "assets/images/large_line.png",
            width: controller.width / 2,
          ),
          SizedBox(height: controller.height / 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _balanceColumn("₹0.00", "Main Balance"),
              Image.asset(
                "assets/images/small_line.png",
                height: controller.height / 20,
              ),
              _balanceColumn("₹0.00", "Unsettled Balance"),
              Image.asset(
                "assets/images/small_line.png",
                height: controller.height / 20,
              ),
              _balanceColumn("₹0.00", "Rewards/Cashback"),
            ],
          ),
          SizedBox(height: controller.height / 60),
          Text(
            'For any refunds related queries please email us on support@payhive.in',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.black.withValues(alpha: 0.6),
              fontWeight: FontWeight.w400,
              fontSize: controller.height / 74,
            ),
          ),
          SizedBox(height: controller.height / 100),
        ],
      ),
    );
  }

  Widget _balanceColumn(String amount, String label) {
    return Column(
      children: [
        Text(
          amount,
          style: theme.textTheme.labelMedium?.copyWith(
            color: appColors.black.withValues(alpha: 0.8),
            fontWeight: FontWeight.bold,
            fontSize: controller.height / 58,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: appColors.black.withValues(alpha: 0.4),
            fontWeight: FontWeight.w300,
            fontSize: controller.height / 70,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tabButton("All Payment", true),
            _tabButton("Main Balance", false),
            _tabButton("Easy Cash", false),
            _tabButton("Cashback", false),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String title, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(
          right: controller.width / 20,
          bottom: controller.height / 80,
          left: 16),
      child: Column(
        children: [
          TextButton(
            onPressed: () {},
            child: Text(
              title,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected ? appColors.primaryLight : appColors.black,
                fontWeight: FontWeight.w700,
                fontSize: controller.height / 64,
              ),
            ),
          ),
          if (isSelected)
            IntrinsicWidth(
              child: Container(
                height: 3,
                width: controller.width / 4,
                color: appColors.primaryLight,
              ),
            )
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return SizedBox(
      height: controller.height / 2.5,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.walletHistoryRes?['data'].length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(onTap: () {}, child: _transactionItem(index));
        },
      ),
    );
  }

  Widget _transactionItem(int ind) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height:
          controller.selectedIndex == ind && controller.moreInfoClicked.value
              ? height / 1.8
              : height / 2.9,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Transaction ID:",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: appColors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: controller.height / 70,
                    ),
                  ),
                  Text(
                    "${controller.walletHistoryRes?['data'][ind]['transactionid']}",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: appColors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: controller.height / 70,
                    ),
                  ),
                ],
              ),
              Text(
                "${controller.walletHistoryRes?['data'][ind]['type'] == 'Debit' ? '-' : "+"}₹${double.parse(controller.walletHistoryRes?['data'][ind]['balance_amt']).toStringAsFixed(2)}",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: controller.walletHistoryRes?['data'][ind]['type'] ==
                          'Debit'
                      ? Colors.red
                      : appColors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: controller.height / 64,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${controller.walletHistoryRes?['data'][ind]['text']}",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: controller.height / 68,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "${controller.walletHistoryRes?['data'][ind]['razorpay_category'] ?? ""}",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: appColors.primaryLight,
                      fontWeight: FontWeight.w400,
                      fontSize: controller.height / 68,
                    ),
                  ),
                  Text(
                    "${controller.walletHistoryRes?['data'][ind]['razorpay_settlement'] ?? ""}",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: appColors.green,
                      fontWeight: FontWeight.w400,
                      fontSize: controller.height / 68,
                    ),
                  ),
                ],
              ),
              Text(
                "Success",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: controller.height / 68,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.walletHistoryRes?['data'][ind]['created_at'],
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.black.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w400,
                  fontSize: controller.height / 68,
                ),
              ),
              InkWell(
                onTap: () {
                  if (controller.walletHistoryRes?['data'][ind]['text']
                          .toString()
                          .trim()
                          .toLowerCase() ==
                      "wallet top up instant") {
                    Get.toNamed(Routes.transactionDetailWithStatusPage,
                        arguments: {'id': controller.walletHistoryRes?['data'][ind]['razorpay_order_id']});
                  } else {
                    controller.selectedIndex = ind;
                    controller.moreInfoClicked.value =
                        !controller.moreInfoClicked.value;
                    controller.update();
                  }
                },
                child: Text(
                  "More Information",
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: appColors.green,
                    fontWeight: FontWeight.w400,
                    fontSize: controller.height / 68,
                  ),
                ),
              ),
            ],
          ),
          if (controller.selectedIndex == ind &&
              controller.moreInfoClicked.value)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height / 60),
                Divider(
                  color: appColors.grey.withValues(alpha: 0.5),
                  thickness: 0.5,
                  height: 30,
                ),
                SizedBox(height: height / 80),
                Text(
                  'Concerned Person',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: appColors.black.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w400,
                    fontSize: controller.height / 68,
                  ),
                ),
                Text(
                  'Name : ${controller.walletHistoryRes?['data'][ind]['personname']}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: appColors.black.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w400,
                    fontSize: controller.height / 68,
                  ),
                ),
                Text(
                  'Email : ${controller.walletHistoryRes?['data'][ind]['personemail']}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: appColors.black.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w400,
                    fontSize: controller.height / 68,
                  ),
                ),
              ],
            ),
        ],
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
            size: controller.height / 32,
            color: appColors.primaryExtraLight,
          ),
          SizedBox(width: controller.width / 80),
          Text(
            "Transaction History",
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.white,
              fontWeight: FontWeight.w200,
              fontSize: controller.height / 40,
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
      expandedHeight: controller.height / 12.6,
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
                left: controller.width / 40,
                bottom: controller.width / 24,
                right: controller.width / 40,
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
}
