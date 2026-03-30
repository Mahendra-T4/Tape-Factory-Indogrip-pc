import 'package:flutter/material.dart';
import 'package:indogrip/features/vendor/data/models/upload_vendor_button.dart';
import 'package:indogrip/features/vendor/data/vendor_miss_record_datasource.dart';
import 'package:indogrip/features/vendor/presentation/pages/vendor-miss-record/vendor_miss_record_panel.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../core/utils/widgets/textfield_label.dart';

abstract class VendorMissRecordPanelBuilder
    extends State<VendorMissRecordPanel> {
  late Map<String, double> columnWidths = {};
  bool isChecked = false;
  final GlobalKey _key = GlobalKey();
  late VendorMissRecordDataSource? _dataSource;
  List<DataGridRow> selectedRows = [];
  final TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    reasonController.text = widget.record.message.toString();
    _dataSource = VendorMissRecordDataSource(
      context: context,
      vendorData: getDummyVendorData(),
    );
  }

  List<VendorMissRecord> getDummyVendorData() {
    final List<VendorMissRecord> vendorList = [];
    for (var item in widget.record.missRecord!) {
      vendorList.add(item);
      // reasonController.text = item.reason ?? '';
    }
    return vendorList;
  }

  Widget get buildTableRecordWidget => Expanded(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: SfDataGrid(
        showHorizontalScrollbar: true,
        key: _key,
        rowsPerPage: 4,
        allowPullToRefresh: true,
        allowColumnsResizing: true,
        columnResizeMode: ColumnResizeMode.onResizeEnd,
        isScrollbarAlwaysShown: true,
        showVerticalScrollbar: true,
        onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
          setState(() {
            columnWidths[details.column.columnName] = details.width;
          });
          return true;
        },
        source: _dataSource!,
        columns: buildGridColumns(),
      ),
    ),
  );

  List<GridColumn> buildGridColumns() {
    return [
      GridColumn(
        columnName: 'Sr No',
        columnWidthMode: ColumnWidthMode.fitByCellValue,
        width: 70,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Sr No')),
        ),
      ),
      GridColumn(
        columnName: 'Reason',
        width: 250,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Reason')),
        ),
      ),
      GridColumn(
        columnName: 'Company Name',
        width: 250,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Company Name')),
        ),
      ),
      GridColumn(
        columnName: 'GSTIN',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('GSTIN')),
        ),
      ),
      GridColumn(
        columnName: 'Mobile Number',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Mobile Number')),
        ),
      ),
      GridColumn(
        columnName: 'Alternate Number',
        width: 160,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Alternate Number')),
        ),
      ),
      GridColumn(
        columnName: 'Owner Name',
        width: 180,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Owner Name')),
        ),
      ),
      GridColumn(
        columnName: 'Owner Mobile Number',
        width: 180,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Owner Mobile Number')),
        ),
      ),
      GridColumn(
        columnName: 'Owner Alternate Number',
        width: 180,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(
            child: TextFieldlabelText('Owner Alternate Number'),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Representative Name',
        width: 200,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Representative Name')),
        ),
      ),
      GridColumn(
        columnName: 'Representative Number',
        width: 180,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(
            child: TextFieldlabelText('Representative Number'),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Representative Alternate',
        width: 200,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(
            child: TextFieldlabelText('Representative Alternate'),
          ),
        ),
      ),
    ];
  }
}
