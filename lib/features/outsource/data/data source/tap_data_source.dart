import 'package:flutter/material.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/features/outsource/data/model/view_tap_in_model.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Tap {
  static final String srNo = 'Sr No';
  static final String productType = 'Product Type';
  static final String date = 'Date';
  static final String vendorName = 'Vendor Name';
  static final String billDate = 'Bill Date';
  static final String cartonPrice = 'Carton Price';
  static final String transportPrice = 'Transport Price';
  static final String totalPrice = 'Total Price';
  static final String cutMMMeter = 'Cut MM Meter';
  static final String roundMeter = 'Round Meter';
  static final String base = 'Base';
  static final String micLabel = 'Micron';
  static final String quantity = 'Quantity';
  static final String tapWeight = 'Tape Weight';
  static final String inventoryCode = 'Serial Number';
  static final String remark = 'Remark';
  // static final String billNuinventoryStatusLabelmber = 'Bill Number';
  static final String inventoryStatusLabel = 'Inventory Status';
}

class TapDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<TapRecord> TapData = [];
  bool isAllChecked;

  final Function(bool) onStatusChanged;
  final Function(bool, int) onCheckboxChanged;
  final Function(TapRecord) onEdit;
  // final Function() onDelete;
  final Function(TapRecord) printLabel;
  // final Function() onProfile;
  final void Function(String?, TapRecord) onChanged;

  TapDataSource({
    required this.TapData,
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
  }

  void buildDataGridRows() {
    dataGridRows = TapData.asMap().entries.map<DataGridRow>((entry) {
      final data = entry.value;
      // final index = entry.key;
      return DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: Tap.srNo,
            value: data.sNo.toString(),
          ),
          DataGridCell<String>(
            columnName: Tap.inventoryCode,
            value: data.inventoryCode,
          ),
          DataGridCell<String>(columnName: Tap.date, value: data.recordDate),

          DataGridCell<String>(
            columnName: Tap.vendorName,
            value: data.vendorInfo!.companyName ?? '',
          ),
          DataGridCell<String>(columnName: Tap.billDate, value: data.billDate),
          DataGridCell<String>(
            columnName: Tap.cartonPrice,
            value: data.cartonPrice.toString(),
          ),
          DataGridCell<String>(
            columnName: Tap.transportPrice,
            value: data.transportPrice.toString(),
          ),
          DataGridCell<String>(
            columnName: Tap.totalPrice,
            value: (data.cartonPrice! + data.transportPrice!).toString(),
          ),
          DataGridCell<String>(
            columnName: Tap.cutMMMeter,
            value: data.additionalInfo?.cutMMMeter.toString(),
          ),
          DataGridCell<String>(
            columnName: Tap.roundMeter,
            value: data.additionalInfo!.tapeLength.toString(),
          ),
          DataGridCell<String>(
            columnName: Tap.micLabel,
            value: data.additionalInfo!.micLabel.toString(),
          ),
          DataGridCell<String>(
            columnName: Tap.base,
            value: data.additionalInfo!.baseLabel.toString(),
          ),
          DataGridCell<String>(
            columnName: Tap.tapWeight,
            value: data.additionalInfo!.tapeWeight.toString(),
          ),
          DataGridCell<String>(
            columnName: Tap.quantity,
            value: data.quantity.toString(),
          ),
          DataGridCell<String>(columnName: Tap.remark, value: data.remark),
          DataGridCell<String>(
            columnName: Tap.inventoryStatusLabel,
            value: data.inventoryStatusLabel,
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
    int rowIndex = dataGridRows.indexOf(row);
    Color? rowBackgroundColor;
    try {
      final statusCell = row.getCells().firstWhere(
        (cell) => cell.columnName == Tap.inventoryStatusLabel,
      );
      final statusText = statusCell.value?.toString().toLowerCase() ?? '';
      if (statusText.contains('out')) {
        rowBackgroundColor = Colors.red;
      } else if (statusText.contains('in')) {
        rowBackgroundColor = Colors.white;
      }
    } catch (e) {
      rowBackgroundColor = null;
    }

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == Tap.inventoryStatusLabel) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            color: rowBackgroundColor,
            child: cell.value is Widget
                ? cell.value as Widget
                : Text(cell.value.toString(), overflow: TextOverflow.ellipsis),
          );
        }
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

  Widget _buildActionButtons(TapRecord Tap) {
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
