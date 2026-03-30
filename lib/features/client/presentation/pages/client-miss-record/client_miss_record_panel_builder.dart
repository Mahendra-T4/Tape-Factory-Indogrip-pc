import 'package:flutter/material.dart';
import 'package:indogrip/features/client/data/client_miss_record_datasource.dart';
import 'package:indogrip/features/client/data/model/upload_client_model.dart';
import 'package:indogrip/features/client/data/model/view_staff_modeld.dart';
import 'package:indogrip/features/client/presentation/pages/client-miss-record/client_miss_record_panel.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../core/utils/widgets/textfield_label.dart';

abstract class ClientMissRecordPanelBuilder
    extends State<ClientMissRecordPanel> {
  late Map<String, double> columnWidths = {};
  bool isChecked = false;
  final GlobalKey _key = GlobalKey();
  late ClientMIssRecordDataSource? _dataSource;
  List<DataGridRow> selectedRows = [];

  final TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    reasonController.text = widget.record.message.toString();
    _dataSource = ClientMIssRecordDataSource(
      context: context,
      clientData: getDummyClientData(),
    );
  }

  List<ClientMissRecord> getDummyClientData() {
    final List<ClientMissRecord> clientList = [];

    for (var item in widget.record.missRecord!) {
      clientList.add(item);
    }
    return clientList;
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
        width: 300,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Reason')),
        ),
      ),
      GridColumn(
        columnName: 'Consignee Name',
        width: 300,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Consignee Name')),
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
        columnName: 'Unit One',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Unit One')),
        ),
      ),
      GridColumn(
        columnName: 'Unit Two',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Unit Two')),
        ),
      ),
      GridColumn(
        columnName: 'Unit Three',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Unit Three')),
        ),
      ),
      GridColumn(
        columnName: 'Unit Four',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Unit Four')),
        ),
      ),
      GridColumn(
        columnName: 'Unit Five',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Unit Five')),
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
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Alternate Number')),
        ),
      ),
      GridColumn(
        columnName: 'Owner Name',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Owner Name')),
        ),
      ),
      GridColumn(
        columnName: 'Owner Mobile',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Owner Mobile')),
        ),
      ),
      GridColumn(
        columnName: 'Owner Alternate Mobile',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(
            child: TextFieldlabelText('Owner Alternate Mobile'),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Purchase Manager',
        width: 200,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Purchase Manager')),
        ),
      ),
      GridColumn(
        columnName: 'Manager Mobile',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Manager Mobile')),
        ),
      ),
      GridColumn(
        columnName: 'Manager Alternate Mobile',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(
            child: TextFieldlabelText('Manager Alternate Mobile'),
          ),
        ),
      ),
    ];
  }
}
