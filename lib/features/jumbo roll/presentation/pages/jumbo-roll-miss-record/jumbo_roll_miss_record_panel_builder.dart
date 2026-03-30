import 'package:flutter/material.dart';
import 'package:indogrip/features/jumbo%20roll/data/jumbo_roll_miss_record_datasource.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/jumbo_uploadfile_response_model.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/view_jumbo_roll_model.dart';
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

  List<JumboMissRecord> _getMissRecordData() {
    final List<JumboMissRecord> recordList = [];

    if (widget.missRecord.missRecord != null &&
        widget.missRecord.missRecord!.isNotEmpty) {
      final firstRecord = widget.missRecord.missRecord!.first;
      recordList.add(
        JumboMissRecord(
          msg: firstRecord.msg,
          billDate: firstRecord.billDate,
          billNumber: firstRecord.billNumber,
          rollNumber: firstRecord.rollNumber,
          base: firstRecord.base,
          mic: firstRecord.mic,
          length: firstRecord.length,
          width: firstRecord.width,
          netWeight: firstRecord.netWeight,
          totalSquareMtr: firstRecord.totalSquareMtr,
          amountPerKG: firstRecord.amountPerKG,
          rollCost: firstRecord.rollCost,
          remark: firstRecord.remark,
          rKey: firstRecord.rKey,
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
      GridColumn(
        columnName: 'MIC',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('MIC')),
        ),
      ),
      GridColumn(
        columnName: 'Total Square Meter',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Total Square Meter')),
        ),
      ),
      GridColumn(
        columnName: 'Amount Per KG',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Amount Per KG')),
        ),
      ),
      GridColumn(
        columnName: 'Roll Cost',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Roll Cost')),
        ),
      ),
    ];
  }
}
