part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class SignupState extends AuthState {}

final class SignupLoading extends SignupState {}

final class SignupSuccess extends SignupState {}

final class SignupFailed extends SignupState {}

// Login

final class LoginState extends AuthState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginFailed extends LoginState {
  final String error;

  LoginFailed(this.error);
}

// forget password

class PasswordResetEmailSent extends AuthState {}

class PasswordResetFailed extends AuthState {
  final String error;

  PasswordResetFailed(this.error);
}

class PasswordResetConfirm extends AuthState {}

class PasswordResetConfirmFailed extends AuthState {}
