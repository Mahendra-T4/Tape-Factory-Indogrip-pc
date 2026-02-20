import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/features/dashboard/data/model/show_static_model.dart';
import 'package:indogrip/features/dashboard/domain/home_manager_repo.dart';
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
}
