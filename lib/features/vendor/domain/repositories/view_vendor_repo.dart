import 'dart:developer' as developer;
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:indogrip/core/config/env_config.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:indogrip/features/vendor/data/models/edit_vendor_api_param.dart';
import 'package:indogrip/features/vendor/data/models/view_vendor_model.dart';
import 'package:retry/retry.dart';

abstract class ViewVendorRepository {
  static Dio _dioClient = Dio();

  static Future<ViewVendorModel> viewVendorsRecords({
    required ViewRecordApiParam param,
  }) async {
    ViewVendorModel viewVendorModel = ViewVendorModel();
    try {
      final response = await retry(
        () => DioService.dioPostApiCall(
          data: FormData.fromMap({
            'activity': 'view-vendor',
            'userKey': HiveService.getUserId(),
            'keyword': param.keyword,
            'filterBy': param.filterBy,
            'sortBy': param.sortBy,
            'orderBy': param.orderBy,
            'pageNO': param.pageNo,
            'fromDate': param.fromDate ?? '',
            'toDate': param.toDate ?? '',
          }),
        ).timeout(const Duration(seconds: 5)),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        viewVendorModel = ViewVendorModel.fromJson(response.data);
        developer.log(
          viewVendorModel.message.toString(),
          name: 'View Vendor Success Response',
        );
      }
    } catch (e) {
      developer.log('Error viewing vendors: $e', name: 'View Vendor');
    }
    return viewVendorModel;
  }

  static Future<SuccessResponse> editVendor({
    required EditVendorApiParam apiParam,
  }) async {
    SuccessResponse successResponse = SuccessResponse();
    try {
      final response = await retry(
        () => DioService.dioPostApiCall(
          data: FormData.fromMap({
            'activity': 'add-vendor',
            'vCompanyName': apiParam.vCompanyName,
            'vMobileNumber': apiParam.vMobileNumber,
            'vAlternateNumber': apiParam.vAlternateNumber,
            'vGSTIN': apiParam.vGSTIN,
            'vOwnerName': apiParam.vOwnerName,
            'vOwnerMobileNumber': apiParam.vOwnerMobileNumber,
            'vRepresentativeName': apiParam.vRepresentativeName,
            'vRepresentativeMobile': apiParam.vRepresentativeMobile,
            'rKey': apiParam.rKey,
            'userKey': HiveService.getUserId(),
          }),
        ).timeout(const Duration(seconds: 5)),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        successResponse = SuccessResponse.fromJson(response.data);
        developer.log(
          successResponse.message.toString(),
          name: 'Edit Vendor Success Response',
        );
      } else {
        SuccessResponse()..message = 'Failed to edit vendor';
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Edit Vendor');
    }
    return successResponse;
  }
}
