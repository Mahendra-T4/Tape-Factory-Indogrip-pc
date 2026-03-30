import 'package:flutter/material.dart';
import 'package:indogrip/features/round/data/models/upload_round_record_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RoundMissRecordDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<RoundMissRecord> roundData = [];
  final BuildContext context;

  RoundMissRecordDataSource({required this.context, required this.roundData}) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = roundData.asMap().entries.map<DataGridRow>((entry) {
      final index = entry.key;
      final data = entry.value;
      return DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: 'Sr No',
            value: (index + 1).toString(),
          ),
          DataGridCell<String>(
            columnName: 'Reason',
            value: data.msg?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Bill Date',
            value: data.billDate?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Bill Number',
            value: data.billNumber?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Roll Number',
            value: data.rollNumber?.toString() ?? '',
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
            columnName: 'Length',
            value: data.length?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Width',
            value: data.width?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Net Weight',
            value: data.netWeight?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Total Square Mtr',
            value: data.totalSquareMtr?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Amount Per KG',
            value: data.amountPerKG?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Roll Cost',
            value: data.rollCost?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Remark',
            value: data.remark?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: 'R Key',
            value: data.rKey?.toString() ?? '',
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
