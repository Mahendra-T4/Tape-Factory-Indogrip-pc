import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/utils/widgets/textfield_label.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/client/data/client_data_source.dart';
import 'package:indogrip/features/client/data/model/view_staff_modeld.dart';
import 'package:indogrip/features/client/presentation/bloc/client_bloc.dart';
import 'package:indogrip/features/client/presentation/pages/edit/edit_client.dart';
import 'package:indogrip/features/client/presentation/pages/profile/client_profile.dart';
import 'package:indogrip/features/global/data/model/change_status_param.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/pagination_widget.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:indogrip/features/client/presentation/pages/view/view_client_builder.dart';

class ViewClientPanel extends StatefulWidget {
  const ViewClientPanel({super.key});
  static const String routeName = '/viewClient';

  @override
  State<ViewClientPanel> createState() => _ViewClientPanelState();
}

class _ViewClientPanelState extends ViewClientBuilder {
  final GlobalKey<ScaffoldState> _stateKey = GlobalKey<ScaffoldState>();
  final GlobalKey _key = GlobalKey();
  late final GlobalBloc globalBloc;

  late Map<String, double> columnWidths = {};
  bool isChecked = false;
  late ClientDataSource? _dataSource;
  List<DataGridRow> selectedRows = [];

  @override
  void dispose() {
    selectedRows.clear();
    super.dispose();
  }

