import 'dart:core';
import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/features/client/domain/repositories/add_client_repo.dart';

class ClientsSearchableDropdown extends StatefulWidget {
  final String label;
  final String? value;
  final bool isFilter;
  final Function(String?) onChanged;

  const ClientsSearchableDropdown({
    super.key,
    required this.label,
    this.value,
    this.isFilter = false,
    required this.onChanged,
  });

  @override
  State<ClientsSearchableDropdown> createState() =>
      _ClientsSearchableDropdownState();
}

class _ClientsSearchableDropdownState extends State<ClientsSearchableDropdown> {
  String? selectedClientName;

  @override
  void initState() {
    super.initState();
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

                return Padding(
                  padding: EdgeInsets.only(bottom: widget.isFilter ? 22 : 0),
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),

                    child: CustomDropdown<String>(
                      hintText: 'Select client',
                      items: data.record!
                          .map((element) => element.rKey.toString())
                          .toList(),
                      initialItem: widget.value,
                      onChanged: (value) {
                        log('changing value to: $value');
                        widget.onChanged(value);
                      },
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
