import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';

class DeleteRecordButton extends StatefulWidget {
  DeleteRecordButton({
    super.key,
    required this.rKey,
    required this.rPanel,
    this.item,
    this.index,
    this.onPressed,
  });
  final String rKey;
  final String rPanel;
  final List<dynamic>? item;
  final int? index;
  final void Function()? onPressed;

  @override
  State<DeleteRecordButton> createState() => _DeleteRecordButtonState();
}

class _DeleteRecordButtonState extends State<DeleteRecordButton> {
  late final GlobalBloc globalBloc;

  @override
  void initState() {
    super.initState();
    globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: globalBloc,
      listener: (context, state) {
        if (state is GlobalDeleteRecordSuccessStatus) {
          if (state.deleteRecordEntity.status == 1) {
            widget.item!.removeAt(widget.index!);
            widget.onPressed?.call();
            ToastService.instance.showSuccess(
              context,
              state.deleteRecordEntity.message ?? "Record deleted successfully",
            );
          } else {
            ToastService.instance.showError(
              context,
              state.deleteRecordEntity.message ?? "Failed to delete record",
            );
          }
        } else {
          if (state is GlobalDeleteRecordErrorStatus) {
            ToastService.instance.showError(context, state.message);
          }
        }
      },
      builder: (context, state) {
        if (state is GlobalLoadingStatus) {
          return Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        }
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.pop();
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
  }
}
