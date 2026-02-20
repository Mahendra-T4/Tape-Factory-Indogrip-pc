import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/staff/presentation/bloc/staff_bloc.dart';

class RoleSelector extends StatefulWidget {
  final String? selectedRole;
  final Function(String?) onChanged;

  const RoleSelector({
    Key? key,
    required this.selectedRole,
    required this.onChanged,
  }) : super(key: key);

  // static const List<String> roles = ["Admin", "Staff"];

  @override
  State<RoleSelector> createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<RoleSelector> {
  late final StaffBloc _staffBloc;
  @override
  void initState() {
    super.initState();
    _staffBloc = StaffBloc();
    _staffBloc.add(LoadUserMasterRollEvent());
  }

  @override
  Widget build(BuildContext context) {
    // final masterRollProvider = ref.watch(mRollProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Role*",
          style: TextStyle(
            color: Color(0xFF3D475C),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        BlocBuilder(
          bloc: _staffBloc,
          builder: (context, state) {
            switch (state.runtimeType) {
              case StaffLoadingStatus:
                return const Center(child: CircularProgressIndicator());
              case MasterUserRollLoadedSuccessState:
                final masterRollState =
                    state as MasterUserRollLoadedSuccessState;
                final data = masterRollState.masterRoll;
                return data.status == 1
                    ? Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: DropdownButtonFormField<String>(
                          value:
                              widget.selectedRole != null &&
                                  (data.record?.any(
                                        (r) =>
                                            r.mUserRoleId.toString() ==
                                            widget.selectedRole,
                                      ) ??
                                      false)
                              ? widget.selectedRole
                              : null,
                          items:
                              data.record
                                  ?.map(
                                    (record) => DropdownMenuItem(
                                      value: record.mUserRoleId.toString(),
                                      child: Text(record.mUserRoleName ?? ''),
                                    ),
                                  )
                                  .toList() ??
                              [],
                          onChanged: widget.onChanged,
                          hint: Text('-Select Panel-'),
                          isExpanded: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) =>
                              value == null ? 'Please select City' : null,
                        ),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 23),
                          child: Text(
                            data.message ?? 'No response from server',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      );
              case MasterUserRollLoadedFailureState:
                final errorState = state as MasterUserRollLoadedFailureState;
                ToastService.instance.showError(context, errorState.error);
                return const SizedBox.shrink();
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
