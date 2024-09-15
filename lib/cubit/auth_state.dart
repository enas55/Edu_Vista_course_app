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

// user status
class NewUser extends AuthState {}

class OldUser extends AuthState {}


class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}


// update user name

class UserNameUpdateLoading extends AuthState {}

class UserNameUpdateSuccess extends AuthState {
  final String message;

  UserNameUpdateSuccess(this.message);
}

class UserNameUpdateFailed extends AuthState {
  final String error;

  UserNameUpdateFailed(this.error);
}

// update user profile pic

class UserProfilePicUpdateLoading extends AuthState {}

class UserProfilePicUpdateSuccess extends AuthState {
  final String message;
  final String? downloadUrl;

  UserProfilePicUpdateSuccess(this.message, {this.downloadUrl});
}

class UserProfilePicUpdateFailed extends AuthState {
  final String error;

  UserProfilePicUpdateFailed(this.error);
}

// log out

class AuthLoading extends AuthState {}

class AuthLogoutSuccess extends AuthState {
  final String message;

  AuthLogoutSuccess(this.message);
}

class AuthLogoutFailed extends AuthState {
  final String error;

  AuthLogoutFailed(this.error);
}
// delete account

class AuthDeleteLoading extends AuthState {}

class AuthDeleteSuccess extends AuthState {
  final String message;

  AuthDeleteSuccess(this.message);
}

class AuthDeleteFailed extends AuthState {
  final String error;

  AuthDeleteFailed(this.error);
}

// google Sign in

class GoogleSignInLoading extends AuthState {}

class GoogleSignInSuccess extends AuthState {}

class GoogleSignInFailed extends AuthState {
  final String error;

  GoogleSignInFailed(this.error);
}
