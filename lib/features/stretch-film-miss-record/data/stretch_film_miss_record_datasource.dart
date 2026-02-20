import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class StretchFilmRecord {
  int? sNo;
  String? filmCode;
  String? filmType;
  String? width;
  String? length;
  String? thickness;
  String? material;
  String? stretchPercentage;
  String? supplier;
  String? batchNumber;
  String? dateReceived;
  String? quality;

  StretchFilmRecord({
    this.sNo,
    this.filmCode,
    this.filmType,
    this.width,
    this.length,
    this.thickness,
    this.material,
    this.stretchPercentage,
    this.supplier,
    this.batchNumber,
    this.dateReceived,
    this.quality,
  });
}

class StretchFilmMissRecordDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<StretchFilmRecord> stretchFilmData = [];
  final BuildContext context;

  StretchFilmMissRecordDataSource({
    required this.context,
    required this.stretchFilmData,
  }) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = stretchFilmData.asMap().entries.map<DataGridRow>((entry) {
      final data = entry.value;
      return DataGridRow(
        cells: [
          DataGridCell<String>(columnName: 'Sr No', value: data.sNo.toString()),
          DataGridCell<String>(
            columnName: 'Film Code',
            value: data.filmCode.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Film Type',
            value: data.filmType.toString(),
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
            columnName: 'Material',
            value: data.material.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Stretch (%)',
            value: data.stretchPercentage.toString(),
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
