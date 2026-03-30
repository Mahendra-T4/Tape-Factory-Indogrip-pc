import 'package:flutter/material.dart';
import 'package:indogrip/features/outsource/data/model/tap_miss_record_model.dart';
import 'package:indogrip/features/outsource/data/model/upload_tap_miss_record_model.dart';
import 'package:indogrip/features/tape/data/tape_miss_record_datasource.dart';
import 'package:indogrip/features/tape/presentation/pages/tape-miss-record/tape_miss_record_panel.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../core/utils/widgets/textfield_label.dart';

abstract class TapeMissRecordPanelBuilder extends State<TapeMissRecordPanel> {
  late Map<String, double> columnWidths = {};
  bool isChecked = false;
  final GlobalKey _key = GlobalKey();
  late TapeMissRecordDataSource? _dataSource;
  List<DataGridRow> selectedRows = [];
  final TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    reasonController.text = widget.record.message.toString();
    _dataSource = TapeMissRecordDataSource(
      context: context,
      tapeData: _getMissRecordData(),
    );
  }

  List<TapMissRecord> _getMissRecordData() {
    final List<TapMissRecord> recordList = [];

    if (widget.record.missRecord != null) {
      for (var item in widget.record.missRecord!) {
        recordList.add(item);
      }
    }

    return recordList;
  }

  Widget get buildTableRecordWidget => Expanded(
    child: Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
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
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Sr No')),
        ),
      ),
      GridColumn(
        columnName: 'Reason',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Reason')),
        ),
      ),
      GridColumn(
        columnName: 'Inventory Code',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Inventory Code')),
        ),
      ),
      GridColumn(
        columnName: 'Vendor Key',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Vendor Key')),
        ),
      ),
      GridColumn(
        columnName: 'Date',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Date')),
        ),
      ),
      GridColumn(
        columnName: 'Bill Number',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Bill Number')),
        ),
      ),
      GridColumn(
        columnName: 'Carton Price',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Carton Price')),
        ),
      ),
      GridColumn(
        columnName: 'Transport Amount',
        width: 140,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Transport Amount')),
        ),
      ),
      GridColumn(
        columnName: 'Product Type',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Product Type')),
        ),
      ),
      GridColumn(
        columnName: 'Cut MM Meter',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Cut MM Meter')),
        ),
      ),
      GridColumn(
        columnName: 'Base',
        width: 100,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Base')),
        ),
      ),
      GridColumn(
        columnName: 'Mic',
        width: 100,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Mic')),
        ),
      ),
      GridColumn(
        columnName: 'Tape Length',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Tape Length')),
        ),
      ),
      GridColumn(
        columnName: 'Tape Weight',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Tape Weight')),
        ),
      ),
      GridColumn(
        columnName: 'Stretch Film Size',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Stretch Film Size')),
        ),
      ),
      GridColumn(
        columnName: 'Core ID',
        width: 100,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Core ID')),
        ),
      ),
      GridColumn(
        columnName: 'Net Weight',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Net Weight')),
        ),
      ),
      GridColumn(
        columnName: 'Gross Weight',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Gross Weight')),
        ),
      ),
      GridColumn(
        columnName: 'Quantity',
        width: 100,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Quantity')),
        ),
      ),
      GridColumn(
        columnName: 'Remarks',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Remarks')),
        ),
      ),
    ];
  }
}