  Widget _buildDesktopView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (Responsive.isDesktop(context)) SideMenuWidget(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DesktopAppBar(context, _stateKey, 'View Clients', false),
              BlocListener<GlobalBloc, GlobalState>(
                bloc: globalBloc,
                listener: (context, state) {
                  if (state is GlobalChangeUserStatusSuccessStatus) {
                    // Handle status change success (for approved, rejected, blocked, etc.)
                    if (state.changeStatusEntity.status == 1) {
                      ToastService.instance.showSuccess(
                        context,
                        state.changeStatusEntity.message.toString(),
                      );

                      // Refresh list after status change
                      clientBloc.add(
                        ViewClientRecordsFetchingEvent(
                          viewClientApiParam: ViewRecordApiParam(
                            keyword: searchController.text,
                            filterBy: recordValue ?? '',
                            orderBy: filterValue.toString(),
                            pageNo: pageNo.toString(),
                            sortBy: entryValue.toString(),
                            fromDate: fromDateController.text,
                            toDate: toDateController.text,
                          ),
                        ),
                      );
                    } else {
                      ToastService.instance.showSuccess(
                        context,
                        state.changeStatusEntity.message.toString(),
                      );
                      clientBloc.add(
                        ViewClientRecordsFetchingEvent(
                          viewClientApiParam: ViewRecordApiParam(
                            keyword: searchController.text,
                            filterBy: recordValue ?? '',
                            orderBy: filterValue.toString(),
                            pageNo: pageNo.toString(),
                            sortBy: entryValue.toString(),
                            fromDate: fromDateController.text,
                            toDate: toDateController.text,
                          ),
                        ),
                      );
                    }
                  } else if (state is GlobalChangeUserStatusErrorStatus) {
                    ToastService.instance.showError(
                      context,
                      state.message.toString(),
                    );
                  } else if (state is GlobalDeleteRecordSuccessStatus) {
                    ToastService.instance.showSuccess(
                      context,
                      state.deleteRecordEntity.message.toString(),
                    );
                    // Refresh list after single delete
                    clientBloc.add(
                      ViewClientRecordsFetchingEvent(
                        viewClientApiParam: ViewRecordApiParam(
                          keyword: searchController.text,
                          filterBy: recordValue ?? '',
                          orderBy: filterValue.toString(),
                          pageNo: pageNo.toString(),
                          sortBy: entryValue.toString(),
                          fromDate: fromDateController.text,
                          toDate: toDateController.text,
                        ),
                      ),
                    );
                  } else if (state is GlobalDeleteRecordErrorStatus) {
                    ToastService.instance.showError(
                      context,
                      state.message.toString(),
                    );
                  } else if (state
                      is GlobalDeleteMultipleRecordsSuccessStatus) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.deleteRecordEntity.message ?? 'Records deleted',
                        ),
                      ),
                    );
                    // Refresh list after bulk delete
                    clientBloc.add(
                      ViewClientRecordsFetchingEvent(
                        viewClientApiParam: ViewRecordApiParam(
                          keyword: searchController.text,
                          filterBy: recordValue ?? '',
                          orderBy: filterValue.toString(),
                          pageNo: pageNo.toString(),
                          sortBy: entryValue.toString(),
                          fromDate: fromDateController.text,
                          toDate: toDateController.text,
                        ),
                      ),
                    );
                    // Clear selection
                    setState(() {
                      selectedRows.clear();
                      selectedItems.clear();
                      isMultipleSelection = false;
                    });
                  } else if (state is GlobalDeleteMultipleRecordsErrorStatus) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                child: buildFilterFieldsDesktop,
              ),
              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [_buildPaginationWidget],
              ),
              BlocConsumer(
                bloc: clientBloc,
                listener: (context, state) {
                  if (state is ViewClientRecordsLoadedSuccessStatus) {
                    _dataSource = null;
                    // Reset data source when new data is fetched
                  }
                },
                buildWhen: (previous, current) {
                  // Always rebuild to handle state changes
                  return true;
                },
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case const (ClientLoadingStatus):
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    case const (ViewClientRecordsLoadedSuccessStatus):
                      final successState =
                          (state as ViewClientRecordsLoadedSuccessStatus)
                              .viewClientModel;

                      _dataSource ??= ClientDataSource(
                        context: context,
                        clientData: successState.record ?? [],
                        isAllChecked: isChecked,
                        onStatusChanged: (value) {
                          setState(() {
                            isChecked = value;
                            if (value) {
                              selectedRows = List.from(_dataSource?.rows ?? []);
                            } else {
                              selectedRows.clear();
                            }
                            final selectedData = value
                                ? (state.viewClientModel.record ?? [])
                                      .map((record) => record.toJson())
                                      .cast<Map<String, dynamic>>()
                                      .toList()
                                : <Map<String, dynamic>>[];
                            handleSelectionChanged(selectedData);
                          });
                        },
                        onCheckboxChanged: (checked, index) {
                          if (_dataSource == null) return;
                          setState(() {
                            if (checked) {
                              selectedRows.add(_dataSource!.rows[index]);
                            } else {
                              selectedRows.remove(_dataSource!.rows[index]);
                            }
                            final selectedRecords = selectedRows
                                .map((row) {
                                  final idx = _dataSource!.rows.indexOf(row);
                                  if (idx != -1 &&
                                      idx <
                                          (state
                                                  .viewClientModel
                                                  .record
                                                  ?.length ??
                                              0)) {
                                    final record =
                                        state.viewClientModel.record![idx];
                                    return record.toJson();
                                  }
                                  return null;
                                })
                                .where((record) => record != null)
                                .cast<Map<String, dynamic>>()
                                .toList();
                            handleSelectionChanged(selectedRecords);
                          });
                        },
                        onEdit: (client, unit) {
                          context.pushNamed(
                            EditClient.routeName,
                            extra: EditClientParam(record: client, unit: unit),
                          );
                        },
                        onDelete: (staff) {
                          globalBloc.add(
                            GlobalDeleteRecordEvent(
                              rKey: staff.rKey.toString(),
                              rPanel: 'view-staff',
                            ),
                          );

                          clientBloc.add(
                            ViewClientRecordsFetchingEvent(
                              viewClientApiParam: ViewRecordApiParam(
                                keyword: searchController.text,
                                filterBy: recordValue ?? '',
                                orderBy: filterValue.toString(),
                                pageNo: pageNo.toString(),
                                sortBy: entryValue.toString(),
                                fromDate: fromDateController.text,
                                toDate: toDateController.text,
                              ),
                            ),
                          );
                        },
                        onProfile: (staff) {
                          context.pushNamed(
                            ClientProfile.routeName,
                            extra: staff,
                          );
                        },
                        onChanged: (String? value, ClientRecord record) {
                          globalBloc.add(
                            GlobalChangeUserStatusEvent(
                              param: ChangeStaffParam(
                                rKey: record.rKey.toString(),
                                rPanel: 'view-client',
                                rStatus: value.toString(),
                                statusReason: '',
                              ),
                            ),
                          );
                          clientBloc.add(
                            ViewClientRecordsFetchingEvent(
                              viewClientApiParam: ViewRecordApiParam(
                                keyword: searchController.text,
                                filterBy: recordValue ?? '',
                                orderBy: filterValue.toString(),
                                pageNo: pageNo.toString(),
                                sortBy: entryValue.toString(),
                                fromDate: fromDateController.text,
                                toDate: toDateController.text,
                              ),
                            ),
                          );
                          // For other statuses, call API directly (no reason required)
                        },
                      );

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          pageQty = state.viewClientModel.pageQty ?? 1;
                        });
                      });

                      return successState.status == 1
                          ? Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  right: 12,
                                ),
                                child: SfDataGrid(
                                  showHorizontalScrollbar: true,
                                  key: _key,
                                  rowsPerPage: 4,
                                  allowPullToRefresh: true,
                                  allowColumnsResizing: true,
                                  columnResizeMode:
                                      ColumnResizeMode.onResizeEnd,
                                  isScrollbarAlwaysShown: true,
                                  showVerticalScrollbar: true,
                                  showCheckboxColumn: isMultipleSelection,
                                  selectionMode: isMultipleSelection
                                      ? SelectionMode.multiple
                                      : SelectionMode.single,

                                  onSelectionChanged: (addedRows, removedRows) {
                                    setState(() {
                                      selectedRows.addAll(addedRows);
                                      selectedRows.removeWhere(
                                        (row) => removedRows.contains(row),
                                      );

                                      final selectedData = selectedRows.map((
                                        row,
                                      ) {
                                        final index = _dataSource!.rows.indexOf(
                                          row,
                                        );
                                        return state
                                            .viewClientModel
                                            .record![index];
                                      }).toList();
                                      handleSelectionChanged(
                                        state.viewClientModel.record!
                                            .where(
                                              (record) =>
                                                  selectedData.contains(record),
                                            )
                                            .map((e) => e.toJson())
                                            .cast<Map<String, dynamic>>()
                                            .toList(),
                                      );
                                    });
                                  },
                                  onColumnResizeUpdate:
                                      (ColumnResizeUpdateDetails details) {
                                        setState(() {
                                          columnWidths[details
                                                  .column
                                                  .columnName] =
                                              details.width;
                                        });
                                        return true;
                                      },
                                  source: _dataSource!,

                                  columns: buildGridColumns(),
                                ),
                              ),
                            )
                          : Expanded(
                              child: Center(
                                child: Text(
                                  successState.message ??
                                      'Refresh to load data',
                                ),
                              ),
                            );
                    case const (ViewClientRecordsErrorStatus):
                      return Center(
                        child: Text(
                          (state as ViewClientRecordsErrorStatus).errorMessage,
                        ),
                      );
                    default:
                      return SizedBox.shrink();
                  }
                },
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
          child: const Center(child: TextFieldlabelText('Sr No')),
        ),
      ),
      GridColumn(
        columnName: 'Client Code',
        // columnWidthMode: ColumnWidthMode.fill,
        width: 180,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Client Code')),
        ),
      ),
      GridColumn(
        columnName: 'Consignee Name',
        width: 300,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Consignee Name')),
        ),
      ),

      GridColumn(
        columnName: 'Mobile Number',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Mobile Number')),
        ),
      ),
      GridColumn(
        columnName: 'GSTIN',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('GSTIN')),
        ),
      ),
      GridColumn(
        columnName: 'Owner Name',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Owner Name')),
        ),
      ),
      GridColumn(
        columnName: 'Owner Mobile',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Owner Mobile')),
        ),
      ),
      GridColumn(
        columnName: 'Owner Alternate Mobile',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(
            child: TextFieldlabelText('Owner Alternate Mobile'),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Purchase Manager',
        width: 200,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Purchase Manager')),
        ),
      ),
      GridColumn(
        columnName: 'Manager Mobile',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Manager Mobile')),
        ),
      ),
      GridColumn(
        columnName: 'Manager Alternate Mobile',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(
            child: TextFieldlabelText('Manager Alternate Mobile'),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Status',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Status')),
        ),
      ),

      GridColumn(
        columnName: 'actions',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Actions')),
        ),
      ),
    ];
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
          key: _stateKey,
          appBar: !Responsive.isDesktop(context)
              ? MobileAppBar(context, _stateKey, 'View Clients')
              : null,
          drawer: !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : null,
          body: _buildDesktopView(),
          // floatingActionButton:
        );
      },
    );
  }

  Widget get _buildPaginationWidget => TableBottomWidget(
    currentPage: pageNo,
    pageQty: pageQty,
    onPagePressed: (pageNumber) {
      setState(() {
        pageNo = pageNumber;
      });
      clientBloc.add(
        ViewClientRecordsFetchingEvent(
          viewClientApiParam: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue ?? '',
            orderBy: filterValue.toString(),
            pageNo: pageNo.toString(),
            sortBy: entryValue.toString(),
            fromDate: fromDateController.text,
            toDate: toDateController.text,
          ),
        ),
      );
      // Page number button clicked
    },
    onFirstPressed: () {
      setState(() {
        pageNo = 1;
        clientBloc.add(
          ViewClientRecordsFetchingEvent(
            viewClientApiParam: ViewRecordApiParam(
              keyword: searchController.text,
              filterBy: recordValue ?? '',
              orderBy: filterValue.toString(),
              pageNo: pageNo.toString(),
              sortBy: entryValue.toString(),
              fromDate: fromDateController.text,
              toDate: toDateController.text,
            ),
          ),
        );
      });
    },
    onPreviousPressed: () {
      if (pageNo >= 1) {
        setState(() {
          pageNo = pageNo - 1;
          clientBloc.add(
            ViewClientRecordsFetchingEvent(
              viewClientApiParam: ViewRecordApiParam(
                keyword: searchController.text,
                filterBy: recordValue ?? '',
                orderBy: filterValue.toString(),
                pageNo: pageNo.toString(),
                sortBy: entryValue.toString(),
                fromDate: fromDateController.text,
                toDate: toDateController.text,
              ),
            ),
          );
        });
      }
    },
    onNextPressed: () {
      if (pageNo <= pageQty) {
        setState(() {
          pageNo = pageNo + 1;
          clientBloc.add(
            ViewClientRecordsFetchingEvent(
              viewClientApiParam: ViewRecordApiParam(
                keyword: searchController.text,
                filterBy: recordValue ?? '',
                orderBy: filterValue.toString(),
                pageNo: pageNo.toString(),
                sortBy: entryValue.toString(),
                fromDate: fromDateController.text,
                toDate: toDateController.text,
              ),
            ),
          );
        });
      }
    },
    onLastPressed: () {
      setState(() {
        pageNo = pageQty;
        clientBloc.add(
          ViewClientRecordsFetchingEvent(
            viewClientApiParam: ViewRecordApiParam(
              keyword: searchController.text,
              filterBy: recordValue ?? '',
              orderBy: filterValue.toString(),
              pageNo: pageNo.toString(),
              sortBy: entryValue.toString(),
              fromDate: fromDateController.text,
              toDate: toDateController.text,
            ),
          ),
        );
      });
    },
  );
}
