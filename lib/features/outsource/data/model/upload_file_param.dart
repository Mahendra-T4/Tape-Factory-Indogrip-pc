import 'dart:io';

class UploadFileParam {
  final String activity;
  final String productType;
  final File csvFile;
  final String? billNumber;
  final String? selectedVendor;
  final String? date;
  final String? rType;

  UploadFileParam({
    required this.activity,
    required this.productType,
    required this.csvFile,
    this.billNumber,
    this.selectedVendor,
    this.date,
    this.rType,
  });
}
