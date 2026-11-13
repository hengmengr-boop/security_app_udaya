enum ToastStatus { none, error, success }

abstract final class AppRooms {
  static const String hogf = 'HOGF - បន្ទប់ប្រជុំជាន់ផ្ទាល់ដី - ដំរី - 8';
  static const String homf01 = 'HOMF01 - បន្ទប់ប្រជុំជាន់ឡៅតឿ - ទន្សាយ - 10';
  static const String homf02 = 'HOMF02 - បន្ទប់ប្រជុំជាន់ឡៅតឿ - លំចង់ - 6';

  static const List<String> all = [hogf, homf01, homf02];
}

/// Global application constants and shared configuration values.
abstract final class C {
  /// ---------------------------------------------------------------------------
  /// API Configuration Options
  /// ---------------------------------------------------------------------------
  /// QA Server HTTPS: 'https://qacltom.udaya-tech.com/utSystemHrAPi'
  /// Server 10 Private (Office WiFi): 'http://192.168.10.10:8080/utSystemHrAPi'
  /// Server 10 Public (External IP): 'http://203.189.156.156:8080/utSystemHrAPi'
  static const String qaApiBaseUrl =
      'https://qacltom.udaya-tech.com/utSystemHrAPi';
  static const String privateApiBaseUrl =
      'http://192.168.10.10:8080/utSystemHrAPi';
  static const String publicApiBaseUrl =
      'http://203.189.156.156:8080/utSystemHrAPi';

  /// Default active Base URL (Office WiFi - Server 10 Private IP)
  static const String apiBaseUrl = privateApiBaseUrl;

  static const int pageSize = 10;

  /// ---------------------------------------------------------------------------
  /// Demo Account Constants
  /// ---------------------------------------------------------------------------
  static const String demoUsername = 'Meng';
  static const String demoPassword = '121212';

  /// ---------------------------------------------------------------------------
  /// Messages
  /// ---------------------------------------------------------------------------

  static const String unauthorizedMessage =
      'Session expired. Please sign in again.';
  static const String serverErrorMessage =
      'The server is not responding. Please try again later.';
}
