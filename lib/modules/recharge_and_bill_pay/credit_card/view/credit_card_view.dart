import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/textfield.dart';
import '../controller/credit_card_controller.dart';
import 'add_credit_card.dart';

class CreditCardView extends GetView<CredCardController> {
  const CreditCardView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appColors.bgColorHome,
      bottomNavigationBar: poweredBySetu(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          appBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(height / 44),
              child: GetBuilder<CredCardController>(
                init: controller,
                builder: (_) => controller.loader.value
                    ? Center(
                        child: SizedBox(
                          height: height / 1.6,
                          child: Lottie.asset(
                            'assets/lottie/wave_loading.json',
                            width: width / 2,
                            height: height / 8,
                          ),
                        ),
                      )
                    : controller.allCredCardRes == null
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
                              buildSearchBar(),
                              SizedBox(height: height * 0.02),
                              BanksSectionRaw(
                                allBanksResponse: controller.allCredCardRes,
                                height: height,
                                query: controller.searchedText.text,
                                controller: controller,
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

  body(context) {
    return Padding(
      padding: EdgeInsets.all(height / 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSearchBar(),
          BanksSectionRaw(
            allBanksResponse: controller.allCredCardRes,
            height: height,
            query: controller.searchedText.text,
            controller: controller,
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
                  backButton(),
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
                "Credit card bill",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.white,
                  fontWeight: FontWeight.w200,
                  fontSize: height / 20,
                ),
              ),
            ],
          ),
          SizedBox(width: width / 3.4),
          Image.asset(
            'assets/home/bbps_white_logo.png',
            height: height / 10,
          ),
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
        fullTag: "Search for bank",
        title: "",
        keyboardType: TextInputType.text,
      ),
    );
  }
}

// -----------------------------------------------------------------------------

class BanksSectionRaw extends StatelessWidget {
  const BanksSectionRaw({
    super.key,
    required this.allBanksResponse,
    required this.height,
    this.query = '',
    required this.controller,
  });

  final Map<String, dynamic>? allBanksResponse;
  final double height;
  final String query;
  final CredCardController controller;


  static const List<String> _fixedPopularBanks = [
    'hdfc credit',
    'state bank of india',
    'sbi',
    'icici credit',
    'axis bank',
    'kotak mahindra bank',
    'rbl bank',
  ];
  bool _isPopularBank(String name) {
    final n = _norm(name);
    return _fixedPopularBanks.any((b) => n.contains(b));
  }

  List<Map<String, dynamic>> _allBanksSorted() {
    final raw = allBanksResponse?['data'];
    if (raw is! List) return const [];
    final list = raw.whereType<Map<String, dynamic>>().toList();
    list.sort((a, b) {
      final an = (a['name'] ?? '').toString().toLowerCase().trim();
      final bn = (b['name'] ?? '').toString().toLowerCase().trim();
      return an.compareTo(bn);
    });
    return list;
  }

  String _norm(String s) =>
      s.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');

  List<Map<String, dynamic>> _filtered(List<Map<String, dynamic>> src) {
    final q = _norm(query);
    if (q.isEmpty) return src;
    return src
        .where((m) => _norm((m['name'] ?? '').toString()).contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(width / 40);

    final allSorted = _allBanksSorted();
    final isSearching = query.trim().isNotEmpty;
    final filtered = _filtered(allSorted);
    final popular = isSearching
        ? const <Map<String, dynamic>>[]
        : allSorted.where((e) => _isPopularBank(e['name'] ?? '')).toList();


    Widget sectionBadge(String text) => Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: appColors.primaryColor.withValues(alpha: 0.1),
          ),
          child: Text(
            '  $text  ',
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.primaryColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              fontSize: height / 100,
            ),
          ),
        );

    List<Widget> buildRows(List<Map<String, dynamic>> list) {
      return List.generate(list.length, (i) {
        final item = list[i];
        final name = (item['name'] ?? '').toString();
        final logo = (item['logo'] ?? '').toString();
        final isLast = i == list.length - 1;

        return _AllBankRowContainer(
          height: height,
          name: name,
          logo: logo.isEmpty ? null : logo,
          creditCardData: item,
          showDivider: !isLast,
          controller: controller,
        );
      });
    }

    if (isSearching) {
      /// SEARCH MODE: only show searched banks container
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration:
                BoxDecoration(color: Colors.white, borderRadius: radius),
            padding: EdgeInsets.fromLTRB(
                height * 0.018, height * 0.018, height * 0.018, height * 0.010),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionBadge('Searched banks'),
                SizedBox(height: height * 0.012),
                if (filtered.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.020),
                    child: Text(
                      'No results found',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  ...buildRows(filtered),
              ],
            ),
          ),
        ],
      );
    }

    /// DEFAULT MODE: Popular + All banks
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Popular banks
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: radius),
          padding: EdgeInsets.all(height / 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionBadge('Popular banks'),
              SizedBox(height: height * 0.015),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: height * 0.008),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: height * 0.02,
                  crossAxisSpacing: height * 0.015,
                  childAspectRatio: 0.9,
                ),
                itemCount: popular.length,
                itemBuilder: (_, i) {
                  final name = (popular[i]['name'] ?? '').toString();
                  final logo = (popular[i]['logo'] ?? '').toString();
                  return _PopularTileRaw(
                    name: name,
                    logo: logo.isEmpty ? null : logo,
                    height: height,
                    creditCardData: popular[i],
                    controller: controller,
                  );
                },
              ),
            ],
          ),
        ),

        SizedBox(height: height * 0.012),
        SizedBox(height: height * 0.012),

        /// All banks
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: radius),
          padding: EdgeInsets.fromLTRB(
              height * 0.018, height * 0.018, height * 0.018, height * 0.010),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionBadge('All banks'),
              SizedBox(height: height * 0.012),
              ...buildRows(allSorted),
            ],
          ),
        ),
      ],
    );
  }
}

