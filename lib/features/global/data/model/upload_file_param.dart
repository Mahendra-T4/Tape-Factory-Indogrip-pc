import 'dart:io';

class UploadFileParam {
  final File csvFile;
  final String billNumber;
  final String selectedVendor;
  final String date;

  UploadFileParam({
    required this.csvFile,
    required this.billNumber,
    required this.selectedVendor,
    required this.date,
  });
}
