import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DropdownItem {
  final String id;
  final String name;

  DropdownItem({required this.id, required this.name});
}

class CustomDropdownWidget extends ConsumerWidget {
  final String? value;
  final Function(String?) onChanged;
  final String? label;

  const CustomDropdownWidget({
    Key? key,
    required this.value,
    required this.onChanged,
    this.label,
  }) : super(key: key);

  static List<DropdownItem> dataList = [
    DropdownItem(id: '1', name: 'Length'),
    DropdownItem(id: '2', name: 'Width'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (label != null && label != '')
          Text(
            label.toString(),
            style: TextStyle(
              color: Color(0xFF3D475C),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

        Container(
          margin: const EdgeInsets.only(top: 10),
          child: DropdownButtonFormField<String>(
            value:
                value != null && (dataList.any((r) => r.id.toString() == value))
                ? value
                : null,
            items: dataList
                .map(
                  (record) => DropdownMenuItem(
                    value: record.id.toString(),
                    child: Text(record.name),
                  ),
                )
                .toList(),

            onChanged: onChanged,
            hint: Text('-Select Panel-'),
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) => value == null ? 'Please select City' : null,
          ),
        ),
      ],
    );
  }
}
