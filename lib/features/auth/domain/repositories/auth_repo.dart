import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:indogrip/core/config/env_config.dart';
import 'package:indogrip/core/database/hive_keys.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/auth/data/models/change_pass_entity.dart';
import 'package:indogrip/features/auth/data/models/forgot_password_entity.dart';
import 'package:indogrip/features/auth/data/models/login_entity.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/features/auth/data/models/uProfile_params.dart';
import 'package:indogrip/features/auth/data/models/update_profile_entity.dart';
import 'package:indogrip/features/auth/presentation/view/login_panel.dart';
import 'package:indogrip/features/dashboard/presentation/page/deshboard.dart';
import 'package:retry/retry.dart';

abstract class AuthRepository {
  // static final _client = http.Client();
  // static final _dioClient = Dio();
  static final url = Uri.parse(EnvConfig.indoGripBaseUrl);
  static Future<UserLoginEntity> tFourUserLogin(
    String email,
    String password,
    BuildContext context,
  ) async {
    UserLoginEntity user = UserLoginEntity();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                "activity": "login",
                "uEmail": email,
                "uPassword": password,
              }),
            ).timeout(
              const Duration(seconds: 5),
              onTimeout: () => throw TimeoutException('Request timed out'),
            ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );
      // final response = await _dioClient.post(
      //   EnvConfig.indoGripBaseUrl,
      //   data: FormData.fromMap({
      //     "activity": "login",
      //     "uEmail": email,
      //     "uPassword": password,
      //   }),
      // );
      if (response.statusCode == 200) {
        // final jsonResponse = jsonDecode(response.body);
        user = UserLoginEntity.fromJson(response.data);
        developer.log(
          response.data.toString(),
          name: 'Login Response',
        ); // Save user data to Hive

        ToastService.instance.showSuccess(context, user.message.toString());

        if (user.status == 1) {
          await HiveService.save(
            key: HiveKeys.fNameKey,
            value: user.record!.userFirstName.toString(),
          );

          await HiveService.save(
            key: HiveKeys.lNameKey,
            value: user.record!.userLastName.toString(),
          );

          await HiveService.save(
            key: HiveKeys.emailKey,
            value: user.record!.userEmailID.toString(),
          );

          await HiveService.save(
            key: HiveKeys.personalEmailKey,
            value: user.record!.userPersonalEmailID.toString(),
          );

          await HiveService.save(
            key: HiveKeys.mobileKey,
            value: user.record!.userMobileNumber.toString(),
          );

          await HiveService.save(
            key: HiveKeys.alternateMobileKey,
            value: user.record!.userAlternateNumber.toString(),
          );
          await HiveService.save(
            key: HiveKeys.role,
            value: user.record!.userRole.toString(),
          );
          await HiveService.save(
            key: HiveKeys.panels,
            value: user.record!.userAssignedPanels.toString(),
          );

          await HiveService.save(
            key: HiveKeys.userImage,
            value: user.record!.userImage.toString(),
          );

          await HiveService.save(
            key: HiveKeys.userIDKey,
            value: user.record!.userKey.toString(),
          );

          await HiveService.save(key: HiveService.kIsLoggedIn, value: true);
          GoRouter.of(context).goNamed(IndoGripDashboard.routeName);

          developer.log('User Logged In: ${user.message}');
        } else {
          ToastService.instance.showError(context, user.message.toString());
        }
      } else {
        ToastService.instance.showError(context, user.message.toString());
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Login Error');
    }
    return user;
  }

  static Future<ChangePasswordEntity> changePassword({
    required String currentPass,
    required String newPassword,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    ChangePasswordEntity changePassEntity = ChangePasswordEntity();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'change-password',
                'currentPass': currentPass,
                'newPassword': newPassword,
                'confirmPassword': confirmPassword,
                'userKey': HiveService.getUserId(),
              }),
            ).timeout(
              const Duration(seconds: 5),
              onTimeout: () => throw TimeoutException('Request timed out'),
            ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        changePassEntity = ChangePasswordEntity.fromJson(response.data);
        log('UserKey : ${HiveService.getUserId()}');
        developer.log(
          name: 'Change Password Param',
          '$currentPass $newPassword $confirmPassword',
        );
        developer.log(
          response.data.toString(),
          name: 'Change Password Response',
        );

        if (response.data['status'] == 1) {
          ToastService.instance.showSuccess(
            context,
            changePassEntity.message.toString(),
          );
        } else {
          ToastService.instance.showError(
            context,
            changePassEntity.message.toString(),
          );
        }
      } else {
        ToastService.instance.showError(
          context,
          changePassEntity.message.toString(),
        );
      }
    } on DioException catch (e) {
      developer.log('DioError: ${e.message}', name: 'Change Password Error');
      // ToastService.instance.showError(context, 'Network error occurred');
    } catch (e) {
      developer.log(e.toString(), name: 'Change Password Error');
      // ToastService.instance.showError(context, 'An error occurred');
    }
    return changePassEntity;
  }

  static Future<UpdateProfileEntity> updateUserProfile({
    required UProfileParams uParams,
  }) async {
    // final Dio dio = Dio();
    UpdateProfileEntity updateProfileEntity = UpdateProfileEntity();
    try {
      final formData = FormData.fromMap({
        'activity': 'edit-profile',
        'uFirstName': uParams.uFirstName,
        'uLastName': uParams.uLastName,
        'uEmail': uParams.uEmail,
        'uPersonalEmail': uParams.uPersonalEmail,
        'uMobile': uParams.uMobile,
        'uAlternateNumber': uParams.uAlternateNumber,
        'userKey': HiveService.getUserId(),
      });
      if (uParams.profileImage != null) {
        formData.files.add(
          MapEntry(
            'userProfile',
            await MultipartFile.fromFile(
              uParams.profileImage!.path,
              filename: uParams.profileImage!.path.split('/').last,
            ),
          ),
        );
      }
      final response = await retry(
        () => DioService.dioPostApiCall(data: formData).timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('Request timed out'),
        ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );
      if (response.statusCode == 200) {
        updateProfileEntity = UpdateProfileEntity.fromJson(response.data);
        developer.log(
          updateProfileEntity.message.toString(),
          name: 'uProfile Repository',
        );
        if (updateProfileEntity.status == 1) {
          ToastService.instance.showSuccess(
            uParams.context,
            updateProfileEntity.message.toString(),
          );
        } else {
          ToastService.instance.showError(
            uParams.context,
            updateProfileEntity.message.toString(),
          );
        }
      } else {
        developer.log(
          'Failed to update profile: ${response.statusCode}',
          name: 'uProfile Repository',
        );
        ToastService.instance.showError(
          uParams.context,
          'Failed to update profile',
        );
      }
    } on DioException catch (e) {
      developer.log('DioError: ${e.message}', name: 'Update Profile Error');
    } catch (e) {
      print(e);
    }
    return updateProfileEntity;
  }

  static Future<ForgotPasswordEntity> forgotUserPassword({
    required String email,
  }) async {
    ForgotPasswordEntity forgotPasswordEntity = ForgotPasswordEntity();
    try {
      final response = await http.post(
        url,
        body: {
          "activity": "forget-password",
          "uEmail": email,
          // 'userKey': HiveService.getUserId(),
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        forgotPasswordEntity = ForgotPasswordEntity.fromJson(jsonResponse);
        developer.log(
          response.body.toString(),
          name: 'Forgot Password Response',
        );
      } else {
        developer.log(
          'Failed to send forgot password request: ${response.statusCode}',
          name: 'Forgot Password Repository',
        );
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Forgot Password Error');
    }
    return forgotPasswordEntity;
  }

  static userLogout(BuildContext context) {
    HiveService.logout(context)
        .then((_) {
          GoRouter.of(context).goNamed(IndoGripLoginPanel.routeName);

          log('User logged out successfully');
        })
        .then(
          (_) => ToastService.instance.showWarning(
            context,
            'Logged out successfully',
          ),
        );
  }
}
