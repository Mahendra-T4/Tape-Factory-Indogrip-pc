import 'dart:async';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:indogrip/core/config/env_config.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/carton/data/models/add_carton_api_param.dart';
import 'package:indogrip/features/core/data/models/add_core_entity.dart';
import 'package:indogrip/features/core/data/models/core_api_param_entity.dart';
import 'package:indogrip/features/core/data/models/edit_core_response_model.dart';
import 'package:indogrip/features/core/data/models/master_core_model.dart';
import 'package:indogrip/features/core/data/models/view_core_model.dart';
import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:retry/retry.dart';

abstract class CoreRepository {
  // static Dio _dioClient = Dio();

  static Future<AddCoreEntity> addCore({
    required CoreApiParams apiParams,
  }) async {
    AddCoreEntity coreEntity = AddCoreEntity();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'add-core',
                'vendorKey': apiParams.vendor,
                'coreType': apiParams.coreType,
                'coreDate': apiParams.coreDate,
                'coreQuantity': apiParams.coreQuantity,
                'billNumber': apiParams.coreBillNumber,
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
        coreEntity = AddCoreEntity.fromJson(response.data);
        if (coreEntity.status == 1) {
          ToastService.instance.showSuccess(
            apiParams.context,
            coreEntity.message.toString(),
          );
          developer.log(
            'Carton added successfully: ${coreEntity.message}',
            name: 'Add Carton',
          );
        } else {
          ToastService.instance.showError(
            apiParams.context,
            coreEntity.message.toString(),
          );
          developer.log(
            'Failed to add carton: ${coreEntity.message}',
            name: 'Add Carton',
          );
        }
      } else {
        developer.log('Failed to add carton', name: 'Add Carton');
      }
    } on DioException catch (e) {
      developer.log('DioException: $e', name: 'Add Carton');
      ToastService.instance.showError(apiParams.context, e.toString());
    } catch (e) {
      print(e);
    }
    return coreEntity;
  }

  static Future<ViewCoreModel> fetchViewCoreData({
    required ViewRecordApiParam param,
  }) async {
    ViewCoreModel viewCoreModel = ViewCoreModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'view-core',
                'userKey': HiveService.getUserId(),
                'keyword': param.keyword ?? '',
                'filterBy': param.filterBy ?? '',
                'sortBy': param.sortBy ?? '',
                'orderBy': param.orderBy ?? '',
                'pageNO': param.pageNo ?? 1,
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
        viewCoreModel = ViewCoreModel.fromJson(response.data);
        developer.log(
          viewCoreModel.message.toString(),
          name: 'View Core Success Response',
        );
      } else {
        developer.log('Failed to fetch core data', name: 'View Core');
      }
    } catch (e) {
      developer.log('Error fetching core data: $e', name: 'View Core');
    }
    return viewCoreModel;
  }

  static Future<EditCoreResponse> editCore({
    required CoreApiParams apiParams,
  }) async {
    EditCoreResponse successResponse = EditCoreResponse();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'add-core',
                'vendorKey': apiParams.vendor,
                'coreType': apiParams.coreType,
                'coreDate': apiParams.coreDate,
                'coreQuantity': apiParams.coreQuantity,
                'billNumber': apiParams.coreBillNumber,
                'rKey': apiParams.rKey,
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
        successResponse = EditCoreResponse.fromJson(response.data);
        developer.log(
          '${apiParams.coreType},${apiParams.coreQuantity},${apiParams.coreBillNumber},${apiParams.coreDate}',
          name: 'Param',
        );
        developer.log(
          successResponse.message.toString(),
          name: 'Edit Core Success Response',
        );
      } else {
        developer.log('Failed to edit Core', name: 'Edit Core');
        return EditCoreResponse()..message = 'Failed to edit Core';
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Edit Core');
    }
    return successResponse;
  }

  static Future<MasterCoreModel> masterCoreType() async {
    MasterCoreModel masterCoreModel = MasterCoreModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'view-master-core',
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
        masterCoreModel = MasterCoreModel.fromJson(response.data);
        developer.log(
          masterCoreModel.message.toString(),
          name: 'Master Core Type',
        );
      } else {
        developer.log(
          'Failed to fetch master Core type',
          name: 'Master Core Type',
        );
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Master Core Type');
    }
    return masterCoreModel;
  }
}
