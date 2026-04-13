import 'dart:developer';
import 'dart:typed_data';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/outsource/data/repositories/os_export_master_repo.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:intl/intl.dart';

class OSStretchFileExporter {
  static Future<Uint8List> generateStretchExcel(
    List<Map<String, dynamic>> data,
  ) async {
    try {
      Excel excel = Excel.createExcel();
      Sheet sheet = excel['Sheet1'];

      List<String> headers = [
        "SNo",
        "Inventory Code",
        "Record Date",
        "Company Name",
        "Bill Date",
        "Bill Number",
        "Gross Weight",
        "Net Weight",
        "Difference",
        "Less Weight",
        "Actual Weight",
        "Stretch Film Size",
        "Core",
        "Mic",
        "Base",
        "Carton Price",
        "Transport Price",
        "Actual Price",
        "PerKGPrice",
        "Margin",
        "Remark",
        "rStatus",
      ];

      for (int i = 0; i < headers.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = TextCellValue(
          headers[i],
        );
      }

      for (int row = 0; row < data.length; row++) {
        var item = data[row];
        final values = [
          item['SNo']?.toString() ?? '',
          item['inventoryCode']?.toString() ?? '',
          item['recordDate']?.toString() ?? '',
          item['vendorInfo']?['companyName']?.toString() ?? '',
          item['billDate']?.toString() ?? '',
          item['billNumber']?.toString() ?? '',
          item['additionalInfo']?['grossWeight']?.toString() ?? '',
          item['additionalInfo']?['netWeight']?.toString() ?? '',
          item['additionalInfo']?['difference']?.toString() ?? '',
          item['additionalInfo']?['lessWeight']?.toString() ?? '',
          item['additionalInfo']?['actualWeight']?.toString() ?? '',
          item['additionalInfo']?['stretchFilmSize']?.toString() ?? '',
          item['additionalInfo']?['coreLabel']?.toString() ?? '',
          item['additionalInfo']?['micLabel']?.toString() ?? '',
          item['additionalInfo']?['baseLabel']?.toString() ?? '',
          item['cartonPrice']?.toString() ?? '',
          item['transportPrice']?.toString() ?? '',
          item['actualPrice']?.toString() ?? '',
          item['additionalInfo']?['perKGPrice']?.toString() ?? '',
          item['additionalInfo']?['margin']?.toString() ?? '',
          item['remark']?.toString() ?? '',
          item['inventoryStatusLabel']?.toString() ?? '',
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

      // List<int> fileBytes = excel.encode()!;
      //   return Uint8List.fromList(fileBytes);

      return excel.encode() as Uint8List;
    } catch (e) {
      print(e);
      return Uint8List(0);
    }
  }

  static Future<void> exportTapeExcel({
    required BuildContext context,
    required ViewRecordApiParam param,
    String? folderPath,
    String fileName = 'stretch_export.xlsx',
  }) async {
    try {
      // Generate filename with current date
      String dateFormatted = DateFormat('dd-MM-yyyy').format(DateTime.now());
      String fileNameWithDate =
          'stretch_data_$dateFormatted.xlsx'; // Default name with date

      // Show directory picker dialog to let user select save location
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select folder to save stretch data',
      );

      if (selectedDirectory == null) {
        // User cancelled the picker
        ToastService.instance.showError(context, 'Export cancelled');
        return;
      }

      List<Map<String, dynamic>> data = await OsExportManagerRepository()
          .exportStretchExcel(param);

      Uint8List bytes = await generateStretchExcel(data);

      // Build the full file path with selected directory and dated filename
      String savePath = '$selectedDirectory/$fileNameWithDate';

      // Use dart:io to save file
      final file = File(savePath);
      await file.writeAsBytes(bytes);

      // Show success toast
      ToastService.instance.showSuccess(
        context,
        'File exported successfully: $fileNameWithDate',
      );

      // Open the folder where file was saved
      try {
        await Process.start('explorer.exe', ['/select,', savePath]);
      } catch (openError) {
        log('Could not open Excel file: $openError');
      }
    } catch (e) {
      log('Error exporting tape Excel: $e');
      ToastService.instance.showError(context, 'Failed to export Excel file.');
    }
  }
}
