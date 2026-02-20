import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:indogrip/features/staff/presentation/bloc/staff_bloc.dart';

class StaffListDropdown extends StatefulWidget {
  final String label;
  final bool isFilter;

  final String? value;
  final Function(String?) onChanged;
  const StaffListDropdown({
    super.key,
    this.isFilter = false,
    required this.label,

    this.value,
    required this.onChanged,
  });

  @override
  State<StaffListDropdown> createState() => _StaffListDropdownState();
}

class _StaffListDropdownState extends State<StaffListDropdown> {
  late final StaffBloc staffBloc;
  String? selectedStaffName;

  @override
  void initState() {
    super.initState();
    staffBloc = StaffBloc()
      ..add(
        ViewStaffRecordsFetchingEvent(viewStaffApiParam: ViewRecordApiParam()),
      );
  }

  void _showStaffSearchDialog(BuildContext context, List<dynamic> staffList) {
    TextEditingController dialogSearchController = TextEditingController();
    List<dynamic> dialogFilteredRecords = List.from(staffList);
    bool dialogShowResults = false;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            void filterRecords(String query) {
              if (query.isEmpty) {
                setDialogState(() {
                  dialogFilteredRecords = List.from(staffList);
                  dialogShowResults = true;
                });
                return;
              }

              dialogFilteredRecords = staffList.where((record) {
                final searchText = query.toLowerCase();
                return (record.uFirstName?.toString().toLowerCase().contains(
                          searchText,
                        ) ??
                        false) ||
                    (record.uLastName?.toString().toLowerCase().contains(
                          searchText,
                        ) ??
                        false) ||
                    ('${record.uFirstName} ${record.uLastName}'
                        .toLowerCase()
                        .contains(searchText));
              }).toList();

              setDialogState(() {
                dialogShowResults = true;
              });
            }

            return AlertDialog(
              title: Text('Select ${widget.label}'),
              content: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search TextField
                    TextField(
                      controller: dialogSearchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        hintText:
                            "Search by First Name, Last Name, or Full Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Color(0xFF9499A1),
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF2D8FCF),
                        ),
                        suffixIcon: dialogSearchController.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  dialogSearchController.clear();
                                  setDialogState(() {
                                    dialogFilteredRecords = List.from(
                                      staffList,
                                    );
                                    dialogShowResults = true;
                                  });
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Color(0xFF9499A1),
                                ),
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        filterRecords(value);
                      },
                    ),
                    // Results List
                    if (dialogShowResults && dialogFilteredRecords.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: dialogFilteredRecords.length,
                          itemBuilder: (context, index) {
                            final record = dialogFilteredRecords[index];
                            return InkWell(
                              onTap: () {
                                final fullName =
                                    '${record.uFirstName} ${record.uLastName}';
                                setState(() {
                                  selectedStaffName = fullName;
                                });
                                widget.onChanged(record.rKey.toString());
                                Navigator.of(dialogContext).pop();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${record.uFirstName} ${record.uLastName}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF3D475C),
                                      ),
                                    ),
                                    if (index <
                                        dialogFilteredRecords.length - 1)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Divider(
                                          height: 1,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    // No Results Message
                    if (dialogShowResults &&
                        dialogFilteredRecords.isEmpty &&
                        dialogSearchController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          'No matching staff found',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.isFilter ? 22 : 0),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldlabelText('Staff'),
          BlocBuilder(
            bloc: staffBloc,
            builder: (context, state) {
              if (state is StaffLoadingStatus) {
                return const CircularProgressIndicator();
              } else if (state is StaffViewLoadedSuccessStatus) {
                final staff = state.viewStaffModel;
                if (staff.status != 1) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Text(
                        widget.label,
                        style: const TextStyle(
                          color: Color(0xFF3D475C),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey.shade700),
                        ),
                        child: Center(
                          child: Text(
                            staff.message ?? 'No response from server',
                          ),
                        ),
                      ),
                    ],
                  );
                }

                // Set selected staff name if value is provided
                if (selectedStaffName == null &&
                    widget.value != null &&
                    widget.value!.isNotEmpty &&
                    widget.value != 'null' &&
                    staff.record != null) {
                  try {
                    final selectedStaff = staff.record!.firstWhere(
                      (s) => s.rKey.toString() == widget.value,
                    );
                    selectedStaffName =
                        '${selectedStaff.uFirstName} ${selectedStaff.uLastName}';
                  } catch (e) {
                    // Record not found
                  }
                }

                return Container(
                  height: 40,
                  // margin: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () => _showStaffSearchDialog(context, staff.record!),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        // vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF9499A1)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedStaffName ?? 'Select ${widget.label}',
                              style: TextStyle(
                                color: selectedStaffName != null
                                    ? const Color(0xFF3D475C)
                                    : Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF2D8FCF),
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (state is StaffViewLoadedFailureStatus) {
                return Center(child: Text(state.error.toString()));
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
