import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payhive/utils/helper/form_validation.dart';
import 'package:payhive/utils/helper/text_capitalization.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';

SizedBox spacing({passedHeight}) =>
    SizedBox(height: passedHeight ?? height / 50);

Widget customTextField(
    {required textEditingController,
    required title,
    fullTag,
    icon,
    suffixIcon,
    obscureText = false,
    TextInputType? keyboardType,
    bool readOnly = false,
    void Function()? onTap,
    bool isCheckBox = false,
    final String? Function(Object?)? validator,
    int? maxLines = 1,
    suffix,
    prefixIcon,
    prefix,
    inputFormatter,
    onChanged,
    textColor,
    hintColor,
    bool border = true,
    InputBorder? enabledBorder,
    EdgeInsetsGeometry? contentPadding,
    int? maxLength,
    bool? filled,
    Color? fillColor,
    double? borderRadius,
    Iterable<String>? autofillHints,
    TextStyle? style,
    double? fontSize}) {
  return FormField(
    validator: validator ??
        (value) => FormValidation.nameValidator(textEditingController!.text,
            tag: title, fullTag: fullTag),
    builder: (FormFieldState<Object> field) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            obscureText: obscureText,
            textAlign: TextAlign.justify,
            controller: textEditingController,
            autofillHints: autofillHints,
            maxLength: maxLength,
            readOnly: readOnly,
            onChanged: onChanged,
            maxLines: maxLines,
            inputFormatters: keyboardType == TextInputType.number ||
                    keyboardType == TextInputType.phone
                ? [
                    FilteringTextInputFormatter.deny(
                        RegExp(r'[!@#$%^&*(),.?":{}|<>-]'))
                  ]
                : null,
            style: style ??
                TextStyle(
                    decorationThickness: 0.0,
                    color: textColor ?? appColors.textDark,
                    fontWeight:
                        fontSize != null ? FontWeight.w500 : FontWeight.w400,
                    fontSize: fontSize ?? height / 28,
                    letterSpacing: fontSize != null ? 1 : null),
            cursorColor: appColors.primaryColor,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              filled: filled,
              fillColor: fillColor,
              contentPadding: contentPadding ??
                  EdgeInsets.symmetric(horizontal: width / 30),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              counter: const SizedBox(height: 0.0),
              labelStyle: theme.textTheme.bodySmall?.copyWith(
                color: appColors.textDark,
                fontSize: height / 54,
                fontWeight: FontWeight.w400,
              ),
              enabledBorder: enabledBorder ??
                  OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(borderRadius ?? width / 50),
                    borderSide: border
                        ? BorderSide(
                            color: field.hasError
                                ? appColors.red
                                : appColors.black.withOpacity(0.35),
                            width: 0.6,
                          )
                        : BorderSide.none,
                  ),
              focusedBorder: enabledBorder ??
                  OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(borderRadius ?? width / 50),
                    borderSide: border
                        ? BorderSide(
                            color: field.hasError
                                ? appColors.red
                                : appColors.black.withOpacity(0.35),
                            width: 0.6,
                          )
                        : BorderSide.none,
                  ),
              border: enabledBorder ??
                  OutlineInputBorder(
                    borderSide: border
                        ? BorderSide(
                            color: field.hasError
                                ? appColors.red
                                : appColors.black.withOpacity(0.35),
                            width: 0.6,
                          )
                        : BorderSide.none,
                    borderRadius:
                        BorderRadius.circular(borderRadius ?? width / 50),
                  ),
              hintText: field.hasError
                  ? fullTag + " is required"
                  : fullTag ??
                      capitalizeFirstCharacter(
                          "Please ${title.toString().contains('Upload') ? "upload" : "enter"} your ${title.toString().split(" ").first}"),
              hintStyle: theme.textTheme.bodySmall?.copyWith(
                color: hintColor ??
                    (field.hasError
                        ? appColors.red
                        : appColors.textDark.withOpacity(0.5)),
                fontSize: height / 28,
                fontWeight: FontWeight.w400,
              ),
              suffixIcon: suffixIcon,
              suffix: suffix,
              prefixIcon: prefixIcon,
              prefix: prefix,
            ),
          ),
          if (field.hasError && textEditingController.text.isNotEmpty)
            SizedBox(height: height / 80),
          if (field.hasError && textEditingController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Text(
                capitalizeFirstCharacter(field.errorText!),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: appColors.red,
                ),
              ),
            ),
        ],
      );
    },
  );
}
