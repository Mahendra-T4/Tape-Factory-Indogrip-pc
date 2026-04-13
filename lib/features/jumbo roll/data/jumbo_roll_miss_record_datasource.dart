import 'package:flutter/material.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/jumbo_uploadfile_response_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class JumboRollMissRecordDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<JumboMissRecord> jumboRollData = [];
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
      final index = entry.key;
      return DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: 'Sr No',
            value: (index + 1).toString(),
          ),
          DataGridCell<String>(
            columnName: 'Roll Code',
            value: data.rollNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Roll Cost',
            value: data.rollCost.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Reason',
            value: data.msg.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Bill Date',
            value: data.billDate.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Bill Number',
            value: data.billNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Roll Number',
            value: data.rollNumber.toString(),
          ),
          DataGridCell<String>(columnName: 'Base', value: data.base.toString()),
          DataGridCell<String>(columnName: 'MIC', value: data.mic.toString()),
          DataGridCell<String>(
            columnName: 'Length',
            value: data.length.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Width',
            value: data.width.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Net Weight',
            value: data.netWeight.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Total Square Meter',
            value: data.totalSquareMtr.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Amount Per KG',
            value: data.amountPerKG.toString(),
          ),

          DataGridCell<String>(
            columnName: 'Remark',
            value: data.remark.toString(),
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
