import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/features/dashboard/data/model/predict_cal_param.dart';
import 'package:indogrip/features/dashboard/data/model/predict_calculation_model.dart';
import 'package:indogrip/features/dashboard/data/model/show_static_model.dart';
import 'package:indogrip/features/dashboard/data/model/stretch_stock_model.dart';
import 'package:indogrip/features/dashboard/data/model/tape_stock_model.dart';
import 'package:indogrip/features/dashboard/domain/home_manager_repo.dart';
import 'package:indogrip/features/dashboard/domain/tape_stock_entity.dart';
import 'package:retry/retry.dart';

class HomeRepository implements HomeManagerRepository {
  @override
  Future<ShowStaticModel> showDashboardStatic() async {
    ShowStaticModel model = ShowStaticModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'show-statics',
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
        model = ShowStaticModel.fromJson(response.data);
        developer.log(
          'Dashboard Static Data: ${response.data}',
          name: 'Dashboard Static',
        );
      } else {
        developer.log(
          'Failed to load dashboard static data',
          name: 'Dashboard Static Failed',
        );
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Dashboard Static Error');
    }
    return model;
  }

  @override
  Future<PredictCalculationModel> predictCalculation({
    required PredictCalParam param,
  }) async {
    PredictCalculationModel model = PredictCalculationModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'predict-calculation',
                'userKey': HiveService.getUserId(),
                "rollSize": param.rollSize,
                "tapeLength": param.tapeLength,
                "ratePerSquareMeter": param.ratePerSquareMeter,
                "wastagePercentage": param.wastagePercentage,
                "conversionRate": param.conversionRate,
                "margin": param.margin,
                // 'micID': param.micID,
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
        model = PredictCalculationModel.fromJson(response.data);
        developer.log(
          'Predict Calculation Data: ${response.data}',
          name: 'Predict Calculation',
        );
      } else {
        developer.log(
          'Failed to load predict calculation data',
          name: 'Predict Calculation Failed',
        );
        return model..message = 'Failed to load predict calculation data';
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Predict Calculation Error');
    }
    return model;
  }

  @override
  Future<PredictCalculationModel> predictCalculationByMic({
    required PredictCalParam param,
  }) async {
    PredictCalculationModel model = PredictCalculationModel();
    try {
      final formData = FormData.fromMap({
        'activity': 'predict-calculation-by-mic',
        'userKey': HiveService.getUserId(),
        "rollSize": param.rollSize,
        "tapeLength": param.tapeLength,
        "amountPerKG": param.amountPerKG,
        "wastagePercentage": param.wastagePercentage,
        "conversionRate": param.conversionRate,
        "margin": param.margin,
        'micID': param.micID,
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
        model = PredictCalculationModel.fromJson(response.data);
        developer.log(
          'Predict Calculation Data: ${response.data}',
          name: 'Predict Calculation',
        );
        developer.log(
          formData.fields.toString(),
          name: 'Predict Calculation FormData',
        );
      } else {
        developer.log(
          'Failed to load predict calculation data',
          name: 'Predict Calculation Failed',
        );
        return model..message = 'Failed to load predict calculation data';
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Predict Calculation Error');
    }
    return model;
  }

  @override
  Future<TapeStockModel> fetchTapeStock({
    required TapeStockEntity param,
  }) async {
    TapeStockModel model = TapeStockModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'tape-stock',
                'userKey': HiveService.getUserId(),
                "baseID": param.baseID,
                "micID": param.micID,
                "cutMMMeterID": param.cutMMMeterID,
                "tapeLength": param.tapeLength,
                "tapeWeight": param.weight,
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
        model = TapeStockModel.fromJson(response.data);
        developer.log('Tape Stock Data: ${response.data}', name: 'Tape Stock');
      } else {
        developer.log(
          'Failed to load tape stock data',
          name: 'Tape Stock Failed',
        );
        return model..message = 'Failed to load tape stock data';
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Tape Stock Error');
    } finally {
      developer.log(
        'Fetch Tape Stock completed for param: ${param.toString()}',
        name: 'Fetch Tape Stock Completed',
      );
      return model;
    }
  }

  @override
  Future<StretchStockModel> fetchStretchStock({
    required String baseID,
    required String filmSizeID,
    required String coreID,
    required String micID,
  }) async {
    StretchStockModel model = StretchStockModel();
    try {
      final formData = FormData.fromMap({
        'activity': 'stretchfilm-stock',
        'userKey': HiveService.getUserId(),
        'baseID': baseID,
        'filmSizeID': filmSizeID,
        'coreID': coreID,
        'micID': micID,
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
        model = StretchStockModel.fromJson(response.data);
        developer.log(
          'Stretch Stock Data: ${response.data}',
          name: 'Stretch Stock',
        );

        developer.log(
          formData.fields.toString(),
          name: 'Stretch Stock FormData',
        );
      } else {
        developer.log(
          'Failed to load stretch stock data',
          name: 'Stretch Stock Failed',
        );
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Stretch Stock Error');
    }
    return model;
  }
}
