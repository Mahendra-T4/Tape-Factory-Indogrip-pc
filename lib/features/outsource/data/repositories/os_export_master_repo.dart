import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/features/outsource/domain/repositories/os_export_repo.dart';

class OsExportManagerRepository implements OutSourceExportMasterRepository {
  @override
  Future<List<Map<String, dynamic>>> exportToExcel(String productType) async {
    try {
      final response = await DioService.dioPostApiCall(
        data: FormData.fromMap({
          'activity': 'view-inventory',
          'userKey': HiveService.getUserId(),
          'productType': productType,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        log(name: 'Exported Data', jsonData.toString());
        // Extract the 'record' list from the response
        final recordList = jsonData is Map && jsonData['record'] is List
            ? (jsonData['record'] as List)
                  .where((item) => item is Map)
                  .map((item) => Map<String, dynamic>.from(item as Map))
                  .toList()
            : <Map<String, dynamic>>[];
        return recordList;
      } else {
        throw Exception('Failed to export data: ${response.statusMessage}');
      }
    } catch (e) {
      log('Error exporting data: $e');
      throw Exception('Error exporting data: $e');
    }
  }
}
