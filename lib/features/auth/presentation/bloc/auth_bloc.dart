import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:indogrip/features/auth/data/models/change_pass_entity.dart';
import 'package:indogrip/features/auth/data/models/forgot_password_entity.dart';
import 'package:indogrip/features/auth/data/models/login_entity.dart';
import 'package:indogrip/features/auth/data/models/uProfile_params.dart';
import 'package:indogrip/features/auth/data/models/update_profile_entity.dart';
import 'package:indogrip/features/auth/domain/repositories/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthTFourUserLoginEvent>(authTFourUserLoginEvent);
    on<AuthUserChangePasswordEvent>(_authUserChangePasswordEvent);
    on<AuthForgotPasswordEvent>(authForgotPasswordEvent);
    on<AuthUpdateUserProfileDetailsEvent>(_authUpdateUserProfileDetailsEvent);
  }

  FutureOr<void> authTFourUserLoginEvent(
    AuthTFourUserLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthTFourLoadingStatus());
    try {
      final user = await AuthRepository.tFourUserLogin(
        event.email,
        event.password,
        event.context,
      );
      emit(AuthTFourLoginSuccessState(user: user));
    } catch (e) {
      log('Login Bloc Error: $e');
      emit(AuthTFourLoginErrorState(error: e.toString()));
    }
  }

  FutureOr<void> _authUserChangePasswordEvent(
    AuthUserChangePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthTFourLoadingStatus());
    try {
      final changePassEntity = await AuthRepository.changePassword(
        currentPass: event.currentPass,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
        context: event.context,
      );

      emit(
        AuthChangePasswordSuccessStatus(changePasswordEntity: changePassEntity),
      );
      if (changePassEntity.status == 1) {
        emit(AuthNavigateToLoginPanelActionStatus());
      }
    } catch (e) {
      log('Change Password Bloc Error: $e');
      print(e);
      emit(AuthChangePasswordErrorStatus(error: e.toString()));
    }
  }

  FutureOr<void> _authUpdateUserProfileDetailsEvent(
    AuthUpdateUserProfileDetailsEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthTFourLoadingStatus());
    try {
      final uProfile = await AuthRepository.updateUserProfile(
        uParams: UProfileParams(
          event.uProfileParams.profileImage,
          uFirstName: event.uProfileParams.uFirstName,
          uLastName: event.uProfileParams.uLastName,
          uEmail: event.uProfileParams.uEmail,
          uMobile: event.uProfileParams.uMobile,
          uAlternateNumber: event.uProfileParams.uAlternateNumber,
          uPersonalEmail: event.uProfileParams.uPersonalEmail,
          context: event.uProfileParams.context,
        ),
      );
      emit(
        AuthUpdateUserProfileDetailsSuccessStatus(
          updateProfileEntity: uProfile,
        ),
      );

      if (uProfile.status == 1) {
        emit(NavigateToLoginPanelAfterUpdateProfileActionStatus());
      }
    } catch (e) {
      emit(AuthUpdateProfileFailedErrorStatus(error: e.toString()));
      print(e);
      log(name: 'uProfile Bloc Error', e.toString());
    }
  }

  FutureOr<void> authForgotPasswordEvent(
    AuthForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthTFourLoadingStatus());
    try {
      final forgotPasswordEntity = await AuthRepository.forgotUserPassword(
        email: event.email,
      );
      emit(
        AuthForgotPasswordSuccessState(
          forgotPasswordEntity: forgotPasswordEntity,
        ),
      );
    } catch (e) {
      emit(AuthForgotPasswordErrorState(error: e.toString()));
      log('Forgot Password Bloc Error: $e');
      print(e);
    }
  }
}
