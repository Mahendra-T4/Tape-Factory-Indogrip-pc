import 'package:flutter/material.dart';
import 'package:indogrip/features/outsource/data/model/tap_miss_record_model.dart';
import 'package:indogrip/features/outsource/data/model/upload_tap_miss_record_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TapeMissRecordDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<TapMissRecord> tapeData = [];
  final BuildContext context;

  TapeMissRecordDataSource({required this.context, required this.tapeData}) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = tapeData.asMap().entries.map<DataGridRow>((entry) {
      final data = entry.value;
      final index = entry.key + 1; // To start Sr No from 1 instead of 0
      return DataGridRow(
        cells: [
          DataGridCell<String>(columnName: 'Sr No', value: index.toString()),
          DataGridCell<String>(
            columnName: 'Reason',
            value: data.reason?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Inventory Code',
            value: data.inventoryCode?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Vendor Key',
            value: data.vendorKey?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Date',
            value: data.date?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Bill Number',
            value: data.billNumber?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Carton Price',
            value: data.cartonPrice?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Transport Amount',
            value: data.transportAmount?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Product Type',
            value: data.productType?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Cut MM Meter',
            value: data.cutMMMeter?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Base',
            value: data.base?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Mic',
            value: data.mic?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Tape Length',
            value: data.tapeLength?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Tape Weight',
            value: data.tapeWeight?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Stretch Film Size',
            value: data.stretchFilmSize?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Core ID',
            value: data.coreID?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Net Weight',
            value: data.netWeight?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Gross Weight',
            value: data.grossWeight?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Quantity',
            value: data.quantity?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Remarks',
            value: data.remarks?.toString() ?? '',
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
      cells: row.getCells().map<Widget>((cell) {
        if (cell.value is Widget) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: cell.value as Widget,
          );
        }

        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SelectableText(
            cell.value?.toString() ?? '',
            maxLines: 1,
            toolbarOptions: const ToolbarOptions(copy: true, selectAll: true),
          ),
        );
      }).toList(),
    );
  }
}
