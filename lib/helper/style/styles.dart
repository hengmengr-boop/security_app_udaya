import 'package:udaya_visitor/helper/helper_export.dart';
import 'package:flutter/material.dart';

// End: Primary Material Color
extension StylesExtension on Color {
  MaterialColor toSwatch() {
    // * Variable
    final strengths = <double>[.05];
    final swatch = <int, Color>{};
    final r = this.r.toInt();
    final g = this.g.toInt();
    final b = this.b.toInt();

    // * Loop
    for (var i = 1; i < 10; i++) {
      // * Add Strengths
      strengths.add(0.1 * i);
    }

    // * Loop Strengths
    for (final strength in strengths) {
      // * Config DS
      final ds = 0.5 - strength;
      // * Config Color Swatch
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    // * Return Material Color
    return MaterialColor(toARGB32(), swatch);
  }
}

const modalBottomSheetShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(Dimen.defaultRadius * 2),
    topRight: Radius.circular(Dimen.defaultRadius * 2),
  ),
);
const modalDialogShape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Dimen.defaultRadius / 2)));

class CustomTextStyle {
  CustomTextStyle._();

  static final ValueNotifier<Color> _titleColor = ValueNotifier(AppColors.chromeHi);
  static final ValueNotifier<Color> _bodyColor = ValueNotifier(AppColors.textBodyDark);
  static final ValueNotifier<Color> _subColor = ValueNotifier(AppColors.textSubDark);
  static final ValueNotifier<Color> _muteColor = ValueNotifier(AppColors.textSubDark);

  static final CustomTextStyle _instance = CustomTextStyle._();

  static CustomTextStyle get instance => _instance;

  void onChanged(bool isDark) {
    _titleColor.value = isDark ? AppColors.chromeHi : AppColors.textBody;
    _bodyColor.value = isDark ? AppColors.textBodyDark : AppColors.textBody;
    _subColor.value = isDark ? AppColors.textSubDark : AppColors.textSub;
    _muteColor.value = isDark ? AppColors.textSubDark : AppColors.textMuted;
  }

  static TextStyle largeTitleTextStyle({
    double? height,
    Color? color,
    double fontSize = Dimen.largeTitleTextSize,
    FontWeight? fontWeight,
    String? fontFamily,
    bool bold = true,
  }) {
    return TextStyle(
      color: color ?? _titleColor.value,
      height: height,
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.bold : fontWeight,
      fontFamily: fontFamily,
    );
  }

  static TextStyle titleTextStyle({
    double? height,
    Color? color,
    double fontSize = Dimen.titleTextSize,
    FontWeight? fontWeight,
    String? fontFamily,
    bool bold = true,
  }) {
    return TextStyle(
      color: color ?? _bodyColor.value,
      height: height,
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.bold : fontWeight,
      fontFamily: fontFamily,
    );
  }

  static TextStyle bodyTextStyle({
    double? height,
    Color? color,
    double fontSize = Dimen.bodyTextSize,
    FontWeight? fontWeight,
    String? fontFamily,
    TextDecoration? decoration,
    bool bold = false,
  }) {
    return TextStyle(
      color: color ?? _subColor.value,
      height: height,
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.bold : fontWeight,
      fontFamily: fontFamily,
      decoration: decoration,
    );
  }

  static TextStyle captionTextStyle({
    double? height,
    Color? color,
    double fontSize = Dimen.captionTextSize,
    FontWeight? fontWeight,
    String? fontFamily,
    TextDecoration? decoration,
    bool bold = false,
    bool italic = false,
  }) {
    return TextStyle(
      color: color ?? _muteColor.value,
      height: height,
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.bold : fontWeight,
      decoration: decoration,
      fontFamily: fontFamily,
      fontStyle: italic ? FontStyle.italic : null,
    );
  }

  static TextStyle buttonTextStyle({
    double? height,
    Color? color,
    double fontSize = Dimen.buttonTextSize,
    FontWeight fontWeight = FontWeight.normal,
    String? fontFamily,
    bool bold = true,
  }) {
    return TextStyle(
      color: color ?? AppColors.white,
      height: height,
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.bold : fontWeight,
      fontFamily: fontFamily,
    );
  }
}
