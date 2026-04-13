import 'dart:developer';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/round/domain/repositories/add_round_repo.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:intl/intl.dart';

class RoundFileExporter {
  static Future<Uint8List> roundExcelFileGenerator(
    List<Map<String, dynamic>> data,
  ) async {
    try {
      Excel excel = Excel.createExcel();
      Sheet sheet = excel['Sheet1'];

      List<String> header = [
        "SNo",
        "Roll Number",
        "Width",
        "Base",
        "Mic",
        "Length",
        "Total Weight",
        "AmountPerKG",
        "CutMMMeter",
        "Round Count",
        "Tape Length",
        "Wastage Percentage",
        "Conversion Rate",
        "Used Length",
        "Pieces PerCarton",
        "Used Square Meter",
        "Roll Cost",
        "Total SquareMtr",
        "RatePerSquareMeter",
        "Carton Material Cost",
        "Carton Rate",
        "Margin 10%",
        "Margin 12%",
        "Margin 15%",
        "Total Carton",
        "roundStatusLabel",
      ];

      for (int i = 0; i < header.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = TextCellValue(
          header[i],
        );
      }

      for (int row = 0; row < data.length; row++) {
        var item = data[row];

        List<String> values = [
          item['sNo']?.toString() ?? '',
          item['rollNumber']?.toString() ?? '',
          item['width']?.toString() ?? '',
          item['base']?.toString() ?? '',
          item['mic']?.toString() ?? '',
          item['length']?.toString() ?? '',
          item['totalWeight']?.toString() ?? '',
          item['amountPerKG']?.toString() ?? '',
          item['cutMMMeter']?.toString() ?? '',
          item['roundCount']?.toString() ?? '',
          item['tapeLength']?.toString() ?? '',
          item['wastagePercentage']?.toString() ?? '',
          item['conversionRate']?.toString() ?? '',
          item['usedLength']?.toString() ?? '',
          item['piecesPerCarton']?.toString() ?? '',
          item['usedSquareMeter']?.toString() ?? '',
          item['rollCost']?.toString() ?? '',
          item['totalSquareMtr']?.toString() ?? '',
          item['ratePerSquareMeter']?.toString() ?? '',
          item['cartonMaterialCost']?.toString() ?? '',
          item['cartonRate']?.toString() ?? '',
          item['marginWithTenPercentage']?.toString() ?? '',
          item['marginWithTwelvePercentage']?.toString() ?? '',
          item['marginWithFifteenPercentage']?.toString() ?? '',
          item['totalCarton']?.toString() ?? '',
          item['roundStatusLabel']?.toString() ?? '',
        ];

        for (int col = 0; col < values.length; col++) {
          sheet
              .cell(
                CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 1),
              )
              .value = TextCellValue(
            values[col],
          );
        }
      }
      return excel.encode() as Uint8List;
    } catch (e) {
      log('Error generating Excel file: $e');
      throw Exception('Error generating Excel file: $e');
    }
  }

  static Future<void> exportRoundDataExcelFile({
    required BuildContext context,
    required ViewRecordApiParam param,
    String? folderPath,
    String fileName = 'round_data.xlsx',
  }) async {
    try {
      // Generate filename with current date
      String dateFormatted = DateFormat('dd-MM-yyyy').format(DateTime.now());
      String fileNameWithDate =
          'round_data_$dateFormatted.xlsx'; // Default name with date

      // Show directory picker dialog to let user select save location
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select folder to save round data',
      );

      if (selectedDirectory == null) {
        // User cancelled the picker
        ToastService.instance.showError(context, 'Export cancelled');
        return;
      }

      List<Map<String, dynamic>> data = await AddRoundRepository()
          .loadRoundJsonData(param);

      Uint8List bytes = await roundExcelFileGenerator(data);

      // Build the full file path with selected directory and dated filename
      String savePath = '$selectedDirectory/$fileNameWithDate';

      final file = File(savePath);

      await file.writeAsBytes(bytes);

      ToastService.instance.showSuccess(
        context,
        'File exported successfully: $fileNameWithDate',
      );

      try {
        // Open the folder where file was saved
        await Process.start('explorer.exe', ['/select,', savePath]);
      } catch (e) {
        log('Error opening file explorer: $e');
      }
    } catch (e) {
      log('Error exporting Round Excel: $e');
      ToastService.instance.showError(
        context,
        'Error exporting Round Excel: $e',
      );
    }
  }
}
