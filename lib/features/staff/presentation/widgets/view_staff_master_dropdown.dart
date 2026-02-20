import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:indogrip/core/widgets/labal_text.dart';
import 'package:indogrip/features/staff/data/models/view_staff_master_model.dart';
import 'package:indogrip/features/staff/domain/repositories/staff_repo.dart';
import 'package:indogrip/features/staff/data/models/view_staff_model.dart';
import 'package:indogrip/features/staff/presentation/bloc/staff_bloc.dart';

final viewStaffStatusProvider = FutureProvider<ViewStaffMasterEntity>((ref) {
  return StaffRepository.viewStaffMasterList();
});

class ViewStaffMasterDropdown extends StatefulWidget {
  const ViewStaffMasterDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });
  final String value;
  final void Function(String?) onChanged;

  @override
  State<ViewStaffMasterDropdown> createState() =>
      _ViewStaffMasterDropdownState();
}

class _ViewStaffMasterDropdownState extends State<ViewStaffMasterDropdown> {
  late final StaffBloc _staffBloc;

  @override
  void initState() {
    super.initState();
    _staffBloc = StaffBloc();
    _staffBloc.add(LoadMasterUserStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _staffBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is StaffLoadingStatus) {
          return Center(
            // height: 20,
            // width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        } else if (state is MasterUserStatusLoadedSuccessState) {
          final data = state.viewStaffMasterEntity;
          return data.status != 1
              ? Center(child: Text(data.message ?? 'No response from server'))
              : DropdownButton<String>(
                  value:
                      widget.value != '' &&
                          (data.record?.any(
                                (r) => r.mID.toString() == widget.value,
                              ) ??
                              false)
                      ? widget.value
                      : null,
                  items:
                      data.record
                          ?.map(
                            (record) => DropdownMenuItem(
                              value: record.mID.toString(),
                              child: Text(
                                record.userStatus ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList() ??
                      [],
                  onChanged: (value) {
                    widget.onChanged.call(value);
                    _staffBloc.add(LoadMasterUserStatusEvent());
                  },
                  hint: Text('-Select-', maxLines: 1),
                  isExpanded: false,
                  underline: SizedBox.shrink(),
                );
        } else if (state is MasterUserStatusLoadedFailureState) {
          return Text('Error: ${state.error}', maxLines: 1);
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
