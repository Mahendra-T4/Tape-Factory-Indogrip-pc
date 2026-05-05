import 'package:flutter/material.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/features/outsource/data/model/view_tap_in_model.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class StripData {
  final String sNo;
  final String vendorName;
  final String billDate;
  final String billNumber;
  final String serialNumber;
  final dynamic cost;
  final dynamic transportPrice;
  final dynamic margin;
  final dynamic grossWeight;
  final String remark;

  StripData({
    required this.sNo,
    required this.vendorName,
    required this.billDate,
    required this.billNumber,
    required this.serialNumber,
    required this.cost,
    required this.transportPrice,
    required this.margin,
    required this.grossWeight,
    required this.remark,
  });
}

class Strip {
  static final String srNo = 'Sr No';

  static final String vendorName = 'Vendor Name';
  static final String billDate = 'Bill Date';
  static final String billNumber = 'Bill Number';
  static final String transportPrice = 'Transport Price';
  static final String cost = 'Cost';
  static final String margin = 'Margin';
  static final String grossWeight = 'Gross Weight';

  static final String serialNumber = 'Serial Number';
  static final String remark = 'Remark';
}

class StripDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<StripData> stripData = [];
  bool isAllChecked;

  final Function(bool) onStatusChanged;
  final Function(bool, int) onCheckboxChanged;
  final Function(StripData) onEdit;
  // final Function() onDelete;
  final Function(StripData) printLabel;
  // final Function() onProfile;
  final void Function(String?, StripData) onChanged;

  int? _highlightedRowIndex;
  int? get highlightedRowIndex => _highlightedRowIndex;
  set highlightedRowIndex(int? value) {
    _highlightedRowIndex = value;
    notifyListeners();
  }

  StripDataSource({
    required this.stripData,
    required this.isAllChecked,

    required this.onStatusChanged,
    required this.onCheckboxChanged,
    required this.onEdit,
    required this.printLabel,
    // required this.onDelete,
    // required this.onProfile,
    required this.onChanged,
  }) {
    buildDataGridRows();
    _highlightedRowIndex = highlightedRowIndex;
  }

  void buildDataGridRows() {
    dataGridRows = stripData.asMap().entries.map<DataGridRow>((entry) {
      final data = entry.value;
      // final index = entry.key;
      return DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: Strip.srNo,
            value: data.sNo.toString(),
          ),
          DataGridCell<String>(
            columnName: Strip.vendorName,
            value: data.vendorName,
          ),
          DataGridCell<String>(
            columnName: Strip.billDate,
            value: data.billDate,
          ),

          DataGridCell<String>(
            columnName: Strip.billNumber,
            value: data.billNumber,
          ),

          DataGridCell<String>(
            columnName: Strip.serialNumber,
            value: data.serialNumber,
          ),
          DataGridCell<String>(
            columnName: Strip.transportPrice,
            value: data.transportPrice.toString(),
          ),
          DataGridCell<String>(
            columnName: Strip.cost,
            value: data.cost.toString(),
          ),

          DataGridCell<String>(
            columnName: Strip.margin,
            value: data.margin.toString(),
          ),
          DataGridCell<String>(
            columnName: Strip.grossWeight,
            value: data.grossWeight.toString(),
          ),

          DataGridCell<String>(columnName: Strip.remark, value: data.remark),

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
    int rowIndex = dataGridRows.indexOf(row);
    Color? rowBackgroundColor;

    final isHighlighted = _highlightedRowIndex == rowIndex;
    // try {
    //   final statusCell = row.getCells().firstWhere(
    //     (cell) => cell.columnName == Silica.inventoryStatusLabel,
    //   );
    //   final statusText = statusCell.value?.toString().toLowerCase() ?? '';
    //   if (statusText.contains('out')) {
    //     rowBackgroundColor = Colors.red;
    //   } else if (statusText.contains('in')) {
    //     rowBackgroundColor = Colors.white;
    //   }
    // } catch (e) {
    //   rowBackgroundColor = null;
    // }

    if (isHighlighted) {
      rowBackgroundColor = Colors.deepPurple.withOpacity(0.2);
    }

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        // if (cell.columnName == Silica.inventoryStatusLabel) {
        //   return Container(
        //     alignment: Alignment.center,
        //     padding: const EdgeInsets.symmetric(horizontal: 4),
        //     color: rowBackgroundColor,
        //     child: cell.value is Widget
        //         ? cell.value as Widget
        //         : Text(cell.value.toString(), overflow: TextOverflow.ellipsis),
        //   );
        // }
        if (cell.columnName == 'actions') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            color: rowBackgroundColor,
            child: cell.value as Widget,
          );
        }
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: rowBackgroundColor,
          child: SelectableText(
            cell.value?.toString() ?? '',
            maxLines: 1,
            toolbarOptions: const ToolbarOptions(copy: true, selectAll: true),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(StripData Tap) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 120),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (HiveService.getRole() != '2')
            SizedBox(
              width: 40,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () => onEdit(Tap),
                constraints: const BoxConstraints(),
              ),
            ),
          SizedBox(
            width: 40,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.label, size: 18),
              onPressed: () => printLabel(Tap),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
