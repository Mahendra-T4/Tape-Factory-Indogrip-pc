import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class VendorRecord {
  int? sNo;
  String? vCode;
  String? vName;
  String? vMobileNumber;
  String? vGSTIN;
  String? vContactPersonName;
  String? vContactPersonMobile;
  String? vContactPersonAlternate;
  String? vBankAccountName;
  String? vBankAccountNumber;
  String? vBankIFSC;

  VendorRecord({
    this.sNo,
    this.vCode,
    this.vName,
    this.vMobileNumber,
    this.vGSTIN,
    this.vContactPersonName,
    this.vContactPersonMobile,
    this.vContactPersonAlternate,
    this.vBankAccountName,
    this.vBankAccountNumber,
    this.vBankIFSC,
  });
}

class VendorMissRecordDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<VendorRecord> vendorData = [];
  final BuildContext context;

  VendorMissRecordDataSource({
    required this.context,
    required this.vendorData,
  }) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = vendorData.asMap().entries.map<DataGridRow>((entry) {
      final data = entry.value;
      return DataGridRow(
        cells: [
          DataGridCell<String>(columnName: 'Sr No', value: data.sNo.toString()),
          DataGridCell<String>(
            columnName: 'Vendor Code',
            value: data.vCode.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Vendor Name',
            value: data.vName.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Mobile Number',
            value: data.vMobileNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'GSTIN',
            value: data.vGSTIN.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Contact Person',
            value: data.vContactPersonName.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Contact Mobile',
            value: data.vContactPersonMobile.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Alternate Mobile',
            value: data.vContactPersonAlternate.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Bank Account Name',
            value: data.vBankAccountName.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Bank Account Number',
            value: data.vBankAccountNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Bank IFSC',
            value: data.vBankIFSC.toString(),
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
