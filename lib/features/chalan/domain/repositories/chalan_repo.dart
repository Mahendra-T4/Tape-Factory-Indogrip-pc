import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/features/chalan/data/model/chalanlist_model.dart';
import 'package:indogrip/features/chalan/data/model/challan_details_model.dart';
import 'package:indogrip/features/chalan/data/model/challan_product_verify_model.dart';
import 'package:indogrip/features/chalan/data/model/return_product.dart';
import 'package:indogrip/features/chalan/data/model/verify_challan_product_param.dart';
import 'package:indogrip/features/global/data/model/success_reponse.dart';
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
          'pageNo': param.pageNo ?? 1,
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

  static Future<ChallanProductVerifyModel> verifyChallanProduct({
    required VerifyProductParam param,
  }) async {
    ChallanProductVerifyModel model = ChallanProductVerifyModel();

    try {
      final formData = FormData.fromMap({
        'activity': 'verify-product',
        'userKey': HiveService.getUserId(),
        'productKey': param.productKey,
        'unitPrice': param.unitPrice,
        'displayQty': param.displayQty,
        'prRemarks': param.prRemarks,
      });
      final response = await DioService.dioPostApiCall(data: formData);
      if (response.statusCode == 200) {
        model = ChallanProductVerifyModel.fromJson(response.data);
        developer.log(
          model.message.toString(),
          name: 'Verify Challan Product Response',
        );
        developer.log(
          formData.fields.toString(),
          name: 'Verify Challan FormData',
        );
      } else {
        // model..message = 'Failed to verify challan product';
        developer.log(
          'Failed to verify challan product',
          name: 'Verify Challan Product Failed',
        );
      }
    } catch (e) {
      developer.log('Exception: $e', name: 'Verify Challan Product');
    }
    return model;
  }

  static Future<SuccessResponse> unverifyProduct({productKey}) async {
    SuccessResponse model = SuccessResponse();

    try {
      final formData = FormData.fromMap({
        'activity': 'unverify-product',
        'userKey': HiveService.getUserId(),
        'productKey': productKey,
      });
      final response = await DioService.dioPostApiCall(data: formData);
      if (response.statusCode == 200) {
        model = SuccessResponse.fromJson(response.data);
        developer.log(
          model.message.toString(),
          name: 'Unverify Challan Product Response',
        );
        developer.log(
          formData.fields.toString(),
          name: 'Unverify Challan FormData',
        );
      } else {
        // model..message = 'Failed to unverify challan product';
        developer.log(
          'Failed to unverify challan product',
          name: 'Unverify Challan Product Failed',
        );
      }
    } catch (e) {
      developer.log('Exception: $e', name: 'Unverify Challan Product');
    }
    return model;
  }

  static Future<SuccessResponse> returnProduct({
    required ReturnProduct param,
  }) async {
    SuccessResponse model = SuccessResponse();

    try {
      final formData = FormData.fromMap({
        'activity': 'return-product',
        'userKey': HiveService.getUserId(),
        'productKey': param.productKey,
        'returnQty': param.returnQty,
        'returnReason': param.returnReason,
        'returnDate': param.returnDate,
      });
      final response = await DioService.dioPostApiCall(data: formData);
      if (response.statusCode == 200) {
        model = SuccessResponse.fromJson(response.data);
        developer.log(
          model.message.toString(),
          name: 'Return Challan Product Response',
        );
        developer.log(
          formData.fields.toString(),
          name: 'Return Challan FormData',
        );
      } else {
        // model..message = 'Failed to return challan product';
        developer.log(
          'Failed to return challan product',
          name: 'Return Challan Product Failed',
        );
      }
    } catch (e) {
      developer.log('Exception: $e', name: 'Return Challan Product');
    }
    return model;
  }

  static Future<List<Map<String, dynamic>>> getChallanJsonData() async {
    try {
      final response = await DioService.dioPostApiCall(
        data: FormData.fromMap({
          'activity': 'challan-list',
          'userKey': HiveService.getUserId(),
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;

        final challanList = jsonData is Map && jsonData['record'] is List
            ? (jsonData['record'] as List)
                  .where((item) => item is Map)
                  .map((item) => Map<String, dynamic>.from(item as Map))
                  .toList()
            : <Map<String, dynamic>>[];

        return challanList;
      } else {
        developer.log(
          'Failed to fetch Challan JSON data',
          name: 'Fetch Challan JSON',
        );
        throw Exception('Failed to fetch Challan JSON data');
      }
    } catch (e) {
      developer.log(
        'Error fetching Challan JSON data: $e',
        name: 'Fetch Challan JSON',
      );
      throw Exception('Error fetching Challan JSON data: $e');
    }
  }
}
