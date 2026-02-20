import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RoundRecord {
  int? sNo;
  String? roundCode;
  String? roundDescription;
  String? diameter;
  String? thickness;
  String? weight;
  String? material;
  String? supplier;
  String? batchNumber;
  String? dateReceived;
  String? quality;

  RoundRecord({
    this.sNo,
    this.roundCode,
    this.roundDescription,
    this.diameter,
    this.thickness,
    this.weight,
    this.material,
    this.supplier,
    this.batchNumber,
    this.dateReceived,
    this.quality,
  });
}

class RoundMissRecordDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<RoundRecord> roundData = [];
  final BuildContext context;

  RoundMissRecordDataSource({required this.context, required this.roundData}) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = roundData.asMap().entries.map<DataGridRow>((entry) {
      final data = entry.value;
      return DataGridRow(
        cells: [
          DataGridCell<String>(columnName: 'Sr No', value: data.sNo.toString()),
          DataGridCell<String>(
            columnName: 'Round Code',
            value: data.roundCode.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Description',
            value: data.roundDescription.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Diameter (mm)',
            value: data.diameter.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Thickness (mm)',
            value: data.thickness.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Weight (kg)',
            value: data.weight.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Material',
            value: data.material.toString(),
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
