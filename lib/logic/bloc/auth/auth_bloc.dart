import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udaya_visitor/data/data_export.dart';
import 'package:udaya_visitor/helper/helper_export.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Owns sign-in / sign-out. Pages react through [BlocConsumer] listeners.
final class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({AuthRepo? repo})
      : _repo = repo ?? AuthRepo(),
        super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<ValidateAuthenticatorEvent>(_onValidateAuthenticator);
    on<CancelAuthenticatorEvent>((event, emit) => emit(AuthInitial()));
    on<LogoutEvent>(_onLogout);
  }

  final AuthRepo _repo;

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final username = event.username.trim();
    final password = event.password;

    try {
      final response = await _repo.step1Login(
        username: username,
        password: password,
      );

      if (response.status && response.loginVerifyToken.isNotEmpty) {
        emit(AuthenticatorRequired(
          username: username,
          loginVerifyToken: response.loginVerifyToken,
        ));
      } else {
        // Try fallback demo credentials
        if (_isDemoAccount(username, password)) {
          await _saveDemoAuth(username);
          emit(AuthAuthenticated());
        } else {
          emit(AuthFailure('Invalid username or password.'));
        }
      }
    } catch (error) {
      // Fallback demo account for local / web testing
      if (_isDemoAccount(username, password)) {
        await _saveDemoAuth(username);
        emit(AuthAuthenticated());
        return;
      }
      emit(AuthFailure(_loginErrorMessage(error)));
    }
  }

  Future<void> _onValidateAuthenticator(
    ValidateAuthenticatorEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _repo.step2Validate2FA(
        username: event.username,
        loginVerifyToken: event.loginVerifyToken,
        code: event.code,
      );

      if (response.status && response.tokenData != null) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthFailure(response.message.isNotEmpty
            ? response.message
            : 'Authenticator verification failed.'));
      }
    } catch (error) {
      emit(AuthFailure(_loginErrorMessage(error)));
    }
  }

  bool _isDemoAccount(String username, String password) {
    return (username == 'admin' && password == '1') ||
        (username == C.demoUsername && password == C.demoPassword) ||
        (username == 'admin' && password == 'admin');
  }

  Future<void> _saveDemoAuth(String username) async {
    await SecureStorageHelper.instance.saveAccessToken('demo-token');
    await AppPreference.saveAccessToken('demo-token');
    await AppPreference.saveUsername(username);
  }

  String _loginErrorMessage(Object error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return 'The login server timed out. Check your connection and try again.';
      }
      if (error.type == DioExceptionType.connectionError) {
        return 'Could not connect to the login server. Check your connection.';
      }
      final data = error.response?.data;
      if (data is Map) {
        final message = data['message'] ?? data['error'];
        if (message != null && message.toString().trim().isNotEmpty) {
          return message.toString();
        }
      }
      if (error.response?.statusCode == 401) {
        return 'Invalid username or password.';
      }
    }
    if (error is FormatException && error.message.toString().isNotEmpty) {
      return error.message.toString();
    }
    return 'Login failed. Please check your credentials or connection.';
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await _repo.logout();
    emit(AuthLoggedOut());
  }
}
