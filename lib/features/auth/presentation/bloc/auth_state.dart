part of 'auth_bloc.dart';

sealed class AuthState {}

sealed class AuthActionState extends AuthState {}

final class AuthInitial extends AuthState {}

final class AuthTFourLoadingStatus extends AuthState {}

final class AuthTFourLoginSuccessState extends AuthState {
  final UserLoginEntity user;

  AuthTFourLoginSuccessState({required this.user});
}

final class AuthTFourLoginErrorState extends AuthState {
  final String error;

  AuthTFourLoginErrorState({required this.error});
}

final class NavigateToTFourHomeActionState extends AuthActionState {}

final class AuthChangePasswordSuccessStatus extends AuthState {
  final ChangePasswordEntity changePasswordEntity;

  AuthChangePasswordSuccessStatus({required this.changePasswordEntity});
}

final class AuthChangePasswordErrorStatus extends AuthState {
  final String error;

  AuthChangePasswordErrorStatus({required this.error});
}

final class AuthNavigateToLoginPanelActionStatus extends AuthActionState {}

final class AuthUpdateUserProfileDetailsSuccessStatus extends AuthState {
  final UpdateProfileEntity updateProfileEntity;

  AuthUpdateUserProfileDetailsSuccessStatus({required this.updateProfileEntity});

}


final class AuthUpdateProfileFailedErrorStatus extends AuthState {
  final String error;

  AuthUpdateProfileFailedErrorStatus({required this.error});
}

final class NavigateToLoginPanelAfterUpdateProfileActionStatus extends AuthActionState{}


final class AuthForgotPasswordSuccessState extends AuthState {
  final ForgotPasswordEntity forgotPasswordEntity;

  AuthForgotPasswordSuccessState({required this.forgotPasswordEntity});
}

final class AuthForgotPasswordErrorState extends AuthState {
  final String error;

  AuthForgotPasswordErrorState({required this.error});
}