import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_selector/file_selector.dart';

class DownloadClientFileButton extends StatelessWidget {
  const DownloadClientFileButton({
    super.key,
    required this.csvURL,
    this.label,
    required this.defaultFileName,
  });
  final String csvURL;
  final String? label;
  final String defaultFileName;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      color: Colors.green,
      label: label ?? 'Download Sample CSV',
      onPressed: () async {
        try {
          // Download the file from the URL
          final response = await http.get(Uri.parse(csvURL));

          if (response.statusCode == 200) {
            // Prompt user to select download folder
            final String? selectedDirectory = await getDirectoryPath();

            // Directory? dir = await getDownloadsDirectory();
            // if (dir == null) {
            //   dir = await getApplicationCacheDirectory();
            // }
            if (selectedDirectory == null) {
              // User cancelled the selection
              ToastService.instance.showInfo(context, 'Download cancelled.');
              return;
            }

            // Create the file path -  this is only name for downloaded file
            // final file = File('${dir.path}/$defaultFileName');
            final file = File('$selectedDirectory/$defaultFileName');

            // Write the bytes to the file
            await file.writeAsBytes(response.bodyBytes);

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
          } else {
            ToastService.instance.showError(
              context,
              'Failed to download file: HTTP ${response.statusCode}',
            );
          }
        } catch (e) {
          // Handle error
          developer.log('Error downloading file: $e');
          ToastService.instance.showError(
            context,
            'Failed to download file: $e',
          );
        }
      },
    );
  }
}
