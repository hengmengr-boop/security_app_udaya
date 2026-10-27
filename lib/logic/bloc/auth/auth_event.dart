part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  LoginEvent({required this.username, required this.password});
}

final class LogoutEvent extends AuthEvent {}
