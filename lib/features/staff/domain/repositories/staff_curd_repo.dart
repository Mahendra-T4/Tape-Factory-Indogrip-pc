import 'dart:async';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/features/client/data/model/view_staff_api_param.dart';
import 'package:indogrip/features/staff/data/models/access_panel_model.dart';
import 'package:indogrip/features/staff/data/models/edit_staff_success_model.dart';
import 'package:indogrip/features/staff/data/models/master_roll_model.dart';
import 'package:indogrip/features/staff/domain/repositories/staff_mathod_provider_repo.dart';
import 'package:retry/retry.dart';

class StaffCURDRepository implements StaffMethodProviderRepo {
  // final Dio _dio = Dio();
  @override
  Future<EditStaffResponse> updateStaffDetails({
    required EditStaffApiParam param,
  }) async {
    EditStaffResponse successResponse = EditStaffResponse();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'add-staff',
                'uFirstName': param.uFirstName,
                'uLastName': param.uLastName,
                'uEmail': param.uEmail,
                'uPersonalEmail': param.uPersonalEmail,
                'uMobileNumber': param.uMobileNumber,
                'uAlternateNumber': param.uAlternateNumber,
                'uRole': param.uRole,
                'uAccessPanel': param.uAccessPanel, //3,5,6
                'userKey': HiveService.getUserId(),
                'uPassword': param.uPassword,
                'uConfirmPassword': param.uConfirmPassword,
                'rKey': param.rKey,
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
        successResponse = EditStaffResponse.fromJson(response.data);
        developer.log(param.uAccessPanel.toString(), name: 'Edit Staff Params');
        developer.log(
          'Update Staff Details Response: ${response.data}',
          name: 'Edit Staff Response',
        );
      } else {
        developer.log(
          'Failed to update staff details: ${response.statusCode} - ${response.statusMessage}',
          name: 'Edit Staff Error',
        );
        return EditStaffResponse()..message = 'Failed to update staff details';
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Edit Staff Error');
      print(e);
    }
    return successResponse;
  }

  @override
  Future<MasterRoll> fetchUserRolls() async {
    MasterRoll masterRoll = MasterRoll();
    try {
      final response = await retry(
        () => DioService.dioPostApiCall(
          data: FormData.fromMap({
            'activity': 'view-master-role',
            'userKey': HiveService.getUserId(),
          }),
        ).timeout(const Duration(seconds: 5)),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );
      if (response.statusCode == 200) {
        masterRoll = MasterRoll.fromJson(response.data);
        developer.log(
          name: 'Master Roll Response',
          masterRoll.message.toString(),
        );
      } else {
        developer.log(
          name: 'Master Roll Error',
          'Failed to fetch master roll, status code: ${response.statusCode}',
        );
        throw Exception(
          'Failed to fetch master roll, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      developer.log(name: 'Master Roll Exception', e.toString());
      print(e);
    }
    return masterRoll;
  }

  @override
  Future<AccessPanel> fetchAccessPanels() async {
    AccessPanel accessPanel = AccessPanel();
    // Dio dioClient = Dio();
    try {
      final response = await retry(
        () => DioService.dioPostApiCall(
          data: FormData.fromMap({
            'activity': 'view-master-panel',
            'userKey': HiveService.getUserId(),
          }),
        ).timeout(const Duration(seconds: 5)),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        accessPanel = AccessPanel.fromJson(response.data);
        developer.log(
          name: 'Access Panel Response',
          accessPanel.message.toString(),
        );
      } else {
        developer.log(
          name: 'Access Panel Error',
          'Failed to fetch access panel, status code: ${response.statusCode}',
        );
        throw Exception(
          'Failed to fetch access panel, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print(e);
    }
    return accessPanel;
  }
}
