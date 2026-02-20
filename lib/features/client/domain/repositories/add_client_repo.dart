import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/features/carton/data/models/view_client_succ_model.dart';
import 'package:indogrip/features/client/data/model/add_client_param.dart';
import 'package:indogrip/features/client/data/model/edit_client_api_param.dart';
import 'package:indogrip/features/client/data/model/view_staff_modeld.dart';
import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:retry/retry.dart';

final viewClientsListProvider = FutureProvider(
  (ref) => AddClientRepository.viewStaffRecords(param: ViewRecordApiParam()),
);

class AddClientRepository {
  // static Dio _dioClient = Dio();

  static Future<SuccessResponse> addClientOnRecord({
    required ClientApiParams param,
  }) async {
    SuccessResponse successResponse = SuccessResponse();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'add-client',
                'cConsigneeName': param.cConsigneeName,
                'cMobileNumber': param.cMobileNumber,
                'cAlternateNumber': param.cAlternateNumber,
                'cGSTIN': param.cGSTIN,
                'cOwnerName': param.cOwnerName,
                'cOwnerMobileNumber': param.cOwnerMobileNumber,
                'cPurchaseManagerName': param.cPurchaseManagerName,
                'cPurchaseManagerNumber': param.cPurchaseManagerNumber,
                'cUnitOne': param.cUnitOne,
                'cUnitTwo': param.cUnitTwo,
                'cUnitThree': param.cUnitThree,
                'cUnitFour': param.cUnitFour,
                'cUnitFive': param.cUnitFive,
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
        successResponse = SuccessResponse.fromJson(response.data);
      }
    } catch (e) {
      developer.log('Error adding client: $e', name: 'Add Client');
      // ToastService.instance.showError(context, e.toString());
    }
    return successResponse;
  }

  static Future<ViewClientModel> viewStaffRecords({
    required ViewRecordApiParam param,
  }) async {
    ViewClientModel viewClientModel = ViewClientModel();
    try {
      developer.log(
        'Requesting view-client with pageNo: ${param.pageNo}',
        name: 'View Client Request',
      );

      final formData = FormData.fromMap({
        'activity': 'view-client',
        'userKey': HiveService.getUserId(),
        'keyword': param.keyword ?? '',
        'filterBy': param.filterBy ?? '',
        'sortBy': param.sortBy ?? '',
        'orderBy': param.orderBy ?? '',
        'pageNO': param.pageNo,
        'fromDate': param.fromDate ?? '',
        'toDate': param.toDate ?? '',
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
        viewClientModel = ViewClientModel.fromJson(response.data);
        developer.log(formData.fields.toString(), name: 'View Client FormData');
        developer.log(
          viewClientModel.message.toString(),
          name: 'View Client Success Response',
        );

        developer.log(response.data.toString(), name: 'View Client Response');
      } else if (response.statusCode == 500) {
        developer.log(
          'Server Error 500: ${response.data}',
          name: 'View Client Server Error',
        );
        developer.log(
          'Request data: userKey=${HiveService.getUserId()}, pageNo=${param.pageNo}',
          name: 'View Client Debug',
        );
      } else {
        developer.log(
          'Error: Status code ${response.statusCode} - ${response.data}',
          name: 'View Client Error',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        developer.log(
          'Connection timeout: The server is taking too long to respond',
          name: 'View Client Timeout',
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        developer.log(
          'Receive timeout: The server response took too long',
          name: 'View Client Timeout',
        );
      } else if (e.response?.statusCode == 500) {
        developer.log(
          'Server Error 500: ${e.response?.data}',
          name: 'View Client Server Error',
        );
      } else {
        developer.log(
          'Error viewing client records: $e',
          name: 'View Client Error',
        );
      }
    } catch (e) {
      developer.log('Error viewing client records: $e', name: 'View Client');
    }
    return viewClientModel;
  }

  static Future<EditClientResponse> updateClientRecord({
    required EditClientApiParam param,
  }) async {
    EditClientResponse successResponse = EditClientResponse();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': param.activity,
                'cConsigneeName': param.cConsigneeName,
                'cAlternateNumber': param.cAlternateNumber,
                'cGSTIN': param.cGSTIN,
                'cOwnerName': param.cOwnerName,
                'cMobileNumber': param.cMobileNumber,
                'cOwnerMobileNumber': param.cOwnerMobileNumber,
                'cPurchaseManagerName': param.cPurchaseManagerName,
                'cPurchaseManagerNumber': param.cPurchaseManagerNumber,
                'rKey': param.rKey,
                'userKey': HiveService.getUserId(),
                'uPassword': param.uPassword,
                'cUnitOne': param.cUnitOne,
                'cUnitTwo': param.cUnitTwo,
                'cUnitThree': param.cUnitThree,
                'cUnitFour': param.cUnitFour,
                'cUnitFive': param.cUnitFive,
                'uConfirmPassword': param.uConfirmPassword,
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
        successResponse = EditClientResponse.fromJson(response.data);
        developer.log(response.data.toString(), name: 'Edit Client Response');
        developer.log(
          '${param.uPassword} - ${param.uConfirmPassword}',
          name: 'Edit Client',
        );
      } else {
        SuccessResponse()
          ..message = 'Failed to delete client: ${response.statusCode}';

        developer.log(
          'Failed to delete client: ${response.statusCode}',
          name: 'Edit Client',
        );
      }
    } catch (e) {
      developer.log('Error deleting client: $e', name: 'Delete Client');
    }
    return successResponse;
  }

  static Future<SuccessResponse> uploadClientCSVFile({
    required String activity,
    required File csvFile,
  }) async {
    SuccessResponse successResponse = SuccessResponse();
    try {
      final formData = FormData.fromMap({
        'activity': activity,
        'userKey': HiveService.getUserId(),
        // 'csvFile': csvFile,
        // Add other necessary fields here
      });
      formData.files.add(
        MapEntry(
          'csvFile',
          await MultipartFile.fromFile(
            csvFile.path,
            filename: csvFile.path.split('/').last,
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
          name: 'Upload Client File Data',
        );
        developer.log(
          successResponse.message.toString(),
          name: 'Upload Client CSV Success',
        );

        // developer.log(csvFile.path, name: 'Upload Client CSV File');
      } else {
        developer.log(
          'Failed to upload CSV file: ${response.statusCode}',
          name: 'Upload Client CSV',
        );
      }
    } catch (e) {
      print(e);
    }
    return successResponse;
  }
}
