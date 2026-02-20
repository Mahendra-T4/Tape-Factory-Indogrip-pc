import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class JumboRollRecord {
  int? sNo;
  String? rollCode;
  String? rollDescription;
  String? width;
  String? length;
  String? weight;
  String? grammage;
  String? supplier;
  String? batchNumber;
  String? dateReceived;
  String? quality;

  JumboRollRecord({
    this.sNo,
    this.rollCode,
    this.rollDescription,
    this.width,
    this.length,
    this.weight,
    this.grammage,
    this.supplier,
    this.batchNumber,
    this.dateReceived,
    this.quality,
  });
}

class JumboRollMissRecordDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<JumboRollRecord> jumboRollData = [];
  final BuildContext context;

  JumboRollMissRecordDataSource({
    required this.context,
    required this.jumboRollData,
  }) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = jumboRollData.asMap().entries.map<DataGridRow>((entry) {
      final data = entry.value;
      return DataGridRow(
        cells: [
          DataGridCell<String>(columnName: 'Sr No', value: data.sNo.toString()),
          DataGridCell<String>(
            columnName: 'Roll Code',
            value: data.rollCode.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Description',
            value: data.rollDescription.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Width (mm)',
            value: data.width.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Length (m)',
            value: data.length.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Weight (kg)',
            value: data.weight.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Grammage (gsm)',
            value: data.grammage.toString(),
          ),
          // DataGridCell<String>(
          //   columnName: 'Supplier',
          //   value: data.supplier.toString(),
          // ),
          DataGridCell<String>(
            columnName: 'Batch Number',
            value: data.batchNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Date Received',
            value: data.dateReceived.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Quality',
            value: data.quality.toString(),
          ),
          // DataGridCell<String>(columnName: 'Status', value: 'Active'),
          // DataGridCell<String>(columnName: 'actions', value: 'Edit'),
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
