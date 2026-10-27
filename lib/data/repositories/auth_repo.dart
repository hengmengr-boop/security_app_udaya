import 'package:udaya_visitor/helper/helper_export.dart';

/// Local-first authentication.
///
/// Today it checks the demo account in [C]. To go online, replace the body of
/// [login] with a Dio call to your backend and save the returned token with
/// [AppPreference.saveAccessToken] — nothing above this class has to change.
final class AuthRepo {
  Future<bool> login({required String username, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final ok = username.trim() == C.demoUsername && password == C.demoPassword;
    if (!ok) return false;
    await AppPreference.saveAccessToken('local-demo-token');
    await AppPreference.saveUsername(username.trim());
    return true;
  }

  Future<void> logout() => AppPreference.clearCredential();
}
