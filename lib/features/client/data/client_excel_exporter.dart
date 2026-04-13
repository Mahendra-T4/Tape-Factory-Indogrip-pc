import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/client/domain/repositories/add_client_repo.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:intl/intl.dart';

class ClientExcelExporter {
  static Future<Uint8List> exportClientsToExcelGenerator(
    List<Map<String, dynamic>> data,
  ) async {
    try {
      Excel excel = Excel.createExcel();
      Sheet sheet = excel['Sheet1'];
      List<String> header = [
        "SNo",
        "Client Code",
        "Consignee Name",
        "Mobile Number",
        "Alternate Number",
        "GSTIN",
        "Owner Name",
        "Owner Mobile",
        "Owner Alternate Mobile",
        "Purchase Manager",
        "Manager Mobile",
        "Manager Alternate Mobile",
        // "Unit Name",
        // "Unit Index",
        "Status",
      ];

      // Write header
      for (int i = 0; i < header.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = TextCellValue(
          header[i],
        );
      }

      for (int row = 0; row < data.length; row++) {
        var item = data[row];

        final values = [
          item['SNo']?.toString() ?? '',
          item['cCode']?.toString() ?? '',
          item['cConsigneeName']?.toString() ?? '',
          item['cMobileNumber']?.toString() ?? '',
          item['cAlternateNumber']?.toString() ?? '',
          item['cGSTIN']?.toString() ?? '',
          item['cOwnerName']?.toString() ?? '',
          item['cOwnerMobileNumber']?.toString() ?? '',
          item['cOwnerAlternateNumber']?.toString() ?? '',
          item['cPurchaseManagerName']?.toString() ?? '',
          item['cPurchaseManagerNumber']?.toString() ?? '',
          item['cPurchaseManagerAlternateNumber']?.toString() ?? '',
          // '', // unitName
          // '', // unitIndex
          // item['rKey']?.toString() ?? '',
          item['rStatus']?.toString() ?? '',
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
      print(e);
      return Uint8List(0);
    }
  }

  static Future<void> exportClientExcelFile({
    required BuildContext context,
    required ViewRecordApiParam param,
    String? folderPath,
    String fileName = 'client_data.xlsx',
  }) async {
    try {
      // Generate filename with current date
      String dateFormatted = DateFormat('dd-MM-yyyy').format(DateTime.now());
      String fileNameWithDate =
          'client_data_$dateFormatted.xlsx'; // Default name with date

      // Show directory picker dialog to let user select save location
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select folder to save client data',
      );

      if (selectedDirectory == null) {
        // User cancelled the picker
        ToastService.instance.showError(context, 'Export cancelled');
        return;
      }

      List<Map<String, dynamic>> data =
          await AddClientRepository.loadClientJsonData(param);

      Uint8List bytes = await exportClientsToExcelGenerator(data);

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
      log('Error exporting client Excel: $e');
      ToastService.instance.showError(context, 'Error exporting file: $e');
    }
  }
}
