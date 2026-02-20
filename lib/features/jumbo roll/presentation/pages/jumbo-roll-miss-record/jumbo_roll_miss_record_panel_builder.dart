import 'package:flutter/material.dart';
import 'package:indogrip/features/jumbo%20roll/data/jumbo_roll_miss_record_datasource.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/jumbo-roll-miss-record/jumbo_roll_miss_record_panel.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../core/utils/widgets/textfield_label.dart';

abstract class JumboRollMissRecordPanelBuilder
    extends State<JumboRollMissRecordPanel> {
  late Map<String, double> columnWidths = {};
  bool isChecked = false;
  final GlobalKey _key = GlobalKey();
  late JumboRollMissRecordDataSource? _dataSource;
  List<DataGridRow> selectedRows = [];

  @override
  void initState() {
    super.initState();
    _dataSource = JumboRollMissRecordDataSource(
      context: context,
      jumboRollData: _getMissRecordData(),
    );
  }

  List<JumboRollRecord> _getMissRecordData() {
    final List<JumboRollRecord> recordList = [];

    if (widget.missRecord.missRecord != null) {
      recordList.add(
        JumboRollRecord(
          sNo: 1,
          rollCode: widget.missRecord.missRecord!.rollNumber ?? '',
          rollDescription: widget.missRecord.missRecord!.remark ?? '',
          width: widget.missRecord.missRecord!.width?.toString() ?? '',
          length: widget.missRecord.missRecord!.length?.toString() ?? '',
          weight: widget.missRecord.missRecord!.netWeight?.toString() ?? '',
          grammage: widget.missRecord.missRecord!.base?.toString() ?? '',
          supplier: widget.missRecord.missRecord!.vendorKey ?? '',
          batchNumber: widget.missRecord.missRecord!.billNumber ?? '',
          dateReceived: widget.missRecord.missRecord!.billDate ?? '',
          quality: widget.missRecord.missRecord!.msg ?? '',
        ),
      );
    }

    return recordList;
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
        columnName: 'Roll Code',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Roll Number')),
        ),
      ),
      GridColumn(
        columnName: 'Description',
        width: 200,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Remark')),
        ),
      ),
      GridColumn(
        columnName: 'Width (mm)',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Width (mm)')),
        ),
      ),
      GridColumn(
        columnName: 'Length (m)',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Length (m)')),
        ),
      ),
      GridColumn(
        columnName: 'Weight (kg)',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Net Weight')),
        ),
      ),
      GridColumn(
        columnName: 'Grammage (gsm)',
        width: 130,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Base')),
        ),
      ),
      // GridColumn(
      //   columnName: 'Supplier',
      //   width: 180,
      //   label: Container(
      //     color: Colors.grey[100],
      //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
      //     alignment: Alignment.center,
      //     child: const Center(child: TextFieldlabelText('Vendor Key')),
      //   ),
      // ),
      GridColumn(
        columnName: 'Batch Number',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Bill Number')),
        ),
      ),
      GridColumn(
        columnName: 'Date Received',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Bill Date')),
        ),
      ),
      GridColumn(
        columnName: 'Quality',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Error Message')),
        ),
      ),
    ];
  }
}
