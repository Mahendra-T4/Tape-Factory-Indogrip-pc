import 'dart:async';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/view_base_model.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/view_micron_modeld.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/view_width_model.dart';
import 'package:retry/retry.dart';

class MasterRepository {
  // static final Dio _dioClient = Dio();

  static Future<ViewBaseModel> viewMasterBase() async {
    ViewBaseModel viewBaseModel = ViewBaseModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'view-master-base',
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
        viewBaseModel = ViewBaseModel.fromJson(response.data);
        developer.log(
          response.data.toString(),
          name: 'View Master Base Response',
        );
      } else {
        developer.log(
          response.data.toString(),
          name: 'View Master Base Failed Response',
        );
        throw Exception('Failed to fetch master base');
      }
    } on DioException catch (e) {
      developer.log(e.toString(), name: 'DioException: ');
    } catch (e) {
      developer.log(e.toString(), name: 'Exception: ');
    }
    return viewBaseModel;
  }

  static Future<ViewMicronModel> viewMasterMicron() async {
    ViewMicronModel viewMicronModel = ViewMicronModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'view-master-mic',
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
        viewMicronModel = ViewMicronModel.fromJson(response.data);
        developer.log(
          response.data.toString(),
          name: 'View Master Micron Response',
        );
      } else {
        developer.log(
          response.data.toString(),
          name: 'View Master Micron Failed Response',
        );
        throw Exception('Failed to Fetch Master Micron');
      }
    } on DioException catch (e) {
      developer.log(e.toString(), name: 'DioException: ');
    } catch (e) {
      developer.log(e.toString(), name: 'Exception: ');
    }
    return viewMicronModel;
  }

  static Future<ViewWidthModel> viewMasterWidth() async {
    ViewWidthModel viewWidthModel = ViewWidthModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'view-master-width',
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
        viewWidthModel = ViewWidthModel.fromJson(response.data);
        developer.log(
          response.data.toString(),
          name: 'View Master width Response',
        );
      } else {
        developer.log(
          response.data.toString(),
          name: 'View Master width Failed Response',
        );
        throw Exception('Failed to fetch master width');
      }
    } on DioException catch (e) {
      developer.log(e.toString(), name: 'DioException: ');
    } catch (e) {
      developer.log(e.toString(), name: 'Width Exception: ');
    }
    return viewWidthModel;
  }
}
