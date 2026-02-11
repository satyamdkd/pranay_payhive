import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/utils/helper/text_capitalization.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:quickalert/quickalert.dart';

String _cleanMessage(String message) {
  final regex = RegExp(
    r'(STATUS 0,|STATUS 1,|Validation failed\.,|\{status: (0|1),|data: |data|:|\}|\{)',
    caseSensitive: false,
  );
  String cleaned = message.replaceAll(regex, '').trim();

  cleaned = cleaned;
  if (cleaned.toLowerCase().contains("msg:")) {
    cleaned = cleaned.split("msg:")[1].trim();
  } else if (cleaned.toLowerCase().contains("msg")) {
    cleaned = cleaned.split("msg")[1].trim();
  } else if (cleaned.toLowerCase().contains("message ")) {
    cleaned = cleaned.split("message ")[1].trim();
  } else if (cleaned.toLowerCase().contains("message:")) {
    cleaned = cleaned.split("message:")[1].trim();
  }

  if (cleaned.toLowerCase().startsWith('msg') ||
      cleaned.toLowerCase().startsWith('message')) {
    final parts = cleaned.split(':');
    if (parts.length > 1) {
      cleaned = parts.sublist(1).join(':').trim();
    }
  }

  return capitalizeFirstCharacter(cleaned);
}

void _showQuickAlert({
  required BuildContext context,
  required QuickAlertType type,
  String? title,
  required String message,
  Color? confirmBtnColor,
  String? confirmBtnText,
  VoidCallback? onConfirmTap,
}) {
  final cleanedMessage = _cleanMessage(message);

  QuickAlert.show(
    context: context,
    title: title,
    borderRadius: 20.0,
    confirmBtnColor: confirmBtnColor!,
    confirmBtnText: confirmBtnText!,
    text: cleanedMessage,
    type: type,
    onConfirmBtnTap: onConfirmTap ?? () => Get.back(),
    barrierDismissible: false,
  );
}

void successDialog({
  required BuildContext context,
  String? title,
  required String message,
  VoidCallback? onTap,
}) {
  _showQuickAlert(
    context: context,
    type: QuickAlertType.success,
    title: title ?? 'Success!',
    message: message,
    confirmBtnColor: appColors.primaryColor,
    confirmBtnText: 'Done',
    onConfirmTap: onTap,
  );
}

void errorDialog({
  required BuildContext context,
  String? title,
  required String message,
  VoidCallback? onTap,
}) {
  _showQuickAlert(
    context: context,
    type: QuickAlertType.error,
    title: title ?? 'Oops!',
    message: message,
    confirmBtnColor: appColors.red,
    confirmBtnText: 'Close',
    onConfirmTap: onTap,
  );
}

void warningDialog({
  required BuildContext context,
  String? title,
  required String message,
  VoidCallback? onTap,
}) {
  _showQuickAlert(
    context: context,
    type: QuickAlertType.warning,
    title: title ?? 'Queued!',
    message: message,
    confirmBtnColor: Colors.orange,
    confirmBtnText: 'Close',
    onConfirmTap: onTap,
  );
}
