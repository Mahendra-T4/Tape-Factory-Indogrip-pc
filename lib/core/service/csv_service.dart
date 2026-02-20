import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadCSVFileService {
  Future<void> loadCSVFileForDownload(
    BuildContext context,
    String assetPath,
    String fileName,
  ) async {
    try {
      // Load the CSV file from assets
      final byteData = await rootBundle.load(
        'assets/csv/import-jumbo-sample.csv',
      );
      final buffer = byteData.buffer;

      // Get the downloads directory
      Directory? dir = await getDownloadsDirectory();
      if (dir == null) {
        // Fallback to application documents directory
        dir = await getApplicationDocumentsDirectory();
      }

      // Create the file path
      final file = File('${dir.path}/import-jumbo-sample.csv');

      // Write the bytes to the file
      await file.writeAsBytes(buffer.asUint8List());

      // Open the file
      final uri = Uri.file(file.path);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        ToastService.instance.showSuccess(
          context,
          'File downloaded and opened successfully!',
        );
      } else {
        ToastService.instance.showError(
          context,
          'File downloaded but could not be opened automatically.',
        );
      }
    } catch (e) {
      // Handle error, perhaps show a snackbar
      developer.log('Error downloading file: $e');
      ToastService.instance.showError(context, 'Failed to download file: $e');
    }
  }
}
