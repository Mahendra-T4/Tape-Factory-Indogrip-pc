import 'dart:async';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/outsource/data/model/inventory_in_param.dart';
import 'package:indogrip/features/outsource/domain/repositories/inventory_in_repo.dart';
import 'package:indogrip/features/outsource/presentation/outside-in/models/add_batch_param.dart';
import 'package:retry/retry.dart';

class InventoryInManagerRepository implements InventoryInRepository {
  @override
  Future<SuccessResponse> addInventoryInRecord({
    required InventoryInParam param,
  }) async {
    SuccessResponse successResponse = SuccessResponse();

    try {
      final formData = FormData.fromMap({
        'activity': 'add-inventory',
        'userKey': HiveService.getUserId(),
        'vendorKey': param.vendorKey,
        'date': param.date,
        'billNumber': param.billNumber,
        'cartonPrice': param.cartonPrice,
        'transportAmount': param.transportAmount,
        'productType': param.productType,
        'quantity': param.quantity,
        'cutMMMeter': param.cutMMMeter,
        'base': param.base,
        'tapeLength': param.tapeLength,
        'stretchFilmSize': param.stretchFilmSize,
        'core': param.core,
        'tapeWeight': param.tapeWeight,
        'mic': param.micron,
        'netWeight': param.netWeight,
        'grossWeight': param.grossWeight,
        'inventoryCode': param.inventoryCode,
        'margin': param.margin,
        'lessWeight': param.lessKGPrice,
        'rate': param.rate,
        'remarks': param.remarks,
        if (param.rKey != null) 'rKey': param.rKey,
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
        successResponse = SuccessResponse.fromJson(response.data);
        developer.log(
          'Inventory In Record Added: ${successResponse.message}',
          name: 'Inventory In',
        );
        developer.log(
          formData.fields.toString(),
          name: 'Inventory In Parameters',
        );
        // return successResponse;
      } else {
        developer.log(
          'Failed to add Inventory In Record: ${response.statusCode}',
          name: 'Inventory In',
        );
        successResponse..message = 'Failed to add record';
      }
    } catch (e) {
      developer.log(
        'Error adding Inventory In Record: $e',
        name: 'Inventory In',
      );
      // successResponse..message = 'Error: $e';
    }
    return successResponse;
  }

  @override
  Future<SuccessResponse> insertBatchRecord({
    required InsertBatch param,
  }) async {
    SuccessResponse model = SuccessResponse();
    try {
      final formData = FormData.fromMap({
        'activity': 'batch-information-for-inventory',
        'userKey': HiveService.getUserId(),
        'inventoryKey': param.inventoryKey,
        'showFor': param.showFor,
        'displayMic': param.displayMic,
        'displayValue': param.displayValue,
        'remark': param.remark,
        'displayMFG': param.displayMFG,
        'batchMRP': param.batchMRP,
        'rKey': param.rKey,
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
        model = SuccessResponse.fromJson(response.data);
        developer.log(model.message.toString(), name: 'Insert Batch Success');
        developer.log(formData.fields.toString(), name: 'Insert Batch Param');
      } else {
        model..message = 'Failed to load batch response';
        developer.log(
          'Failed to load batch response',
          name: 'Insert Batch Failed',
        );
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Insert Batch Error');
    }
    return model;
  }
}
