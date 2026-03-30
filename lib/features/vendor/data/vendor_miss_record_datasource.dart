import 'package:flutter/material.dart';
import 'package:indogrip/features/vendor/data/models/upload_vendor_button.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class VendorMissRecordDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<VendorMissRecord> vendorData = [];
  final BuildContext context;

  VendorMissRecordDataSource({
    required this.context,
    required this.vendorData,
  }) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = vendorData.asMap().entries.map<DataGridRow>((entry) {
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
            columnName: 'Company Name',
            value: data.vCompanyName.toString(),
          ),
          DataGridCell<String>(
            columnName: 'GSTIN',
            value: data.vGSTIN.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Mobile Number',
            value: data.vMobileNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Alternate Number',
            value: data.vAlternateNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Owner Name',
            value: data.vOwnerName.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Owner Mobile Number',
            value: data.vOwnerMobileNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Owner Alternate Number',
            value: data.vOwnerAlternateNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Representative Name',
            value: data.vRepresentativeName.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Representative Number',
            value: data.vRepresentativeNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Representative Alternate',
            value: data.vRepresentativeAlternate.toString(),
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
