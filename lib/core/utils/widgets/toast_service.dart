import 'package:flutter/material.dart';
import 'custom_toast_widget.dart';

class ToastService {
  OverlayEntry? _currentToast;
  bool _isVisible = false;
  static final ToastService instance = ToastService._();
  static const Duration _animationDuration = Duration(milliseconds: 200);

  ToastService._();

  void show(
    BuildContext context, {
    required String message,
    required ToastType type,
    Duration duration = const Duration(seconds: 2),
  }) {
    if (!context.mounted) return;

    // Hide any existing toast
    hide();

    final overlay = Overlay.of(context);

    _isVisible = true;

    _currentToast = OverlayEntry(
      builder:
          (context) => TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: _isVisible ? 1.0 : 0.0),
            duration: _animationDuration,
            builder:
                (context, value, child) =>
                    Opacity(opacity: value, child: child),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Material(
                    color: Colors.transparent,
                    child: AppToast(message: message, type: type),
                  ),
                ),
              ),
            ),
          ),
    );

    overlay.insert(_currentToast!);

    Future.delayed(duration - _animationDuration, () {
      if (_isVisible) {
        _isVisible = false;
        if (_currentToast != null) {
          Future.delayed(_animationDuration, () {
            hide();
          });
        }
      }
    });
  }

  void hide() {
    _currentToast?.remove();
    _currentToast = null;
  }

  // Convenience methods
  void showSuccess(BuildContext context, String message) {
    show(context, message: message, type: ToastType.success);
  }

  void showError(BuildContext context, String message) {
    show(context, message: message, type: ToastType.error);
  }

  void showWarning(BuildContext context, String message) {
    show(context, message: message, type: ToastType.warning);
  }

  void showInfo(BuildContext context, String message) {
    show(context, message: message, type: ToastType.info);
  }
}
