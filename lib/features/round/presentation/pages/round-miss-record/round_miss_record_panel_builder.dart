import 'package:flutter/material.dart';
import 'package:indogrip/features/round/data/models/upload_round_record_model.dart';
import 'package:indogrip/features/round/data/round_miss_record_datasource.dart';
import 'package:indogrip/features/round/presentation/pages/round-miss-record/round_miss_record_panel.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../core/utils/widgets/textfield_label.dart';

abstract class RoundMissRecordPanelBuilder extends State<RoundMissRecordPanel> {
  late Map<String, double> columnWidths = {};
  bool isChecked = false;
  final GlobalKey _key = GlobalKey();
  late RoundMissRecordDataSource? _dataSource;
  List<DataGridRow> selectedRows = [];
  final TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    reasonController.text = widget.record.message.toString();
    _dataSource = RoundMissRecordDataSource(
      context: context,
      roundData: _getMissRecordData(),
    );
  }

  List<RoundMissRecord> _getMissRecordData() {
    final List<RoundMissRecord> recordList = [];

    if (widget.record.missRecord != null) {
      recordList.add(
        RoundMissRecord(
          msg: widget.record.missRecord!.msg,
          billDate: widget.record.missRecord!.billDate,
          billNumber: widget.record.missRecord!.billNumber,
          rollNumber: widget.record.missRecord!.rollNumber,
          base: widget.record.missRecord!.base,
          mic: widget.record.missRecord!.mic,
          length: widget.record.missRecord!.length,
          width: widget.record.missRecord!.width,
          netWeight: widget.record.missRecord!.netWeight,
          totalSquareMtr: widget.record.missRecord!.totalSquareMtr,
          amountPerKG: widget.record.missRecord!.amountPerKG,
          rollCost: widget.record.missRecord!.rollCost,
          remark: widget.record.missRecord!.remark,
          rKey: widget.record.missRecord!.rKey,
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
        columnName: 'Reason',
        width: 450,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Reason')),
        ),
      ),
      GridColumn(
        columnName: 'Bill Date',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Bill Date')),
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
        columnName: 'Roll Number',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Roll Number')),
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
        columnName: 'Length',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Length')),
        ),
      ),
      GridColumn(
        columnName: 'Width',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Width')),
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
        columnName: 'Total Square Mtr',
        width: 140,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Total Square Mtr')),
        ),
      ),
      GridColumn(
        columnName: 'Amount Per KG',
        width: 120,
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
      GridColumn(
        columnName: 'Remark',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Remark')),
        ),
      ),
      GridColumn(
        columnName: 'R Key',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('R Key')),
        ),
      ),
    ];
  }
}
