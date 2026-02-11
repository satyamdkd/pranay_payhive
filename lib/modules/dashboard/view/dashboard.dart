import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/dashboard/controller/dashboard_controller.dart';
import 'package:payhive/modules/dashboard/view/screens/home.dart';
import 'package:payhive/modules/dashboard/view/screens/new_profile.dart';
import 'package:payhive/modules/dashboard/view/screens/wallet.dart';
import 'package:payhive/routes/pages.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';

import '../widget/upload_aadhar.dart';
import 'screens/new_add_money.dart';

class Dashboard extends GetView<DashBoardController> {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (ctx) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (v, t) async {
              controller.onBackButton();
            },
            child: Scaffold(
              extendBody: true,
              backgroundColor: controller.bottomNavIndex.value == 4
                  ? appColors.bgColorHome.withValues(alpha: 0.9)
                  : appColors.bgColorHome,
              body: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (controller.scrollController.position.pixels > 0) {
                    controller.hideTitle.value = false;
                  } else {
                    controller.hideTitle.value = true;
                  }

                  return true;
                },
                child: CustomScrollView(
                  controller: controller.scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    if (controller.bottomNavIndex.value != 4) appBar(),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => body(context),
                        childCount: 1,
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: buildNavBar(context),
            ),
          );
        });
  }

  // Widget body(context) {
  //   return GetBuilder(
  //       init: controller,
  //       builder: (cxt) {
  //         return controller.bottomNavIndex.value == 0
  //             ? const Home()
  //             : controller.bottomNavIndex.value == 1
  //                 ? Wallet(controller: controller)
  //                 : controller.bottomNavIndex.value == 2
  //                     ? const AddMoneyNew()
  //                     : controller.bottomNavIndex.value == 4
  //                         ? const NewProfile()
  //                         : underDevelopment(context);
  //       });
  // }

  Widget body(context) {
    return GetBuilder(
        init: controller,
        builder: (cxt) {
          return controller.bottomNavIndex.value == 0
              ? const Home()
              : controller.bottomNavIndex.value == 1
                  ? Wallet(controller: controller)
                  : controller.bottomNavIndex.value == 2
                      ? const AddMoneyNew()
                      : controller.bottomNavIndex.value == 4
                          ? const NewProfile()
                          : underDevelopment(context);
        });
  }

  Container underDevelopment(context) {
    return Container(
      height: MediaQuery.sizeOf(context).height - height / 2.84,
      alignment: Alignment.center,
      child: Text(
        "Under Development\n\n\n",
        style: theme.textTheme.labelMedium?.copyWith(
          color: appColors.textDark.withValues(alpha: 0.2),
          fontWeight: FontWeight.w800,
          fontSize: height / 16,
        ),
      ),
    );
  }

  buildNavBar(context) {
    return Obx(
      () => Stack(
        children: [
          Container(
            padding:
                EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 90),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    MediaQuery.sizeOf(context).height / 38),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  stops: const [-1, 2.0],
                  colors: [
                    appColors.primaryColor,
                    appColors.primaryLight.withValues(alpha: 0.6),
                  ],
                ),
              ),
              padding:
                  EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 150),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft:
                      Radius.circular(MediaQuery.sizeOf(context).height / 40),
                  topRight:
                      Radius.circular(MediaQuery.sizeOf(context).height / 40),
                ),
                child: BottomNavigationBar(
                  elevation: MediaQuery.sizeOf(context).height / 200,
                  backgroundColor: Colors.white,
                  showUnselectedLabels: true,
                  selectedLabelStyle: theme.textTheme.bodySmall?.copyWith(
                    color: appColors.textExtraLight,
                    fontSize: MediaQuery.sizeOf(context).height / 200,
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: theme.textTheme.bodySmall?.copyWith(
                      color: appColors.textExtraLight,
                      fontSize: MediaQuery.sizeOf(context).height / 40,
                      fontWeight: FontWeight.w500),
                  currentIndex: 0,
                  type: BottomNavigationBarType.fixed,
                  unselectedItemColor: appColors.black,
                  selectedItemColor: appColors.black,
                  onTap: (index) {
                    controller.bottomNavPressed(index);
                  },
                  items: [
                    BottomNavigationBarItem(
                      label: "",
                      icon: Image.asset(
                        controller.bottomNavIndex.value == 0
                            ? "assets/icons/home.png"
                            : "assets/icons/home_grey.png",
                        height: MediaQuery.sizeOf(context).height / 40,
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: "",
                      icon: Image.asset(
                        controller.bottomNavIndex.value == 1
                            ? "assets/icons/wallet.png"
                            : "assets/icons/wallet_grey.png",
                        height: MediaQuery.sizeOf(context).height / 40,
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: "",
                      icon: Image.asset(
                        controller.bottomNavIndex.value == 2
                            ? "assets/icons/add_button.png"
                            : "assets/icons/add_button_grey.png",
                        height: MediaQuery.sizeOf(context).height / 40,
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: "",
                      icon: Image.asset(
                        controller.bottomNavIndex.value == 3
                            ? "assets/bb_bill_cat_icons/msg_home.png"
                            : "assets/icons/msg_grey.png",
                        height: MediaQuery.sizeOf(context).height / 40,
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: "",
                      icon: Image.asset(
                        controller.bottomNavIndex.value == 4
                            ? "assets/bb_bill_cat_icons/profile_grad.png"
                            : "assets/icons/profile_grey.png",
                        height: MediaQuery.sizeOf(context).height / 40,
                      ),
                    ),
                  ],
                ),
              ),
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
            Image.asset(
              'assets/images/flare_two.png',
              fit: BoxFit.fitHeight,
            ),
            Container(
              margin: EdgeInsets.only(
                left: height / 30,
                bottom: width / 30,
                right: height / 30,
              ),
              alignment: Alignment.bottomLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  appBarTitle(),
                  actionWidgets(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row appBarTitle() {
    return Row(
      children: [
        controller.bottomNavIndex.value == 1 ||
                controller.bottomNavIndex.value == 2
            ? Padding(
                padding: const EdgeInsets.all(5),
                child: SizedBox(
                  height: height / 14,
                  width: height / 14,
                  child: Image.asset(
                    "assets/icons/wallet_grey1.png",
                    fit: BoxFit.contain,
                  ),
                ),
              )
            : Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: appColors.white,
                    borderRadius: BorderRadius.circular(1000.0),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: SizedBox(
                    height: height / 14,
                    width: height / 14,
                    child: Image.asset(
                      "assets/icons/payhive_logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
        SizedBox(width: width / 40),
        controller.bottomNavIndex.value == 0
            ? Text(
                "Hi, ${"${controller.userDetails?['data']['name'] ?? ''}"}",

                /// "Hi, ${"${controller.userDetails?['data']['name'] ?? ''}".split(' ').first}",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: height / 24,
                ),
              )
            : Text(
                controller.bottomNavIndex.value == 1
                    ? "Wallet"
                    : controller.bottomNavIndex.value == 2
                        ? "Add Money"
                        : "",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: height / 24,
                ),
              ),
      ],
    );
  }

  Row actionWidgets() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            controller.bottomNavIndex.value = 1;
            controller.update();
          },
          child: Image.asset(
            'assets/images/wallet.png',
            scale: 4,
          ),
        ),
        spacing(),
        InkWell(
          onTap: () {},
          child: Image.asset(
            'assets/images/notification.png',
            scale: 3.6,
          ),
        ),
        spacing(),
        InkWell(
          onTap: () {
            controller.helpCenter();
          },
          child: Image.asset(
            'assets/images/support.png',
            scale: 4,
          ),
        ),
      ],
    );
  }

  SizedBox spacing() {
    return const SizedBox(
      width: 12.0,
    );
  }
}
