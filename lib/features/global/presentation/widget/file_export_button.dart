import 'package:flutter/material.dart';
import 'package:indogrip/Assets/assets.dart';

class FileExportButton extends StatelessWidget {
  const FileExportButton({super.key, this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,

      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Image.asset(
          Assets.assetsImagesExportExcelFileIcon,
          width: 20,
          height: 20,
        ),
        label: const Text('Export Excel'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[900],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
