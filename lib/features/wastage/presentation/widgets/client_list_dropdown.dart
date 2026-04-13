import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/features/client/domain/repositories/add_client_repo.dart';

class ClientsListDropdown extends StatefulWidget {
  final String label;
  final String? value;
  final bool isFilter;
  final Function(String?) onChanged;

  const ClientsListDropdown({
    super.key,
    required this.label,
    this.value,
    this.isFilter = false,
    required this.onChanged,
  });

  @override
  State<ClientsListDropdown> createState() => _ClientsListDropdownState();
}

class _ClientsListDropdownState extends State<ClientsListDropdown> {
  String? selectedClientName;

  @override
  void initState() {
    super.initState();
  }

  void _showClientSearchDialog(BuildContext context, List<dynamic> clients) {
    TextEditingController dialogSearchController = TextEditingController();
    List<dynamic> dialogFilteredRecords = List.from(clients);
    bool dialogShowResults = false;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            void filterRecords(String query) {
              if (query.isEmpty) {
                setDialogState(() {
                  dialogFilteredRecords = List.from(clients);
                  dialogShowResults = true;
                });
                return;
              }

              dialogFilteredRecords = clients.where((record) {
                final searchText = query.toLowerCase();
                return (record.cConsigneeName
                            ?.toString()
                            .toLowerCase()
                            .contains(searchText) ??
                        false) ||
                    (record.cCode?.toString().toLowerCase().contains(
                          searchText,
                        ) ??
                        false) ||
                    (record.cOwnerName?.toString().toLowerCase().contains(
                          searchText,
                        ) ??
                        false) ||
                    (record.cMobileNumber?.toString().toLowerCase().contains(
                          searchText,
                        ) ??
                        false);
              }).toList();

              setDialogState(() {
                dialogShowResults = true;
              });
            }

            return AlertDialog(
              title: Text(widget.label),
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
                            "Search by Consignee Name, Code, Owner Name, or Mobile",
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
                                    dialogFilteredRecords = List.from(clients);
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
                      onTap: () {
                        if (dialogSearchController.text.isEmpty) {
                          setDialogState(() {
                            dialogFilteredRecords = List.from(clients);
                            dialogShowResults = true;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    // Results List
                    if (dialogShowResults && dialogFilteredRecords.isNotEmpty)
                      Container(
                        constraints: const BoxConstraints(maxHeight: 300),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: dialogFilteredRecords.length,
                          itemBuilder: (context, index) {
                            final record = dialogFilteredRecords[index];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedClientName =
                                      record.cConsigneeName ?? '';
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
                                      record.cConsigneeName ?? '',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF3D475C),
                                      ),
                                    ),
                                    if (record.cCode != null &&
                                        record.cCode!.isNotEmpty)
                                      Text(
                                        'Code: ${record.cCode}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
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
                          'No matching clients found',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldlabelText(widget.label),
        Consumer(
          builder: (context, ref, child) {
            final cListProvider = ref.watch(viewClientsListProvider);
            return cListProvider.when(
              data: (data) {
                if (data.status != 1) {
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
                            data.message ?? 'No response from server',
                          ),
                        ),
                      ),
                    ],
                  );
                }

                // Set selected client name if value is provided
                if (selectedClientName == null &&
                    widget.value != null &&
                    widget.value!.isNotEmpty &&
                    widget.value != 'null' &&
                    data.record != null) {
                  try {
                    final selectedClient = data.record!.firstWhere(
                      (client) => client.rKey.toString() == widget.value,
                    );
                    selectedClientName = selectedClient.cConsigneeName ?? '';
                  } catch (e) {
                    // Record not found
                  }
                }

                return Padding(
                  padding: EdgeInsets.only(bottom: widget.isFilter ? 22 : 0),
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),

                    child: InkWell(
                      onTap: () =>
                          _showClientSearchDialog(context, data.record!),
                      child: Container(
                        height: 40,
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
                                selectedClientName ?? 'Select ${widget.label}',
                                style: TextStyle(
                                  color: selectedClientName != null
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
                  ),
                );
              },
              error: (error, stackTrace) =>
                  Center(child: Text('Error loading clients: $error')),
              loading: () => const CircularProgressIndicator(),
            );
          },
        ),
      ],
    );
  }
}
