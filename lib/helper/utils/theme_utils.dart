import 'package:udaya_visitor/helper/helper_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

final class ThemeUtils {
  ThemeUtils._();

  static final ThemeUtils _instance = ThemeUtils._();

  static ThemeUtils get instance => _instance;

  /// Notifier for the current theme mode (light/dark)
  static final _themeMode = ValueNotifier<ThemeMode>(AppPreference.getTheme);
  static final _primaryColor = ValueNotifier<Color>(AppPreference.getPrimaryColor);
  static final _isDarkNotifier = ValueNotifier<bool>(false);

  /// Getter for the current state
  static ValueNotifier<ThemeMode> get themeModeNotifier => _themeMode;

  static ValueNotifier<Color> get primaryColorNotifier => _primaryColor;

  static bool get isDark => _isDarkNotifier.value;

  static Color get primaryColor => _primaryColor.value;

  /// Initialize the theme state
  void initTheme({ThemeMode? themeMode}) {
    // * Add System Brightness Change Listener
    // TODO -
    // * On Theme Changed
    _onThemeChanged(AppPreference.getTheme);
    _primaryColor.value = AppPreference.getPrimaryColor;
  }

  /// Update the theme and notify listeners
  void setTheme(ThemeMode themeMode) => _onThemeChanged(themeMode);

  void setPrimaryColor(Color color) {
    _primaryColor.value = color;
    AppPreference.savePrimaryColor(color);
  }

  void _onThemeChanged(ThemeMode themeMode) {
    // * [_isDarkNotifier] - If is system check from the [platformBrightness]
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      _isDarkNotifier.value = brightness == Brightness.dark;
      // * [_isDarkNotifier] - If isn't system compare with the [ThemeMode.dark]
    } else {
      _isDarkNotifier.value = themeMode == ThemeMode.dark;
    }

    // * Update the custom text styles before triggering rebuild
    CustomTextStyle.instance.onChanged(_isDarkNotifier.value);

    // * Notify listeners to rebuild the app
    _themeMode.value = themeMode;
    AppPreference.saveThemeMode(themeMode);
  }
}
