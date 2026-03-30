import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;
import 'package:indogrip/core/config/env_config.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';

import 'package:indogrip/features/global/data/model/change_status_model.dart';
import 'package:indogrip/features/global/data/model/change_status_param.dart';
import 'package:indogrip/features/global/data/model/delete_record_model.dart';
import 'package:indogrip/features/global/data/model/delete_record_param.dart';
import 'package:indogrip/features/global/data/model/master_status_model.dart';
import 'package:indogrip/features/global/data/model/setting_model.dart';
import 'package:indogrip/features/global/data/model/stock_status_model.dart';
import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/global/data/model/udpate_status_model.dart';
import 'package:indogrip/features/global/data/model/update_default_setting_model.dart';
import 'package:indogrip/features/global/data/model/ustatus_param.dart';
import 'package:indogrip/features/global/data/model/view_master_user_status_model.dart';
import 'package:indogrip/features/global/domain/repositories/global_repo.dart';
import 'package:indogrip/features/outsource/data/model/upload_file_param.dart';
import 'package:indogrip/features/round/data/models/upload_round_record_model.dart';
import 'package:retry/retry.dart';

final deleteRecordProvider =
    FutureProvider.family<DeleteRecordEntity, DeleteRecordParam>(
      (ref, param) => GlobalManagerRepository().deleteRecord(
        rKey: param.rKey,
        rPanel: param.rPanel,
      ),
    );

