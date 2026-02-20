import 'dart:async';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/features/outsource/data/model/master_product_type_model.dart';
import 'package:indogrip/features/outsource/data/model/stretch_film_model.dart';
import 'package:indogrip/features/outsource/domain/repositories/master_in_repo.dart';
import 'package:retry/retry.dart';

class MasterInManagerRepository implements MasterInRepository {
  @override
  Future<MasterStretchFilmModel> loadMasterStretchFilmData() async {
    MasterStretchFilmModel masterData = MasterStretchFilmModel();

    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'view-master-stretch-film',
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
        masterData = MasterStretchFilmModel.fromJson(response.data);
        developer.log(masterData.message.toString(), name: 'MasterIn Success');
      } else {
        masterData..message = 'Failed to load data';
        developer.log(
          'Failed to load master stretch film data. Status code: ${response.statusCode}',
          name: 'MasterIn Failed',
        );
      }
    } catch (e) {
      developer.log(
        'Error loading master stretch film data: $e',
        name: 'MasterIn Error',
      );
      // masterData..message = 'Error loading data';
    }
    return masterData;
  }

  @override
  Future<MasterProductTypeModel> loadMasterProductTypeData() async {
    MasterProductTypeModel model = MasterProductTypeModel();

    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'view-master-product-type',
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
        model = MasterProductTypeModel.fromJson(response.data);
        developer.log(
          model.message.toString(),
          name: 'MasterIn Product Tpe Success',
        );
        developer.log(response.data, name: 'Response');
      } else {
        developer.log(response.data, name: 'Response');
        model..message = 'Failed to load data';
        developer.log(
          'Failed to load master product type data. Status code: ${response.statusCode}',
          name: 'MasterIn Product Tpe Failed',
        );
      }
    } catch (e) {
      developer.log(
        'Error loading master product type data: $e',
        name: 'MasterIn Product Tpe Error',
      );
      // masterData..message = 'Error loading data';
    }
    return model;
  }
}
