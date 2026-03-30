import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/client/domain/repositories/add_client_repo.dart';

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

      // int rowIndex = 1;
      // for (var item in data) {
      //   List units = item['unitList'] ?? [];
      //   if (units.isEmpty) {
      //     // If no units, still write one row with empty unit fields
      //     final values = [
      //       item['SNo']?.toString() ?? '',
      //       item['cCode']?.toString() ?? '',
      //       item['cConsigneeName']?.toString() ?? '',
      //       item['cMobileNumber']?.toString() ?? '',
      //       item['cAlternateNumber']?.toString() ?? '',
      //       item['cGSTIN']?.toString() ?? '',
      //       item['cOwnerName']?.toString() ?? '',
      //       item['cOwnerMobileNumber']?.toString() ?? '',
      //       item['cOwnerAlternateNumber']?.toString() ?? '',
      //       item['cPurchaseManagerName']?.toString() ?? '',
      //       item['cPurchaseManagerNumber']?.toString() ?? '',
      //       item['cPurchaseManagerAlternateNumber']?.toString() ?? '',
      //       '', // unitName
      //       '', // unitIndex
      //       // item['rKey']?.toString() ?? '',
      //       item['rStatus']?.toString() ?? '',
      //     ];
      //     for (int col = 0; col < values.length; col++) {
      //       sheet
      //           .cell(
      //             CellIndex.indexByColumnRow(
      //               columnIndex: col,
      //               rowIndex: rowIndex,
      //             ),
      //           )
      //           .value = TextCellValue(
      //         values[col],
      //       );
      //     }
      //     rowIndex++;
      //   } else {
      //     for (var unit in units) {
      //       final values = [
      //         item['SNo']?.toString() ?? '',
      //         item['cCode']?.toString() ?? '',
      //         item['cConsigneeName']?.toString() ?? '',
      //         item['cMobileNumber']?.toString() ?? '',
      //         item['cAlternateNumber']?.toString() ?? '',
      //         item['cGSTIN']?.toString() ?? '',
      //         item['cOwnerName']?.toString() ?? '',
      //         item['cOwnerMobileNumber']?.toString() ?? '',
      //         item['cOwnerAlternateNumber']?.toString() ?? '',
      //         item['cPurchaseManagerName']?.toString() ?? '',
      //         item['cPurchaseManagerNumber']?.toString() ?? '',
      //         item['cPurchaseManagerAlternateNumber']?.toString() ?? '',
      //         unit['unitName']?.toString() ?? '',
      //         unit['unitIndex']?.toString() ?? '',
      //         // item['rKey']?.toString() ?? '',
      //         item['rStatus']?.toString() ?? '',
      //       ];
      //       for (int col = 0; col < values.length; col++) {
      //         sheet
      //             .cell(
      //               CellIndex.indexByColumnRow(
      //                 columnIndex: col,
      //                 rowIndex: rowIndex,
      //               ),
      //             )
      //             .value = TextCellValue(
      //           values[col],
      //         );
      //       }
      //       rowIndex++;
      //     }
      //   }
      // }

      return excel.encode() as Uint8List;
    } catch (e) {
      print(e);
      return Uint8List(0);
    }
  }

  static Future<void> exportClientExcelFile({
    required BuildContext context,
    String? folderPath,
    String fileName = 'client_data.xlsx',
  }) async {
    try {
      List<Map<String, dynamic>> data =
          await AddClientRepository.loadClientJsonData();

      Uint8List bytes = await exportClientsToExcelGenerator(data);

      String? savePath;
      if (folderPath != null && folderPath.isNotEmpty) {
        savePath = '$folderPath/$fileName';
      } else {
        savePath = fileName;
      }

      ToastService.instance.showSuccess(
        context,
        'File exported successfully to $savePath',
      );

      final file = File(savePath);
      await file.writeAsBytes(bytes);

      try {
        await Process.start('explorer.exe', [savePath]);
      } catch (e) {
        log('Error opening file explorer: $e');
      }
    } catch (e) {
      log('Error exporting client Excel: $e');
      ToastService.instance.showError(context, 'Error exporting file: $e');
    }
  }
}
