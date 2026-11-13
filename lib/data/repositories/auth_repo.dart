import 'package:udaya_visitor/data/api/auth_api.dart';
import 'package:udaya_visitor/data/models/auth_models.dart';
import 'package:udaya_visitor/helper/helper_export.dart';

/// Authentication Repository for 2-step Authentication (`/auth/login` and `/auth/validate/google-authenticator`).
final class AuthRepo {
  AuthRepo({AuthApi? authApi}) : _authApi = authApi ?? AuthApi();

  final AuthApi _authApi;

  /// Step 1: Login with username/password -> returns `loginVerifyToken` string
  Future<AuthLoginResponse> step1Login({
    required String username,
    required String password,
    String deviceId = '320794035e5bfcaf',
    String deviceName = 'SM-S928B',
  }) async {
    final req = AuthLoginRequest(
      username: username.trim(),
      password: password,
      deviceId: deviceId,
      deviceName: deviceName,
    );
    return _authApi.login(req);
  }

  /// Step 2: Validate 2FA Google Authenticator code / PIN -> saves accessToken
  Future<AuthValidate2FaResponse> step2Validate2FA({
    required String code,
    required String username,
    required String loginVerifyToken,
  }) async {
    final req = AuthValidate2FaRequest(
      code: code.trim(),
      username: username.trim(),
      loginVerifyToken: loginVerifyToken,
    );
    final res = await _authApi.validate2FA(req);
    if (res.tokenData != null && res.tokenData!.accessToken.isNotEmpty) {
      final token = res.tokenData!.accessToken;
      await SecureStorageHelper.instance.saveAccessToken(token);
      await AppPreference.saveAccessToken(token);
      await AppPreference.saveUsername(username.trim());
    }
    return res;
  }

  Future<void> logout() async {
    await SecureStorageHelper.instance.clearTokens();
    await AppPreference.clearCredential();
  }
}