class _PopularTileRaw extends StatelessWidget {
  const _PopularTileRaw({
    required this.name,
    required this.logo,
    required this.height,
    required this.creditCardData,
    required this.controller,
  });

  final String name;
  final String? logo;
  final double height;
  final Map<String, dynamic> creditCardData;
  final CredCardController controller;





  @override
  Widget build(BuildContext context) {
    final iconSize = height * 0.055;
    return InkWell(
      borderRadius: BorderRadius.circular(height * 0.015),
      onTap: () {
        controller.mobileNumber.clear();
        controller.lastFourDigitOfCreditCard.clear();
        Get.to(
          () => AddNewCreditCard(name, creditCardData),
          transition: Transition.leftToRight,
        );
      },
      child: Column(
        children: [
          _LogoBoxRaw(
            size: iconSize,
            url: logo,
            fallback: _initials(name),
            height: height,
          ),
          SizedBox(height: height * 0.010),
          Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.textDark,
              fontWeight: FontWeight.w700,
              fontSize: height / 80,
            ),
          ),
        ],
      ),
    );
  }
}

/// A single all-banks row as a decorated Container (no ListTile/ListView)
class _AllBankRowContainer extends StatelessWidget {
  const _AllBankRowContainer({
    required this.height,
    required this.name,
    required this.logo,
    required this.creditCardData,
    required this.showDivider,
    required this.controller,
  });

  final double height;
  final String name;
  final String? logo;
  final Map<String, dynamic> creditCardData;
  final bool showDivider;
  final CredCardController controller;

  @override
  Widget build(BuildContext context) {
    final iconSize = height * 0.046;
    final radius = BorderRadius.circular(height * 0.012);

    return InkWell(
      borderRadius: radius,
      onTap: () {
        controller.mobileNumber.clear();
        controller.lastFourDigitOfCreditCard.clear();
        Get.to(
          () => AddNewCreditCard(name, creditCardData),
          transition: Transition.leftToRight,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: height * 0.012),
        child: Column(
          children: [
            Row(
              children: [
                _LogoBoxRaw(
                  size: iconSize,
                  url: logo,
                  fallback: _initials(name),
                  height: height,
                ),
                SizedBox(width: height * 0.016),
                Expanded(
                  child: Text(
                    name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontSize: height * 0.018,
                      fontWeight: FontWeight.w500,
                      color: appColors.textDark,
                    ),
                  ),
                ),
                Icon(
                  CupertinoIcons.right_chevron,
                  size: height * 0.022,
                  color: Colors.grey.withValues(alpha: 0.6),
                ),
              ],
            ),
            if (showDivider) ...[
              SizedBox(height: height * 0.012),
              Divider(
                height: height * 0.005,
                thickness: 0.6,
                color: const Color(0xFFE4E7EC),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LogoBoxRaw extends StatelessWidget {
  const _LogoBoxRaw({
    required this.size,
    required this.url,
    required this.fallback,
    required this.height,
  });

  final double size;
  final String? url;
  final String fallback;
  final double height;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(height);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: radius,
      ),
      clipBehavior: Clip.antiAlias,
      child: (url != null && url!.isNotEmpty)
          ? Image.network(
              url!,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => _fallback(),
              loadingBuilder: (c, w, p) => p == null
                  ? w
                  : Center(
                      child: SizedBox(
                        width: size * .45,
                        height: size * .45,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
            )
          : _fallback(),
    );
  }

  Widget _fallback() => Center(
        child: Text(
          fallback,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: size * 0.38,
            color: Colors.black87,
          ),
        ),
      );
}

String _initials(String name) {
  final parts =
      name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first.characters.first.toUpperCase();
  return (parts[0].characters.first + parts[1].characters.first).toUpperCase();
}
