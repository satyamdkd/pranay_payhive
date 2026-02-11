import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/modules/recharge_and_bill_pay/dth/view/add_dth_biller.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import '../controller/dth_controller.dart';

class DthBillers extends GetView<DthController> {
  const DthBillers({super.key});

  Container consentCard(double height) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(height / 50),
      ),
      padding: EdgeInsets.all(height / 30),
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
                fontWeight: FontWeight.w400,
                fontSize: height / 40,
              ),
            ),
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
            child: GetBuilder<DthController>(
              init: controller,
              builder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [myBody(context)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  myBody(context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final billers = controller.allDTHBillers?['data'] as List<dynamic>?;
    return controller.loader.value
        ? Center(
            child: SizedBox(
              height: height / 1.4,
              child: Lottie.asset(
                'assets/lottie/wave_loading.json',
                width: width / 2,
                height: height / 8,
              ),
            ),
          )
        : billers == null || billers.isEmpty
            ? Container(
                height: height / 1.29,
                alignment: Alignment.center,
                child: Text(
                  "NO DATA AVAILABLE!",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: appColors.grey.withValues(alpha: 0.5),
                    letterSpacing: 1,
                    fontWeight: FontWeight.w900,
                    fontSize: height / 40,
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width / 16), // less horizontal padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.035),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 3),
                      decoration: BoxDecoration(
                        color: appColors.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(width / 40),
                          topLeft: Radius.circular(width / 40),
                        ),
                        border: Border(
                          top: BorderSide(
                            color: appColors.primaryColor,
                            width: 4.0,
                          ),
                        ),
                      ),
                      child: Text(
                        "SELECT YOUR BILLER",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: height / 80, // smaller font size
                          color: appColors.primaryColor,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(width / 40),
                          bottomLeft: Radius.circular(width / 40),
                          bottomRight: Radius.circular(width / 40),
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: appColors.primaryExtraLight,
                            width: 0.35,
                          ),
                          left: BorderSide(
                            color: appColors.primaryExtraLight,
                            width: 0.35,
                          ),
                          right: BorderSide(
                            color: appColors.primaryExtraLight,
                            width: 0.35,
                          ),
                          top: BorderSide(
                            color: appColors.primaryExtraLight,
                            width: 0.35,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                appColors.primaryColor.withValues(alpha: 0.04),
                            blurRadius: height / 20, // less blur
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: billers.length,
                        separatorBuilder: (_, i) => Divider(
                          color: appColors.primaryExtraLight,
                          thickness: 0.35,
                          height: 0,
                        ),
                        itemBuilder: (context, i) {
                          final biller = billers[i];
                          String? logoUrl = biller['logo'];
                          String name = biller['name'] ?? 'DTH Operator';
                          final initials = name.isNotEmpty
                              ? name
                                  .trim()
                                  .split(' ')
                                  .map((e) => e[0])
                                  .take(2)
                                  .join()
                                  .toUpperCase()
                              : '?';
                          String? subtitle = biller['subtitle'];
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(height / 50),
                              onTap: () {
                                controller.mobileOrSubId.clear();
                                controller.mobileNumber.clear();

                                controller.billerName = name;
                                controller.billerData = biller;

                                Get.to(() => AddNewDTHBill(name, biller),
                                    transition: Transition.leftToRight);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: height / 55,
                                    horizontal: width / 50), // less padding
                                child: Row(
                                  children: [
                                    SizedBox(width: width / 40),
                                    logoUrl != null && logoUrl.isNotEmpty
                                        ? CircleAvatar(
                                            radius:
                                                height / 44, // smaller avatar
                                            backgroundColor: Colors.white,
                                            backgroundImage:
                                                NetworkImage(logoUrl),
                                          )
                                        : CircleAvatar(
                                            radius: height / 44,
                                            backgroundColor: appColors
                                                .primaryColor
                                                .withValues(alpha: 0.17),
                                            child: Text(
                                              initials,
                                              style: theme
                                                  .textTheme.headlineSmall
                                                  ?.copyWith(
                                                color: appColors.primaryColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: height / 62,
                                              ),
                                            ),
                                          ),
                                    SizedBox(width: width / 30),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.bodyLarge
                                                ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: height / 70,
                                              letterSpacing: 0.5,
                                              color: appColors.textDark,
                                            ),
                                          ),
                                          if (subtitle != null &&
                                              subtitle.isNotEmpty)
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: height /
                                                      180), // less top padding
                                              child: Text(
                                                subtitle,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: theme
                                                    .textTheme.labelMedium
                                                    ?.copyWith(
                                                  color: appColors.grey,
                                                  fontSize: height / 70,
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: height / 60), // smaller bottom space
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
              'DTH Recharge',
              style: theme.textTheme.labelMedium?.copyWith(
                color: appColors.white,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w400,
                fontSize: height / 22,
              ),
            ),
          ],
        ),
        SizedBox(width: width / 3.1),
        Image.asset(
          'assets/home/bbps_white_logo.png',
          height: height / 10,
        ),
      ],
    ),
  );
}
