import 'dart:developer' as developer;
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:indogrip/core/config/env_config.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:indogrip/features/wastage/data/model/add_wastage_param.dart';
import 'package:indogrip/features/wastage/data/model/edit_wastage_api_param.dart';
import 'package:indogrip/features/wastage/data/model/edit_wastage_success_model.dart';
import 'package:indogrip/features/wastage/data/model/view_wastage_model.dart';
import 'package:indogrip/features/wastage/domain/repositories/wastage_mathod_repo.dart';
import 'package:retry/retry.dart';

class AddWastageRepository implements WastageMathodProviderRepository {
  // final Dio _dio = Dio();
  @override
  Future<SuccessResponse> addWastage(AddWastageParam addWastageParam) async {
    SuccessResponse successResponse = SuccessResponse();

    try {
      var data = FormData.fromMap({
        'activity': addWastageParam.activity,
        'wastageDate': addWastageParam.wastageDate,
        'wastageClient': addWastageParam.wastageClient,
        'billNumber': addWastageParam.billNumber,
        'weight': addWastageParam.width,
        'price': addWastageParam.price_kg,
        'remark': addWastageParam.remark,
        'userKey': HiveService.getUserId(),
      });
      final response = await retry(
        () => DioService.dioPostApiCall(
          data: data,
        ).timeout(const Duration(seconds: 5)),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        successResponse = SuccessResponse.fromJson(response.data);
        developer.log(name: 'Param', '${data.fields}');
        developer.log(name: 'Add Wastage Response', '${response.data}');
      } else {
        developer.log(name: 'Add Wastage Error', 'Failed to add wastage');

        throw Exception('Failed to add wastage');
      }
    } catch (e) {
      developer.log(name: 'Add Wastage Exception', '$e');
    }
    return successResponse;
  }

  @override
  Future<ViewWastageModel> viewWastage({
    required ViewRecordApiParam param,
  }) async {
    ViewWastageModel viewWastageModel = ViewWastageModel();

    try {
      final response = await retry(
        () => DioService.dioPostApiCall(
          data: FormData.fromMap({
            'activity': 'view-wastage',
            'userKey': HiveService.getUserId(),
            'keyword': param.keyword ?? '',
            'filterBy': param.filterBy ?? '',
            'sortBy': param.sortBy ?? '',
            'orderBy': param.orderBy ?? '',
            'pageNO': param.pageNo ?? 1,
            'fromDate': param.fromDate ?? '',
            'toDate': param.toDate ?? '',
          }),
        ).timeout(const Duration(seconds: 5)),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        viewWastageModel = ViewWastageModel.fromJson(response.data);
        developer.log(name: 'View Wastage Response', '${response.data}');
      } else {
        developer.log(name: 'View Wastage Error', 'Failed to view wastage');
        ViewWastageModel()..message = 'Failed to view wastage';
        throw Exception('Failed to view wastage');
      }
    } catch (e) {
      developer.log(name: 'View Wastage Exception', '$e');
      // ViewWastageModel()..message = e.toString();
    }
    return viewWastageModel;
  }

  @override
  Future<EditWastageResponse> editWastage({
    required EditWastageApiParam apiParam,
  }) async {
    EditWastageResponse successResponse = EditWastageResponse();
    try {
      final response = await retry(
        () => DioService.dioPostApiCall(
          data: FormData.fromMap({
            'activity': apiParam.activity,
            'wastageDate': apiParam.wastageDate,
            'wastageClient': apiParam.wastageClient,
            'billNumber': apiParam.billNumber,
            'width': apiParam.width,
            'price': apiParam.price_kg,
            'remark': apiParam.remark,
            'userKey': HiveService.getUserId(),
            'rKey:': apiParam.rKey,
          }),
        ).timeout(const Duration(seconds: 5)),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );
      if (response.statusCode == 200) {
        successResponse = EditWastageResponse.fromJson(response.data);
        developer.log(name: 'Param', '${apiParam.wastageClient}');
        developer.log(name: 'Edit Wastage Response', '${response.data}');
      } else {
        developer.log(name: 'Edit Wastage Error', 'Failed to edit wastage');
        throw Exception('Failed to edit wastage');
      }
    } catch (e) {
      print(e);
    }
    return successResponse;
  }
}