class GlobalManagerRepository implements GlobalRepository {
  // final Dio _dioClient = Dio();
  @override
  Future<ChangeStatusEntity> changeUserStatus({
    required ChangeStaffParam param,
  }) async {
    ChangeStatusEntity entity = ChangeStatusEntity();

    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'change-status',
                'userKey': HiveService.getUserId(),
                'rKey': param.rKey,
                'rPanel': param.rPanel,
                'rStatus': param.rStatus,
                'statusReason': param.statusReason,
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
        developer.log(
          response.data.toString(),
          name: 'Change Status Response Data',
        );
        entity = ChangeStatusEntity.fromJson(response.data);
        developer.log(entity.message.toString(), name: 'Change Status');
      } else {
        developer.log(
          'Failed to change status: ${response.statusCode}',
          name: 'Change Status Error',
        );
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error changing status: $e\nStackTrace: $stackTrace',
        name: 'Change Status Exception',
      );
    }
    return entity;
  }

  @override
  Future<DeleteRecordEntity> deleteRecord({
    required String rKey,
    required String rPanel,
  }) async {
    DeleteRecordEntity entity = DeleteRecordEntity();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'delete-record',
                'userKey': HiveService.getUserId(),
                'rKey': rKey,
                'rPanel': rPanel,
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
        entity = DeleteRecordEntity.fromJson(response.data);
        developer.log(entity.message.toString(), name: 'Delete Record');
        developer.log(response.data.toString(), name: 'Delete Record Response');
      } else {
        print('Failed to delete record: ${response.statusCode}');
      }
    } catch (e) {
      developer.log(
        'Error deleting record: $e',
        name: 'Delete Record Exception',
      );
    }
    return entity;
  }

  @override
  Future<DeleteRecordEntity> deleteMultipleRecords({
    required List<String> rKeys,
    required String rPanel,
  }) async {
    DeleteRecordEntity entity = DeleteRecordEntity();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: {
                'activity': 'multi-record',
                'userKey': HiveService.getUserId(),
                'rKeys': rKeys,
                'rPanel': rPanel,
              },
            ).timeout(
              const Duration(seconds: 5),
              onTimeout: () => throw TimeoutException('Request timed out'),
            ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        entity = DeleteRecordEntity.fromJson(response.data);
        developer.log(
          entity.message.toString(),
          name: 'Delete Multiple Records',
        );
      } else {
        developer.log(
          'Failed to delete multiple records: ${response.statusCode}',
          name: 'Delete Multiple Records Error',
        );
      }
    } catch (e) {
      developer.log(
        'Error deleting multiple records: $e',
        name: 'Delete Multiple Records Exception',
      );
    }
    return entity;
  }

  @override
  Future<UserStatusModel> masterUserStatus() async {
    UserStatusModel masterStatusModel = UserStatusModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'view-master-activestatus',
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
        masterStatusModel = UserStatusModel.fromJson(response.data);
        developer.log(
          response.data.toString(),
          name: 'Master User Status Response',
        );
      } else {
        developer.log(
          response.data.toString(),
          name: 'Master User Status Failed Response',
        );
        throw Exception('Failed to Fetch Master User Status');
      }
    } on DioException catch (e) {
      developer.log(e.toString(), name: 'DioException: ');
    } catch (e) {
      developer.log(e.toString(), name: 'Exception: ');
    }
    return masterStatusModel;
  }

  @override
  Future<SuccessResponse> uploadCsvFile({
    required UploadFileParam param,
  }) async {
    SuccessResponse successResponse = SuccessResponse();
    try {
      final formData = FormData.fromMap({
        'activity': 'upload-csv-file',
        'userKey': HiveService.getUserId(),
        'rType': param.rType,
        'billNumber': param.billNumber,
        'vendorKey': param.selectedVendor,
        'billDate': param.date,
        // 'csvFile': param.csvFile,
        // Add other necessary fields here
      });

      formData.files.add(
        MapEntry(
          'csvFile',
          await MultipartFile.fromFile(
            param.csvFile.path,
            filename: param.csvFile.path.split('/').last,
          ),
        ),
      );

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
        successResponse = SuccessResponse.fromJson(response.data);
        developer.log(
          response.data.toString(),
          name: 'Upload CSV File Response Parse',
        );
        developer.log(
          successResponse.message.toString(),
          name: 'Upload CSV File Response',
        );
      } else {
        developer.log(
          'Failed to upload CSV file: ${response.statusCode}',
          name: 'Upload CSV File Error',
        );
      }
    } catch (e) {
      developer.log(
        'Error uploading CSV file: $e',
        name: 'Upload CSV File Exception',
      );
    }
    return successResponse;
  }

  @override
  Future<SettingModel> fetchSettings() async {
    SettingModel settingModel = SettingModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'view-settings',
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
        settingModel = SettingModel.fromJson(response.data);
        developer.log(response.data.toString(), name: 'View Settings Response');
      } else {
        developer.log(
          response.data.toString(),
          name: 'View Settings Failed Response',
        );
        throw Exception('Failed to View Settings');
      }
    } on DioException catch (e) {
      developer.log(e.toString(), name: 'DioException: ');
    } catch (e) {
      developer.log(e.toString(), name: 'Exception: ');
    }
    return settingModel;
  }

  @override
  Future<UpdateStatusModel> updateUserStatus(
    BuildContext context, {
    required UStatus param,
  }) async {
    UpdateStatusModel uStatus = UpdateStatusModel();
    try {
      var data = FormData.fromMap({
        "activity": param.activity,
        "rKey": param.rKey,
        "rStatus": param.rStatus,
        'rPanel': param.rPanel,
        'statusReason': param.statusReason,
        'userKey': HiveService.getUserId(),
      });
      final response = await retry(
        () => DioService.dioPostApiCall(data: data).timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('Request timed out'),
        ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        uStatus = UpdateStatusModel.fromJson(response.data);

        developer.log(name: 'Update Status:', uStatus.message.toString());
        developer.log(name: 'Data:', data.fields.toString());
      } else {
        developer.log(name: 'Update Status Failed', 'Failed to Update Status');

        developer.log(name: 'Data:', data.fields.toString());
        developer.log(name: 'Data:', data.fields.toString());
      }
    } catch (e) {
      developer.log(name: 'Update Status Error', e.toString());
    }
    return uStatus;
  }

  @override
  Future<StockStatusModel> stockStatus() async {
    StockStatusModel model = StockStatusModel();
    try {
      final response = await retry(
        () => DioService.dioPostApiCall(
          data: FormData.fromMap({
            'activity': 'view-master-stock-status',
            'userKey': HiveService.getUserId(),
          }),
        ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        model = StockStatusModel.fromJson(response.data);
        developer.log(model.message.toString(), name: 'Master Stock Response');
      } else {
        developer.log(
          'Failed to Load Data from server',
          name: 'Master Stock Response Failed',
        );
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Master Stock Response');
    }
    return model;
  }

  @override
  Future<UpdateDefaultSetting> updateDefaultSetting({
    required String conversionRate,
    required String wastagePercentage,
    required String amountPerKG,
  }) async {
    UpdateDefaultSetting updateDefaultSetting = UpdateDefaultSetting();
    try {
      final response = await retry(
        () => DioService.dioPostApiCall(
          data: FormData.fromMap({
            'activity': 'update-settings',
            'amountPerKG': amountPerKG,
            'wastagePercentage': wastagePercentage,
            'conversionRate': conversionRate,
            'userKey': HiveService.getUserId(),
          }),
        ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        updateDefaultSetting = UpdateDefaultSetting.fromJson(response.data);
        developer.log(
          response.data.toString(),
          name: 'Update Default Setting Response',
        );
      } else {
        developer.log(
          'Failed to update default setting: ${response.statusCode}',
          name: 'Update Default Setting Failed',
        );
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Update Default Setting Error');
    }
    return updateDefaultSetting;
  }

  @override
  Future<UploadRoundRecordModel> uploadRoundRecordCsvFile({
    required UploadFileParam param,
  }) async {
    UploadRoundRecordModel successResponse = UploadRoundRecordModel();
    try {
      final formData = FormData.fromMap({
        'activity': 'upload-csv-file',
        'userKey': HiveService.getUserId(),
        'rType': param.rType,
        'billNumber': param.billNumber,
        'vendorKey': param.selectedVendor,
        'billDate': param.date,
        // 'csvFile': param.csvFile,
        // Add other necessary fields here
      });

      formData.files.add(
        MapEntry(
          'csvFile',
          await MultipartFile.fromFile(
            param.csvFile.path,
            filename: param.csvFile.path.split('/').last,
          ),
        ),
      );

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
        successResponse = UploadRoundRecordModel.fromJson(response.data);
        developer.log(
          response.data.toString(),
          name: 'Upload CSV File Response Parse',
        );
        developer.log(
          successResponse.message.toString(),
          name: 'Upload CSV File Response',
        );
      } else {
        developer.log(
          'Failed to upload CSV file: ${response.statusCode}',
          name: 'Upload CSV File Error',
        );
      }
    } catch (e) {
      developer.log(
        'Error uploading CSV file: $e',
        name: 'Upload CSV File Exception',
      );
    }
    return successResponse;
  }
}
