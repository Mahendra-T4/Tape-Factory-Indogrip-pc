import 'package:flutter/material.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/utils/widgets/textfield_label.dart';
import 'package:indogrip/features/loss%20meters/pages/view/view_loss_meter_builder.dart';
import 'package:indogrip/features/loss%20meters/data/loss_meter_data_source.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ViewLossMeterPanel extends StatefulWidget {
  const ViewLossMeterPanel({super.key});

  @override
  State<ViewLossMeterPanel> createState() => _ViewLossMeterPanelState();
}

class _ViewLossMeterPanelState extends ViewLossMeterBuilder {
  final GlobalKey<ScaffoldState> _stateKey = GlobalKey<ScaffoldState>();
  final GlobalKey _key = GlobalKey();
  late Map<String, double> columnWidths = {};
  bool isChecked = false;
  late LossMeterDataSource _dataSource;
  List<DataGridRow> selectedRows = [];

  @override
  void dispose() {
    selectedRows.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeDataSource();
  }

  void _initializeDataSource() {
    _dataSource = LossMeterDataSource(
      lossMeterData: lossMetersData,
      isAllChecked: isChecked,
      onStatusChanged: (value) {
        setState(() {
          isChecked = value;
          if (value) {
            selectedRows = List.from(_dataSource.rows);
          } else {
            selectedRows.clear();
          }
          handleSelectionChanged(value ? List.from(lossMetersData) : []);
        });
      },
      onCheckboxChanged: (checked, index) {
        setState(() {
          if (checked) {
            selectedRows.add(_dataSource.rows[index]);
          } else {
            selectedRows.remove(_dataSource.rows[index]);
          }
          handleSelectionChanged(
            selectedRows.map((row) {
              final idx = _dataSource.rows.indexOf(row);
              return lossMetersData[idx];
            }).toList(),
          );
        });
      },
      onEdit: handleEdit,
      onDelete: handleDelete,
      onProfile: handleProfile,
    );
  }

  Widget _buildDesktopView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SideMenuWidget(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DesktopAppBar(context, _stateKey, 'View Loss Meters',false),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: buildFilterFieldsDesktop,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildSelectionActions(),
                      Expanded(
                        child: SfDataGrid(
                          showHorizontalScrollbar: true,
                          key: _key,
                          rowsPerPage: 4,
                          allowPullToRefresh: true,
                          allowColumnsResizing: true,
                          columnResizeMode: ColumnResizeMode.onResizeEnd,
                          isScrollbarAlwaysShown: true,
                          showVerticalScrollbar: true,
                          showCheckboxColumn: isMultipleSelection,
                          selectionMode:
                              isMultipleSelection
                                  ? SelectionMode.multiple
                                  : SelectionMode.single,
                          onSelectionChanged: (addedRows, removedRows) {
                            setState(() {
                              selectedRows.addAll(addedRows);
                              selectedRows.removeWhere(
                                (row) => removedRows.contains(row),
                              );

                              final selectedData =
                                  selectedRows.map((row) {
                                    final index = _dataSource.rows.indexOf(row);
                                    return lossMetersData[index];
                                  }).toList();
                              handleSelectionChanged(selectedData);
                            });
                          },
                          onColumnResizeUpdate: (details) {
                            setState(() {
                              columnWidths[details.column.columnName] =
                                  details.width;
                            });
                            return true;
                          },
                          source: _dataSource,
                          columns: buildGridColumns(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

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
          child: const TextFieldlabelText('Sr No'),
        ),
      ),
      GridColumn(
        columnName: 'Jumbo Roll',
        columnWidthMode: ColumnWidthMode.fill,
        width: Responsive.isDesktop(context) ? double.nan : 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Jumbo Roll')),
        ),
      ),
      GridColumn(
        columnName: 'Total Consume Meter',
        columnWidthMode: ColumnWidthMode.fill,
        width: Responsive.isDesktop(context) ? double.nan : 180,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Total Consume Meter')),
        ),
      ),
      GridColumn(
        columnName: 'Total Receive Meter',
        columnWidthMode: ColumnWidthMode.fill,
        width: Responsive.isDesktop(context) ? double.nan : 180,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Total Receive Meter')),
        ),
      ),
      GridColumn(
        columnName: 'Loss Meters',
        columnWidthMode: ColumnWidthMode.fill,
        width: Responsive.isDesktop(context) ? double.nan : 120,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Loss Meters')),
        ),
      ),
      GridColumn(
        columnName: 'actions',
        columnWidthMode: ColumnWidthMode.fitByColumnName,
        width: 120,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Actions')),
        ),
      ),
    ];
  }

  Widget _buildTabletView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildFilterFieldsTablet,
          buildSelectionActions(),
          Expanded(
            child: SfDataGrid(
              showHorizontalScrollbar: true,
              key: _key,
              rowsPerPage: 4,
              allowPullToRefresh: true,
              allowColumnsResizing: true,
              columnResizeMode: ColumnResizeMode.onResizeEnd,
              isScrollbarAlwaysShown: true,
              showVerticalScrollbar: true,
              showCheckboxColumn: isMultipleSelection,
              selectionMode:
                  isMultipleSelection
                      ? SelectionMode.multiple
                      : SelectionMode.single,
              onSelectionChanged: (addedRows, removedRows) {
                setState(() {
                  selectedRows.addAll(addedRows);
                  selectedRows.removeWhere((row) => removedRows.contains(row));

                  final selectedData =
                      selectedRows.map((row) {
                        final index = _dataSource.rows.indexOf(row);
                        return lossMetersData[index];
                      }).toList();
                  handleSelectionChanged(selectedData);
                });
              },
              onColumnResizeUpdate: (details) {
                setState(() {
                  columnWidths[details.column.columnName] = details.width;
                });
                return true;
              },
              source: _dataSource,
              columnWidthMode: ColumnWidthMode.fill,
              columns: buildGridColumns(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _stateKey,
      appBar:
          !Responsive.isDesktop(context)
              ? MobileAppBar(context, _stateKey, 'View Loss Meters')
              : null,
      drawer: !Responsive.isDesktop(context) ? const SideMenuWidget() : null,
      body:
          Responsive.isDesktop(context)
              ? _buildDesktopView()
              : _buildTabletView(),
    );
  }
}
