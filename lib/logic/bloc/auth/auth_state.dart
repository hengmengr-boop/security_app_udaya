part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthAuthenticated extends AuthState {}

final class AuthFailure extends AuthState {
  AuthFailure([this.message = 'Login failed. Please try again.']);

  final String message;
}

final class AuthenticatorRequired extends AuthState {
  AuthenticatorRequired(
      {required this.username, required this.loginVerifyToken});
  final String username;
  final String loginVerifyToken;
}

final class AuthLoggedOut extends AuthState {}
