import 'dart:async';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/outsource/data/model/stretchfilm_sticker_model.dart';
import 'package:indogrip/features/outsource/data/model/tap_sticker_info_model.dart';
import 'package:indogrip/features/outsource/data/model/upload_file_param.dart';
import 'package:indogrip/features/outsource/data/model/view_stretchfilm_model.dart';
import 'package:indogrip/features/outsource/data/model/view_tap_in_model.dart';
import 'package:indogrip/features/outsource/domain/repositories/in_out_repo.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:retry/retry.dart';

class InventoryOutManagerRepository implements InventoryOutRepository {
  @override
  Future<ViewTapInventoryModel> loadTapInventoryData({
    required ViewRecordApiParam param,
  }) async {
    ViewTapInventoryModel model = ViewTapInventoryModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'view-inventory',
                'userKey': HiveService.getUserId(),
                'filterBy': param.filterBy,
                'productType': '1',
                'keyword': param.keyword,
                'sortBy': param.sortBy,
                'orderBy': param.orderBy,
                'pageNo': param.pageNo,
                'vendorKey': param.vendorKey,
                'baseID': param.baseID,
                'micID': param.micID,
                'cutMMMeterID': param.widthID,
                'fromDate': param.fromDate ?? '',
                'toDate': param.toDate ?? '',
                'tapeLength': param.tapeLength,
                'tapeWeight': param.tapeWeight,
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
        model = ViewTapInventoryModel.fromJson(response.data);
        developer.log(
          model.message.toString(),
          name: 'View Tap Inventory Success',
        );
      } else {
        model.message = 'Failed to load data from server';
        developer.log(
          'Failed to load data from server',
          name: 'View Tap Inventory Failed',
        );
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Tape Inventory Error');
      model.message = e.toString();
    }
    return model;
  }

  @override
  Future<TapeStickerInfoModel> loadTapeStickerDetails(
    String inventoryKey,
  ) async {
    TapeStickerInfoModel model = TapeStickerInfoModel();
    try {
      final formData = FormData.fromMap({
        'activity': 'inventory-details',
        'userKey': HiveService.getUserId(),
        'inventoryKey': inventoryKey,
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
      ;

      if (response.statusCode == 200) {
        model = TapeStickerInfoModel.fromJson(response.data);
        developer.log(formData.fields.toString(), name: 'View Tape param');
        developer.log(
          model.message.toString(),
          name: 'View Tape Sticker Details Success',
        );
      } else {
        model..message = 'Failed to load sticker details from server';
        developer.log(
          'Failed to load sticker details from server',
          name: 'View Tape Sticker Details Failed',
        );
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Sticker Details Error');
    }
    return model;
  }

  @override
  Future<ViewStretchFilmModel> loadStretchFilmInventoryData({
    required ViewRecordApiParam param,
  }) async {
    ViewStretchFilmModel model = ViewStretchFilmModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'view-inventory',
                'userKey': HiveService.getUserId(),
                'productType': '2',
                'keyword': param.keyword,
                'filterBy': param.filterBy,
                'sortBy': param.sortBy,
                'orderBy': param.orderBy,
                'pageNo': param.pageNo,
                'vendorKey': param.vendorKey,
                'filmSizeID': param.filmSizeID,
                'coreID': param.coreID,
                'fromDate': param.fromDate ?? '',
                'toDate': param.toDate ?? '',
                'baseID': param.baseID ?? '',
                'micID': param.micID ?? '',
              }),
            ).timeout(
              const Duration(seconds: 5),
              onTimeout: () => throw TimeoutException('Request timed out'),
            ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );
      ;

      if (response.statusCode == 200) {
        model = ViewStretchFilmModel.fromJson(response.data);
        developer.log(
          model.message.toString(),
          name: 'View StretchFilm Inventory Success',
        );
      } else {
        model..message = 'Failed to load data from server';
        developer.log(
          'Failed to load data from server',
          name: 'View StretchFilm Inventory Failed',
        );
      }
    } catch (e) {
      developer.log(e.toString(), name: 'StretchFilm Inventory Error');
    }
    return model;
  }

  @override
  Future<StretchFilmStickerModel> loadStretchFilmStickerDetails(
    String inventoryKey,
  ) async {
    StretchFilmStickerModel model = StretchFilmStickerModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'inventory-details',
                'userKey': HiveService.getUserId(),
                'inventoryKey': inventoryKey,
              }),
            ).timeout(
              const Duration(seconds: 5),
              onTimeout: () => throw TimeoutException('Request timed out'),
            ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );
      ;

      if (response.statusCode == 200) {
        model = StretchFilmStickerModel.fromJson(response.data);
        developer.log(
          model.message.toString(),
          name: 'View Tape Sticker Details Success',
        );
      } else {
        model..message = 'Failed to load sticker details from server';
        developer.log(
          'Failed to load sticker details from server',
          name: 'View Stretch Sticker Details Failed',
        );
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Sticker Details Error');
    }
    return model;
  }

  @override
  Future<StretchFilmStickerModel> loadStrectchFilmStickerDetails(
    String inventoryKey,
  ) async {
    StretchFilmStickerModel model = StretchFilmStickerModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'inventory-details',
                'userKey': HiveService.getUserId(),
                'inventoryKey': inventoryKey,
              }),
            ).timeout(
              const Duration(seconds: 5),
              onTimeout: () => throw TimeoutException('Request timed out'),
            ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );
      ;

      if (response.statusCode == 200) {
        model = StretchFilmStickerModel.fromJson(response.data);
        developer.log(
          model.message.toString(),
          name: 'StretchFilm Sticker Response',
        );
      } else {
        developer.log(
          'Failed to load data from server',
          name: 'StretchFilm Sticker Failed',
        );
      }
    } catch (e) {
      developer.log(e.toString(), name: 'StretchFilm Sticker Error');
    }
    return model;
  }

  @override
  Future<SuccessResponse> uploadCSVFileInventoryIN(
    UploadFileParam param,
  ) async {
    SuccessResponse successResponse = SuccessResponse();
    try {
      final formData = FormData.fromMap({
        'activity': 'import-inventory',
        'userKey': HiveService.getUserId(),
        'date': param.date,
        'billNumber': param.billNumber,
        'vendorKey': param.selectedVendor,
        'productType': param.productType,
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
      ;

      if (response.statusCode == 200) {
        successResponse = SuccessResponse.fromJson(response.data);
        developer.log(formData.fields.toString(), name: 'Upload CSV In param');
        developer.log(param.csvFile.toString(), name: 'Upload CSV File');
        developer.log(response.data.toString(), name: 'Upload CSV Response');
        developer.log(
          successResponse.message.toString(),
          name: 'Upload CSV In Response',
        );
      } else {
        developer.log(
          'Failed to load CSV File in',
          name: 'Upload CSV In Failed',
        );
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Upload CSV File IN Error');
    }
    return successResponse;
  }

  @override
  Future<SuccessResponse> uploadStretchCSVFileInventoryIN(
    UploadFileParam param,
  ) async {
    SuccessResponse successResponse = SuccessResponse();
    try {
      final formData = FormData.fromMap({
        'activity': 'import-inventory',
        'userKey': HiveService.getUserId(),
        'date': param.date,
        'billNumber': param.billNumber,
        'vendorKey': param.selectedVendor,
        'productType': param.productType,
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
      ;

      if (response.statusCode == 200) {
        successResponse = SuccessResponse.fromJson(response.data);
        developer.log(formData.fields.toString(), name: 'Upload CSV In param');
        developer.log(param.csvFile.toString(), name: 'Upload CSV File');
        developer.log(response.data.toString(), name: 'Upload CSV Response');
        developer.log(
          successResponse.message.toString(),
          name: 'Upload CSV In Response',
        );
      } else {
        developer.log(
          'Failed to load CSV File in',
          name: 'Upload CSV In Failed',
        );
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Upload CSV File IN Error');
    }
    return successResponse;
  }
}
