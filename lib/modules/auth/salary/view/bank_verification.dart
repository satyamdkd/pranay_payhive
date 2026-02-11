// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:payhive/modules/auth/salary/view/lets_verify_id.dart';
// import 'package:payhive/utils/screen_size.dart';
// import 'package:payhive/utils/theme/apptheme.dart';
// import 'package:payhive/utils/widgets/button.dart';
// import 'package:payhive/utils/widgets/textfield.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
//
// class BankVerification extends StatefulWidget {
//   const BankVerification({super.key});
//
//   @override
//   State<BankVerification> createState() => _BankVerificationState();
// }
//
// class _BankVerificationState extends State<BankVerification> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
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
//                 bank(context)
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
//   Container bank(BuildContext context) {
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
//                 spacing(passedHeight: height / 10),
//                 customTextField(
//                   textEditingController: TextEditingController(),
//                   title: "",
//                   fullTag: "Full Name",
//                   keyboardType: TextInputType.phone,
//                 ),
//                 spacing(passedHeight: height / 20),
//                 customTextField(
//                   textEditingController: TextEditingController(),
//                   title: "",
//                   fullTag: "Bank Account Number",
//                   keyboardType: TextInputType.phone,
//                 ),
//                 spacing(passedHeight: height / 20),
//                 customTextField(
//                   textEditingController: TextEditingController(),
//                   title: "",
//                   fullTag: "IFSC Code",
//                   keyboardType: TextInputType.phone,
//                 ),
//                 spacing(passedHeight: height / 20),
//                 Padding(
//                   padding: const EdgeInsets.all(4.0),
//                   child: Text(
//                     "Complete verification with a penny drop of ₹1 to customer provided bank account details.",
//                     style: theme.textTheme.bodySmall?.copyWith(
//                       color: const Color(0xff222222),
//                       fontSize: height / 32,
//                       fontWeight: FontWeight.w300,
//                     ),
//                   ),
//                 ),
//                 spacer(),
//                 customButton(
//                     title: "Verify",
//                     context: context,
//                     onTap: () {
//                       Get.to(() => const LetsVerifyYourIdentity());
//                     }),
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
//         "Enter Your\nBank Account Details",
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
