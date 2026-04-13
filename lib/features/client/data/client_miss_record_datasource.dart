import 'package:flutter/material.dart';
import 'package:indogrip/features/client/data/model/upload_client_model.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ClientMIssRecordDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<ClientMissRecord> clientData = [];
  final BuildContext context;

  ClientMIssRecordDataSource({
    required this.context,
    required this.clientData,
  }) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = clientData.asMap().entries.map<DataGridRow>((entry) {
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
            value: data.reason.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Consignee Name',
            value: data.cConsigneeName.toString(),
          ),
          DataGridCell<String>(
            columnName: 'GSTIN',
            value: data.cGSTIN.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Unit One',
            value: data.cUnitOne..toString(),
          ),
          DataGridCell<String>(
            columnName: 'Unit Two',
            value: data.cUnitTwo.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Unit Three',
            value: data.cUnitThree.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Unit Four',
            value: data.cUnitFour.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Unit Five',
            value: data.cUnitFive.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Mobile Number',
            value: data.cMobileNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Alternate Number',
            value: data.cAlternateNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Owner Name',
            value: data.cOwnerName.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Owner Mobile',
            value: data.cOwnerMobileNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Owner Alternate Mobile',
            value: data.cOwnerAlternateNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Purchase Manager',
            value: data.cPurchaseManagerName.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Manager Mobile',
            value: data.cPurchaseManagerNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Manager Alternate Mobile',
            value: data.cPurchaseManagerAlternateNumber.toString(),
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
        // If the DataGridCell holds a Widget (for example the Status dropdown
        // or action buttons), render it directly. Otherwise fall back to text.
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
