import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/utils/responsive/layout_builder.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/textfield.dart';
import '../controller/gas_controller.dart';
import 'add_gas_biller.dart';

class GasAllBillers extends GetView<GasController> {
  const GasAllBillers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appColors.bgColorHome,
      bottomNavigationBar: poweredBySetu(),
      body: ResponsiveLayout(builder: (context, maxWith, maxHeight) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            appBar(),
            SliverToBoxAdapter(
              child: GetBuilder<GasController>(
                init: controller,
                builder: (_) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [myBody(context)],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  myBody(context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final billersRaw =
        controller.allElectricityBillers?['data'] as List<dynamic>?;

    /// --- Search filtering logic ---
    final searchText = controller.searchedText.text.trim().toLowerCase();
    final billers = billersRaw == null
        ? null
        : searchText.isEmpty
            ? billersRaw
            : billersRaw.where((b) {
                final name = (b['name'] ?? '').toString().toLowerCase();
                final subtitle = (b['subtitle'] ?? '').toString().toLowerCase();
                return name.contains(searchText) ||
                    subtitle.contains(searchText);
              }).toList();

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
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.03),
                buildSearchBar(),
                billers == null || billers.isEmpty
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
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.03),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 3),
                            decoration: BoxDecoration(
                              color:
                                  appColors.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(width / 40),
                                topLeft: Radius.circular(width / 40),
                              ),
                            ),
                            child: Text(
                              "Gas Cylinder Booking",
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: height / 80,
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
                              boxShadow: [
                                BoxShadow(
                                  color: appColors.primaryColor
                                      .withValues(alpha: 0.04),
                                  blurRadius: height / 20,
                                ),
                              ],
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: billers.length,
                              separatorBuilder: (_, i) => Divider(
                                thickness: 0.5,
                                color: appColors.primaryColor
                                    .withValues(alpha: 0.10),
                                height: 0,
                              ),
                              itemBuilder: (context, i) {
                                final b = billers[i];
                                String? logoUrl = b['logo'];
                                String name =
                                    b['name'] ?? 'Electricity Operator';
                                final initials = name.isNotEmpty
                                    ? name
                                        .trim()
                                        .split(' ')
                                        .map((e) => e[0])
                                        .take(2)
                                        .join()
                                        .toUpperCase()
                                    : '?';
                                String? subtitle = b['subtitle'];
                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius:
                                        BorderRadius.circular(height / 50),
                                    onTap: () {
                                      controller.billerName = name;

                                      controller.clearAllFields();

                                      Get.to(
                                          () => AddNewGas(name, b));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: height / 55,
                                          horizontal: width / 50),
                                      child: Row(
                                        children: [
                                          SizedBox(width: width / 40),
                                          logoUrl != null && logoUrl.isNotEmpty
                                              ? CircleAvatar(
                                                  radius: height / 44,
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
                                                      color: appColors
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: height / 68,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: theme
                                                      .textTheme.bodyLarge
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
                                                        top: height / 180),
                                                    child: Text(
                                                      subtitle,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                          SizedBox(height: height / 60),
                        ],
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

  Widget buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width / 50),
        color: appColors.white,
        border: Border.all(color: Colors.grey.withValues(alpha: 0.35)),
      ),
      child: customTextField(
        textEditingController: controller.searchedText,
        border: false,
        prefixIcon: Container(
          padding: EdgeInsets.all(width / 26),
          child: Icon(
            CupertinoIcons.search,
            size: height / 18,
            color: Colors.grey,
          ),
        ),
        suffixIcon: controller.searchedText.text.isNotEmpty
            ? InkWell(
                onTap: () {
                  controller.searchedText.clear();
                  controller.update();
                },
                child: Container(
                  padding: EdgeInsets.all(width / 26),
                  child: Icon(
                    CupertinoIcons.clear_circled,
                    color: appColors.red,
                    size: height / 18,
                  ),
                ),
              )
            : null,
        onChanged: (v) {
          controller.update();
        },
        fullTag: "Search...",
        title: "",
        keyboardType: TextInputType.text,
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
              'Gas Booking',
              style: theme.textTheme.labelMedium?.copyWith(
                color: appColors.white,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w400,
                fontSize: height / 22,
              ),
            ),
          ],
        ),
        SizedBox(width: width / 3),
        Image.asset(
          'assets/home/bbps_white_logo.png',
          height: height / 10,
        ),
      ],
    ),
  );
}
