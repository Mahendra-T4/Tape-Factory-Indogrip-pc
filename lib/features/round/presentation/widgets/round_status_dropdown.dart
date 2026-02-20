import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/features/staff/presentation/bloc/staff_bloc.dart';
import 'package:indogrip/features/staff/data/models/view_staff_master_model.dart';

class RoundStatusDropdown extends StatefulWidget {
  final String value;
  final Function(String?) onChanged;

  const RoundStatusDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<RoundStatusDropdown> createState() => _RoundStatusDropdownState();
}

class _RoundStatusDropdownState extends State<RoundStatusDropdown> {
  late StaffBloc _staffBloc;
  ViewStaffMasterEntity? _masterStatus;

  @override
  void initState() {
    super.initState();
    _staffBloc = BlocProvider.of<StaffBloc>(context);
    _staffBloc.add(LoadMasterUserStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StaffBloc, StaffState>(
      bloc: _staffBloc,
      listener: (context, state) {
        if (state is MasterUserStatusLoadedSuccessState) {
          setState(() {
            _masterStatus = state.viewStaffMasterEntity;
          });
        }
      },
      child: _masterStatus == null
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          :  DropdownButton<String>(
              value:
                  widget.value != '' &&
                      (_masterStatus?.record?.any(
                            (r) => r.mID.toString() == widget.value,
                          ) ??
                          false)
                  ? widget.value
                  : null,
              items:
                  _masterStatus?.record
                      ?.map(
                        (record) => DropdownMenuItem(
                          value: record.mID.toString(),
                          child: Text(record.userStatus ?? '', maxLines: 1),
                        ),
                      )
                      .toList() ??
                  [],
              onChanged: (value) {
                widget.onChanged(value);
              },
              hint: const Text('-Select-', maxLines: 1),
              isExpanded: false,
              underline: const SizedBox.shrink(),
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
