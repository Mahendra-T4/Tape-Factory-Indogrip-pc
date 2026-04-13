import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:indogrip/features/vendor/domain/repositories/view_vendor_repo.dart';
import 'package:intl/intl.dart';

class VendorFileExporter {
  static Future<Uint8List> vendorExcelFileGenerator(
    List<Map<String, dynamic>> data,
  ) async {
    try {
      Excel excel = Excel.createExcel();
      Sheet sheet = excel['Sheet1'];

      List<String> headers = [
        "SNo",
        "Vendor Code",
        "CompanyName",
        "CompanyMobileNumber",
        "AlternateNumber",
        "CompanyGSTIN",
        "VendorName",
        "VendorMobileNumber",
        "VenderAlternateNumber",
        "RepresentativeName",
        "RepresentativeNumber",
        "RAlternateNumber",
      ];

      for (int i = 0; i < headers.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = TextCellValue(
          headers[i],
        );

        for (int row = 0; row < data.length; row++) {
          var vendorData = data[row];

          List<String> values = [
            vendorData['SNo']?.toString() ?? '',
            vendorData['vCode']?.toString() ?? '',
            vendorData['vCompanyName']?.toString() ?? '',
            vendorData['vCompanyMobileNumber']?.toString() ?? '',
            vendorData['vAlternateNumber']?.toString() ?? '',
            vendorData['companyGSTIN']?.toString() ?? '',
            vendorData['vVendorName']?.toString() ?? '',
            vendorData['vVendorMobileNumber']?.toString() ?? '',
            vendorData['vVenderAlternateNumber']?.toString() ?? '',
            vendorData['vRepresentativeName']?.toString() ?? '',
            vendorData['vRepresentativeNumber']?.toString() ?? '',
            vendorData['vRAlternateNumber']?.toString() ?? '',
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
      throw Exception('Failed to generate Excel file: $e');
    }
  }

  static Future<void> exportVendorExcelFile({
    required BuildContext context,
    required ViewRecordApiParam param,
    String fileName = 'vendor_data.xlsx',
    String? folderPath,
  }) async {
    try {
      // Generate filename with current date
      String dateFormatted = DateFormat('dd-MM-yyyy').format(DateTime.now());
      String fileNameWithDate =
          'vendor_data_$dateFormatted.xlsx'; // Default name with date

      // Show directory picker dialog to let user select save location
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select folder to save vendor data',
      );

      if (selectedDirectory == null) {
        // User cancelled the picker
        ToastService.instance.showError(context, 'Export cancelled');
        return;
      }

      List<Map<String, dynamic>> vendorData =
          await ViewVendorRepository.loadViewVendorJsonData(param);

      Uint8List bytes = await vendorExcelFileGenerator(vendorData);

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
      log('Error exporting vendor Excel: $e');
      ToastService.instance.showError(context, 'Error exporting file: $e');
    }
  }
}
