import 'dart:developer' as developer;
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FilePickerService {
  static Future<File?> pickFileFromDevice(File? file) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'csv', 'xlsx', 'xls'],
      );

      if (result == null || result.files.isEmpty) return null;

      final pickedFile = result.files.first;

      if (pickedFile.path == null) return null;

      return File(pickedFile.path!);
    } catch (e) {
      developer.log(name: 'File Picker Error', e.toString());
      return null;
    }
  }
}
