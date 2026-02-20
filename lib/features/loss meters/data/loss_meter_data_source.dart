import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LossMeterDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<Map<String, dynamic>> lossMeterData = [];
  bool isAllChecked;
  final Function(bool) onStatusChanged;
  final Function(bool, int) onCheckboxChanged;
  final Function(Map<String, dynamic>) onEdit;
  final Function(Map<String, dynamic>) onDelete;
  final Function(Map<String, dynamic>) onProfile;

  LossMeterDataSource({
    required List<Map<String, dynamic>> lossMeterData,
    required this.isAllChecked,
    required this.onStatusChanged,
    required this.onCheckboxChanged,
    required this.onEdit,
    required this.onDelete,
    required this.onProfile,
  }) {
    this.lossMeterData = lossMeterData;
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows =
        lossMeterData.asMap().entries.map<DataGridRow>((entry) {
          final data = entry.value;
          return DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: 'Sr No',
                value: data['Sr No'].toString(),
              ),
              DataGridCell<String>(
                columnName: 'Jumbo Roll',
                value: data['Jumbo Roll'].toString(),
              ),
              DataGridCell<String>(
                columnName: 'Total Consume Meter',
                value: data['Total Consume Meter'].toString(),
              ),
              DataGridCell<String>(
                columnName: 'Total Receive Meter',
                value: data['Total Receive Meter'].toString(),
              ),
              DataGridCell<String>(
                columnName: 'Loss Meters',
                value: data['Loss Meters'].toString(),
              ),
              DataGridCell<Widget>(
                columnName: 'actions',
                value: _buildActionButtons(data),
              ),
            ],
          );
        }).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells:
          row.getCells().map<Widget>((cell) {
            if (cell.columnName == 'actions') {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: cell.value as Widget,
              );
            }
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                cell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> lossMeter) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 120),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 35,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.edit, size: 18),
              onPressed: () => onEdit(lossMeter),
              constraints: const BoxConstraints(),
            ),
          ),
          SizedBox(
            width: 35,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.delete, size: 18),
              onPressed: () => onDelete(lossMeter),
              constraints: const BoxConstraints(),
            ),
          ),
          SizedBox(
            width: 35,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.person, size: 18),
              onPressed: () => onProfile(lossMeter),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
