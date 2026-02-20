import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _dataSource = TapeMissRecordDataSource(
      context: context,
      tapeData: getDummyTapeData(),
    );
  }

  List<TapeRecord> getDummyTapeData() {
    return [
      TapeRecord(
        sNo: 1,
        tapeCode: 'TP001',
        tapeType: 'Packing Tape',
        width: '50',
        length: '100',
        thickness: '45',
        adhesiveType: 'Acrylic',
        supplier: 'ABC Tape Industries',
        batchNumber: 'BATCH001',
        dateReceived: '2024-01-15',
        quality: 'A Grade',
      ),
      TapeRecord(
        sNo: 2,
        tapeCode: 'TP002',
        tapeType: 'Masking Tape',
        width: '24',
        length: '50',
        thickness: '35',
        adhesiveType: 'Natural Rubber',
        supplier: 'Global Tape Co',
        batchNumber: 'BATCH002',
        dateReceived: '2024-01-16',
        quality: 'A Grade',
      ),
      TapeRecord(
        sNo: 3,
        tapeCode: 'TP003',
        tapeType: 'Double Sided Tape',
        width: '12',
        length: '25',
        thickness: '50',
        adhesiveType: 'Acrylic',
        supplier: 'Premium Tapes Ltd',
        batchNumber: 'BATCH003',
        dateReceived: '2024-01-17',
        quality: 'B Grade',
      ),
      TapeRecord(
        sNo: 4,
        tapeCode: 'TP004',
        tapeType: 'Bopp Tape',
        width: '48',
        length: '100',
        thickness: '40',
        adhesiveType: 'Hot Melt',
        supplier: 'Indian Tape Mills',
        batchNumber: 'BATCH004',
        dateReceived: '2024-01-18',
        quality: 'A Grade',
      ),
      TapeRecord(
        sNo: 5,
        tapeCode: 'TP005',
        tapeType: 'Foam Tape',
        width: '30',
        length: '75',
        thickness: '60',
        adhesiveType: 'Acrylic',
        supplier: 'Quality Tape Co',
        batchNumber: 'BATCH005',
        dateReceived: '2024-01-19',
        quality: 'A Grade',
      ),
    ];
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
        columnName: 'Tape Code',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Tape Code')),
        ),
      ),
      GridColumn(
        columnName: 'Tape Type',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Tape Type')),
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
        columnName: 'Thickness (microns)',
        width: 160,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Thickness (microns)')),
        ),
      ),
      GridColumn(
        columnName: 'Adhesive Type',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Adhesive Type')),
        ),
      ),
      GridColumn(
        columnName: 'Supplier',
        width: 180,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Supplier')),
        ),
      ),
      GridColumn(
        columnName: 'Batch Number',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Batch Number')),
        ),
      ),
      GridColumn(
        columnName: 'Date Received',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Date Received')),
        ),
      ),
      GridColumn(
        columnName: 'Quality',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Quality')),
        ),
      ),
      // GridColumn(
      //   columnName: 'Status',
      //   width: 120,
      //   label: Container(
      //     color: Colors.grey[100],
      //     child: const Center(child: TextFieldlabelText('Status')),
      //   ),
      // ),
      // GridColumn(
      //   columnName: 'actions',
      //   width: 120,
      //   label: Container(
      //     color: Colors.grey[100],
      //     child: const Center(child: TextFieldlabelText('Actions')),
      //   ),
      // ),
    ];
  }
}
