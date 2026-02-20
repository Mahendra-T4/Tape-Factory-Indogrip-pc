import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

enum TableSelectionMode { none, single, multiple }

class CustomDataTable extends StatefulWidget {
  final List<String> columns;
  final List<Map<String, dynamic>> data;
  final Function(Map<String, dynamic>)? onEdit;
  final Function(Map<String, dynamic>)? onDelete;
  final Function(Map<String, dynamic>)? onProfile;
  final bool showActions;
  final double rowHeight;
  final TableSelectionMode selectionMode;
  final Function(List<Map<String, dynamic>>)? onSelectionChanged;
  final DataGridController? controller;

  const CustomDataTable({
    Key? key,
    required this.columns,
    required this.data,
    this.onEdit,
    this.onDelete,
    this.onProfile,
    this.showActions = true,
    this.rowHeight = 50,
    this.selectionMode = TableSelectionMode.none,
    this.onSelectionChanged,
    this.controller,
  }) : super(key: key);

  @override
  State<CustomDataTable> createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  late CustomDataSource _dataSource;
  late List<GridColumn> _columns;
  late DataGridController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? DataGridController();
    _initializeDataSource();
  }

  void _initializeDataSource() {
    _dataSource = CustomDataSource(
      data: widget.data,
      columns: widget.columns,
      onEdit: widget.onEdit,
      onDelete: widget.onDelete,
      onProfile: widget.onProfile,
      showActions: widget.showActions,
      onSelectionChanged: widget.onSelectionChanged,
    );
    final totalColumns = widget.columns.length + (widget.showActions ? 1 : 0);
    final columnWidthMode =
        totalColumns <= 5
            ? ColumnWidthMode.fill
            : ColumnWidthMode.fitByCellValue;

    _columns =
        widget.columns.map<GridColumn>((String column) {
          double width;
          switch (column) {
            case 'First Name':
            case 'Last Name':
              width = 120;
              break;
            case 'Mobile':
            case 'Alternate Mobile':
              width = 130;
              break;
            case 'Login Email':
            case 'Email ID':
              width = 200;
              break;
            case 'Roles':
              width = 250;
              break;
            default:
              width = 150;
          }
          return GridColumn(
            columnName: column,
            width: width,
            columnWidthMode: columnWidthMode,
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              // alignment: Alignment.centerLeft,
              child: Text(
                column,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
          );
        }).toList();

    if (widget.showActions) {
      _columns.add(
        GridColumn(
          columnName: 'Actions',
          width: 150,
          columnWidthMode: columnWidthMode,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text(
              'Actions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  void didUpdateWidget(CustomDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data ||
        oldWidget.columns != widget.columns ||
        oldWidget.showActions != widget.showActions) {
      _initializeDataSource();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDF2F7), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.04),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          shadowColor: Colors.transparent,
          dividerColor: const Color(0xFFEDF2F7),
        ),
        child: SfDataGrid(
          source: _dataSource,
          columns: _columns,
          controller: _controller,
          rowHeight: widget.rowHeight,
          headerRowHeight: 60,
          gridLinesVisibility: GridLinesVisibility.horizontal,
          headerGridLinesVisibility: GridLinesVisibility.none,
          allowSorting: true,
          allowFiltering: false,
          columnWidthMode:
              _columns.length <= 5
                  ? ColumnWidthMode.fill
                  : ColumnWidthMode.fitByCellValue,
          allowMultiColumnSorting: true,
          allowTriStateSorting: true,
          selectionMode: _getSelectionMode(widget.selectionMode),
          navigationMode: GridNavigationMode.row,
          isScrollbarAlwaysShown: true,
          frozenColumnsCount: 1,
          horizontalScrollPhysics: const AlwaysScrollableScrollPhysics(),
          verticalScrollPhysics: const AlwaysScrollableScrollPhysics(),
          showCheckboxColumn:
              widget.selectionMode == TableSelectionMode.multiple,
          checkboxShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          onSelectionChanged: (addedRows, removedRows) {
            if (widget.onSelectionChanged != null) {
              // Get all selected rows data
              final List<Map<String, dynamic>> selectedData = [];
              for (var row in _controller.selectedRows) {
                final rowIndex = _dataSource.rows.indexOf(row);
                if (rowIndex >= 0 && rowIndex < widget.data.length) {
                  selectedData.add(widget.data[rowIndex]);
                }
              }
              widget.onSelectionChanged!(selectedData);
            }
          },
          defaultColumnWidth: 150,
        ),
      ),
    );
  }

  SelectionMode _getSelectionMode(TableSelectionMode mode) {
    switch (mode) {
      case TableSelectionMode.none:
        return SelectionMode.none;
      case TableSelectionMode.single:
        return SelectionMode.single;
      case TableSelectionMode.multiple:
        return SelectionMode.multiple;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
}

class CustomDataSource extends DataGridSource {
  final List<Map<String, dynamic>> data;
  final List<String> columns;
  final Function(Map<String, dynamic>)? onEdit;
  final Function(Map<String, dynamic>)? onDelete;
  final Function(Map<String, dynamic>)? onProfile;
  final bool showActions;
  final Function(List<Map<String, dynamic>>)? onSelectionChanged;
  final List<DataGridRow> _rows = [];
  final Map<DataGridRow, Map<String, dynamic>> _rowToDataMap = {};
  CustomDataSource({
    required this.data,
    required this.columns,
    this.onEdit,
    this.onDelete,
    this.onProfile,
    this.showActions = true,
    this.onSelectionChanged,
  }) {
    _rows.addAll(
      data.map<DataGridRow>((item) {
        final row = DataGridRow(cells: _buildCells(item));
        _rowToDataMap[row] = item;
        return row;
      }),
    );
  }

  List<DataGridCell> _buildCells(Map<String, dynamic> item) {
    final cells =
        columns.map<DataGridCell>((column) {
          return DataGridCell<String>(
            columnName: column,
            value: item[column]?.toString() ?? '',
          );
        }).toList();

    if (showActions) {
      cells.add(
        DataGridCell<Widget>(
          columnName: 'Actions',
          value: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (onEdit != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => onEdit!(item),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        FontAwesomeIcons.penToSquare,
                        color: Color(0xFF3B82F6),
                        size: 17,
                      ),
                    ),
                  ),
                ),
              if (onDelete != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => onDelete!(item),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        FontAwesomeIcons.trash,
                        color: Color(0xFFEF4444),
                        size: 17,
                      ),
                    ),
                  ),
                ),
              if (onProfile != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => onProfile!(item),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        FontAwesomeIcons.userPen,
                        color: Color(0xFF22C55E),
                        size: 17,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }
    return cells;
  }

  @override
  List<DataGridRow> get rows => _rows;

  Map<String, dynamic> getDataForRow(DataGridRow row) {
    return _rowToDataMap[row] ?? {};
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: Colors.white,
      cells:
          row.getCells().map<Widget>((cell) {
            if (cell.columnName == 'Actions') {
              return cell.value as Widget;
            }
            return Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                cell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
    );
  }
}
