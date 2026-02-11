// import 'package:flutter/material.dart';
// import 'package:snap_task/services/di/di.dart';
// import 'package:snap_task/utils/screen_size.dart';
// import 'package:snap_task/utils/theme/apptheme.dart';
//
// showLoaderDialog(BuildContext context, callback, tag) {
//   AlertDialog alert = AlertDialog(
//     content: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Image.asset(
//           "assets/icons/app_icon.png",
//           height: height / 14,
//           width: height / 14,
//         ),
//         SizedBox(height: height / 40),
//         Container(
//             padding: EdgeInsets.symmetric(horizontal: width / 40),
//             height: width / 46,
//             width: width,
//             child: const LinearProgressIndicator()),
//         SizedBox(height: height / 40),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: width / 40),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("$tag please wait...    "),
//               Text(
//                 "$percentage/100 %",
//                 style: theme.textTheme.bodySmall?.copyWith(
//                     color: appColors.green, fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (context) => StatefulBuilder(builder: (context, setState) {
//       return alert;
//     }),
//   );
// }
