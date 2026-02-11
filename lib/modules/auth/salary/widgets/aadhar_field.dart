import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payhive/utils/theme/apptheme.dart';

class AadharInputFormatter extends TextInputFormatter {
  /// Formats as 1234-5678-4321 (max 12 numeric only)
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length > 12) digitsOnly = digitsOnly.substring(0, 12);

    var buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      buffer.write(digitsOnly[i]);
      if ((i + 1) % 4 == 0 && i != digitsOnly.length - 1) buffer.write('-');
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

Widget aadharTextField(
    {required TextEditingController controller,
    void Function(String)? onChanged,
    bool readOnly = false,
    Widget? suffixIcon}) {
  return TextField(
    controller: controller,
    onChanged: onChanged,
    readOnly: readOnly,
    textAlign: TextAlign.justify,
    keyboardType: TextInputType.number,

    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      AadharInputFormatter(),
    ],
    maxLength: 14,

    /// 12 digits + 2 dashes
    buildCounter: (_,
            {required currentLength, required isFocused, required maxLength}) =>
        null,
    decoration: InputDecoration(
      hintText: '',
      suffixIcon: suffixIcon,
      hintStyle: theme.textTheme.bodySmall?.copyWith(
        color: appColors.textDark.withValues(alpha: 0.15),
        fontSize: 28,
        fontWeight: FontWeight.w700,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: appColors.black.withValues(alpha: 0.35),
          width: 0.6,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: appColors.black.withValues(alpha: 0.35),
          width: 0.6,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: appColors.black.withValues(alpha: 0.35),
          width: 0.6,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    ),

    style: TextStyle(
        letterSpacing: 2.4,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: appColors.primaryColor),
  );
}

class PanGstInputFormatter extends TextInputFormatter {
  final bool allowGst; // accountTypeIndex != 0

  PanGstInputFormatter({required this.allowGst});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow only A–Z and 0–9
    String raw =
        newValue.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

    // PAN = 10, GST = 15
    final maxRawLength = allowGst ? 15 : 10;
    if (raw.length > maxRawLength) {
      raw = raw.substring(0, maxRawLength);
    }

    final buffer = StringBuffer();

    for (int i = 0; i < raw.length; i++) {
      buffer.write(raw[i]);

      // ---- PAN dashes ----
      // ABCDE-1234-F
      if (i == 4 || i == 8) {
        if (i < raw.length - 1) buffer.write('-');
      }

      // ---- GST extra dashes (ONLY if GST allowed & length > PAN) ----
      // 22-ABCDE-1234-F-1Z5
      if (allowGst && raw.length > 10) {
        if (i == 1 || i == 11) {
          if (i < raw.length - 1) buffer.write('-');
        }
      }
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

Widget panGstTextField({
  required TextEditingController controller,
  required bool allowGst,
  void Function(String)? onChanged,
  bool readOnly = false,
  Widget? suffixIcon,
}) {
  return TextField(
    controller: controller,
    onChanged: onChanged,
    readOnly: readOnly,
    textCapitalization: TextCapitalization.characters,
    keyboardType: TextInputType.text,
    inputFormatters: [
      PanGstInputFormatter(allowGst: allowGst),
    ],
    maxLength: allowGst ? 19 : 12,
    buildCounter: (_,
            {required currentLength, required isFocused, required maxLength}) =>
        null,
    decoration: InputDecoration(
      hintText: allowGst ? 'Enter PAN/GST Number' : 'Enter PAN Number',
      suffixIcon: suffixIcon,
      hintStyle: theme.textTheme.bodySmall?.copyWith(
        color: appColors.textDark.withValues(alpha: 0.15),
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: appColors.black.withValues(alpha: 0.35),
          width: 0.6,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: appColors.black.withValues(alpha: 0.35),
          width: 0.6,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: appColors.black.withValues(alpha: 0.35),
          width: 0.6,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    ),
    style: TextStyle(
        letterSpacing: 2.4,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: appColors.primaryColor),
  );
}

