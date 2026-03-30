// import 'dart:io';
// import 'dart:typed_data';

// import 'package:excel/excel.dart';
// import 'package:file_saver/file_saver.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';

// Future<Uint8List> generateExcel(List<Map<String, dynamic>> data) async {
//   var excel = Excel.createExcel();
//   Sheet sheet = excel['Sheet1'];

//   // Add headers (customize based on your data keys)
//   List<String> headers = [
//     'ID',
//     'Name',
//     'Email',
//     'Phone',
//   ]; // e.g., for users API
//   for (int i = 0; i < headers.length; i++) {
//     sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value =
//         TextCellValue(headers[i]);
//   }

//   // Add data rows
//   for (int row = 0; row < data.length; row++) {
//     var item = data[row];
//     sheet
//         .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row + 1))
//         .value = IntCellValue(
//       item['id'] ?? 0,
//     );
//     sheet
//         .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row + 1))
//         .value = TextCellValue(
//       item['name'] ?? '',
//     );
//     sheet
//         .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row + 1))
//         .value = TextCellValue(
//       item['email'] ?? '',
//     );
//     sheet
//         .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row + 1))
//         .value = TextCellValue(
//       item['phone'] ?? '',
//     );
//   }

//   // Encode to bytes
//   List<int> fileBytes = excel.encode()!;
//   return Uint8List.fromList(fileBytes);
// }



// !----------------------------------------

// Future<void> exportExcelFromApi() async {
//   try {
//     // Fetch data
//     List<Map<String, dynamic>> data = await fetchApiData();

//     // Generate Excel
//     Uint8List bytes = await generateExcel(data);

//     // Save with dialog
//     final result = await FileSaver.instance.saveAs(
//       name: 'api_data.xlsx',
//       bytes: bytes,
     
//       mimeType: MimeType.microsoftExcel, fileExtension: '.xlsx',
//     );

//     if (result != null) {
//       print('Excel saved to: $result');
//     } else {
//       print('Save cancelled');
//     }
//   } catch (e) {
//     print('Error: $e');
//     // Show snackbar/dialog for user feedback
//   }
// }


// !--------------------------------------------

// Future<void> saveToDocuments(Uint8List bytes) async {
//   Directory docDir = await getApplicationDocumentsDirectory();
//   String path = '${docDir.path}/api_data.xlsx';
//   File file = File(path);
//   await file.writeAsBytes(bytes);
//   print('Saved to: $path');
// }

// // ElevatedButton(
// //   onPressed: exportExcelFromApi,
// //   child: Text('Generate & Export Excel'),
// // )
