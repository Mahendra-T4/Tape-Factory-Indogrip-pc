import 'package:flutter/material.dart';
import 'package:indogrip/features/stretch-film-miss-record/data/stretch_film_miss_record_datasource.dart';
import 'package:indogrip/features/stretch-film-miss-record/presentation/stretch_film_miss_record_panel.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

abstract class StretchFilmMissRecordPanelBuilder
    extends State<StretchFilmMissRecordPanel> {
  late Map<String, double> columnWidths = {};
  bool isChecked = false;
  late StretchFilmMissRecordDataSource? _dataSource;
  List<DataGridRow> selectedRows = [];

  @override
  void initState() {
    super.initState();
    _dataSource = StretchFilmMissRecordDataSource(
      context: context,
      stretchFilmData: getDummyStretchFilmData(),
    );
  }

  List<StretchFilmRecord> getDummyStretchFilmData() {
    return [
      StretchFilmRecord(
        sNo: 1,
        filmCode: 'SF001',
        filmType: 'LLDPE Stretch Film',
        width: '500',
        length: '1500',
        thickness: '20',
        material: 'LLDPE',
        stretchPercentage: '300',
        supplier: 'ABC Plastics Ltd',
        batchNumber: 'BATCH001',
        dateReceived: '2024-01-15',
        quality: 'A Grade',
      ),
      StretchFilmRecord(
        sNo: 2,
        filmCode: 'SF002',
        filmType: 'LLDPE Stretch Film',
        width: '450',
        length: '1200',
        thickness: '18',
        material: 'LLDPE',
        stretchPercentage: '280',
        supplier: 'Global Plastics Inc',
        batchNumber: 'BATCH002',
        dateReceived: '2024-01-16',
        quality: 'A Grade',
      ),
      StretchFilmRecord(
        sNo: 3,
        filmCode: 'SF003',
        filmType: 'LDPE Stretch Film',
        width: '600',
        length: '2000',
        thickness: '25',
        material: 'LDPE',
        stretchPercentage: '250',
        supplier: 'Premium Plastic Co',
        batchNumber: 'BATCH003',
        dateReceived: '2024-01-17',
        quality: 'B Grade',
      ),
    ];
  }

  Widget get buildTableRecordWidget {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SfDataGrid(
          source: _dataSource!,
          columnWidthMode: ColumnWidthMode.fill,
          selectionMode: SelectionMode.multiple,
          onSelectionChanged:
              (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
                setState(() {
                  selectedRows.addAll(addedRows);
                  selectedRows.removeWhere((row) => removedRows.contains(row));
                });
              },
          columns: [
            GridColumn(
              columnName: 'Sr No',
              width: 80,
              label: Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: const Text(
                  'Sr No',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GridColumn(
              columnName: 'Film Code',
              width: 120,
              label: Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: const Text(
                  'Film Code',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GridColumn(
              columnName: 'Film Type',
              width: 150,
              label: Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: const Text(
                  'Film Type',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GridColumn(
              columnName: 'Width (mm)',
              width: 120,
              label: Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: const Text(
                  'Width (mm)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GridColumn(
              columnName: 'Length (m)',
              width: 120,
              label: Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: const Text(
                  'Length (m)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GridColumn(
              columnName: 'Thickness (microns)',
              width: 160,
              label: Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: const Text(
                  'Thickness (microns)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GridColumn(
              columnName: 'Material',
              width: 120,
              label: Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: const Text(
                  'Material',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GridColumn(
              columnName: 'Stretch (%)',
              width: 120,
              label: Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: const Text(
                  'Stretch (%)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GridColumn(
              columnName: 'Supplier',
              width: 180,
              label: Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: const Text(
                  'Supplier',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GridColumn(
              columnName: 'Batch Number',
              width: 140,
              label: Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: const Text(
                  'Batch Number',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GridColumn(
              columnName: 'Date Received',
              width: 140,
              label: Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: const Text(
                  'Date Received',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GridColumn(
              columnName: 'Quality',
              width: 120,
              label: Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: const Text(
                  'Quality',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // GridColumn(
            //   columnName: 'Status',
            //   width: 120,
            //   label: Container(
            //     color: Colors.grey[100],
            //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //     alignment: Alignment.center,
            //     child: const Text(
            //       'Status',
            //       style: TextStyle(fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            // GridColumn(
            //   columnName: 'actions',
            //   width: 120,
            //   label: Container(
            //     color: Colors.grey[100],
            //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //     alignment: Alignment.center,
            //     child: const Text(
            //       'Actions',
            //       style: TextStyle(fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
