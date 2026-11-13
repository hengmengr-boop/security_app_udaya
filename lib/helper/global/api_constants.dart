import 'package:udaya_visitor/helper/global/constants.dart';

class ApiConstants {
  static const baseUrl = C.apiBaseUrl;

  // Auth
  static const authLogin = '/auth/login';
  static const authValidate2FA = '/auth/validate/google-authenticator';
  static const login = authLogin;

  // Visitor

  static const visitorAdd = '/visitor/add';
  static String visitorCheckIn(int id) => '/visitor/check-in/$id';
  static String visitorCheckOut(int id) => '/visitor/check-out/$id';
  static const visitorCountBadge = '/visitor/count-badge';
  static String visitorFind(int id) => '/visitor/find/$id';
  static const visitorLinkFacility = '/visitor/link-facility';
  static const visitorList = '/visitor/list';
  static const publicCheckIn = '/visitor/public/check-in';
  static const publicVerifyPin = '/visitor/public/verify-pin';
  static const visitorPublicCheckIn = publicCheckIn;
  static const visitorPublicVerifyPin = publicVerifyPin;
  static String visitorQrCode(int id) => '/visitor/qr-code/$id';
  static const visitorReport = '/visitor/report';
}
