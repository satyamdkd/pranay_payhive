import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/utils/helper/text_capitalization.dart';
import 'package:payhive/utils/theme/apptheme.dart';

void showSnackBar({
  String? title,
  required String message,
  Color? color,
  Duration? duration,
}) {
  final theme = Theme.of(Get.context!);
  final mediaQuery = MediaQuery.of(Get.context!);

  String cleanedMessage = _cleanMessage(message);
  cleanedMessage = capitalizeFirstCharacter(cleanedMessage);

  Get.snackbar(
    title ?? "Payhive",
    cleanedMessage,
    snackPosition: SnackPosition.TOP,
    duration: duration ?? const Duration(seconds: 2),
    backgroundColor: color ?? appColors.primaryColor,
    colorText: appColors.white,
    borderRadius: 4.0,
    borderColor: Colors.white,
    borderWidth: 0.5,
    margin: const EdgeInsets.all(10.0),
    padding: const EdgeInsets.all(16.0),
    icon: const Icon(Icons.info_outline, color: Colors.white),
    animationDuration: const Duration(milliseconds: 300),
    snackStyle: SnackStyle.FLOATING,
    messageText: Text(
      cleanedMessage,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: appColors.white,
        fontWeight: FontWeight.w600,
        fontSize: mediaQuery.size.height / 60,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    ),
    titleText: Text(
      title ?? "Payhive",
      style: theme.textTheme.titleLarge?.copyWith(
        color: appColors.white,
        fontWeight: FontWeight.w800,
        fontSize: mediaQuery.size.height / 54,
      ),
    ),
  );
}

String _cleanMessage(String message) {
  final regex = RegExp(
    r'(STATUS 0,|STATUS 1,|Validation failed\.,|\{status: (0|1),|data: |data|:|\}|\{)',
    caseSensitive: false,
  );
  String cleaned = message.replaceAll(regex, '').trim();

  cleaned = cleaned;
  if (cleaned.toLowerCase().contains("msg:")) {
    cleaned = cleaned.split("msg:")[1].trim();
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
