import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/utils/widgets/custom_toast_widget.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';

class MultiDeleteButton extends StatefulWidget {
  MultiDeleteButton({
    super.key,
    required this.onPressed,
    required this.panel,
    required this.selectedItems,
    this.keyField = 'rKey', // Default to 'rKey' for backward compatibility
  });
  final String panel;
  List<Map<String, dynamic>> selectedItems = [];
  final String keyField; // New parameter for custom key field

  final void Function()? onPressed;

  @override
  State<MultiDeleteButton> createState() => _MultiDeleteButtonState();
}

class _MultiDeleteButtonState extends State<MultiDeleteButton> {
  late final GlobalBloc globalBloc;
  @override
  void initState() {
    globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: BlocConsumer(
        bloc: globalBloc,
        listener: (context, state) {
          // Handle multiple-delete success/failure and refresh UI
          if (state is GlobalDeleteMultipleRecordsSuccessStatus) {
            if (state.deleteRecordEntity.status == 1) {
              if (context.mounted) {
                ToastService.instance.show(
                  context,
                  message: state.deleteRecordEntity.message.toString(),
                  type: ToastType.success,
                );
                // Clear selection and refresh list

                widget.onPressed?.call();
              }
            } else {
              if (context.mounted) {
                ToastService.instance.show(
                  context,
                  message: state.deleteRecordEntity.message.toString(),
                  type: ToastType.warning,
                );
              }
            }
          } else if (state is GlobalDeleteMultipleRecordsErrorStatus) {
            if (context.mounted) {
              ToastService.instance.show(
                context,
                message: state.message.toString(),
                type: ToastType.error,
              );
            }
          }
        },
        builder: (context, state) {
          if (state is GlobalLoadingStatus) {
            return const SizedBox(
              height: 36,
              width: 36,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return ElevatedButton.icon(
            onPressed: () {
              if (widget.selectedItems.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No record are selected')),
                );
                return;
              }

              final List<String> rKeys = widget.selectedItems
                  .map((m) => m[widget.keyField]?.toString())
                  .where((k) => k != null && k.isNotEmpty)
                  .cast<String>()
                  .toList();

              if (rKeys.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No valid rKey found for selected items'),
                  ),
                );
                return;
              }

              // Confirm deletion
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Confirm delete'),
                  content: Text('Delete selected records?'),
                  actions: [
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.pop();
                        globalBloc.add(
                          GlobalDeleteMultipleRecordsEvent(
                            rKeys: rKeys,
                            rPanel: widget.panel,
                          ),
                        );
                        log(
                          'Attempting to delete rKeys: ${rKeys.map((e) => e)}',
                        );
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete),
            label: const Text('Delete Selected'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
