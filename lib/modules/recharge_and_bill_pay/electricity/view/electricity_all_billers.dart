// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:payhive/modules/recharge_and_bill_pay/electricity/view/add_electricity_biller.dart';
// import 'package:payhive/utils/responsive/layout_builder.dart';
// import 'package:payhive/utils/screen_size.dart';
// import 'package:payhive/utils/theme/apptheme.dart';
// import 'package:payhive/utils/widgets/textfield.dart';
// import '../controller/electricity_controller.dart';
//
// class ElectricityAllBillers extends GetView<ElectricityController> {
//   const ElectricityAllBillers({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: appColors.bgColorHome,
//       bottomNavigationBar: poweredBySetu(),
//       body: ResponsiveLayout(builder: (context, maxWith, maxHeight) {
//         return CustomScrollView(
//           physics: const BouncingScrollPhysics(),
//           slivers: [
//             appBar(),
//             SliverToBoxAdapter(
//               child: GetBuilder<ElectricityController>(
//                 init: controller,
//                 builder: (_) => Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [myBody(context)],
//                 ),
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
//
//   myBody(context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     final billersRaw =
//         controller.allElectricityBillers?['data'] as List<dynamic>?;
//
//     /// --- Map of specific acronyms to full names ---
//     final Map<String, List<String>> acronymMap = {
//       'tgspdcl': ['southern power distribution company of telangana'],
//       'tgnpdcl': ['northern power distribution company of telangana'],
//       'apcpdcl': ['central power distribution corporation'],
//     };
//
//     /// --- Enhanced search filtering logic ---
//     final searchText = controller.searchedText.text.trim().toLowerCase();
//     final billers = billersRaw == null
//         ? null
//         : searchText.isEmpty
//             ? billersRaw
//             : billersRaw.where((b) {
//                 final name = (b['name'] ?? '').toString().toLowerCase();
//                 final subtitle = (b['subtitle'] ?? '').toString().toLowerCase();
//
//                 // Regular contains search
//                 if (name.contains(searchText) ||
//                     subtitle.contains(searchText)) {
//                   return true;
//                 }
//
//                 // Check if search text is one of the specific acronyms
//                 if (acronymMap.containsKey(searchText)) {
//                   final matchPhrases = acronymMap[searchText]!;
//                   // Check if name or subtitle contains any of the match phrases
//                   return matchPhrases.any((phrase) =>
//                       name.contains(phrase) || subtitle.contains(phrase));
//                 }
//
//                 return false;
//               }).toList();
//
//     return controller.loader.value
//         ? Center(
//             child: SizedBox(
//               height: height / 1.4,
//               child: Lottie.asset(
//                 'assets/lottie/wave_loading.json',
//                 width: width / 2,
//                 height: height / 8,
//               ),
//             ),
//           )
//         : Padding(
//             padding: EdgeInsets.symmetric(horizontal: width / 40),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: height * 0.03),
//                 buildSearchBar(),
//                 billers == null || billers.isEmpty
//                     ? Container(
//                         height: height / 1.29,
//                         alignment: Alignment.center,
//                         child: Text(
//                           "NO DATA AVAILABLE!",
//                           textAlign: TextAlign.center,
//                           style: theme.textTheme.labelMedium?.copyWith(
//                             color: appColors.grey.withValues(alpha: 0.5),
//                             letterSpacing: 1,
//                             fontWeight: FontWeight.w900,
//                             fontSize: height / 40,
//                           ),
//                         ),
//                       )
//                     : Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: height * 0.03),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 3),
//                             decoration: BoxDecoration(
//                               color:
//                                   appColors.primaryColor.withValues(alpha: 0.1),
//                               borderRadius: BorderRadius.only(
//                                 topRight: Radius.circular(width / 40),
//                                 topLeft: Radius.circular(width / 40),
//                               ),
//                             ),
//                             child: Text(
//                               "SELECT YOUR BILLER",
//                               style: theme.textTheme.headlineSmall?.copyWith(
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: height / 80,
//                                 color: appColors.primaryColor,
//                                 letterSpacing: 0.8,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.only(
//                                 topRight: Radius.circular(width / 40),
//                                 bottomLeft: Radius.circular(width / 40),
//                                 bottomRight: Radius.circular(width / 40),
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: appColors.primaryColor
//                                       .withValues(alpha: 0.04),
//                                   blurRadius: height / 20,
//                                 ),
//                               ],
//                             ),
//                             child: ListView.separated(
//                               shrinkWrap: true,
//                               padding: EdgeInsets.zero,
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemCount: billers.length,
//                               separatorBuilder: (_, i) => Divider(
//                                 thickness: 0.5,
//                                 color: appColors.primaryColor
//                                     .withValues(alpha: 0.10),
//                                 height: 0,
//                               ),
//                               itemBuilder: (context, i) {
//                                 final b = billers[i];
//                                 String? logoUrl = b['logo'];
//                                 String name =
//                                     b['name'] ?? 'Electricity Operator';
//                                 final initials = name.isNotEmpty
//                                     ? name
//                                         .trim()
//                                         .split(' ')
//                                         .map((e) => e[0])
//                                         .take(2)
//                                         .join()
//                                         .toUpperCase()
//                                     : '?';
//                                 String? subtitle = b['subtitle'];
//                                 return Material(
//                                   color: Colors.transparent,
//                                   child: InkWell(
//                                     borderRadius:
//                                         BorderRadius.circular(height / 50),
//                                     onTap: () {
//                                       controller.billerName = name;
//
//                                       controller.clearAllFields();
//
//                                       Get.to(
//                                           () => AddNewElectricityBill(name, b));
//                                     },
//                                     child: Container(
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: height / 55,
//                                           horizontal: width / 50),
//                                       child: Row(
//                                         children: [
//                                           SizedBox(width: width / 40),
//                                           logoUrl != null && logoUrl.isNotEmpty
//                                               ? CircleAvatar(
//                                                   radius: height / 44,
//                                                   backgroundColor: Colors.white,
//                                                   backgroundImage:
//                                                       NetworkImage(logoUrl),
//                                                 )
//                                               : CircleAvatar(
//                                                   radius: height / 44,
//                                                   backgroundColor: appColors
//                                                       .primaryColor
//                                                       .withValues(alpha: 0.17),
//                                                   child: Text(
//                                                     initials,
//                                                     style: theme
//                                                         .textTheme.headlineSmall
//                                                         ?.copyWith(
//                                                       color: appColors
//                                                           .primaryColor,
//                                                       fontWeight:
//                                                           FontWeight.w700,
//                                                       fontSize: height / 68,
//                                                     ),
//                                                   ),
//                                                 ),
//                                           SizedBox(width: width / 30),
//                                           Expanded(
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   name,
//                                                   maxLines: 2,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   style: theme
//                                                       .textTheme.bodyLarge
//                                                       ?.copyWith(
//                                                     fontWeight: FontWeight.w500,
//                                                     fontSize: height / 70,
//                                                     letterSpacing: 0.5,
//                                                     color: appColors.textDark,
//                                                   ),
//                                                 ),
//                                                 if (subtitle != null &&
//                                                     subtitle.isNotEmpty)
//                                                   Padding(
//                                                     padding: EdgeInsets.only(
//                                                         top: height / 180),
//                                                     child: Text(
//                                                       subtitle,
//                                                       maxLines: 1,
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       style: theme
//                                                           .textTheme.labelMedium
//                                                           ?.copyWith(
//                                                         color: appColors.grey,
//                                                         fontSize: height / 70,
//                                                       ),
//                                                     ),
//                                                   )
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           SizedBox(height: height / 60),
//                         ],
//                       ),
//               ],
//             ),
//           );
//   }
//
//   Padding poweredBySetu() {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'Powered by  ',
//             style: theme.textTheme.labelMedium?.copyWith(
//               color: appColors.primaryColor,
//               letterSpacing: 1,
//               fontWeight: FontWeight.w200,
//               fontSize: height / 28,
//             ),
//           ),
//           Image.asset(
//             'assets/temp/settu_logo.png',
//             height: height / 14,
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget buildSearchBar() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(width / 50),
//         color: appColors.white,
//         border: Border.all(color: Colors.grey.withValues(alpha: 0.35)),
//       ),
//       child: customTextField(
//         textEditingController: controller.searchedText,
//         border: false,
//         prefixIcon: Container(
//           padding: EdgeInsets.all(width / 26),
//           child: Icon(
//             CupertinoIcons.search,
//             size: height / 18,
//             color: Colors.grey,
//           ),
//         ),
//         suffixIcon: controller.searchedText.text.isNotEmpty
//             ? InkWell(
//                 onTap: () {
//                   controller.searchedText.clear();
//                   controller.update();
//                 },
//                 child: Container(
//                   padding: EdgeInsets.all(width / 26),
//                   child: Icon(
//                     CupertinoIcons.clear_circled,
//                     color: appColors.red,
//                     size: height / 18,
//                   ),
//                 ),
//               )
//             : null,
//         onChanged: (v) {
//           controller.update();
//         },
//         fullTag: "Search by biller name",
//         title: "",
//         keyboardType: TextInputType.text,
//       ),
//     );
//   }
// }
//
// SliverAppBar appBar() {
//   return SliverAppBar(
//     automaticallyImplyLeading: false,
//     backgroundColor: appColors.primaryColor,
//     expandedHeight: height / 4.6,
//     floating: false,
//     pinned: true,
//     forceElevated: true,
//     stretch: true,
//     title: null,
//     flexibleSpace: FlexibleSpaceBar(
//       background: Stack(
//         fit: StackFit.expand,
//         children: [
//           Container(color: appColors.primaryColor),
//           Image.asset('assets/images/flare_two.png', fit: BoxFit.fitHeight),
//           Container(
//             margin: EdgeInsets.only(
//               left: width / 30,
//               bottom: width / 20,
//               right: width / 30,
//             ),
//             alignment: Alignment.bottomLeft,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [backButton()],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
//
// GestureDetector backButton() {
//   return GestureDetector(
//     onTap: () => Get.back(),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       mainAxisSize: MainAxisSize.max,
//       children: [
//         Row(
//           children: [
//             Icon(
//               Icons.arrow_back_ios_rounded,
//               size: height / 18,
//               color: appColors.primaryExtraLight,
//             ),
//             SizedBox(width: width / 80),
//             Text(
//               'Electricity Bill Pay',
//               style: theme.textTheme.labelMedium?.copyWith(
//                 color: appColors.white,
//                 letterSpacing: 0.5,
//                 fontWeight: FontWeight.w400,
//                 fontSize: height / 22,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(width: width / 4),
//         Image.asset(
//           'assets/home/bbps_white_logo.png',
//           height: height / 10,
//         ),
//       ],
//     ),
//   );
// }


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/modules/recharge_and_bill_pay/electricity/view/add_electricity_biller.dart';
import 'package:payhive/utils/responsive/layout_builder.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/textfield.dart';
import '../controller/electricity_controller.dart';

