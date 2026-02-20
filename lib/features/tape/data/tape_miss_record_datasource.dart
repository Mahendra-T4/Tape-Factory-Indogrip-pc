import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TapeRecord {
  int? sNo;
  String? tapeCode;
  String? tapeType;
  String? width;
  String? length;
  String? thickness;
  String? adhesiveType;
  String? supplier;
  String? batchNumber;
  String? dateReceived;
  String? quality;

  TapeRecord({
    this.sNo,
    this.tapeCode,
    this.tapeType,
    this.width,
    this.length,
    this.thickness,
    this.adhesiveType,
    this.supplier,
    this.batchNumber,
    this.dateReceived,
    this.quality,
  });
}

class TapeMissRecordDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<TapeRecord> tapeData = [];
  final BuildContext context;

  TapeMissRecordDataSource({required this.context, required this.tapeData}) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = tapeData.asMap().entries.map<DataGridRow>((entry) {
      final data = entry.value;
      return DataGridRow(
        cells: [
          DataGridCell<String>(columnName: 'Sr No', value: data.sNo.toString()),
          DataGridCell<String>(
            columnName: 'Tape Code',
            value: data.tapeCode.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Tape Type',
            value: data.tapeType.toString(),
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
            columnName: 'Thickness (microns)',
            value: data.thickness.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Adhesive Type',
            value: data.adhesiveType.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Supplier',
            value: data.supplier.toString(),
          ),
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
