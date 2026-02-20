import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/features/chalan/data/model/chalanlist_model.dart';
import 'package:indogrip/features/chalan/data/model/challan_details_model.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';

abstract class ChallanRepository {
  static Future<ChalanListModel> fetchChalanRecords({
    required ViewRecordApiParam param,
  }) async {
    ChalanListModel model = ChalanListModel();

    try {
      final response = await DioService.dioPostApiCall(
        data: FormData.fromMap({
          'activity': 'challan-list',
          'userKey': HiveService.getUserId(),
          'keyword': param.keyword ?? '',
          'filterBy': param.filterBy ?? '',
          'sortBy': param.sortBy ?? '',
          'orderBy': param.orderBy ?? '',
          'pageNO': param.pageNo ?? 1,
          'fromDate': param.fromDate ?? '',
          'toDate': param.toDate ?? '',
          'staffKey': param.staffKey ?? '',
          'clientKey': param.clientKey ?? '',
        }),
      );
      if (response.statusCode == 200) {
        model = ChalanListModel.fromJson(response.data);
        developer.log(
          model.message.toString(),
          name: 'Fetch Chalan Records Response',
        );
      } else {
        model..message = 'Failed to fetch chalan records';
        developer.log(
          'Failed to fetch chalan records',
          name: 'Fetch Chalan Records',
        );
      }
    } catch (e) {
      developer.log('Exception: $e', name: 'Fetch Chalan Records');
    } finally {
      return model;
    }
  }

  static Future<ChallanDetailsModel> fetchChallanDetails({
    required String orderKey,
  }) async {
    ChallanDetailsModel model = ChallanDetailsModel();

    try {
      final response = await DioService.dioPostApiCall(
        data: FormData.fromMap({
          'activity': 'challan-details',
          'userKey': HiveService.getUserId(),
          'orderKey': orderKey,
        }),
      );
      if (response.statusCode == 200) {
        model = ChallanDetailsModel.fromJson(response.data);
        developer.log(
          model.message.toString(),
          name: 'Fetch Chalan Details Response',
        );
      } else {
        model..message = 'Failed to fetch chalan details';
        developer.log(
          'Failed to fetch chalan details',
          name: 'Fetch Chalan Details',
        );
      }
    } catch (e) {
      developer.log('Exception: $e', name: 'Fetch Chalan Details');
    } finally {
      return model;
    }
  }
}
