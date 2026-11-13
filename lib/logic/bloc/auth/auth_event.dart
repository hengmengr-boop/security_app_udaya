part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class LoginEvent extends AuthEvent {
  final String username;
  final String password;
  LoginEvent({required this.username, required this.password});
}

final class ValidateAuthenticatorEvent extends AuthEvent {
  final String username;
  final String loginVerifyToken;
  final String code;

  ValidateAuthenticatorEvent(
      {required this.username,
      required this.loginVerifyToken,
      required this.code});
}

final class CancelAuthenticatorEvent extends AuthEvent {}

final class LogoutEvent extends AuthEvent {}
