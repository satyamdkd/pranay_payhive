import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/modules/list_pos_req/controller/list_pos_controller.dart';
import 'package:payhive/modules/list_pos_req/model/all_pos_request.dart';
import 'package:payhive/routes/pages.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';

class ListPosRequest extends GetView<ListPosController> {
  const ListPosRequest({super.key});

  Widget customTabBar(BuildContext context) {
    final tabNames = ["Pending", "Approved", "Rejected"];
    final tabCounts = [
      controller.pending.length,
      controller.approved.length,
      controller.rejected.length,
    ];
    final selectedIndex = controller.tabController.index;
    final bg = appColors.primaryColor.withValues(alpha: 0.12);

    return Container(
      margin: EdgeInsets.only(
        left: height / 30,
        right: height / 30,
        top: height / 20,
        bottom: height / 80,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(height / 15),
      ),
      child: Row(
        children: List.generate(tabNames.length, (i) {
          final isActive = selectedIndex == i;
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(height / 15),
              onTap: () {
                controller.tabController.animateTo(i);
                controller.update(); // refresh for immediate feedback
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: height / 50, horizontal: width / 80),
                decoration: BoxDecoration(
                  color: isActive ? appColors.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(height / 15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tabNames[i],
                      style: TextStyle(
                        color: isActive ? Colors.white : appColors.primaryColor,
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.w600,
                        fontSize: height / 36,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: width / 60),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1.5, horizontal: 7),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white
                            : appColors.primaryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(height / 40),
                      ),
                      child: Text(
                        tabCounts[i].toString(),
                        style: TextStyle(
                          color: isActive
                              ? appColors.primaryColor
                              : appColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: height / 36,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.white,
      appBar: appBar(),
      body: GetBuilder(
          init: controller,
          builder: (ctx) {
            return controller.loading.value
                ? Center(
                    child: Lottie.asset('assets/lottie/wave_loading.json',
                        width: width, height: height / 2.5),
                  )
                : SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    child: Column(
                      children: [
                        customTabBar(context),
                        Expanded(
                          child: TabBarView(
                            controller: controller.tabController,
                            children: [
                              _buildTransactionList(
                                  controller.pending, 'Pending'),
                              _buildTransactionList(
                                  controller.approved, 'Approved'),
                              _buildTransactionList(
                                  controller.rejected, 'Rejected'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
          }),
    );
  }

  Widget _buildTransactionList(List<PosRequestItem> list, String status) {
    return list.isEmpty
        ? Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: height / 20),
            child: Text(
              "NO DATA AVAILABLE",
              style: theme.textTheme.labelMedium?.copyWith(
                color: appColors.grey,
                letterSpacing: 1,
                fontWeight: FontWeight.w900,
                fontSize: height / 18,
              ),
            ),
          )
        : RefreshIndicator(
            onRefresh: () async {
              controller.getAllPosList();
            },
            child: ListView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {},
                    child: _transactionItem(
                        list[index], index, status, list, context));
              },
            ),
          );
  }

  Widget _transactionItem(
      PosRequestItem item, int index, status, list, context) {
    return Container(
      margin: EdgeInsets.only(
        left: width / 30,
        right: width / 30,
        top: height / 30,
        bottom: index == list.length - 1 ? height / 32 : 0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(width / 20),
        border: Border.all(width: 0.24, color: appColors.primaryColor),
        boxShadow: [
          BoxShadow(
            color: appColors.primaryColor.withValues(alpha: 0.10),
            blurRadius: width / 23,
            offset: Offset(0, height / 88),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: width / 70,
            height: height / 5,
            decoration: BoxDecoration(
              color: appColors.primaryColor.withValues(alpha: 0.8),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(width / 16),
                bottomRight: Radius.circular(width / 16),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width / 22, vertical: height / 38),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          item.rrnNumber != null
                              ? "RRN: ${item.rrnNumber}".toUpperCase()
                              : '',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: appColors.primaryColor,
                            fontSize: height / 38,
                            letterSpacing: 1.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (status != 'Approved')
                        customButton(
                          passedHeight: height / 17,
                          passedWidth: width / 5,
                          title: status == 'Pending' ? 'Edit' : 'Resubmit',
                          border:
                              Border.all(color: appColors.white, width: 0.35),
                          context: context,
                          onTap: () {
                            Get.toNamed(Routes.posRequest, arguments: item)!
                                .then((v) {
                              controller.getAllPosList();
                            });
                          },
                        ),
                    ],
                  ),
                  SizedBox(height: height / 54),
                  Row(
                    children: [
                      Icon(Icons.currency_rupee,
                          color: appColors.green, size: height / 24),
                      Text(
                        item.amount ?? '0',
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: appColors.green.withValues(alpha: 0.8),
                          fontWeight: FontWeight.bold,
                          fontSize: height / 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height / 56),
                  Divider(
                      color: appColors.primaryColor.withValues(alpha: 0.1),
                      thickness: 1),
                  SizedBox(height: height / 80),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _labelWithValue(
                                label: "Serial ",
                                value: item.serialno ?? '-',
                                icon: Icons.confirmation_number,
                                theme: theme,
                                height: height,
                                color: appColors.primaryColor),
                            SizedBox(height: height / 72),
                            _labelWithValue(
                                label: "Card Type",
                                value: item.cardTypeName?.toUpperCase() ?? '-',
                                icon: Icons.credit_card,
                                theme: theme,
                                height: height,
                                color: appColors.green),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _labelWithValue(
                                label: "TID ",
                                value: item.tid ?? '-',
                                icon: Icons.confirmation_number_outlined,
                                theme: theme,
                                height: height,
                                color: appColors.primaryColor),
                            SizedBox(height: height / 72),
                            _labelWithValue(
                                label: "Date ",
                                value: item.transactionDate != null
                                    ? DateFormat("d MMM, yyyy").format(
                                        DateFormat("dd/MM/yyyy")
                                            .parse(item.transactionDate!))
                                    : '-',
                                icon: Icons.calendar_today,
                                theme: theme,
                                height: height,
                                color: appColors.primaryColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height / 56),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelWithValue(
      {required String label,
      required String value,
      required IconData icon,
      required ThemeData theme,
      required double height,
      required Color color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: height / 46, color: color.withValues(alpha: 0.84)),
        const SizedBox(width: 4),
        Text(
          "$label:",
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: height / 40,
          ),
        ),
        const SizedBox(width: 2),
        Flexible(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: height / 40,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: appColors.primaryColor,
      leadingWidth: width,
      leading: Container(
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.only(bottom: width / 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            backButton(),
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
          SizedBox(width: width / 30),
          Icon(
            Icons.arrow_back_ios_new_rounded,
            size: height / 14,
            color: appColors.white,
          ),
          SizedBox(width: width / 80),
          Text(
            " All P.O.S Requests",
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.white,
              letterSpacing: 1,
              fontWeight: FontWeight.w400,
              fontSize: height / 22,
            ),
          ),
        ],
      ),
    );
  }
}
