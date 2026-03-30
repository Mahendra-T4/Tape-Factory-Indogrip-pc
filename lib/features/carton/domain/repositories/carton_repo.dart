import 'dart:async';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/carton/data/models/add_carton_api_param.dart';
import 'package:indogrip/features/carton/data/models/add_carton_entity.dart';
import 'package:indogrip/features/carton/data/models/master_carton_type_model.dart';
import 'package:indogrip/features/carton/data/models/view_carton_model.dart';
import 'package:indogrip/features/carton/data/models/view_client_succ_model.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:retry/retry.dart';

abstract class CartonRepository {
  // static Dio _dioClient = Dio();

  static Future<AddCartonEntity> addCarton({
    required CartonApiParams apiParams,
  }) async {
    AddCartonEntity cartonEntity = AddCartonEntity();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'add-carton',
                'cartonType': apiParams.cartonType,
                'cartonDate': apiParams.cartonDate,
                'cartonQuantity': apiParams.cartonQuantity,
                'billNumber': apiParams.billNumber,
                'vendorKey': apiParams.vendorKey,
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
        cartonEntity = AddCartonEntity.fromJson(response.data);
        if (cartonEntity.status == 1) {
          ToastService.instance.showSuccess(
            apiParams.context,
            cartonEntity.message.toString(),
          );
          developer.log(
            'Carton added successfully: ${cartonEntity.message}',
            name: 'Add Carton',
          );
        } else {
          ToastService.instance.showError(
            apiParams.context,
            cartonEntity.message.toString(),
          );
          developer.log(
            'Failed to add carton: ${cartonEntity.message}',
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
    return cartonEntity;
  }

  static Future<ViewCartonModel> fetchViewCartonData({
    required ViewRecordApiParam param,
  }) async {
    ViewCartonModel viewCartonModel = ViewCartonModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'view-carton',
                'userKey': HiveService.getUserId(),
                'keyword': param.keyword ?? '',
                'filterBy': param.filterBy ?? '',
                'sortBy': param.sortBy ?? '',
                'orderBy': param.orderBy ?? '',
                'pageNo': param.pageNo ?? 1,
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
        viewCartonModel = ViewCartonModel.fromJson(response.data);
        developer.log(
          viewCartonModel.message.toString(),
          name: 'Fetch View Carton',
        );
      } else {
        developer.log(
          'Failed to fetch View Carton Data',
          name: 'Fetch View Carton',
        );
      }
    } on DioException catch (e) {
      developer.log('DioException: $e', name: 'View Carton');
      // ToastService.instance.showError(apiParams.context, e.toString());
    } catch (e) {
      print(e);
    }
    return viewCartonModel;
  }

  static Future<EditClientResponse> editCarton({
    required CartonApiParams apiParams,
  }) async {
    EditClientResponse successResponse = EditClientResponse();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'add-carton',
                'cartonType': apiParams.cartonType,
                'cartonDate': apiParams.cartonDate,
                'cartonQuantity': apiParams.cartonQuantity,
                'billNumber': apiParams.billNumber,
                'vendorKey': apiParams.vendorKey,
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
        successResponse = EditClientResponse.fromJson(response.data);
        developer.log(
          '${apiParams.cartonType},${apiParams.cartonQuantity},${apiParams.billNumber},${apiParams.cartonDate}',
          name: 'Param',
        );
        developer.log(
          successResponse.message.toString(),
          name: 'Edit Carton Success Response',
        );
      } else {
        developer.log('Failed to edit carton', name: 'Edit Carton');
        return EditClientResponse()..message = 'Failed to edit carton';
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Edit Carton');
    }
    return successResponse;
  }

  static Future<CartonTypeModel> masterCartonType() async {
    CartonTypeModel cartonTypeModel = CartonTypeModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'view-master-carton',
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
        cartonTypeModel = CartonTypeModel.fromJson(response.data);
        developer.log(
          cartonTypeModel.message.toString(),
          name: 'Master Carton Type',
        );
      } else {
        developer.log(
          'Failed to fetch master carton type',
          name: 'Master Carton Type',
        );
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Master Carton Type');
    }
    return cartonTypeModel;
  }
}
