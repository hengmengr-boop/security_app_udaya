import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udaya_visitor/data/data_export.dart';

final class AppPreference {
  // * Shared Preferences
  static late SharedPreferences _preferences;

  // * Authentication Info
  static const _keyAccessToken = 'accessToken';
  static const _keyRefreshToken = 'refreshToken';
  static const _keyUsername = 'username';

  // * Setting
  static const _keyTheme = 'theme';
  static const _keyPrimaryColor = 'primaryColor';

  // * Visitors
  static const _keyVisitors = 'visitors';

  // * Ensure Initialized
  static Future<void> ensureInitialized() async => _preferences = await SharedPreferences.getInstance();

  // ── Auth ──────────────────────────────────────────────────────────────────

  static Future<void> saveAccessToken(String accessToken) async {
    await _preferences.setString(_keyAccessToken, 'Bearer $accessToken');
  }

  static Future<void> saveRefreshToken(String refreshToken) async {
    await _preferences.setString(_keyRefreshToken, refreshToken);
  }

  static Future<void> saveUsername(String username) async {
    await _preferences.setString(_keyUsername, username);
  }

  static String? get getAccessToken => _preferences.getString(_keyAccessToken);

  static String? get getRefreshToken => _preferences.getString(_keyRefreshToken);

  static String? get getUsername => _preferences.getString(_keyUsername);

  // ── Theme ─────────────────────────────────────────────────────────────────

  static Future<void> saveThemeMode(ThemeMode themeMode) async {
    await _preferences.setInt(_keyTheme, themeMode.index);
  }

  static Future<void> savePrimaryColor(Color color) async {
    await _preferences.setInt(_keyPrimaryColor, color.toARGB32());
  }

  static ThemeMode get getTheme {
    return ThemeMode.values[_preferences.getInt(_keyTheme) ?? ThemeMode.light.index];
  }

  static Color get getPrimaryColor {
    final value = _preferences.getInt(_keyPrimaryColor);
    if (value == null) return const Color(0xFF241F63); // Udaya navy
    return Color(value);
  }

  // ── Visitors ──────────────────────────────────────────────────────────────

  static bool get hasVisitors => _preferences.containsKey(_keyVisitors);

  static Future<void> saveVisitors(List<VisitorModel> visitors) async {
    await _preferences.setString(_keyVisitors, VisitorModel.encodeList(visitors));
  }

  static List<VisitorModel> get getVisitors => VisitorModel.decodeList(_preferences.getString(_keyVisitors));

  // ── Operation ─────────────────────────────────────────────────────────────

  static Future<void> clearCredential() async {
    await _preferences.remove(_keyAccessToken);
    await _preferences.remove(_keyRefreshToken);
    await _preferences.remove(_keyUsername);
  }

  static Future<void> clear() async => await _preferences.clear();
}
