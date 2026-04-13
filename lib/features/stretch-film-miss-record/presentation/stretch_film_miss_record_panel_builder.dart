import 'package:flutter/material.dart';
import 'package:indogrip/core/utils/scroll_behavier.dart';
import 'package:indogrip/features/outsource/data/model/stretch_missrecord_model.dart';
import 'package:indogrip/features/stretch-film-miss-record/data/stretch_film_miss_record_datasource.dart';
import 'package:indogrip/features/stretch-film-miss-record/presentation/stretch_film_miss_record_panel.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

abstract class StretchFilmMissRecordPanelBuilder
    extends State<StretchFilmMissRecordPanel> {
  late Map<String, double> columnWidths = {};
  bool isChecked = false;
  late StretchFilmMissRecordDataSource? _dataSource;
  List<DataGridRow> selectedRows = [];
  final TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    reasonController.text = widget.record.message.toString();
    _dataSource = StretchFilmMissRecordDataSource(
      context: context,
      stretchFilmData: _getMissRecordData(),
    );
  }

  List<StretchMissRecord> _getMissRecordData() {
    final List<StretchMissRecord> recordList = [];

    if (widget.record.missRecord != null) {
      for (var item in widget.record.missRecord!) {
        recordList.add(item);
      }
    }

    return recordList;
  }

  Widget get buildTableRecordWidget {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ScrollConfiguration(
          behavior: HorizontalMouseScrollBehavior(),
          child: SfDataGrid(
            source: _dataSource!,
            columnWidthMode: ColumnWidthMode.fill,
            selectionMode: SelectionMode.multiple,
            onSelectionChanged:
                (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
                  setState(() {
                    selectedRows.addAll(addedRows);
                    selectedRows.removeWhere(
                      (row) => removedRows.contains(row),
                    );
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
                columnName: 'Reason',
                width: 450,
                label: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Reason',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Inventory Code',
                width: 120,
                label: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Inventory Code',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              GridColumn(
                columnName: 'Date',
                width: 120,
                label: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Bill Number',
                width: 120,
                label: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Bill Number',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Carton Price',
                width: 120,
                label: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Carton Price',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Transport Amount',
                width: 140,
                label: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Transport Amount',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Product Type',
                width: 120,
                label: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Product Type',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Cut MM Meter',
                width: 120,
                label: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Cut MM Meter',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Base',
                width: 100,
                label: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Base',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Mic',
                width: 100,
                label: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Mic',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Tape Length',
                width: 120,
                label: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Tape Length',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Tape Weight',
                width: 120,
                label: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Tape Weight',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Stretch Film Size',
                width: 150,
                label: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Stretch Film Size',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              GridColumn(
                columnName: 'Net Weight',
                width: 120,
                label: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Net Weight',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Gross Weight',
                width: 120,
                label: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Gross Weight',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Quantity',
                width: 100,
                label: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Quantity',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Remarks',
                width: 150,
                label: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Remarks',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
