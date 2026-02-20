import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';

class DeleteConfirmationAlert extends StatefulWidget {
  final String title;
  final String message;
  final String rPanel;
  final String itemName;
  final VoidCallback onConfirm;
  final List<dynamic>? item;
  final int? index;
  final String rKey;

  const DeleteConfirmationAlert({
    super.key,
    required this.title,
    required this.message,
    required this.rPanel,
    required this.itemName,
    required this.onConfirm,
    this.item,
    this.index,
    required this.rKey,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    required String rPanel,
    required String itemName,
    required VoidCallback onConfirm,
    required List<dynamic>? item,
    required int? index,
    required String rKey,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => DeleteConfirmationAlert(
        title: title,
        message: message,
        itemName: itemName,
        onConfirm: onConfirm,
        rPanel: rPanel,
        item: item,
        index: index,
        rKey: rKey,
      ),
    );
  }

  @override
  State<DeleteConfirmationAlert> createState() =>
      _DeleteConfirmationAlertState();
}

class _DeleteConfirmationAlertState extends State<DeleteConfirmationAlert>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late final GlobalBloc globalBloc;

  @override
  void initState() {
    super.initState();
    globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _buildAlertContent(),
        ),
      ),
    );
  }

  Widget _buildAlertContent() {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.15),
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated warning icon
              _buildWarningIcon(),
              const SizedBox(height: 24),

              // Title
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey.shade900,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),

              // Message
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),

              // Item name highlight
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.red.shade400,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        widget.itemName,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarningIcon() {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.3, 0.8, curve: Curves.elasticOut),
        ),
      ),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.red.shade400, Colors.red.shade600],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: const Center(
          child: Icon(Icons.delete_outline, color: Colors.white, size: 42),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Cancel Button
        Expanded(
          child: _buildButton(
            label: 'Cancel',
            onPressed: () {
              context.pop();
            },
            isPrimary: false,
          ),
        ),
        const SizedBox(width: 12),

        // Delete Button
        Expanded(child: deleteButton),
      ],
    );
  }

  Widget get deleteButton => BlocConsumer(
    bloc: globalBloc,
    listener: (context, state) {
      if (state is GlobalDeleteRecordSuccessStatus) {
        if (state.deleteRecordEntity.status == 1) {
          widget.item?.removeAt(widget.index ?? 0);
          widget.onConfirm.call();
          ToastService.instance.showSuccess(
            context,
            state.deleteRecordEntity.message ?? "Record deleted successfully",
          );
          // Close dialog after deletion succeeds
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted && Navigator.canPop(context)) {
              Navigator.pop(context, true);
            }
          });
        } else {
          ToastService.instance.showError(
            context,
            state.deleteRecordEntity.message ?? "Failed to delete record",
          );
        }
      } else if (state is GlobalDeleteRecordErrorStatus) {
        ToastService.instance.showError(context, state.message);
      }
    },
    builder: (context, state) {
      if (state is GlobalLoadingStatus) {
        return SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: const AlwaysStoppedAnimation<Color>(
              Colors.deepPurpleAccent,
            ),
          ),
        );
      }
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            globalBloc.add(
              GlobalDeleteRecordEvent(
                rKey: widget.rKey.toString(),
                rPanel: widget.rPanel.toString(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.red.shade400, Colors.red.shade600],
              ),

              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Proceed',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            gradient: isPrimary
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.red.shade400, Colors.red.shade600],
                  )
                : null,
            color: isPrimary ? null : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: isPrimary
                ? null
                : Border.all(color: Colors.grey.shade300, width: 1.5),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isPrimary ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
