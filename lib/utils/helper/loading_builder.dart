// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:snap_task/utils/theme/apptheme.dart';
//
// class LoadingBuilder {
//   LoadingBuilder();
//
//   static void show() {
//     showDialog(
//       context: Get.overlayContext!,
//       barrierDismissible: false,
//       builder: (context) {
//         return WillPopScope(
//           onWillPop: () async => false,
//           child: const AlertDialog(
//             /// ALREADY COMMENTED
//             /// shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
//             backgroundColor: Colors.transparent,
//             insetPadding: EdgeInsets.symmetric(horizontal: 100.0),
//             content: _LoadingIndicator(),
//             elevation: 0.0,
//           ),
//         );
//       },
//     );
//   }
//
//   static void hide() {
//     Get.close(1);
//   }
// }
//
// class _LoadingIndicator extends StatelessWidget {
//   const _LoadingIndicator();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 120,
//       decoration: BoxDecoration(
//         color: appColors.white,
//         borderRadius: const BorderRadius.all(Radius.circular(8.0)),
//       ),
//       child: _getLoadingIndicator(),
//     );
//   }
//
//   Widget _getLoadingIndicator() {
//     return Center(
//       child: SizedBox.square(
//         dimension: 40.0,
//         child: CircularProgressIndicator(
//           color: appColors.primaryColor,
//           strokeWidth: 1.0,
//         ),
//       ),
//     );
//   }
// }
