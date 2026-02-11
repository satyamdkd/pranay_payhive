import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/utils/responsive/layout_builder.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/textfield.dart';
import '../controller/fastag_controller.dart';
import 'add_fastag_biller.dart';

/// ---------------- FIXED FAVOURITE FASTAG BANKS ----------------
const List<String> _favoriteFastagBanks = [
  'idfc first bank',
  'icici bank',
  'state bank of india',
  'sbi',
  'hdfc bank',
  'airtel payments bank',
  'axis bank',
];

String _norm(String s) =>
    s.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');

bool _isFavoriteFastag(String name) {
  final n = _norm(name);
  return _favoriteFastagBanks.any((b) => n.contains(b));
}

/// --------------------------------------------------------------

class FastagAllBillers extends GetView<FastagController> {
  const FastagAllBillers({super.key});

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
              child: GetBuilder<FastagController>(
                init: controller,
                builder: (_) => myBody(context),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget myBody(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final billersRaw =
        controller.allElectricityBillers?['data'] as List<dynamic>?;

    final searchText = controller.searchedText.text.trim().toLowerCase();

    final filteredBillers = billersRaw == null
        ? null
        : searchText.isEmpty
            ? billersRaw
            : billersRaw.where((b) {
                final name = (b['name'] ?? '').toString().toLowerCase();
                final subtitle = (b['subtitle'] ?? '').toString().toLowerCase();
                return name.contains(searchText) ||
                    subtitle.contains(searchText);
              }).toList();

    final favoriteBillers = searchText.isNotEmpty || filteredBillers == null
        ? <dynamic>[]
        : filteredBillers
            .where((b) => _isFavoriteFastag(b['name'] ?? ''))
            .toList();

    final otherBillers = filteredBillers == null
        ? null
        : searchText.isEmpty
            ? filteredBillers
                .where((b) => !_isFavoriteFastag(b['name'] ?? ''))
                .toList()
            : filteredBillers;

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
                if (filteredBillers == null || filteredBillers.isEmpty)
                  Container(
                    height: height / 1.29,
                    alignment: Alignment.center,
                    child: Text(
                      "NO DATA AVAILABLE!",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: appColors.grey.withValues(alpha: 0.5),
                        letterSpacing: 1,
                        fontWeight: FontWeight.w900,
                        fontSize: height / 40,
                      ),
                    ),
                  )
                else ...[
                  /// -------- Favourite FASTag Banks --------
                  if (favoriteBillers.isNotEmpty) ...[
                    SizedBox(height: height * 0.03),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(width / 40),
                        boxShadow: [
                          BoxShadow(
                            color:
                                appColors.primaryColor.withValues(alpha: 0.04),
                            blurRadius: height / 20,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(height / 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(
                              'Favourite FASTag Banks', height, width),
                          SizedBox(height: height * 0.015),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                horizontal: height * 0.008),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: height * 0.02,
                              crossAxisSpacing: height * 0.015,
                              childAspectRatio: 0.9,
                            ),
                            itemCount: favoriteBillers.length,
                            itemBuilder: (_, i) {
                              final b = favoriteBillers[i];
                              final name = (b['name'] ?? '').toString();
                              final logo = (b['logo'] ?? '').toString();

                              return _FavouriteFastagTile(
                                name: name,
                                logo: logo.isEmpty ? null : logo,
                                data: b,
                                height: height,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: height * 0.02),

                  /// -------- All FASTag Banks --------
                  _sectionHeader('All FASTag Banks', height, width),
                  _bankList(otherBillers!, height, width),

                  SizedBox(height: height / 60),
                ],
              ],
            ),
          );
  }

