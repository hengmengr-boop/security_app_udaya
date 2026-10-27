enum ToastStatus { none, error, success }

enum AIUse { gemini, claude }

abstract final class AppRooms {
  static const String hogf = 'HOGF - បន្ទប់ប្រជុំជាន់ផ្ទាល់ដី - ដំរី - 8';
  static const String homf01 = 'HOMF01 - បន្ទប់ប្រជុំជាន់ឡៅតឿ - ទន្សាយ - 10';
  static const String homf02 = 'HOMF02 - បន្ទប់ប្រជុំជាន់ឡៅតឿ - លំចង់ - 6';

  static const List<String> all = [hogf, homf01, homf02];
}

/// Global application constants and shared configuration values.
abstract final class C {
  /// ---------------------------------------------------------------------------
  /// Configuration
  /// ---------------------------------------------------------------------------

  static const int pageSize = 10;

  /// ---------------------------------------------------------------------------
  /// AI Provider Configuration
  /// ---------------------------------------------------------------------------

  static const String claudeApiVersion = '2023-06-01';
  static const String geminiApiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const String claudeApiBaseUrl = 'https://api.anthropic.com/v1';

  /// ---------------------------------------------------------------------------
  /// Demo account (local-first login, replace with a real API in [AuthRepo])
  /// ---------------------------------------------------------------------------

  static const String demoUsername = 'Meng';
  static const String demoPassword = '121212';

  /// ---------------------------------------------------------------------------
  /// Messages
  /// ---------------------------------------------------------------------------

  static const String unauthorizedMessage = 'Session expired. Please sign in again.';
  static const String serverErrorMessage = 'The server is not responding. Please try again later.';
}