/// ---------------- FIXED FAVOURITE ELECTRICITY BILLERS ----------------
const List<String> _favoriteElectricityBillers = [
  'southern power distribution company of telangana',
  'northern power distribution company of telangana',
  'central power distribution corporation',
];

String _norm(String s) =>
    s.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');

bool _isFavoriteElectricity(String name) {
  final n = _norm(name);
  return _favoriteElectricityBillers.any((b) => n.contains(b));
}

/// --------------------------------------------------------------

class ElectricityAllBillers extends GetView<ElectricityController> {
  const ElectricityAllBillers({super.key});

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
              child: GetBuilder<ElectricityController>(
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

    /// --- Map of specific acronyms to full names ---
    final Map<String, List<String>> acronymMap = {
      'tgspdcl': ['southern power distribution company of telangana'],
      'tgnpdcl': ['northern power distribution company of telangana'],
      'apcpdcl': ['central power distribution corporation'],
    };

    /// --- Enhanced search filtering logic ---
    final searchText = controller.searchedText.text.trim().toLowerCase();
    final filteredBillers = billersRaw == null
        ? null
        : searchText.isEmpty
        ? billersRaw
        : billersRaw.where((b) {
      final name = (b['name'] ?? '').toString().toLowerCase();
      final subtitle = (b['subtitle'] ?? '').toString().toLowerCase();

      // Regular contains search
      if (name.contains(searchText) ||
          subtitle.contains(searchText)) {
        return true;
      }

      // Check if search text is one of the specific acronyms
      if (acronymMap.containsKey(searchText)) {
        final matchPhrases = acronymMap[searchText]!;
        // Check if name or subtitle contains any of the match phrases
        return matchPhrases.any((phrase) =>
        name.contains(phrase) || subtitle.contains(phrase));
      }

      return false;
    }).toList();

    final favoriteBillers = searchText.isNotEmpty || filteredBillers == null
        ? <dynamic>[]
        : filteredBillers
        .where((b) => _isFavoriteElectricity(b['name'] ?? ''))
        .toList();

    final otherBillers = filteredBillers == null
        ? null
        : searchText.isEmpty
        ? filteredBillers
        .where((b) => !_isFavoriteElectricity(b['name'] ?? ''))
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
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.grey.withValues(alpha: 0.5),
                  letterSpacing: 1,
                  fontWeight: FontWeight.w900,
                  fontSize: height / 40,
                ),
              ),
            )
          else ...[
            /// -------- Favourite Electricity Billers --------
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
                        'Favourite Electricity Billers', height, width),
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

                        return _FavouriteElectricityTile(
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

            /// -------- All Electricity Billers --------
            _sectionHeader('All Electricity Billers', height, width),
            _billerList(otherBillers!, height, width),

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

  Widget _billerList(List<dynamic> billers, double height, double width) {
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
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: billers.length,
        separatorBuilder: (_, i) => Divider(
          thickness: 0.5,
          color: appColors.primaryColor.withValues(alpha: 0.10),
          height: 0,
        ),
        itemBuilder: (context, i) {
          final b = billers[i];
          String? logoUrl = b['logo'];
          String name = b['name'] ?? 'Electricity Operator';
          final initials = name.isNotEmpty
              ? name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
              : '?';
          String? subtitle = b['subtitle'];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(height / 50),
              onTap: () {
                controller.billerName = name;
                controller.clearAllFields();
                Get.to(() => AddNewElectricityBill(name, b));
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: height / 55, horizontal: width / 50),
                child: Row(
                  children: [
                    SizedBox(width: width / 40),
                    logoUrl != null && logoUrl.isNotEmpty
                        ? CircleAvatar(
                      radius: height / 44,
                      backgroundColor: Colors.white,
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
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: height / 70,
                              letterSpacing: 0.5,
                              color: appColors.textDark,
                            ),
                          ),
                          if (subtitle != null && subtitle.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: height / 180),
                              child: Text(
                                subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelMedium?.copyWith(
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
        fullTag: "Search by biller name",
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
              'Electricity Bill Pay',
              style: theme.textTheme.labelMedium?.copyWith(
                color: appColors.white,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w400,
                fontSize: height / 22,
              ),
            ),
          ],
        ),
        SizedBox(width: width / 4),
        Image.asset(
          'assets/home/bbps_white_logo.png',
          height: height / 10,
        ),
      ],
    ),
  );
}

/// ------------------- FAVOURITE ELECTRICITY TILE -------------------
class _FavouriteElectricityTile extends StatelessWidget {
  final String name;
  final String? logo;
  final Map<String, dynamic> data;
  final double height;

  const _FavouriteElectricityTile({
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
        final controller = Get.find<ElectricityController>();
        controller.billerName = name;
        controller.clearAllFields();
        Get.to(() => AddNewElectricityBill(name, data));
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
