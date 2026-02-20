part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class AuthTFourUserLoginEvent extends AuthEvent {
  final String email;
  final String password;
  final BuildContext context;

  AuthTFourUserLoginEvent({
    required this.email,
    required this.password,
    required this.context,
  });
}

final class AuthUserChangePasswordEvent extends AuthEvent {
  final String currentPass;
  final String newPassword;
  final String confirmPassword;
  final BuildContext context;

  AuthUserChangePasswordEvent({
    required this.currentPass,
    required this.newPassword,
    required this.confirmPassword,
    required this.context,
  });
}

final class AuthUpdateUserProfileDetailsEvent extends AuthEvent {
  final UProfileParams uProfileParams;
  final BuildContext context;

  AuthUpdateUserProfileDetailsEvent({
    required this.uProfileParams,
    required this.context,
  });
}

final class AuthForgotPasswordEvent extends AuthEvent {
  final String email;

  AuthForgotPasswordEvent({required this.email});
}
