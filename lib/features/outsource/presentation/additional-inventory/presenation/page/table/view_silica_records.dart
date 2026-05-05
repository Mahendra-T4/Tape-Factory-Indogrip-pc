import 'package:flutter/material.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/scroll_behavier.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/features/outsource/presentation/additional-inventory/data/source/silic_record_data_source.dart';
import 'package:indogrip/features/outsource/presentation/additional-inventory/presenation/page/table/view_silica_record_table_builder.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ViewSilicaRecordTablePanel extends StatefulWidget {
  const ViewSilicaRecordTablePanel({super.key});
  static const String routeName = '/outsource/silica/view';

  @override
  State<ViewSilicaRecordTablePanel> createState() =>
      _ViewSilicaRecordTablePanelState();
}

class _ViewSilicaRecordTablePanelState extends ViewSilicaRecordTableBuilder {
  final GlobalKey _key = GlobalKey();
  final GlobalKey<ScaffoldState> stateKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    silicaDataSource = SilicaDataSource(
      silicaData: silicaData,
      onStatusChanged: (value) {
        setState(() {
          isChecked = value;
          if (!isChecked) {
            selectedRows.clear();
            selectedItems.clear();
          }
        });
      },
      onCheckboxChanged: (value, index) {
        setState(() {
          if (value) {
            selectedRows.add(silicaDataSource!.rows[index]);
            selectedItems.add(silicaData[index]);
          } else {
            selectedRows.remove(silicaDataSource!.rows[index]);
            selectedItems.remove(silicaData[index]);
          }
        });
      },
      onEdit: (data) {
        // Handle edit action
      },
      printLabel: (data) {
        // Handle print label action
      },
      isAllChecked: false,
      onChanged: (String? p1, SilicaData p2) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: InternetConnectionService().connectionStream,
      initialData: true, // Assume connected initially
      builder: (context, snapshot) {
        // Handle error state
        if (snapshot.hasError) {
          return const NoInternetConnection();
        }

        // Handle disconnected state
        if (snapshot.data == false) {
          return const NoInternetConnection();
        }

        // Handle loading state
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          key: stateKey,
          appBar: !Responsive.isDesktop(context)
              ? MobileAppBar(context, stateKey, 'View Silica')
              : DesktopAppBar(context, stateKey, 'View Silica', false),
          drawer: !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : null,

          body: Padding(
            padding: EdgeInsets.all(Responsive.kHZRowPadding),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: silicaSearchFields),
                SliverToBoxAdapter(
                  child: SizedBox(height: Responsive.kHZRowPadding),
                ),
                SliverToBoxAdapter(child: buildSilicaRecordTable),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget get buildSilicaRecordTable => SizedBox(
    height: MediaQuery.of(context).size.height * 0.8,
    child: ScrollConfiguration(
      behavior: HorizontalMouseScrollBehavior(),
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
        // onCellTap: (DataGridCellTapDetails details) {
        //   if (dataSource != null) {
        //     dataSource!.highlightedRowIndex =
        //         details.rowColumnIndex.rowIndex - 1;
        //   }
        // },
        selectionMode: isMultipleSelection
            ? SelectionMode.multiple
            : SelectionMode.single,
        onSelectionChanged: (addedRows, removedRows) {
          setState(() {
            selectedRows.addAll(addedRows);
            selectedRows.removeWhere((row) => removedRows.contains(row));

            final selectedData = selectedRows.map((row) {
              final index = silicaDataSource!.rows.indexOf(row);
              return silicaData[index];
            }).toList();
            handleSelectionChanged(
              selectedData.whereType<SilicaData>().toList(),
            );
          });
        },
        source: silicaDataSource!,
        columns: buildGridColumns(),
      ),
    ),
  );
}
