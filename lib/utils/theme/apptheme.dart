import 'package:flutter/material.dart';
import 'package:payhive/constants/colors.dart';

AppColors get appColors => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

class ThemeHelper {
  ThemeData themeData() => _getThemeData();
  AppColors themeColor() => _getThemeColors();
  var colorScheme = ColorSchemes.primaryColorScheme;

  ThemeData _getThemeData() {
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors().white,
        titleTextStyle: TextStyle(
          color: AppColors().black,
          fontWeight: FontWeight.w500,
          fontSize: 20,
          fontFamily: "Asap",
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        border: InputBorder.none,
      ),
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: colorScheme.primary,
      radioTheme: RadioThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.onSurface;
        }),
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors().primaryColor,
      ),
      dividerTheme: DividerThemeData(
        thickness: 0.5,
        space: 2,
        color: colorScheme.secondaryContainer,
      ),
    );
  }

  AppColors _getThemeColors() {
    return AppColors();
  }
}

class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: TextStyle(
          color: AppColors().black,
          fontSize: 16,
          fontFamily: "Asap",
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: colorScheme.primary,
          fontSize: 14,
          fontFamily: "Asap",
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: colorScheme.primary,
          fontSize: 12,
          fontFamily: "Asap",
          fontWeight: FontWeight.w400,
        ),
        displayMedium: TextStyle(
          color: colorScheme.primary,
          fontSize: 40,
          fontFamily: "Asap",
          fontWeight: FontWeight.w700,
        ),
        displaySmall: TextStyle(
          color: colorScheme.primary,
          fontSize: 36,
          fontFamily: "Asap",
          fontWeight: FontWeight.w500,
        ),
        headlineLarge: TextStyle(
          color: AppColors().black,
          fontSize: 32,
          fontFamily: "Asap",
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: TextStyle(
          color: AppColors().black,
          fontSize: 24,
          fontFamily: "Asap",
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: AppColors().black,
          fontSize: 28,
          fontFamily: "Asap",
          fontWeight: FontWeight.w700,
        ),
        labelLarge: TextStyle(
          color: AppColors().black,
          fontSize: 12,
          fontFamily: "Asap",
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: appColors.black,
          fontSize: 10,
          fontFamily: "Asap",
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
          color: AppColors().black,
          fontSize: 20,
          fontFamily: "Asap",
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: AppColors().black,
          fontSize: 16,
          fontFamily: "Asap",
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: AppColors().black,
          fontSize: 14,
          fontFamily: "Asap",
          fontWeight: FontWeight.w500,
        ),
      );
}

class ColorSchemes {
  static ColorScheme primaryColorScheme = ColorScheme.light(
      primary: AppColors().textDark,
      primaryContainer: AppColors().primaryColor,
      secondaryContainer: AppColors().primaryDark,
      errorContainer: AppColors().red,
      onPrimary: AppColors().primaryColor,
      onPrimaryContainer: AppColors().primaryColor);
}
