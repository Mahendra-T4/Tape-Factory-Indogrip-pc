import 'package:flutter/material.dart';

class AppToast {
  static void show({
    required BuildContext context,
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(milliseconds: 800),
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => _ToastOverlay(
        message: message,
        type: type,
        onDismiss: () {
          overlay.setState(() {});
        },
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}

enum ToastType { success, error, warning, info }

class _ToastOverlay extends StatefulWidget {
  final String message;
  final ToastType type;
  final VoidCallback onDismiss;

  const _ToastOverlay({
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  @override
  _ToastOverlayState createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FadeTransition(
              opacity: _animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -1),
                  end: Offset.zero,
                ).animate(_animation),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: _getBackgroundColor(),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: _getShadowColor(),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIcon(),
                        color: _getIconColor(),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          widget.message,
                          style: TextStyle(
                            color: _getTextColor(),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: _getIconColor(),
                          size: 20,
                        ),
                        onPressed: () {
                          _controller.reverse().then((_) {
                            widget.onDismiss();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case ToastType.success:
        return Colors.green.shade50;
      case ToastType.error:
        return Colors.red.shade50;
      case ToastType.warning:
        return Colors.orange.shade50;
      case ToastType.info:
        return Colors.blue.shade50;
    }
  }

  Color _getIconColor() {
    switch (widget.type) {
      case ToastType.success:
        return Colors.green.shade700;
      case ToastType.error:
        return Colors.red.shade700;
      case ToastType.warning:
        return Colors.orange.shade700;
      case ToastType.info:
        return Colors.blue.shade700;
    }
  }

  Color _getTextColor() {
    switch (widget.type) {
      case ToastType.success:
        return Colors.green.shade900;
      case ToastType.error:
        return Colors.red.shade900;
      case ToastType.warning:
        return Colors.orange.shade900;
      case ToastType.info:
        return Colors.blue.shade900;
    }
  }

  Color _getShadowColor() {
    switch (widget.type) {
      case ToastType.success:
        return Colors.green.withOpacity(0.2);
      case ToastType.error:
        return Colors.red.withOpacity(0.2);
      case ToastType.warning:
        return Colors.orange.withOpacity(0.2);
      case ToastType.info:
        return Colors.blue.withOpacity(0.2);
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case ToastType.success:
        return Icons.check_circle_outline;
      case ToastType.error:
        return Icons.error_outline;
      case ToastType.warning:
        return Icons.warning_amber;
      case ToastType.info:
        return Icons.info_outline;
    }
  }
}