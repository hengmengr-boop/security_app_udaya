import 'package:flutter/material.dart';

/// Locales supported by the application.
abstract final class LanguageManager {
  static const Locale defaultLanguage = Locale('en', 'US');
  static const Locale khmerLanguage = Locale('km', 'KH');

  static const List<Locale> supportedLanguage = <Locale>[
    defaultLanguage,
    khmerLanguage,
  ];
}
