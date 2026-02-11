// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:payhive/modules/pos/controller/pos_controller.dart';
// import 'package:payhive/utils/screen_size.dart';
// import 'package:payhive/utils/theme/apptheme.dart';
// import 'package:payhive/utils/widgets/textfield.dart';
//
// class PosDialog extends ModalRoute<void> {
//   PosDialog({required this.myController});
//
//   final PosController? myController;
//
//   @override
//   Duration get transitionDuration => const Duration(milliseconds: 500);
//
//   @override
//   bool get opaque => false;
//
//   @override
//   bool get barrierDismissible => true;
//
//   @override
//   Color get barrierColor => Colors.black.withOpacity(0.2);
//
//   @override
//   String? get barrierLabel => null;
//
//   @override
//   bool get maintainState => true;
//
//   @override
//   Widget buildPage(
//     BuildContext context,
//     Animation animation,
//     Animation secondaryAnimation,
//   ) {
//     return Material(
//       type: MaterialType.transparency,
//       child: SafeArea(
//         child: _buildOverlayContent(context),
//       ),
//     );
//   }
//
//   Widget _buildOverlayContent(BuildContext context) {
//     return Center(
//         child: Container(
//       height: MediaQuery.of(context).size.height / 1.5,
//       width: MediaQuery.of(context).size.width / 1.01,
//       decoration: const BoxDecoration(
//         color: Colors.transparent,
//       ),
//       child: SingleChildScrollView(
//         child: GetBuilder<PosController>(
//             init: myController,
//             builder: (ctx) {
//               return Column(
//                 children: [
//                   SizedBox(height: height / 25),
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: height / 30),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: appColors.white,
//                         width: 4
//                       ),
//                       gradient: const LinearGradient(
//                         begin: Alignment.bottomLeft,
//                         end: Alignment.topRight,
//                         stops: [-2, 1],
//                         colors: [
//                           Color(0xffA903D2),
//                           Color(0xff5033A4),
//                         ],
//                       ),
//                       borderRadius: BorderRadius.circular(height / 40),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.2),
//                           spreadRadius: 5,
//                           blurRadius: 7,
//                           offset: const Offset(
//                               0, 3), // changes position of shadow
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(height / 30.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: height / 120),
//                           InkWell(
//                             onTap: () {
//                               myController?.dateTimePicker(context);
//                             },
//                             child: IgnorePointer(
//                               ignoring: true,
//                               child: customTextField(
//                                 textEditingController:
//                                 myController?.selectDate,
//                                 title: '',
//                                 fullTag: 'Select Date',
//                                 filled: true,
//                                 readOnly: true,
//                                 fillColor:
//                                 appColors.bgColorHome.withOpacity(0.5),
//                                 border: false,
//                                 textColor: appColors.white,
//                                 hintColor: appColors.white,
//                                 prefixIcon: Container(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: height / 30,
//                                     horizontal: width / 30,
//                                   ),
//                                   child: Icon(
//                                     CupertinoIcons.calendar,
//                                     size: height / 18,
//                                     color: appColors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: height / 30),
//                           customTextField(
//                             textEditingController: myController?.amount,
//                             title: '',
//                             fullTag: 'Enter Amount',
//                             filled: true,
//                             fillColor: appColors.bgColorHome.withOpacity(0.5),
//                             border: false,
//                             keyboardType: TextInputType.number,
//                             textColor: appColors.white,
//                             hintColor: appColors.white,
//                             prefixIcon: Container(
//                               padding: EdgeInsets.symmetric(
//                                 vertical: height / 30,
//                                 horizontal: width / 60,
//                               ),
//                               child: Icon(
//                                 Icons.currency_rupee_rounded,
//                                 size: height / 18,
//                                 color: appColors.white,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: height / 30),
//                           InkWell(
//                             onTap: () {
//                               myController?.hideSerialNumber.value =
//                               !myController!.hideSerialNumber.value;
//
//                               myController?.hideMidTid.value = true;
//
//                               myController?.update();
//                             },
//                             child: IgnorePointer(
//                               ignoring: true,
//                               child: customTextField(
//                                 textEditingController:
//                                 myController?.serialNumber,
//                                 title: '',
//                                 fullTag: 'Select Serial Number',
//                                 filled: true,
//                                 readOnly: true,
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius:
//                                   myController?.hideSerialNumber.value ==
//                                       false
//                                       ? BorderRadius.only(
//                                     topLeft:
//                                     Radius.circular(width / 50),
//                                     topRight:
//                                     Radius.circular(width / 50),
//                                   )
//                                       : BorderRadius.circular(width / 50),
//                                   borderSide: BorderSide.none,
//                                 ),
//                                 fillColor:
//                                 appColors.bgColorHome.withOpacity(0.5),
//                                 border: false,
//                                 textColor: appColors.white,
//                                 hintColor: appColors.white,
//                                 prefixIcon: Container(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: height / 30,
//                                     horizontal: width / 30,
//                                   ),
//                                   child: Icon(
//                                     Icons.confirmation_number_rounded,
//                                     size: height / 18,
//                                     color: appColors.white,
//                                   ),
//                                 ),
//                                 suffixIcon: Container(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: height / 30,
//                                     horizontal: width / 30,
//                                   ),
//                                   child: Icon(
//                                     Icons.arrow_drop_down_rounded,
//                                     size: height / 18,
//                                     color: appColors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           serialNumberListWidget(context),
//                           SizedBox(height: height / 20),
//                           if (myController!.bankStringList != null &&
//                               myController!.bankStringList!.isNotEmpty)
//                             Text(
//                               'Select Bank',
//                               style: context.textTheme.bodySmall!.copyWith(
//                                 fontSize: height / 28,
//                                 letterSpacing: 2,
//                                 color: appColors.white,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           SizedBox(height: height / 40),
//                           if (myController!.bankStringList != null &&
//                               myController!.bankStringList!.isNotEmpty)
//                             Padding(
//                               padding: const EdgeInsets.only(left: 10.0),
//                               child: Wrap(
//                                 spacing: width / 60,
//                                 runSpacing: width / 60,
//                                 children: List.generate(
//                                   myController!.bankStringList!.length,
//                                       (ind) {
//                                     final bank =
//                                     myController?.bankStringList![ind];
//                                     final isSelected =
//                                         myController?.selectedBank == bank;
//
//                                     return IntrinsicWidth(
//                                       child: InkWell(
//                                         onTap: () {
//                                           myController?.hideMidTid.value =
//                                           false;
//
//                                           myController?.selectedBank = bank;
//                                           myController?.getBankId();
//                                           myController?.update();
//                                         },
//                                         child: Container(
//                                           alignment: Alignment.center,
//                                           padding: EdgeInsets.symmetric(
//                                             vertical: height / 80,
//                                             horizontal: width / 30,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             border: Border.all(
//                                                 color: isSelected
//                                                     ? appColors.white
//                                                     : appColors.grey),
//                                             gradient: isSelected
//                                                 ? LinearGradient(
//                                               begin:
//                                               Alignment.bottomLeft,
//                                               end: Alignment.topRight,
//                                               stops: const [-2, 1],
//                                               colors: [
//                                                 appColors.primaryLight,
//                                                 appColors.red,
//                                               ],
//                                             )
//                                                 : const LinearGradient(
//                                               begin:
//                                               Alignment.bottomLeft,
//                                               end: Alignment.topRight,
//                                               stops: [-2, 1],
//                                               colors: [
//                                                 Color(0xffffffff),
//                                                 Color(0xffffffff),
//                                               ],
//                                             ),
//                                             borderRadius:
//                                             BorderRadius.circular(
//                                                 height / 90),
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: Colors.grey
//                                                     .withOpacity(0.2),
//                                                 spreadRadius: 5,
//                                                 blurRadius: 7,
//                                                 offset: const Offset(0,
//                                                     3), // changes position of shadow
//                                               ),
//                                             ],
//                                           ),
//                                           child: Text(
//                                             myController!
//                                                 .bankStringList![ind],
//                                             style: context
//                                                 .textTheme.bodySmall!
//                                                 .copyWith(
//                                               fontSize: height / 30,
//                                               letterSpacing: 1,
//                                               color: isSelected
//                                                   ? appColors.white
//                                                   : appColors.textExtraLight,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           if (myController?.selectedBank != null)
//                             SizedBox(height: height / 30),
//                           if (myController?.selectedBank != null)
//                             InkWell(
//                               onTap: () {
//                                 myController!.hideMidTid.value =
//                                 !myController!.hideMidTid.value;
//
//                                 myController?.hideSerialNumber.value = true;
//                                 myController?.update();
//                               },
//                               child: IgnorePointer(
//                                 ignoring: true,
//                                 child: customTextField(
//                                   textEditingController: myController?.tid,
//                                   title: '',
//                                   fullTag: 'Select T.I.D',
//                                   filled: true,
//                                   readOnly: true,
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: myController!
//                                         .hideMidTid.value ==
//                                         false
//                                         ? BorderRadius.only(
//                                       topLeft:
//                                       Radius.circular(width / 50),
//                                       topRight:
//                                       Radius.circular(width / 50),
//                                     )
//                                         : BorderRadius.circular(width / 50),
//                                     borderSide: BorderSide.none,
//                                   ),
//                                   fillColor:
//                                   appColors.bgColorHome.withOpacity(0.5),
//                                   border: false,
//                                   textColor: appColors.white,
//                                   hintColor: appColors.white,
//                                   prefixIcon: Container(
//                                     padding: EdgeInsets.symmetric(
//                                       vertical: height / 30,
//                                       horizontal: width / 30,
//                                     ),
//                                     child: Icon(
//                                       Icons.confirmation_number_rounded,
//                                       size: height / 18,
//                                       color: appColors.white,
//                                     ),
//                                   ),
//                                   suffixIcon: Container(
//                                     padding: EdgeInsets.symmetric(
//                                       vertical: height / 30,
//                                       horizontal: width / 30,
//                                     ),
//                                     child: Icon(
//                                       Icons.arrow_drop_down_rounded,
//                                       size: height / 18,
//                                       color: appColors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           midTidListWidget(context),
//                           SizedBox(height: height / 30),
//                           if (myController!.cardTYPE != null &&
//                               myController!.cardTYPE!.isNotEmpty)
//                             Text(
//                               'Card Network Type',
//                               style: context.textTheme.bodySmall!.copyWith(
//                                 fontSize: height / 28,
//                                 letterSpacing: 2,
//                                 color: appColors.white,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           SizedBox(height: height / 40),
//                           if (myController!.cardTYPE != null &&
//                               myController!.cardTYPE!.isNotEmpty)
//                             Padding(
//                               padding: const EdgeInsets.only(left: 10.0),
//                               child: Wrap(
//                                 spacing: width / 60,
//                                 runSpacing: width / 60,
//                                 children: List.generate(
//                                   myController!.cardTYPE!.length,
//                                       (ind) {
//                                     final card = myController?.cardTYPE![ind];
//                                     final isSelected =
//                                         myController?.selectedCard == card;
//
//                                     return IntrinsicWidth(
//                                       child: InkWell(
//                                         onTap: () {
//                                           myController?.selectedCard = card;
//                                           myController?.update();
//                                         },
//                                         child: Container(
//                                           alignment: Alignment.center,
//                                           padding: EdgeInsets.symmetric(
//                                             vertical: height / 80,
//                                             horizontal: width / 30,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             border: Border.all(
//                                                 color: isSelected
//                                                     ? appColors.white
//                                                     : appColors.grey),
//                                             gradient: isSelected
//                                                 ? LinearGradient(
//                                               begin:
//                                               Alignment.bottomLeft,
//                                               end: Alignment.topRight,
//                                               stops: const [-2, 1],
//                                               colors: [
//                                                 appColors.primaryLight,
//                                                 appColors.red,
//                                               ],
//                                             )
//                                                 : const LinearGradient(
//                                               begin:
//                                               Alignment.bottomLeft,
//                                               end: Alignment.topRight,
//                                               stops: [-2, 1],
//                                               colors: [
//                                                 Color(0xffffffff),
//                                                 Color(0xffffffff),
//                                               ],
//                                             ),
//                                             borderRadius:
//                                             BorderRadius.circular(
//                                                 height / 90),
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: Colors.grey
//                                                     .withOpacity(0.2),
//                                                 spreadRadius: 5,
//                                                 blurRadius: 7,
//                                                 offset: const Offset(0,
//                                                     3), // changes position of shadow
//                                               ),
//                                             ],
//                                           ),
//                                           child: Text(
//                                             myController!.cardTYPE![ind],
//                                             style: context
//                                                 .textTheme.bodySmall!
//                                                 .copyWith(
//                                               fontSize: height / 30,
//                                               letterSpacing: 1,
//                                               color: isSelected
//                                                   ? appColors.white
//                                                   : appColors.textExtraLight,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           SizedBox(height: height / 16),
//                           customTextField(
//                             textEditingController:
//                             myController?.rRNSlipNumber,
//                             title: '',
//                             fullTag: 'Enter RRN From Slip',
//                             filled: true,
//                             fillColor: appColors.bgColorHome.withOpacity(0.5),
//                             border: false,
//                             keyboardType: TextInputType.text,
//                             textColor: appColors.white,
//                             hintColor: appColors.white,
//                             prefixIcon: Container(
//                               padding: EdgeInsets.symmetric(
//                                 vertical: height / 30,
//                                 horizontal: width / 60,
//                               ),
//                               child: Icon(
//                                 Icons.receipt_rounded,
//                                 size: height / 18,
//                                 color: appColors.white,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: height / 30),
//                           InkWell(
//                             onTap: () {
//                               myController?.pickDocument(context);
//                             },
//                             child: IgnorePointer(
//                               ignoring: true,
//                               child: customTextField(
//                                 textEditingController: myController?.document,
//                                 title: '',
//                                 fullTag: 'Upload slip',
//                                 filled: true,
//                                 readOnly: true,
//                                 fillColor:
//                                 appColors.bgColorHome.withOpacity(0.5),
//                                 border: false,
//                                 keyboardType: TextInputType.number,
//                                 textColor: appColors.white,
//                                 hintColor: appColors.white,
//                                 prefixIcon: Container(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: height / 30,
//                                     horizontal: width / 60,
//                                   ),
//                                   child: Icon(
//                                     Icons.upload_file_rounded,
//                                     size: height / 18,
//                                     color: appColors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           if (myController?.file != null)
//                             SizedBox(height: height / 60),
//                           if (myController?.file != null)
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     myController?.file = null;
//                                     myController?.document.clear();
//                                     myController?.update();
//                                   },
//                                   child: Text(
//                                     "Delete",
//                                     style: theme.textTheme.bodySmall
//                                         ?.copyWith(
//                                         color: Colors.redAccent,
//                                         fontSize: height / 28,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: width / 30,
//                                 ),
//                                 InkWell(
//                                   onTap: () async {
//                                     // Future.delayed(Duration.zero, () {
//                                     //   Navigator.of(context).push(
//                                     //     ViewDoc(
//                                     //       authCubit: authCubit,
//                                     //       docPath: authCubit.panDocCon.text,
//                                     //       file: authCubit.panDoc,
//                                     //     ),
//                                     //   );
//                                     // });
//                                   },
//                                   child: Text(
//                                     "View  ",
//                                     style: theme.textTheme.bodySmall
//                                         ?.copyWith(
//                                         color: appColors.green,
//                                         fontSize: height / 28,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           SizedBox(height: height / 20),
//                           myController?.isLoading.value == false
//                               ? SizedBox(
//                               width: width,
//                               height: height / 8,
//                               child: OutlinedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   foregroundColor: appColors.white,
//                                   minimumSize: const Size(88, 36),
//                                   side: BorderSide(
//                                       width: 0.8, color: appColors.white),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.all(
//                                       Radius.circular(height / 40.0),
//                                     ),
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   myController?.validatePOSForm();
//                                 },
//                                 child: Text(
//                                   "Submit",
//                                   style: theme.textTheme.bodyLarge
//                                       ?.copyWith(
//                                       color: appColors.white,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: height / 24),
//                                 ),
//                               ))
//                               : Lottie.asset(
//                               'assets/lottie/wave_loading.json',
//                               width: width,
//                               height: height / 4),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             }),
//       )
//     ));
//   }
//
//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     return FadeTransition(
//       opacity: animation,
//       child: ScaleTransition(
//         scale: animation,
//         child: child,
//       ),
//     );
//   }
//
//   Widget midTidListWidget(context) {
//     if (myController!.midTidList.isNotEmpty) {
//       return AnimatedContainer(
//         duration: const Duration(milliseconds: 500),
//         height: myController?.hideMidTid.value == false ? height / 3 : 0,
//         padding: EdgeInsets.only(top: width / 30),
//         decoration: BoxDecoration(
//           color: appColors.white,
//           borderRadius: const BorderRadius.only(
//             bottomLeft: Radius.circular(10),
//             bottomRight: Radius.circular(10),
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
//           itemCount: myController?.midTidList.length,
//           shrinkWrap: true,
//           itemBuilder: (BuildContext context, int index) {
//             return InkWell(
//               onTap: () {
//                 myController?.hideMidTid.value = true;
//                 myController?.mid.text =
//                     myController!.midTidList[index].mid.toString();
//                 myController?.tid.text =
//                     'TID : ${myController?.midTidList[index].tid.toString()}';
//                 myController?.tidToSendInApi =
//                     myController?.midTidList[index].tid.toString();
//                 myController?.midToSendInApi =
//                     myController?.midTidList[index].tid.toString();
//                 debugPrint(myController?.mid.toString());
//
//                 myController?.update();
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: width / 40.0, vertical: height / 80.0),
//                 margin: const EdgeInsets.only(right: 10, bottom: 10, left: 10),
//                 decoration: BoxDecoration(
//                     gradient: myController?.midTidList[index].tid ==
//                             myController?.tidToSendInApi
//                         ? LinearGradient(
//                             begin: Alignment.bottomLeft,
//                             end: Alignment.topRight,
//                             stops: const [-2, 1],
//                             colors: [
//                               appColors.primaryLight,
//                               appColors.red,
//                             ],
//                           )
//                         : const LinearGradient(
//                             begin: Alignment.bottomLeft,
//                             end: Alignment.topRight,
//                             stops: [-2, 1],
//                             colors: [
//                               Color(0xffffffff),
//                               Color(0xffffffff),
//                             ],
//                           ),
//                     borderRadius: BorderRadius.circular(4)),
//                 child: Text(
//                   '${myController?.selectedBank} - TID ${myController?.midTidList[index].tid!}',
//                   style: theme.textTheme.labelMedium?.copyWith(
//                     color: myController?.midTidList[index].tid ==
//                             myController?.tidToSendInApi
//                         ? appColors.white
//                         : appColors.black,
//                     fontSize: height / 28,
//                     fontWeight: FontWeight.w500,
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
//   Widget serialNumberListWidget(context) {
//     if (myController!.serialNumberList.isNotEmpty) {
//       return AnimatedContainer(
//         duration: const Duration(milliseconds: 500),
//         height: myController?.hideSerialNumber.value == false ? height / 3 : 0,
//         padding: EdgeInsets.only(top: width / 30),
//         decoration: BoxDecoration(
//           color: appColors.white,
//           borderRadius: const BorderRadius.only(
//             bottomLeft: Radius.circular(10),
//             bottomRight: Radius.circular(10),
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
//           itemCount: myController?.serialNumberList.length,
//           shrinkWrap: true,
//           itemBuilder: (BuildContext context, int index) {
//             return InkWell(
//               onTap: () {
//                 myController?.hideSerialNumber.value = true;
//                 myController?.selectedSerialNumber =
//                     myController?.serialNumberStringList[index];
//                 myController?.update();
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: width / 40.0, vertical: height / 80.0),
//                 margin: const EdgeInsets.only(right: 10, bottom: 10, left: 10),
//                 decoration: BoxDecoration(
//                     gradient: myController?.serialNumberList[index] ==
//                             myController?.selectedSerialNumber
//                         ? LinearGradient(
//                             begin: Alignment.bottomLeft,
//                             end: Alignment.topRight,
//                             stops: const [-2, 1],
//                             colors: [
//                               appColors.primaryLight,
//                               appColors.red,
//                             ],
//                           )
//                         : const LinearGradient(
//                             begin: Alignment.bottomLeft,
//                             end: Alignment.topRight,
//                             stops: [-2, 1],
//                             colors: [
//                               Color(0xffffffff),
//                               Color(0xffffffff),
//                             ],
//                           ),
//                     borderRadius: BorderRadius.circular(4)),
//                 child: Text(
//                   ' ${myController?.serialNumberStringList[index]} ',
//                   style: theme.textTheme.labelMedium?.copyWith(
//                     color: myController?.serialNumberStringList[index] ==
//                             myController?.selectedSerialNumber
//                         ? appColors.white
//                         : appColors.black,
//                     fontSize: height / 28,
//                     fontWeight: FontWeight.w500,
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
//   GestureDetector backButton() {
//     return GestureDetector(
//       onTap: () {
//         Get.back();
//       },
//       child: Row(
//         children: [
//           SizedBox(width: width / 30),
//           Icon(
//             Icons.arrow_back_ios_new_rounded,
//             size: height / 14,
//             color: appColors.white,
//           ),
//           SizedBox(width: width / 80),
//           Text(
//             " P.O.S Request",
//             style: theme.textTheme.labelMedium?.copyWith(
//               color: appColors.white,
//               letterSpacing: 1,
//               fontWeight: FontWeight.w400,
//               fontSize: height / 18,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
