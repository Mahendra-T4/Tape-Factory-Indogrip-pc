import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/features/chalan/data/chalan_datasource.dart';
import 'package:indogrip/features/chalan/data/model/chalanlist_model.dart';
import 'package:indogrip/features/chalan/presentation/bloc/challan_bloc.dart';
import 'package:indogrip/features/chalan/presentation/page/bill/bill_formate.dart';
import 'package:indogrip/features/chalan/presentation/page/chalan_panel.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/refresh_button.dart';
import 'package:indogrip/features/global/presentation/widget/search_fields.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

abstract class ChalanBuilder extends State<ChalanPanel> {
  final TextEditingController searchController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  List<DataGridRow> selectedRows = [];
  bool isMultipleSelection = false;
  String? clientKey;
  int? highlightedRowIndex;
  var recordValue, filterValue, entryValue, currentPage;
  late final ChallanBloc challanBloc;
  late final GlobalBloc globalBloc;
  final GlobalKey key = GlobalKey();
  String? staffKey;
  @override
  void initState() {
    super.initState();
    challanBloc = ChallanBloc();
    globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    challanBloc.add(
      FetchChallanRecordsEvent(
        param: ViewRecordApiParam(pageNo: '', sortBy: '10'),
      ),
    );
  }

  dataLoadingEventCall() {
    challanBloc.add(
      FetchChallanRecordsEvent(
        param: ViewRecordApiParam(
          keyword: searchController.text,
          filterBy: recordValue ?? '',
          orderBy: filterValue.toString(),
          pageNo: currentPage.toString(),
          sortBy: entryValue.toString(),
          fromDate: fromDateController.text,
          toDate: toDateController.text,
          clientKey: clientKey ?? '',
          staffKey: staffKey ?? '',
        ),
      ),
    );
  }

  ChalanDataSource? dataSource;
  late Map<String, double> columnWidths = {};
  bool isChecked = false;

  // List<DataGridRow> selectedRows = [];
  int? pageNo;
  int? pageQty;

  // Mock data for demonstration - replace with actual BLoC later
  late List<ChalanRecord> dummyData;

  Widget get refreshButton => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      SizedBox(
        width: MediaQuery.sizeOf(context).width * .15,
        height: 35,
        child: RefreshButton(
          onPressed: () {
            dataLoadingEventCall();
          },
        ),
      ),
    ],
  );

  Widget get searchFields => SearchFields(
    isStatus: true,
    controller: searchController,
    onSearch: (keyword) {
      dataLoadingEventCall();
    },
    onChangedStatus: (status) {
      setState(() {
        recordValue = status;
      });
      dataLoadingEventCall();
    },
    onChangedOrder: (order) {
      setState(() {
        filterValue = order;
      });
      dataLoadingEventCall();
    },
    onChangedSort: (sortBy) {
      setState(() {
        entryValue = sortBy ?? 10;
      });
      dataLoadingEventCall();
    },
  );

  Widget get buildContentTableWidget => BlocConsumer(
    bloc: challanBloc,
    listener: (context, state) {},
    builder: (context, state) {
      switch (state.runtimeType) {
        case ChallanLoadingState:
          return const Center(child: CircularProgressIndicator());
        case ChallanRecordLoadedSuccessState:
          final successState = state as ChallanRecordLoadedSuccessState;
          dummyData = successState.model.record ?? [];
          if (state.model.status == 1) {
            dataSource = ChalanDataSource(
              chalanData: state.model.record ?? [],
              isAllChecked: isChecked,
              highlightedRowIndex: highlightedRowIndex,
              onStatusChanged: (value) {
                setState(() {
                  isChecked = value;
                  if (value) {
                    selectedRows = List.from(dataSource?.rows ?? []);
                  } else {
                    selectedRows.clear();
                  }
                });
              },
              onCheckboxChanged: (checked, index) {
                if (dataSource == null) return;
                setState(() {
                  if (checked) {
                    selectedRows.add(dataSource!.rows[index]);
                  } else {
                    selectedRows.remove(dataSource!.rows[index]);
                  }
                });
              },

              onProfile: (ChalanRecord record) {
                context.pushNamed(BillFormate.routeName, extra: record.rKey);
                // Handle profile action
                print('Profile record: ${record.challanNumber}');
              },
              onChanged: (String? value, ChalanRecord record) {
                // Handle status change
                print('Status changed to: $value for ${record.challanNumber}');
              },
            );
          }
          return state.model.status != 1
              ? Expanded(
                  child: Center(
                    child: Text(state.model.message ?? 'Refresh to load data'),
                  ),
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SfDataGridTheme(
                      data: SfDataGridThemeData(
                        headerColor: Colors.grey[200],
                        gridLineColor: Colors.grey[300],
                        gridLineStrokeWidth: 1,
                      ),
                      child: SfDataGrid(
                        showHorizontalScrollbar: true,
                        key: key,
                        rowsPerPage: 4,
                        allowPullToRefresh: true,
                        allowColumnsResizing: true,

                        columnResizeMode: ColumnResizeMode.onResizeEnd,
                        isScrollbarAlwaysShown: true,
                        showVerticalScrollbar: true,
                        showCheckboxColumn:
                            false, // Set to true when multi-selection is enabled
                        selectionMode: SelectionMode
                            .single, // Change to multiple when needed
                        onSelectionChanged: (addedRows, removedRows) {
                          if (dataSource == null) return;
                          setState(() {
                            selectedRows.addAll(addedRows);
                            selectedRows.removeWhere(
                              (row) => removedRows.contains(row),
                            );
                          });
                        },
                        onCellDoubleTap:
                            (DataGridCellDoubleTapDetails details) {
                              setState(() {
                                highlightedRowIndex =
                                    details.rowColumnIndex.rowIndex - 1;
                              });
                            },
                        onColumnResizeUpdate:
                            (ColumnResizeUpdateDetails details) {
                              setState(() {
                                columnWidths[details.column.columnName] =
                                    details.width;
                              });
                              return true;
                            },
                        source: dataSource!,
                        columnWidthMode: ColumnWidthMode.fill,
                        columns: buildColumns(),
                      ),
                    ),
                  ),
                );
        case ChallanRecordLoadedFailureState:
          final failureState = state as ChallanRecordLoadedFailureState;
          return Center(child: Text('Error: ${failureState.errorMessage}'));
        default:
          return const SizedBox.shrink();
      }
    },
  );

  List<GridColumn> buildColumns() {
    return [
      GridColumn(
        columnName: Chalan.srNo,
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
        columnName: Chalan.challanNumber,
        width: double.nan,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Text(
            'Challan No',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Chalan.dateTime,
        width: 300,
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
        columnName: Chalan.cCode,
        width: 200,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Text(
            'Client Code',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Chalan.cConsigneeName,
        width: 400,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Text(
            'Consignee Name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Chalan.unitName,
        width: 200,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Text(
            'Unit Name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Chalan.name,
        width: double.nan,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Text(
            'Staff Name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'actions',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Text(
            'Actions',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ];
  }
}
