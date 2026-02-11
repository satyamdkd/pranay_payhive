// import 'package:flutter/material.dart';
// import 'package:payhive/utils/widgets/button.dart';
// import 'package:percent_indicator/percent_indicator.dart';
// import 'package:payhive/utils/screen_size.dart';
// import 'package:payhive/utils/theme/apptheme.dart';
//
// class AadharDetails extends StatefulWidget {
//   const AadharDetails({super.key, required this.aadharDetails});
//   final Map<String, dynamic> aadharDetails;
//
//   @override
//   State<AadharDetails> createState() => _AadharDetailsState();
// }
//
// class _AadharDetailsState extends State<AadharDetails> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   bool isOTPScreen = false;
//
//   @override
//   Widget build(BuildContext context) {
//     debugPrint(".\n\n\n\n\n.${widget.aadharDetails.toString()}.\n\n\n\n\n\n.");
//
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: appColors.primaryColor,
//       body: SafeArea(
//         child: Container(
//           margin: EdgeInsets.only(top: height / 100),
//           width: MediaQuery.sizeOf(context).width,
//           height: MediaQuery.sizeOf(context).height,
//           alignment: Alignment.center,
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage("assets/images/splash_bg.png"),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: SafeArea(
//             child: Column(
//               children: [
//                 progress(),
//                 spacing(passedHeight: height / 7),
//                 text(),
//                 spacer(),
//                 aadharDetails(context)
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Spacer spacer() => const Spacer();
//
//   bool isTermChecked = false;
//
//   Container aadharDetails(BuildContext context) {
//     return Container(
//       height: MediaQuery.sizeOf(context).height / 1.35,
//       width: width,
//       decoration: BoxDecoration(
//         color: appColors.white,
//         borderRadius: BorderRadius.only(
//           topRight: Radius.circular(height / 16),
//           topLeft: Radius.circular(height / 16),
//         ),
//       ),
//       child: Stack(
//         children: [
//           Padding(
//             padding: EdgeInsets.only(left: width / 20, right: width / 20),
//             child: Column(
//               children: [
//                 spacing(passedHeight: height / 9),
//                 Image.asset(
//                   "assets/icons/successmark.png",
//                   height: height / 8,
//                 ),
//                 spacing(passedHeight: height / 90),
//                 Text(
//                   "Aadhar Verified",
//                   style: theme.textTheme.headlineSmall?.copyWith(
//                     color: appColors.black,
//                     fontWeight: FontWeight.w700,
//                     fontSize: height / 22,
//                   ),
//                 ),
//                 spacing(passedHeight: height / 20),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 3.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SizedBox(
//                         width: width / 2.4,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Name",
//                               style: theme.textTheme.headlineSmall?.copyWith(
//                                 color: appColors.black.withOpacity(0.6),
//                                 fontWeight: FontWeight.w200,
//                                 fontSize: height / 26,
//                               ),
//                             ),
//                             Text(
//                               widget.aadharDetails['name'] ?? '',
//                               style: theme.textTheme.headlineSmall?.copyWith(
//                                 color: appColors.black.withOpacity(0.8),
//                                 fontWeight: FontWeight.w300,
//                                 fontSize: height / 24,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 spacing(passedHeight: height / 20),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 3.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SizedBox(
//                         width: width / 2.4,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Gender",
//                               style: theme.textTheme.headlineSmall?.copyWith(
//                                 color: appColors.black.withOpacity(0.6),
//                                 fontWeight: FontWeight.w200,
//                                 fontSize: height / 26,
//                               ),
//                             ),
//                             Text(
//                               widget.aadharDetails['gender'] ?? '',
//                               style: theme.textTheme.headlineSmall?.copyWith(
//                                 color: appColors.black.withOpacity(0.8),
//                                 fontWeight: FontWeight.w300,
//                                 fontSize: height / 24,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         width: width / 2.4,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Date Of Birth",
//                               style: theme.textTheme.headlineSmall?.copyWith(
//                                 color: appColors.black.withOpacity(0.6),
//                                 fontWeight: FontWeight.w200,
//                                 fontSize: height / 26,
//                               ),
//                             ),
//                             Text(
//                               widget.aadharDetails['dateOfBirth'] ?? '',
//                               style: theme.textTheme.headlineSmall?.copyWith(
//                                 color: appColors.black.withOpacity(0.8),
//                                 fontWeight: FontWeight.w300,
//                                 fontSize: height / 24,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 spacing(passedHeight: height / 20),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 3.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SizedBox(
//                         width: width / 1.2,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Address",
//                               style: theme.textTheme.headlineSmall?.copyWith(
//                                 color: appColors.black.withOpacity(0.6),
//                                 fontWeight: FontWeight.w200,
//                                 fontSize: height / 26,
//                               ),
//                             ),
//                             Text(
//                               widget.aadharDetails['address'] ?? '',
//                               style: theme.textTheme.headlineSmall?.copyWith(
//                                 color: appColors.black.withOpacity(0.8),
//                                 fontWeight: FontWeight.w300,
//                                 fontSize: height / 24,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 spacer(),
//                 customButton(title: "Continue", context: context, onTap: () {}),
//                 spacing(passedHeight: height / 8),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: -height / 8,
//             child: IgnorePointer(
//               ignoring: true,
//               child: Image.asset(
//                 "assets/images/home_flare.png",
//                 width: width,
//                 height: height / 1.75,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Container text() {
//     return Container(
//       alignment: Alignment.centerLeft,
//       padding: EdgeInsets.only(
//         top: width / 20,
//         left: width / 20,
//         right: width / 20,
//       ),
//       child: Text(
//         "\nAadhar Verified",
//         style: theme.textTheme.headlineSmall
//             ?.copyWith(color: appColors.white, fontWeight: FontWeight.w600),
//       ),
//     );
//   }
//
//   SizedBox spacing({passedHeight}) =>
//       SizedBox(height: passedHeight ?? height / 20);
//
//   LinearPercentIndicator progress() {
//     return LinearPercentIndicator(
//       width: width,
//       animation: true,
//       animationDuration: 2000,
//       padding: EdgeInsets.zero,
//       lineHeight: height / 100,
//       percent: 0.5,
//       backgroundColor: appColors.primaryExtraLight,
//       progressColor: appColors.green,
//     );
//   }
// }
