import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final List<String> columns;
  final List<Map<String, dynamic>> data;
  final bool showCheckbox;
  final List<Map<String, dynamic>> selectedItems;
  final Function(Map<String, dynamic>) onEdit;
  final Function(Map<String, dynamic>) onDelete;
  final Function(Map<String, dynamic>) onProfile;
  final Function(List<Map<String, dynamic>>) onSelectionChanged;
  final bool isMultipleSelection;

  const CustomDataTable({
    Key? key,
    required this.columns,
    required this.data,
    required this.showCheckbox,
    required this.selectedItems,
    required this.onEdit,
    required this.onDelete,
    required this.onProfile,
    required this.onSelectionChanged,
    this.isMultipleSelection = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
            showCheckboxColumn: showCheckbox,
            columns: _buildColumns(),
            rows: _buildRows(),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      if (showCheckbox)
        DataColumn(
          label: Checkbox(
            value: data.length == selectedItems.length && data.isNotEmpty,
            onChanged: (bool? value) {
              if (value == true) {
                onSelectionChanged(List.from(data));
              } else {
                onSelectionChanged([]);
              }
            },
          ),
        ),
      ...columns.map((column) => DataColumn(
            label: Text(
              column,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D475C),
              ),
            ),
          )),
      const DataColumn(label: Text('Actions')),
    ];
  }

  List<DataRow> _buildRows() {
    return data.map((item) {
      bool isSelected = selectedItems.contains(item);
      return DataRow(
        selected: isSelected,
        onSelectChanged: showCheckbox
            ? (bool? selected) {
                if (selected != null) {
                  List<Map<String, dynamic>> newSelection =
                      List.from(selectedItems);
                  if (selected) {
                    if (!isMultipleSelection) {
                      newSelection.clear();
                    }
                    newSelection.add(item);
                  } else {
                    newSelection.remove(item);
                  }
                  onSelectionChanged(newSelection);
                }
              }
            : null,
        cells: _buildCells(item),
      );
    }).toList();
  }

  List<DataCell> _buildCells(Map<String, dynamic> item) {
    return [
      if (showCheckbox)
        DataCell(Checkbox(
          value: selectedItems.contains(item),
          onChanged: (bool? selected) {
            if (selected != null) {
              List<Map<String, dynamic>> newSelection = List.from(selectedItems);
              if (selected) {
                if (!isMultipleSelection) {
                  newSelection.clear();
                }
                newSelection.add(item);
              } else {
                newSelection.remove(item);
              }
              onSelectionChanged(newSelection);
            }
          },
        )),
      ...columns.map((column) => DataCell(
            Text(
              item[column]?.toString() ?? '',
              style: const TextStyle(color: Color(0xFF3D475C)),
            ),
          )),
      DataCell(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
            onPressed: () => onEdit(item),
            tooltip: 'Edit',
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            onPressed: () => onDelete(item),
            tooltip: 'Delete',
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.green, size: 20),
            onPressed: () => onProfile(item),
            tooltip: 'Profile',
          ),
        ],
      )),
    ];
  }
}