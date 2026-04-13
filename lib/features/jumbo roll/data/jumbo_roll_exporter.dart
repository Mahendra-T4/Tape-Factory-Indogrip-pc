import 'dart:developer';
import 'dart:typed_data';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/jumbo%20roll/demain/repositories/jumbo_roll_repo.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:intl/intl.dart';

class JumboRollExporter {
  static Future<Uint8List> jumboRollDataExcelGenerator(
    List<Map<String, dynamic>> data,
  ) async {
    try {
      Excel excel = Excel.createExcel();
      Sheet sheet = excel['Sheet1'];

      List<String> header = [
        "SNo",
        "Vendor Code",
        "Company Name",
        "Record Date",
        "Bill Date",
        "Bill Number",
        "Roll Number",
        "Base",
        "Mic",
        "Length",
        "Consume Length",
        "Available Length",
        "Width",
        "Net Weight",
        "Square Meter",
        "AmountPerKG",
        "Roll Cost",
        "Remark",
        "rStatus",
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
            item['vendorInfo']?['vendorCode']?.toString() ?? '',
            item['vendorInfo']?['companyName']?.toString() ?? '',
            item['jumboDate']?.toString() ?? '',
            item['jBillDate']?.toString() ?? '',
            item['jBillNumber']?.toString() ?? '',
            item['jRollNumber']?.toString() ?? '',
            item['baseLabel']?.toString() ?? '',
            item['micLabel']?.toString() ?? '',
            item['jLength']?.toString() ?? '',
            item['consumeLength']?.toString() ?? '',
            item['availableLength']?.toString() ?? '',
            item['jWidth']?.toString() ?? '',
            item['jWeight']?.toString() ?? '',
            item['jSquareMeter']?.toString() ?? '',
            item['amountPerKG']?.toString() ?? '',
            item['rollCost']?.toString() ?? '',
            item['jRemark']?.toString() ?? '',
            item['jumboStatusLabel']?.toString() ?? '',

            // vendorInfo fields
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

  static Future<void> exportJumboRollExcelFile({
    required BuildContext context,
    required ViewRecordApiParam param,
    String? folderPath,
    String fileName = 'jumboroll_export.xlsx',
  }) async {
    try {
      // Generate filename with current date
      String dateFormatted = DateFormat('dd-MM-yyyy').format(DateTime.now());
      String fileNameWithDate =
          'jumbo_roll_data_$dateFormatted.xlsx'; // Default name with date

      // Show directory picker dialog to let user select save location
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select folder to save jumbo roll data',
      );

      if (selectedDirectory == null) {
        // User cancelled the picker
        ToastService.instance.showError(context, 'Export cancelled');
        return;
      }

      List<Map<String, dynamic>> data =
          await JumboRollRepository.getJumboRollJsonData(param);

      Uint8List bytes = await jumboRollDataExcelGenerator(data);

      // Build the full file path with selected directory and dated filename
      String savePath = '$selectedDirectory/$fileNameWithDate';

      final file = File(savePath);

      await file.writeAsBytes(bytes);

      log('Excel file saved successfully at: $savePath');

      ToastService.instance.showSuccess(
        context,
        'File exported successfully: $fileNameWithDate',
      );

      try {
        // Open the folder where file was saved
        await Process.start('explorer.exe', ['/select,', savePath]);
      } catch (e) {
        log('Could not open Excel file: $e');
      }
    } catch (e) {
      log('Error exporting Jumbo Roll Excel: $e');
      ToastService.instance.showError(context, 'Failed to export Excel file.');
    }
  }
}