  Widget _sectionHeader(String title, double height, double width) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: appColors.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(width / 40),
      ),
      child: Text(
        title,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: height / 80,
          color: appColors.primaryColor,
        ),
      ),
    );
  }

  Widget _bankList(List<dynamic> billers, double height, double width) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(width / 40),
        boxShadow: [
          BoxShadow(
            color: appColors.primaryColor.withValues(alpha: 0.04),
            blurRadius: height / 20,
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: billers.length,
        separatorBuilder: (_, __) => Divider(
          thickness: 0.5,
          color: appColors.primaryColor.withValues(alpha: 0.10),
          height: 0,
        ),
        itemBuilder: (context, i) {
          return _fastagRow(billers[i], context);
        },
      ),
    );
  }

  Widget _fastagRow(Map<String, dynamic> b, BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    String name = b['name'] ?? 'FASTag Bank';
    String? subtitle = b['subtitle'];
    String? logoUrl = b['logo'];

    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '?';

    return InkWell(
      onTap: () {
        controller.billerName = name;
        controller.clearAllFields();
        Get.to(() => AddNewFastag(name, b));
      },
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: height / 55, horizontal: width / 50),
        child: Row(
          children: [
            logoUrl != null && logoUrl.isNotEmpty
                ? CircleAvatar(
                    radius: height / 44,
                    backgroundImage: NetworkImage(logoUrl),
                  )
                : CircleAvatar(
                    radius: height / 44,
                    backgroundColor:
                        appColors.primaryColor.withValues(alpha: 0.17),
                    child: Text(
                      initials,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: appColors.primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: height / 68,
                      ),
                    ),
                  ),
            SizedBox(width: width / 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: height / 70,
                      color: appColors.textDark,
                    ),
                  ),
                  if (subtitle != null && subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: appColors.grey,
                        fontSize: height / 72,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
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
              fontWeight: FontWeight.w200,
              fontSize: height / 28,
            ),
          ),
          Image.asset('assets/temp/settu_logo.png', height: height / 14),
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
          child: Icon(CupertinoIcons.search,
              size: height / 18, color: Colors.grey),
        ),
        suffixIcon: controller.searchedText.text.isNotEmpty
            ? InkWell(
                onTap: () {
                  controller.searchedText.clear();
                  controller.update();
                },
                child: Container(
                  padding: EdgeInsets.all(width / 26),
                  child: Icon(CupertinoIcons.clear_circled,
                      color: appColors.red, size: height / 18),
                ),
              )
            : null,
        onChanged: (_) => controller.update(),
        fullTag: "Search FASTag Issuing bank",
        title: "",
        keyboardType: TextInputType.text,
      ),
    );
  }
}

/// ------------------- APP BAR -------------------

SliverAppBar appBar() {
  return SliverAppBar(
    automaticallyImplyLeading: false,
    backgroundColor: appColors.primaryColor,
    expandedHeight: height / 4.6,
    pinned: true,
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
            child: backButton(),
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
      children: [
        Icon(Icons.arrow_back_ios_rounded,
            size: height / 18, color: appColors.primaryExtraLight),
        SizedBox(width: width / 80),
        Text(
          'FASTag Recharge',
          style: theme.textTheme.labelMedium?.copyWith(
            color: appColors.white,
            fontWeight: FontWeight.w400,
            fontSize: height / 22,
          ),
        ),
        const Spacer(),
        Image.asset('assets/home/bbps_white_logo.png', height: height / 10),
      ],
    ),
  );
}

class _FavouriteFastagTile extends StatelessWidget {
  final String name;
  final String? logo;
  final Map<String, dynamic> data;
  final double height;

  const _FavouriteFastagTile({
    required this.name,
    required this.logo,
    required this.data,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '?';

    return InkWell(
      borderRadius: BorderRadius.circular(height / 40),
      onTap: () {
        final controller = Get.find<FastagController>();
        controller.billerName = name;
        controller.clearAllFields();
        Get.to(() => AddNewFastag(name, data));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          logo != null
              ? CircleAvatar(
                  radius: height / 42,
                  backgroundImage: NetworkImage(logo!),
                  backgroundColor: Colors.white,
                )
              : CircleAvatar(
                  radius: height / 42,
                  backgroundColor:
                      appColors.primaryColor.withValues(alpha: 0.15),
                  child: Text(
                    initials,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: appColors.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
          SizedBox(height: height * 0.01),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: height / 80,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
