import 'dart:developer' as developer;
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:retry/retry.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/client/data/model/view_staff_api_param.dart';
import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/staff/data/models/add_staff_model.dart';
import 'package:indogrip/features/staff/data/models/add_staff_param.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:indogrip/features/staff/data/models/view_staff_master_model.dart';
import 'package:indogrip/features/staff/data/models/view_staff_model.dart';

class StaffRepository {
  // static Dio _dioClient = Dio();

  static Future<AddStaffEntity> addStaff({required AddStaffParam param}) async {
    AddStaffEntity successResponse = AddStaffEntity();
    try {
      var data = FormData.fromMap({
        'activity': 'add-staff',
        'uFirstName': param.uFirstName,
        'uLastName': param.uLastName,
        'uEmail': param.uEmail,
        'uPersonalEmail': param.uPersonalEmail,
        'uMobileNumber': param.uMobileNumber,
        'uAlternateNumber': param.uAlternateNumber,
        'uRole': param.uRole,
        'uAccessPanel': param.uAccessPanel.join(','), //3,5,6
        'userKey': HiveService.getUserId(),
        'uPassword': param.uPassword,
        'uConfirmPassword': param.uConfirmPassword,
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
        successResponse = AddStaffEntity.fromJson(response.data);
        developer.log('Api Params : ${data.fields.toString()}');
        developer.log(
          name: 'Add Staff Response',
          successResponse.message.toString(),
        );

        if (successResponse.status == 1) {
          ToastService.instance.showSuccess(
            param.context,
            successResponse.message.toString(),
          );
        } else {
          ToastService.instance.showError(
            param.context,
            successResponse.message.toString(),
          );
        }
      }
    } catch (e) {
      developer.log(name: 'Add Staff Error', e.toString());
    }
    return successResponse;
  }

  static Future<ViewStaffModel> viewStaff({
    required ViewRecordApiParam param,
  }) async {
    ViewStaffModel viewStaffModel = ViewStaffModel();
    final data = FormData.fromMap({
      'activity': 'view-staff',
      'userKey': HiveService.getUserId(),
      'keyword': param.keyword,
      'filterBy': param.filterBy,
      'sortBy': param.sortBy,
      'orderBy': param.orderBy,
      'pageNO': param.pageNo ?? '',
      'fromDate': param.fromDate ?? '',
      'toDate': param.toDate ?? '',
    });

    developer.log(data.toString(), name: 'View Staff Api Params');

    try {
      final response = await retry(
        () => DioService.dioPostApiCall(
          data: data,
        ).timeout(const Duration(seconds: 5)),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        viewStaffModel = ViewStaffModel.fromJson(response.data);
        developer.log(
          viewStaffModel.message.toString(),
          name: 'View Staff Message',
        );
        developer.log(
          'View Staff Response: ${viewStaffModel.toJson()}',
          name: 'View Staff Repository',
        );
      } else {
        developer.log(
          'View Staff Error: ${response.statusCode}',
          name: 'View Staff Repository',
        );
      }
    } on DioException catch (e) {
      developer.log('DioError: ${e.message}', name: 'View Staff Repository');
    } catch (e) {
      developer.log('View Staff Error: $e', name: 'View Staff Repository');
      print(e);
    }

    return viewStaffModel;
  }

  static Future<SuccessResponse> editStaffOnRecord({
    required EditStaffApiParam param,
  }) async {
    SuccessResponse successResponse = SuccessResponse();
    try {
      final response = await retry(
        () => DioService.dioPostApiCall(
          data: FormData.fromMap({
            'activity': param.activity,
            'uFirstName': param.uFirstName,
            'uLastName': param.uLastName,
            'uEmail': param.uEmail,
            'uPersonalEmail': param.uPersonalEmail,
            'uMobileNumber': param.uMobileNumber,
            'uAlternateNumber': param.uAlternateNumber,
            'uRole': param.uRole,
            'uAccessPanel': param.uAccessPanel,
            'rKey': param.rKey,
            'uPassword': param.uPassword,
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
          '${successResponse.message}',
          name: 'Edit Staff Response',
        );
      }
    } catch (e) {
      developer.log('Error updating client: $e', name: 'Update Client');
      // ToastService.instance.showError(context, e.toString());
    }
    return successResponse;
  }

  static Future<ViewStaffMasterEntity> viewStaffMasterList() async {
    ViewStaffMasterEntity viewStaffMasterEntity = ViewStaffMasterEntity();

    try {
      final response = await retry(
        () => DioService.dioPostApiCall(
          data: FormData.fromMap({
            'activity': 'view-master-userrequest',
            'userKey': HiveService.getUserId(),
          }),
        ).timeout(const Duration(seconds: 5)),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        viewStaffMasterEntity = ViewStaffMasterEntity.fromJson(response.data);
        developer.log(
          'View Staff Master Response: ${viewStaffMasterEntity.toJson()}',
          name: 'View Staff Master Repository',
        );
      } else {
        developer.log(
          'View Staff Master Error: ${response.statusCode}',
          name: 'View Staff Master Repository',
        );
      }
    } on DioException catch (e) {
      developer.log(
        'DioError: ${e.message}',
        name: 'View Staff Master Repository',
      );
    } catch (e) {
      developer.log(
        'View Staff Master Error: $e',
        name: 'View Staff Master Repository',
      );
      print(e);
    }

    return viewStaffMasterEntity;
  }
}
