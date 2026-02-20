import 'package:flutter/material.dart';

enum ToastType { success, error, warning, info }

class AppToast extends StatelessWidget {
  final String message;
  final ToastType type;

  const AppToast({Key? key, required this.message, required this.type})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: _getBackgroundColor(),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.2),
          //     spreadRadius: 1,
          //     blurRadius: 8,
          //     offset: const Offset(0, 2),
          //   ),
          // ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getIcon(),
            const SizedBox(width: 12.0),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case ToastType.success:
        return const Color(0xFF4CAF50);
      case ToastType.error:
        return const Color(0xFFE53935);
      case ToastType.warning:
        return const Color(0xFFFFA726);
      case ToastType.info:
        return Colors.black;
    }
  }

  Widget _getIcon() {
    IconData iconData;
    switch (type) {
      case ToastType.success:
        iconData = Icons.check_circle_outline;
        break;
      case ToastType.error:
        iconData = Icons.error_outline;
        break;
      case ToastType.warning:
        iconData = Icons.warning_amber_rounded;
        break;
      case ToastType.info:
        iconData = Icons.info_outline;
        break;
    }

    return Icon(iconData, color: Colors.white, size: 24);
  }
}
