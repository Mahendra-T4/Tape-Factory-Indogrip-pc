import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/features/outsource/domain/repositories/os_export_repo.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';

class OsExportManagerRepository implements OutSourceExportMasterRepository {
  @override
  Future<List<Map<String, dynamic>>> exportToExcel(
    ViewRecordApiParam param,
  ) async {
    try {
      final response = await DioService.dioPostApiCall(
        data: FormData.fromMap({
          'activity': 'view-inventory',
          'userKey': HiveService.getUserId(),
          'filterBy': param.filterBy,
          'productType': '1',
          'keyword': param.keyword,
          'sortBy': param.sortBy,
          'orderBy': param.orderBy,
          'pageNo': param.pageNo,
          'vendorKey': param.vendorKey,
          'baseID': param.baseID,
          'micID': param.micID,
          'cutMMMeterID': param.widthID,
          'fromDate': param.fromDate ?? '',
          'toDate': param.toDate ?? '',
          'tapeLength': param.tapeLength,
          'tapeWeight': param.tapeWeight,
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

  @override
  Future<List<Map<String, dynamic>>> exportStretchExcel(
    ViewRecordApiParam param,
  ) async {
    try {
      final response = await DioService.dioPostApiCall(
        data: FormData.fromMap({
          'activity': 'view-inventory',
          'userKey': HiveService.getUserId(),
          'productType': '2',
          'keyword': param.keyword,
          'filterBy': param.filterBy,
          'sortBy': param.sortBy,
          'orderBy': param.orderBy,
          'pageNo': param.pageNo,
          'vendorKey': param.vendorKey,
          'filmSizeID': param.filmSizeID,
          'coreID': param.coreID,
          'fromDate': param.fromDate ?? '',
          'toDate': param.toDate ?? '',
          'baseID': param.baseID ?? '',
          'micID': param.micID ?? '',
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
