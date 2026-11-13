import 'package:udaya_visitor/data/models/auth_models.dart';
import 'package:udaya_visitor/helper/global/api_client.dart';
import 'package:udaya_visitor/helper/global/api_constants.dart';

/// Authentication API Client for `utSystemHrAPI`.
class AuthApi {
  AuthApi({ApiClient? apiClient}) : _client = apiClient ?? ApiClient.shared;

  final ApiClient _client;

  /// Step 1: POST /auth/login
  Future<AuthLoginResponse> login(AuthLoginRequest request) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.authLogin,
      data: request.toJson(),
    );
    ApiResponseParser.body(response.data);
    return AuthLoginResponse.fromJson(response.data!);
  }

  /// Step 2: POST /auth/validate/google-authenticator
  Future<AuthValidate2FaResponse> validate2FA(
      AuthValidate2FaRequest request) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.authValidate2FA,
      data: request.toJson(),
    );
    ApiResponseParser.body(response.data);
    return AuthValidate2FaResponse.fromJson(response.data!);
  }
}
