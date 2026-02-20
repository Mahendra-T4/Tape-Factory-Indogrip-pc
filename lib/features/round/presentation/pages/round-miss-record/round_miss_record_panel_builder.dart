import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _dataSource = RoundMissRecordDataSource(
      context: context,
      roundData: getDummyRoundData(),
    );
  }

  List<RoundRecord> getDummyRoundData() {
    return [
      RoundRecord(
        sNo: 1,
        roundCode: 'RD001',
        roundDescription: 'Steel Round Bar',
        diameter: '25',
        thickness: '25',
        weight: '15',
        material: 'Stainless Steel',
        supplier: 'ABC Steel Ltd',
        batchNumber: 'BATCH001',
        dateReceived: '2024-01-15',
        quality: 'A Grade',
      ),
      RoundRecord(
        sNo: 2,
        roundCode: 'RD002',
        roundDescription: 'Aluminum Round Rod',
        diameter: '32',
        thickness: '32',
        weight: '8',
        material: 'Aluminum',
        supplier: 'Global Metals Co',
        batchNumber: 'BATCH002',
        dateReceived: '2024-01-16',
        quality: 'A Grade',
      ),
      RoundRecord(
        sNo: 3,
        roundCode: 'RD003',
        roundDescription: 'Copper Round Bar',
        diameter: '20',
        thickness: '20',
        weight: '18',
        material: 'Copper',
        supplier: 'Premium Metals',
        batchNumber: 'BATCH003',
        dateReceived: '2024-01-17',
        quality: 'B Grade',
      ),
      RoundRecord(
        sNo: 4,
        roundCode: 'RD004',
        roundDescription: 'Iron Round Rod',
        diameter: '28',
        thickness: '28',
        weight: '12',
        material: 'Cast Iron',
        supplier: 'Indian Steel Mills',
        batchNumber: 'BATCH004',
        dateReceived: '2024-01-18',
        quality: 'A Grade',
      ),
      RoundRecord(
        sNo: 5,
        roundCode: 'RD005',
        roundDescription: 'Brass Round Bar',
        diameter: '24',
        thickness: '24',
        weight: '16',
        material: 'Brass',
        supplier: 'Quality Metals Ltd',
        batchNumber: 'BATCH005',
        dateReceived: '2024-01-19',
        quality: 'A Grade',
      ),
    ];
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
        columnName: 'Round Code',
        width: 130,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Round Code')),
        ),
      ),
      GridColumn(
        columnName: 'Description',
        width: 200,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Description')),
        ),
      ),
      GridColumn(
        columnName: 'Diameter (mm)',
        width: 130,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Diameter (mm)')),
        ),
      ),
      GridColumn(
        columnName: 'Thickness (mm)',
        width: 140,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Thickness (mm)')),
        ),
      ),
      GridColumn(
        columnName: 'Weight (kg)',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Weight (kg)')),
        ),
      ),
      GridColumn(
        columnName: 'Material',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Material')),
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
     
    ];
  }
}
