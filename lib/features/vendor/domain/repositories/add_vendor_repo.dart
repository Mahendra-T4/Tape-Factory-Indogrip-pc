import 'dart:developer' as developer;
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:indogrip/core/config/env_config.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/features/client/data/model/add_client_param.dart';

import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/vendor/data/models/edit_vendor_success_model.dart';
import 'package:indogrip/features/vendor/data/models/upload_vendor_button.dart';
import 'package:retry/retry.dart';

class AddVendorRepository {
  static Dio _dioClient = Dio();

  static Future<EditVendorResponse> addClientOnRecord({
    required ClientApiParams param,
  }) async {
    EditVendorResponse successResponse = EditVendorResponse();
    try {
      final response = await retry(
        () => DioService.dioPostApiCall(
          data: FormData.fromMap({
            'activity': 'add-vendor',
            'vCompanyName': param.cConsigneeName,
            'vMobileNumber': param.cMobileNumber,
            'vAlternateNumber': param.cAlternateNumber,
            'vGSTIN': param.cGSTIN,
            'vOwnerName': param.cOwnerName,
            'vOwnerMobileNumber': param.cOwnerMobileNumber,
            'vOwnerAlternateNumber': param.cOwnerAlternateNumber,
            'vRepresentativeName': param.cPurchaseManagerName,
            'vRepresentativeNumber': param.cPurchaseManagerNumber,
            'vRepresentativeAlternate': param.cPurchaseManagerAlternateNumber,
            'userKey': HiveService.getUserId(),
          }),
        ).timeout(const Duration(seconds: 5)),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );
      if (response.statusCode == 200) {
        successResponse = EditVendorResponse.fromJson(response.data);
      }
    } catch (e) {
      developer.log('Error adding client: $e', name: 'Add Client');
      // ToastService.instance.showError(context, e.toString());
    }
    return successResponse;
  }

  static Future<UploadVendorResponse> uploadVendorFile({
    required String activity,
    required File csvFile,
  }) async {
    UploadVendorResponse successResponse = UploadVendorResponse();
    try {
      final formData = FormData.fromMap({
        'activity': activity,
        'userKey': HiveService.getUserId(),
        // 'csvFile': csvFile,
        // Add other necessary fields here
      });
      formData.files.add(
        MapEntry(
          'csvFile',
          await MultipartFile.fromFile(
            csvFile.path,
            filename: csvFile.path.split('/').last,
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
      if (response.statusCode == 200) {
        successResponse = UploadVendorResponse.fromJson(response.data);

        developer.log(
          response.data.toString(),
          name: 'Upload Vendor File Data',
        );
        developer.log(
          successResponse.message.toString(),
          name: 'Upload Vendor CSV Success',
        );

        // developer.log(csvFile.path, name: 'Upload Vendor CSV File');
      } else {
        developer.log(
          'Failed to upload CSV file: ${response.statusCode}',
          name: 'Upload Vendor CSV',
        );
      }
    } catch (e) {
      print(e);
    }
    return successResponse;
  }
}
