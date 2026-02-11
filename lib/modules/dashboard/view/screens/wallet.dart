import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/constants/colors.dart';
import 'package:payhive/modules/dashboard/controller/dashboard_controller.dart';
import 'package:payhive/utils/helper/text_capitalization.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';

import '../../../../routes/pages.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key, required this.controller});

  final DashBoardController controller;

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    debugPrint(widget.controller.walletAmount.value.toString());

    return GetBuilder(
        init: widget.controller,
        builder: (ctx) {
          return RefreshIndicator(
            onRefresh: () async {
              widget.controller.dashboardApi();
              widget.controller.walletHistory();
            },
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                _buildBalanceCard(),
                const SizedBox(height: 16),
                if (widget.controller.walletHistoryRes != null)
                  Container(
                    margin: EdgeInsets.only(
                      left: height / 30,
                      right: height / 30,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [-1, 1],
                        colors: [
                          appColors.primaryColor,
                          appColors.primaryLight.withValues(alpha: 0.75),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(height / 20),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 5)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTabBar(),
                        if (widget.controller.walletHistoryRes != null)
                          _buildTransactionList(),
                      ],
                    ),
                  ),
              ],
            ),
          );
        });
  }

  Widget _buildBalanceCard() {
    return Container(
      width: width,
      height: height / 2.7,
      margin: EdgeInsets.only(
        left: height / 30,
        right: height / 30,
        top: height / 30,
      ),
      padding: EdgeInsets.all(height / 30),
      decoration: BoxDecoration(
        border: Border.all(color: appColors.white, width: 0.5),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [-1, 1],
          colors: [
            appColors.primaryColor,
            appColors.primaryLight.withValues(alpha: 0.85),
          ],
        ),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        borderRadius: BorderRadius.circular(height / 20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Main balance",
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.primaryExtraLight,
              fontWeight: FontWeight.w300,
              fontSize: height / 30,
            ),
          ),
          widget.controller.dashboardLoading.value
              ? Lottie.asset('assets/lottie/wave_loading.json',
                  width: width / 2, height: height / 6.5)
              : Text(
                  "₹${widget.controller.walletAmount.value}",
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: appColors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: height / 12,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _tabButton("All",
            widget.controller.walletStatusIndex.value == 1 ? true : false, 1),
        _tabButton("Wallet",
            widget.controller.walletStatusIndex.value == 2 ? true : false, 2),

        /// _tabButton("Lien",
        ///    widget.controller.walletStatusIndex.value == 3 ? true : false, 3),
        _tabButton("Settled",
            widget.controller.walletStatusIndex.value == 3 ? true : false, 3),
      ],
    );
  }

  Widget _tabButton(String title, bool isSelected, ind) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            widget.controller.walletStatusIndex.value = ind;
            widget.controller.update();
          },
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.white,

              /// color: isSelected ? appColors.primaryLight : appColors.black,
              fontWeight: FontWeight.w600,
              fontSize: height / 32,
            ),
          ),
        ),
        if (isSelected)
          IntrinsicWidth(
            child: Container(
              height: 3,
              width: width / 3.3,
              color: appColors.white,
              // color: appColors.primaryLight,
            ),
          ),
        if (!isSelected)
          IntrinsicWidth(
            child: Container(
              height: 3,
              width: width / 3.3,
              color: appColors.primaryLight,
              // color: appColors.white,
            ),
          )
      ],
    );
  }

  Widget _buildTransactionList() {
    var status = widget.controller.walletStatusIndex.value == 1
        ? 'all'
        : widget.controller.walletStatusIndex.value == 2
            ? 'wallet'
            : widget.controller.walletStatusIndex.value == 3
                ? 'settled'
                : 'all';

    return SizedBox(
      height: height * 1.2,
      child: widget.controller.walletHistoryRes?['data'][status] == null ||
              widget.controller.walletHistoryRes?['data'][status].isEmpty
          ? noDataAvailable()
          : ListView.builder(
              padding: EdgeInsets.only(top: height / 30, bottom: height / 6),
              itemCount:
                  widget.controller.walletHistoryRes?['data'][status].length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {
                      // Get.toNamed(
                      //   Routes.transactionDetailWithStatusPage,
                      //   arguments: {
                      //     'id': widget.controller.walletHistoryRes?['data']
                      //         [status][index]['order_id'],
                      //     'source': widget.controller.walletHistoryRes?['data']
                      //         [status][index]['source'],
                      //   },
                      // );
                    },
                    child: _transactionItem(
                        widget.controller.walletHistoryRes?['data'][status]
                            [index],
                        index));
              },
            ),
    );
  }

  // Widget _transactionItem(item) {
  //   // DateTime dateTime =
  //   //     DateTime.parse(item['datetime'] ?? "0000-00-00 00:00:00");
  //   // final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  //
  //   var cardColor = item['type'] == 'debit' ? Colors.red : Colors.green;
  //
  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 500),
  //     margin: EdgeInsets.only(
  //         bottom: height / 30, left: width / 30, right: width / 30),
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(8),
  //       border:
  //           Border.all(color: Colors.black.withValues(alpha: 0.1), width: 0.25),
  //       boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: [
  //             Text(
  //               capitalizeFirstCharacter("${item['category']} ${item['type']}"),
  //               style: theme.textTheme.labelMedium?.copyWith(
  //                 color: cardColor,
  //                 letterSpacing: 1,
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: height / 32,
  //               ),
  //             ),
  //             Text(
  //               '${item['type'] == 'debit' ? "-" : "+"}₹${item['amount']}',
  //               style: theme.textTheme.labelMedium?.copyWith(
  //                 color: cardColor,
  //                 letterSpacing: 1,
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: height / 20,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 12),
  //         IntrinsicWidth(
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  //             decoration: BoxDecoration(
  //                 color: Colors.grey.withValues(alpha: 0.2),
  //                 borderRadius: BorderRadius.circular(4)),
  //             child: Row(
  //               children: [
  //                 Text(
  //                   "Old amt. ${item['old_balance']}  ",
  //                   style: theme.textTheme.labelMedium?.copyWith(
  //                     color: appColors.black,
  //                     letterSpacing: 1,
  //                     fontWeight: FontWeight.w300,
  //                     fontSize: height / 40,
  //                   ),
  //                 ),
  //                 const Icon(
  //                   Icons.arrow_right_alt_rounded,
  //                   size: 16.0,
  //                   color: Colors.green,
  //                 ),
  //                 Text(
  //                   "  New amt. ${item['new_balance']}",
  //                   style: theme.textTheme.labelMedium?.copyWith(
  //                     color: appColors.black,
  //                     letterSpacing: 1,
  //                     fontWeight: FontWeight.w300,
  //                     fontSize: height / 40,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 12),
  //         Text(
  //           "Reference Id : ${item['reference']}",
  //           style: theme.textTheme.labelMedium?.copyWith(
  //             color: appColors.black,
  //             fontWeight: FontWeight.w300,
  //             fontSize: height / 36,
  //           ),
  //         ),
  //         const SizedBox(height: 6),
  //         Text(
  //           'Description : ${item['description']}',
  //           style: theme.textTheme.labelMedium?.copyWith(
  //             color: appColors.textDark,
  //             letterSpacing: 1,
  //             fontWeight: FontWeight.w400,
  //             fontSize: height / 40,
  //           ),
  //         ),
  //         SizedBox(height: height / 80),
  //         Align(
  //           alignment: Alignment.centerRight,
  //           child: Text(
  //             item['datetime'],
  //             style: theme.textTheme.labelMedium?.copyWith(
  //               color: appColors.black.withValues(alpha: 0.8),
  //               fontWeight: FontWeight.w300,
  //               fontSize: height / 38,
  //             ),
  //           ),
  //         ),
  //         SizedBox(height: height / 90),
  //       ],
  //     ),
  //   );
  // }

  Container noDataAvailable() {
    return Container(
      height: height / 2,
      margin: EdgeInsets.only(bottom: height / 5),
      alignment: Alignment.center,
      child: Text(
        "No record found!",
        textAlign: TextAlign.center,
        style: theme.textTheme.labelMedium?.copyWith(
          color: appColors.grey.withValues(alpha: 0.6),
          letterSpacing: 1,
          fontWeight: FontWeight.w900,
          fontSize: height / 20,
        ),
      ),
    );
  }

  /// -------

  Widget _transactionItem(item, int index) {
    final isDebit = item['type'] == 'debit';
    final amountColor =
        isDebit ? const Color(0xFFFF9F43) : const Color(0xFF2ECC71);
    var cardColor = item['type'] == 'debit' ? Colors.red : Colors.green;

    var catType = item['provider'].toString().toLowerCase().trim();
    return Obx(() {
      final isExpanded = widget.controller.expandedIndex.value == index;

      return GestureDetector(
        onTap: () {
          widget.controller.expandedIndex.value = isExpanded ? -1 : index;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(
            horizontal: width / 30,
            vertical: height / 80,
          ),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [appColors.primaryColor, appColors.primaryLight],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ───────── Header Row ─────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        catType == 'system' || catType == 'razorpay'
                            ? 'PayIn'
                            : catType == 'bbps'
                                ? 'Bill Payment'
                                : catType == 'bbps charge'
                                    ? 'Transaction charges'
                                    : capitalizeFirstCharacter(
                                        "${item['category']} ${item['type']}"),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: cardColor,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                          fontSize: height / 32,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['datetime'],
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${isDebit ? '-' : '+'}₹${item['amount']}",
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: amountColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _statusChip(item['status']),
                    ],
                  ),
                ],
              ),
              if (!isExpanded)
                Text(
                  'Reference ID : ${item['reference']}',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: Colors.white70, fontSize: 12),
                ),

              /// ───────── Expand Arrow ─────────
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white70,
                ),
              ),

              /// ───────── Expanded Content ─────────
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: isExpanded
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: _expandedDetails(item),
                secondChild: const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _expandedDetails(item) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow("Provider", item['provider'] ?? "-"),
          _infoRow("Reference ID", item['reference']),
          _infoRow("Description", item['description']),
          if (item['pg'] != null) _infoRow("Gateway", item['pg']),
          if (item['card'] != null) _infoRow("Card", "•••• ${item['card']}"),
          if (item['cardtype'] != null)
            _infoRow("Type", capitalizeFirstCharacter(item['cardtype'])),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: appColors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _amountRow("Old Balance", item['old_balance']),
                _amountRow("New Balance", item['new_balance']),
                if (item['charges'] != null)
                  _amountRow("Charges", "-₹${item['charges']}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(label,
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: Colors.white60)),
          ),
          Expanded(
            flex: 2,
            child: Text(value,
                style:
                    theme.textTheme.labelSmall?.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _amountRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  theme.textTheme.labelSmall?.copyWith(color: Colors.white70)),
          Text("₹$value",
              style: theme.textTheme.labelSmall?.copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor(status).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 14, color: statusColor(status)),
          const SizedBox(width: 4),
          Text(
            capitalizeFirstCharacter(status),
            style: TextStyle(
              color: statusColor(status),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color statusColor(String status) {
    switch (status) {
      case 'success':
        return const Color(0xFF2ECC71);
      case 'pending':
        return const Color(0xFFF1C40F);
      case 'failed':
        return const Color(0xFFE74C3C);
      default:
        return Colors.grey;
    }
  }
}
