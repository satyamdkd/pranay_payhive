// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:payhive/modules/auth/salary/controller/salaried_controller.dart';
// import 'package:payhive/modules/auth/salary/view/account_type.dart';
// import 'package:payhive/modules/auth/salary/view/pan_verify_salary.dart';
// import 'package:payhive/utils/screen_size.dart';
// import 'package:payhive/utils/theme/apptheme.dart';
// import 'package:payhive/utils/widgets/button.dart';
// import 'package:payhive/utils/widgets/snackbar.dart';
// import 'package:payhive/utils/widgets/textfield.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
//
// class SalariedAnnualIncome extends GetView<SalariedController> {
//   const SalariedAnnualIncome({super.key});
//   Spacer spacer() => const Spacer();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: appColors.primaryColor,
//       body: body(context),
//     );
//   }
//
//   LinearPercentIndicator progress() {
//     return LinearPercentIndicator(
//       width: width,
//       animation: true,
//       animationDuration: 2000,
//       padding: EdgeInsets.zero,
//       lineHeight: height / 100,
//       percent: 0.4,
//       backgroundColor: appColors.primaryExtraLight,
//       progressColor: appColors.green,
//     );
//   }
//
//   Container text() {
//     return Container(
//       alignment: Alignment.centerLeft,
//       padding: EdgeInsets.only(
//         top: width / 20,
//         left: width / 18,
//         right: width / 20,
//       ),
//       child: Text(
//         "Select Your Annual Income",
//         style: theme.textTheme.headlineSmall?.copyWith(
//             color: appColors.primaryColor, fontWeight: FontWeight.w600),
//       ),
//     );
//   }
//
//   Widget body(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         height: MediaQuery.sizeOf(context).height,
//         width: MediaQuery.sizeOf(context).width,
//         alignment: Alignment.center,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/images/bg_drop_down.png"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Column(
//           children: [
//             progress(),
//             GetBuilder(
//                 init: controller,
//                 builder: (cxt) {
//                   return Column(
//                     children: [
//                       spacing(passedHeight: height / 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             alignment: Alignment.centerRight,
//                             margin: EdgeInsets.only(
//                                 left: width / 20, top: width / 20),
//                             child: Container(
//                               height: height / 12,
//                               width: height / 4,
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 borderRadius:
//                                     BorderRadius.circular(width / 100),
//                                 border: Border.all(
//                                   color: appColors.primaryLight,
//                                   width: 0.4,
//                                 ),
//                               ),
//                               child: InkWell(
//                                 onTap: () {
//                                   Get.offAll(AccountType(),
//                                       transition: Transition.leftToRight,
//                                       duration:
//                                           const Duration(milliseconds: 500));
//                                 },
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.arrow_back_ios_rounded,
//                                       size: height / 25,
//                                       color: appColors.primaryLight,
//                                     ),
//                                     Text(
//                                       " Back ",
//                                       style:
//                                           theme.textTheme.labelSmall?.copyWith(
//                                         color: appColors.primaryLight,
//                                         fontWeight: FontWeight.w300,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           if (controller.isAnnualIncomeDisabled.value)
//                             Container(
//                               alignment: Alignment.centerRight,
//                               margin: EdgeInsets.only(
//                                   right: width / 20, top: width / 20),
//                               child: Container(
//                                 height: height / 12,
//                                 width: height / 4,
//                                 alignment: Alignment.center,
//                                 decoration: BoxDecoration(
//                                   borderRadius:
//                                       BorderRadius.circular(width / 100),
//                                   border: Border.all(
//                                     color: appColors.primaryLight,
//                                     width: 0.4,
//                                   ),
//                                 ),
//                                 child: InkWell(
//                                   onTap: () {
//                                     Get.offAll(const PanVerifySalary(),
//                                         transition: Transition.rightToLeft,
//                                         duration:
//                                             const Duration(milliseconds: 500));
//                                   },
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         " Next ",
//                                         style: theme.textTheme.labelSmall
//                                             ?.copyWith(
//                                           color: appColors.primaryLight,
//                                           fontWeight: FontWeight.w300,
//                                         ),
//                                       ),
//                                       Icon(
//                                         Icons.arrow_forward_ios_rounded,
//                                         size: height / 25,
//                                         color: appColors.primaryLight,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                       IgnorePointer(
//                         ignoring: controller.isAnnualIncomeDisabled.value,
//                         child: Column(
//                           children: [
//                             text(),
//                             spacing(passedHeight: height / 20),
//
//                             if (controller.accountTypeIndex == 1)
//                               Column(
//                                 children: [
//                                   businessType(),
//                                   searchedBusinessTypeListWidget(),
//                                   spacing(passedHeight: height / 20),
//                                   formOfBusiness(),
//                                   searchedFormOfBusinessListWidget(),
//                                 ],
//                               ),
//                             spacing(passedHeight: height / 20),
//
//                             annual(),
//                             searchedAnnualIncomeListWidget(),
//
//                           ],
//                         ),
//                       )
//                     ],
//                   );
//                 }),
//             spacer(),
//             GetBuilder(
//                 init: controller,
//                 builder: (ctx) {
//                   if (!controller.isAnnualIncomeDisabled.value) {
//                     return controller.annualIncomeLoading.value
//                         ? Container(
//                             padding: EdgeInsets.symmetric(
//                               vertical: height / 30,
//                               horizontal: width / 30,
//                             ),
//                             child: CupertinoActivityIndicator(
//                               color: appColors.primaryLight,
//                               radius: height / 20,
//                             ),
//                           )
//                         : IgnorePointer(
//                             ignoring: controller.isAnnualIncomeDisabled.value,
//                             child: Container(
//                               margin: EdgeInsets.all(width / 30.0),
//                               child: customButton(
//                                   title: "Continue",
//                                   context: context,
//                                   onTap: () {
//                                     if (controller.accountTypeIndex == 1) {
//                                       if (controller.annualIncomeController.text
//                                           .isEmpty) {
//                                         showSnackBar(
//                                           message:
//                                               'Please select your annual income',
//                                           title: 'Annual Income',
//                                         );
//                                       } else if (controller
//                                           .businessTypeController
//                                           .text
//                                           .isEmpty) {
//                                         showSnackBar(
//                                           message:
//                                               'Please select your business type',
//                                           title: 'Business Type',
//                                         );
//                                       } else if (controller
//                                           .formOfBusinessController
//                                           .text
//                                           .isEmpty) {
//                                         showSnackBar(
//                                           message:
//                                               'Please select your form of business',
//                                           title: 'Form of business',
//                                         );
//                                       } else {
//                                         controller.salariedAPI(step: '6');
//                                       }
//                                     } else {
//                                       if (controller.annualIncomeController.text
//                                           .isNotEmpty) {
//                                         controller.salariedAPI(step: '6');
//                                       } else {
//                                         showSnackBar(
//                                           message:
//                                               'Please select your annual income',
//                                           title: 'Annual Income',
//                                         );
//                                       }
//                                     }
//                                   }),
//                             ),
//                           );
//                   } else {
//                     return const SizedBox();
//                   }
//                 }),
//             spacing(passedHeight: height / 10),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget searchedAnnualIncomeListWidget() {
//     if (controller.annualStringList != null &&
//         controller.annualStringList!.isNotEmpty) {
//       return AnimatedContainer(
//         duration: const Duration(milliseconds: 500),
//         height: controller.hideSearchListAnnualIncome.value == false
//             ? height / 2
//             : 0,
//         margin: EdgeInsets.only(
//           left: width / 20.0,
//           right: width / 20.0,
//         ),
//         padding: EdgeInsets.only(top: width / 30),
//         decoration: BoxDecoration(
//           color: appColors.white,
//           borderRadius: const BorderRadius.only(
//             bottomLeft: Radius.circular(4),
//             bottomRight: Radius.circular(4),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 5,
//               blurRadius: 7,
//               offset: const Offset(0, 3), // changes position of shadow
//             ),
//           ],
//         ),
//         child: ListView.builder(
//           itemCount: controller.annualStringList!.length,
//           shrinkWrap: true,
//           itemBuilder: (BuildContext context, int index) {
//             return InkWell(
//               onTap: () {
//                 controller.hideSearchListAnnualIncome.value = true;
//                 controller.update();
//                 controller.annualIncomeController.text =
//                     controller.annualStringList![index];
//                 controller.setAnnualIncomeValue(
//                     controller.annualIncomeController.text);
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: width / 20.0,
//                   vertical: width / 30.0,
//                 ),
//                 margin: EdgeInsets.only(
//                   left: width / 30.0,
//                   right: width / 30.0,
//                 ),
//                 decoration: controller.annualStringList![index] ==
//                         controller.annualIncomeController.text
//                     ? BoxDecoration(
//                         borderRadius: BorderRadius.circular(4.0),
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.topRight,
//                           stops: const [-1, 2.0],
//                           colors: [
//                             appColors.primaryColor,
//                             appColors.primaryColor,
//                           ],
//                         ),
//                       )
//                     : null,
//                 child: Text(
//                   controller.annualStringList![index],
//                   style: theme.textTheme.labelMedium?.copyWith(
//                     color: controller.annualStringList![index] ==
//                             controller.annualIncomeController.text
//                         ? appColors.white
//                         : appColors.black,
//                     fontSize: height / 36,
//                     fontWeight: FontWeight.w300,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     } else {
//       return const SizedBox();
//     }
//   }
//
//   Widget searchedBusinessTypeListWidget() {
//     if (controller.businessTypeStringList != null &&
//         controller.businessTypeStringList!.isNotEmpty) {
//       return AnimatedContainer(
//         duration: const Duration(milliseconds: 500),
//         height: controller.hideSearchListBusinessType.value == false
//             ? height / 2
//             : 0,
//         margin: EdgeInsets.only(
//           left: width / 20.0,
//           right: width / 20.0,
//         ),
//         padding: EdgeInsets.only(top: width / 30),
//         decoration: BoxDecoration(
//           color: appColors.white,
//           borderRadius: const BorderRadius.only(
//             bottomLeft: Radius.circular(4),
//             bottomRight: Radius.circular(4),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 5,
//               blurRadius: 7,
//               offset: const Offset(0, 3), // changes position of shadow
//             ),
//           ],
//         ),
//         child: ListView.builder(
//           itemCount: controller.businessTypeStringList!.length,
//           shrinkWrap: true,
//           itemBuilder: (BuildContext context, int index) {
//             return InkWell(
//               onTap: () {
//                 controller.hideSearchListBusinessType.value = true;
//                 controller.update();
//                 controller.businessTypeController.text =
//                     controller.businessTypeStringList![index];
//                 controller.setBusinessTypeValue(
//                     controller.businessTypeController.text);
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: width / 20.0,
//                   vertical: width / 30.0,
//                 ),
//                 margin: EdgeInsets.only(
//                   left: width / 30.0,
//                   right: width / 30.0,
//                 ),
//                 decoration: controller.businessTypeStringList![index] ==
//                         controller.businessTypeController.text
//                     ? BoxDecoration(
//                         borderRadius: BorderRadius.circular(4.0),
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.topRight,
//                           stops: const [-1, 2.0],
//                           colors: [
//                             appColors.primaryColor,
//                             appColors.primaryColor,
//                           ],
//                         ),
//                       )
//                     : null,
//                 child: Text(
//                   controller.businessTypeStringList![index],
//                   style: theme.textTheme.labelMedium?.copyWith(
//                     color: controller.businessTypeStringList![index] ==
//                             controller.businessTypeController.text
//                         ? appColors.white
//                         : appColors.black,
//                     fontSize: height / 36,
//                     fontWeight: FontWeight.w300,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     } else {
//       return const SizedBox();
//     }
//   }
//
//   Widget searchedFormOfBusinessListWidget() {
//     if (controller.formOfBusinessStringList != null &&
//         controller.formOfBusinessStringList!.isNotEmpty) {
//       return AnimatedContainer(
//         duration: const Duration(milliseconds: 500),
//         height: controller.hideSearchListFormOfBusiness.value == false
//             ? height / 2
//             : 0,
//         margin: EdgeInsets.only(
//           left: width / 20.0,
//           right: width / 20.0,
//         ),
//         padding: EdgeInsets.only(top: width / 30),
//         decoration: BoxDecoration(
//           color: appColors.white,
//           borderRadius: const BorderRadius.only(
//             bottomLeft: Radius.circular(4),
//             bottomRight: Radius.circular(4),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 5,
//               blurRadius: 7,
//               offset: const Offset(0, 3), // changes position of shadow
//             ),
//           ],
//         ),
//         child: ListView.builder(
//           itemCount: controller.formOfBusinessStringList!.length,
//           shrinkWrap: true,
//           itemBuilder: (BuildContext context, int index) {
//             return InkWell(
//               onTap: () {
//                 controller.hideSearchListFormOfBusiness.value = true;
//                 controller.update();
//                 controller.formOfBusinessController.text =
//                     controller.formOfBusinessStringList![index];
//                 controller.setFormOfBusinessValue(
//                     controller.formOfBusinessController.text);
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: width / 20.0,
//                   vertical: width / 30.0,
//                 ),
//                 margin: EdgeInsets.only(
//                   left: width / 30.0,
//                   right: width / 30.0,
//                 ),
//                 decoration: controller.formOfBusinessStringList![index] ==
//                         controller.formOfBusinessController.text
//                     ? BoxDecoration(
//                         borderRadius: BorderRadius.circular(4.0),
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.topRight,
//                           stops: const [-1, 2.0],
//                           colors: [
//                             appColors.primaryColor,
//                             appColors.primaryColor,
//                           ],
//                         ),
//                       )
//                     : null,
//                 child: Text(
//                   controller.formOfBusinessStringList![index],
//                   style: theme.textTheme.labelMedium?.copyWith(
//                     color: controller.formOfBusinessStringList![index] ==
//                             controller.formOfBusinessController.text
//                         ? appColors.white
//                         : appColors.black,
//                     fontSize: height / 36,
//                     fontWeight: FontWeight.w300,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     } else {
//       return const SizedBox();
//     }
//   }
//
//   Widget annual() {
//     return InkWell(
//       onTap: () {
//         controller.hideSearchListBusinessType.value = true;
//         controller.hideSearchListFormOfBusiness.value = true;
//
//         controller.hideSearchListAnnualIncome.value =
//             !controller.hideSearchListAnnualIncome.value;
//         controller.update();
//       },
//       child: Padding(
//         padding: EdgeInsets.only(
//           left: width / 20.0,
//           right: width / 20.0,
//         ),
//         child: IgnorePointer(
//           ignoring: true,
//           child: customTextField(
//             readOnly: true,
//             textEditingController: controller.annualIncomeController,
//             title: "",
//             fullTag: "Annual Income",
//             enabledBorder: OutlineInputBorder(
//               borderRadius: controller.hideSearchListAnnualIncome.value == false
//                   ? BorderRadius.only(
//                       topLeft: Radius.circular(width / 50),
//                       topRight: Radius.circular(width / 50),
//                     )
//                   : BorderRadius.circular(width / 50),
//               borderSide: BorderSide(
//                 color: appColors.black.withOpacity(0.35),
//                 width: 0.6,
//               ),
//             ),
//             textColor: appColors.black,
//             prefixIcon: Container(
//               padding: EdgeInsets.all(width / 26),
//               child: Image.asset(
//                 "assets/temp/annual_income.png",
//                 fit: BoxFit.contain,
//                 height: height / 90,
//                 width: height / 90,
//               ),
//             ),
//             suffixIcon: Icon(
//               Icons.keyboard_arrow_down,
//               color: appColors.black.withOpacity(0.4),
//               size: height / 14,
//             ),
//             keyboardType: TextInputType.phone,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget businessType() {
//     return InkWell(
//       onTap: () {
//         controller.hideSearchListAnnualIncome.value = true;
//         controller.hideSearchListFormOfBusiness.value = true;
//
//         controller.hideSearchListBusinessType.value =
//             !controller.hideSearchListBusinessType.value;
//         controller.update();
//       },
//       child: Padding(
//         padding: EdgeInsets.only(
//           left: width / 20.0,
//           right: width / 20.0,
//         ),
//         child: IgnorePointer(
//           ignoring: true,
//           child: customTextField(
//             readOnly: true,
//             textEditingController: controller.businessTypeController,
//             title: "",
//             fullTag: "Business Type",
//             enabledBorder: OutlineInputBorder(
//               borderRadius: controller.hideSearchListBusinessType.value == false
//                   ? BorderRadius.only(
//                       topLeft: Radius.circular(width / 50),
//                       topRight: Radius.circular(width / 50),
//                     )
//                   : BorderRadius.circular(width / 50),
//               borderSide: BorderSide(
//                 color: appColors.black.withOpacity(0.35),
//                 width: 0.6,
//               ),
//             ),
//             textColor: appColors.black,
//             prefixIcon: Container(
//               padding: EdgeInsets.all(width / 26),
//               child: Image.asset(
//                 "assets/temp/annual_income.png",
//                 fit: BoxFit.contain,
//                 height: height / 90,
//                 width: height / 90,
//               ),
//             ),
//             suffixIcon: Icon(
//               Icons.keyboard_arrow_down,
//               color: appColors.black.withOpacity(0.4),
//               size: height / 14,
//             ),
//             keyboardType: TextInputType.phone,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget formOfBusiness() {
//     return InkWell(
//       onTap: () {
//         controller.hideSearchListAnnualIncome.value = true;
//         controller.hideSearchListBusinessType.value = true;
//         controller.hideSearchListFormOfBusiness.value =
//             !controller.hideSearchListFormOfBusiness.value;
//         controller.update();
//       },
//       child: Padding(
//         padding: EdgeInsets.only(
//           left: width / 20.0,
//           right: width / 20.0,
//         ),
//         child: IgnorePointer(
//           ignoring: true,
//           child: customTextField(
//             readOnly: true,
//             textEditingController: controller.formOfBusinessController,
//             title: "",
//             fullTag: "Form Of Business",
//             enabledBorder: OutlineInputBorder(
//               borderRadius:
//                   controller.hideSearchListFormOfBusiness.value == false
//                       ? BorderRadius.only(
//                           topLeft: Radius.circular(width / 50),
//                           topRight: Radius.circular(width / 50),
//                         )
//                       : BorderRadius.circular(width / 50),
//               borderSide: BorderSide(
//                 color: appColors.black.withOpacity(0.35),
//                 width: 0.6,
//               ),
//             ),
//             textColor: appColors.black,
//             prefixIcon: Container(
//               padding: EdgeInsets.all(width / 26),
//               child: Image.asset(
//                 "assets/temp/annual_income.png",
//                 fit: BoxFit.contain,
//                 height: height / 90,
//                 width: height / 90,
//               ),
//             ),
//             suffixIcon: Icon(
//               Icons.keyboard_arrow_down,
//               color: appColors.black.withOpacity(0.4),
//               size: height / 14,
//             ),
//             keyboardType: TextInputType.phone,
//           ),
//         ),
//       ),
//     );
//   }
// }
