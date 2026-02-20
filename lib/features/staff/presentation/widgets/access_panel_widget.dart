// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/features/staff/presentation/bloc/staff_bloc.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class AccessPanelWidget extends StatefulWidget {
  final String? selectedRole;
  final Function(List<String>) onConfirm;
  final List<String> selectedSkills;
  AccessPanelWidget({
    Key? key,
    this.selectedRole,
    required this.onConfirm,
    required this.selectedSkills,
  }) : super(key: key);

  @override
  State<AccessPanelWidget> createState() => _AccessPanelWidgetState();
}

class _AccessPanelWidgetState extends State<AccessPanelWidget> {
  late List<String> _selectedSkills;
  late final StaffBloc _staffBloc;

  @override
  void initState() {
    super.initState();
    _staffBloc = StaffBloc();
    _staffBloc.add(LoadAccessPanelEvent());
    _selectedSkills = List<String>.from(widget.selectedSkills);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _staffBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case StaffLoadingStatus:
            return const Center(child: CircularProgressIndicator());
          case AccessPanelLoadedSuccessState:
            final accessPanelState = state as AccessPanelLoadedSuccessState;
            final data = accessPanelState.accessPanel;
            return data.status == 1
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MultiSelectDialogField<String>(
                        dialogWidth: 350,

                        items: data.record!
                            .map(
                              (right) => MultiSelectItem<String>(
                                right.mPanelId.toString(),
                                right.mPanelName.toString(),
                              ),
                            )
                            .toList(),
                        initialValue: _selectedSkills,
                        chipDisplay: MultiSelectChipDisplay(
                          onTap: (item) {
                            setState(() {
                              _selectedSkills.remove(item);
                              widget.onConfirm(_selectedSkills);
                            });
                          },
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        buttonText: Text(
                          "Select Rights",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        buttonIcon: const Icon(Icons.arrow_drop_down),
                        searchable: false,
                        listType: MultiSelectListType.LIST,
                        onConfirm: (values) {
                          setState(() {
                            _selectedSkills = List<String>.from(values);
                          });
                          widget.onConfirm(List<String>.from(values));
                        },

                        validator: (values) {
                          if (values == null || values.isEmpty) {
                            return "Please select at least one right";
                          }
                          return null;
                        },
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      data.message ?? 'No response from server',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
          case AccessPanelLoadedFailureState:
            final errorState = state as AccessPanelLoadedFailureState;
            return Center(
              child: Text(
                "Error loading access panel: ${errorState.error}",
                style: TextStyle(color: Colors.red),
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
