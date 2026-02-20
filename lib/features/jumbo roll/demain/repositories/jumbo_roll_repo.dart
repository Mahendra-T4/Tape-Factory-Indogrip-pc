import 'dart:async';
import 'dart:developer';
import 'dart:developer' as develper;
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/edit_jumbo_roll_success_model.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/jumbo_api_params.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/jumbo_role_entity.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/jumbo_uploadfile_response_model.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/view_jumbo_roll_model.dart';
import 'package:indogrip/features/outsource/data/model/upload_file_param.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:retry/retry.dart';

class JumboRollRepository {
  // static final Dio _dioClient = Dio();

  static Future<JumboRoleEntity> addJumboRoll({
    required JumboRollApiParams apiParams,
  }) async {
    JumboRoleEntity jumboRoleEntity = JumboRoleEntity();
    try {
      final formData = FormData.fromMap({
        'activity': 'add-jumbo-roll',
        'vendorKey': apiParams.vendorKey,
        'billDate': apiParams.billDate,
        'billNumber': apiParams.billNumber,
        'rollNumber': apiParams.rollNumber,
        'base': apiParams.base,
        'mic': apiParams.mic,
        'length': apiParams.length,
        'width': apiParams.width,
        'netWeight': apiParams.netWeight,
        'remark': apiParams.remark,
        'amountPerKG': apiParams.amountPerKG,
        'userKey': HiveService.getUserId(),
      });
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
        jumboRoleEntity = JumboRoleEntity.fromJson(response.data);
        develper.log(formData.fields.toString(), name: 'Add Jumbo FormData');
        if (jumboRoleEntity.status == 1) {
          ToastService.instance.showSuccess(
            apiParams.context,
            jumboRoleEntity.message.toString(),
          );
        } else {
          ToastService.instance.showError(
            apiParams.context,
            jumboRoleEntity.message.toString(),
          );
        }
      } else {
        log('Failed to add Jumbo Roll', name: 'Add Jumbo Roll');
        throw Exception('Failed to add Jumbo Roll');
      }
    } on DioException catch (e) {
      ToastService.instance.showError(apiParams.context, e.toString());
      print('DioException: $e');
    } catch (e) {
      print('Error adding Jumbo Roll: $e');
    }
    return jumboRoleEntity;
  }

  static Future<ViewJumboRollModel> fetchJumboRollRecords({
    required ViewRecordApiParam param,
  }) async {
    ViewJumboRollModel viewJumboRollModel = ViewJumboRollModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'view-jumbo-roll',
                'userKey': HiveService.getUserId(),
                'keyword': param.keyword,
                'filterBy': param.filterBy,
                'sortBy': param.sortBy,
                'orderBy': param.orderBy,
                'pageNo': param.pageNo,
                'vendorKey': param.vendorKey,
                'baseID': param.baseID,
                'micID': param.micID,
                'widthID': param.widthID,
                'fromDate': param.fromDate ?? '',
                'toDate': param.toDate ?? '',
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
        viewJumboRollModel = ViewJumboRollModel.fromJson(response.data);
        log(
          viewJumboRollModel.message.toString(),
          name: 'View Jumbo Roll Success Response',
        );
        log(response.data.toString(), name: 'View Jumbo Roll  Response');
      } else {
        log('Failed to fetch Jumbo Roll records', name: 'Fetch Jumbo Roll');
      }
    } catch (e) {
      log('Error fetching Jumbo Roll records: $e', name: 'Fetch Jumbo Roll');
    }
    return viewJumboRollModel;
  }

  static Future<EditJumboRollResponse> editJumboRoll({
    required JumboRollApiParams apiParams,
  }) async {
    EditJumboRollResponse successResponse = EditJumboRollResponse();
    try {
      final formData = FormData.fromMap({
        'activity': 'add-jumbo-roll',
        'vendorKey': apiParams.vendorKey,
        'billDate': apiParams.billDate,
        'billNumber': apiParams.billNumber,
        'rollNumber': apiParams.rollNumber,
        'base': apiParams.base,
        'mic': apiParams.mic,
        'length': apiParams.length,
        'width': apiParams.width,
        'netWeight': apiParams.netWeight,
        'remark': apiParams.remark,
        'amountPerKG': apiParams.amountPerKG,
        'userKey': HiveService.getUserId(),
        'rKey': apiParams.rKey,
        // 'userKey': HiveService.getUserId(),
      });
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
        successResponse = EditJumboRollResponse.fromJson(response.data);
        developer.log(
          formData.fields.toString(),
          name: 'Add/Edit Jumbo FormData',
        );
        if (successResponse.status == 1) {
          ToastService.instance.showSuccess(
            apiParams.context,
            successResponse.message.toString(),
          );
        } else {
          ToastService.instance.showError(
            apiParams.context,
            successResponse.message.toString(),
          );
        }
      } else {
        log('Failed to edit Jumbo Roll', name: 'edit Jumbo Roll');
        throw Exception('Failed to edit Jumbo Roll');
      }
    } on DioException catch (e) {
      ToastService.instance.showError(apiParams.context, e.toString());
      print('DioException: $e');
    } catch (e) {
      print('Error edit Jumbo Roll: $e');
    }
    return successResponse;
  }

  static Future<JumboUploadFileResponseModel> uploadJumboCsvFile({
    required UploadFileParam param,
  }) async {
    JumboUploadFileResponseModel successResponse =
        JumboUploadFileResponseModel();
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
        successResponse = JumboUploadFileResponseModel.fromJson(response.data);
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
