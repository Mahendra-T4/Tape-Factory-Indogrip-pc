import 'dart:developer';
import 'dart:typed_data';
import 'dart:io';
import 'package:excel/excel.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/chalan/domain/repositories/chalan_repo.dart';
import 'package:indogrip/features/jumbo%20roll/demain/repositories/jumbo_roll_repo.dart';

class ChallanExporter {
  static Future<Uint8List> challanDataExcelGenerator(
    List<Map<String, dynamic>> data,
  ) async {
    try {
      Excel excel = Excel.createExcel();
      Sheet sheet = excel['Sheet1'];

      List<String> header = [
        "SNo",
        "Challan Number",
        "Date",
        "Client Code",
        "Consignee Name",
        "Unit Name",
        "Staff Name",
      ];

      for (int i = 0; i < header.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = TextCellValue(
          header[i],
        );

        for (int row = 0; row < data.length; row++) {
          var item = data[row];

          final values = [
            item['SNo']?.toString() ?? '',
            item['challanNumber']?.toString() ?? '',
            item['dateTime']?.toString() ?? '',
            item['clientInformation']?['cCode']?.toString() ?? '',
            item['clientInformation']?['cConsigneeName']?.toString() ?? '',
            item['clientInformation']?['unitName']?.toString() ?? '',
            '${item['staffInformation']?['uFirstName'] ?? ''} ${item['staffInformation']?['uLastName'] ?? ''}',
          ];

          for (int col = 0; col < values.length; col++) {
            sheet
                .cell(
                  CellIndex.indexByColumnRow(
                    columnIndex: col,
                    rowIndex: row + 1,
                  ),
                )
                .value = TextCellValue(
              values[col],
            );
          }
        }
      }
      return excel.encode() as Uint8List;
    } catch (e) {
      log('Error generating Excel file: $e');
      return Uint8List(0);
    }
  }

  static Future<void> exportChallanExcelFile({
    required BuildContext context,
    String? folderPath,
    String fileName = 'challan_export.xlsx',
  }) async {
    try {
      List<Map<String, dynamic>> data =
          await ChallanRepository.getChallanJsonData();

      Uint8List bytes = await challanDataExcelGenerator(data);

      String? savePath;

      if (folderPath != null && folderPath.isNotEmpty) {
        savePath = '$folderPath/$fileName';
      } else {
        savePath = fileName;
      }

      final file = File(savePath);

      await file.writeAsBytes(bytes);

      log('Excel file saved successfully at: $savePath');

      ToastService.instance.showSuccess(
        context,
        'File exported successfully to $savePath',
      );

      try {
        await Process.start('explorer.exe', [savePath]);
      } catch (e) {
        log('Could not open Excel file: $e');
      }
    } catch (e) {
      log('Error exporting Challan Excel: $e');
      ToastService.instance.showError(context, 'Failed to export Excel file.');
    }
  }
}
