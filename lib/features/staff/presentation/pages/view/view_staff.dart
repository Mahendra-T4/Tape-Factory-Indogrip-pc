import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/scroll_behavier.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/features/global/data/model/change_status_param.dart';
import 'package:indogrip/features/global/presentation/widget/multi_delete_button.dart';
import 'package:indogrip/features/global/presentation/widget/pagination_widget.dart';
import 'package:indogrip/features/global/presentation/widget/refresh_button.dart';
import 'package:indogrip/features/staff/data/models/edit_staff_details_param_model.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:indogrip/features/staff/presentation/bloc/staff_bloc.dart';
import 'package:indogrip/features/staff/presentation/pages/edit/edit_add_staff_page.dart';
import 'package:indogrip/features/staff/presentation/pages/view/view_staff_builder.dart';
import 'package:indogrip/features/staff/data/staff_data_source.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// Custom scroll behavior to enable mouse wheel horizontal scrolling
// class HorizontalMouseScrollBehavior extends MaterialScrollBehavior {
//   @override
//   Set<PointerDeviceKind> get dragDevices => {
//     PointerDeviceKind.touch,
//     PointerDeviceKind.mouse,
//     PointerDeviceKind.trackpad,
//   };
// }

class ViewStaffPanel extends StatefulWidget {
  const ViewStaffPanel({super.key});
  static const String routeName = '/viewStaff';

  @override
  State<ViewStaffPanel> createState() => _ViewStaffPanelState();
}

class _ViewStaffPanelState extends ViewStaffBuilder {
  final GlobalKey<ScaffoldState> _stateKey = GlobalKey<ScaffoldState>();
  final GlobalKey _key = GlobalKey();
  late Map<String, double> columnWidths = {};
  bool isChecked = false;
  String pageText = '';
  bool isExpanded = false;

  StaffDataSource? _dataSource;
  List<DataGridRow> selectedRows = [];
  List<Map<String, dynamic>> selectedItems = [];
  int? pageNo;
  int? pageQty;

  @override
  void dispose() {
    selectedRows.clear();
    _dataSource?.dispose();
    _dataSource = null;
    staffBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pageNo = 1;
    pageQty = 1;
  }

  Widget buildSelectionActions() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          MultiDeleteButton(
            selectedItems: selectedItems,
            panel: 'view-staff',
            onPressed: () {
              if (selectedItems.isNotEmpty) {
                globalBloc.add(
                  GlobalDeleteMultipleRecordsEvent(
                    rKeys: selectedItems
                        .map((item) => item['rKey'].toString())
                        .toList(),
                    rPanel: 'view-staff',
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabletView() {
    return CustomScrollView(
      slivers: [
        // if (Responsive.isDesktop(context))
        SliverToBoxAdapter(
          child: BlocListener<GlobalBloc, GlobalState>(
            bloc: globalBloc,
            listener: (context, state) {
              if (state is GlobalChangeUserStatusSuccessStatus) {
                // Handle status change success (for approved, rejected, blocked, etc.)
                if (state.changeStatusEntity.status == 1) {
                  ToastService.instance.showSuccess(
                    context,
                    state.changeStatusEntity.message?.isNotEmpty == true
                        ? state.changeStatusEntity.message.toString()
                        : 'Status updated successfully',
                  );

                  // Refresh list after status change
                  staffBloc.add(
                    ViewStaffRecordsFetchingEvent(
                      viewStaffApiParam: ViewRecordApiParam(
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
                    state.changeStatusEntity.message?.isNotEmpty == true
                        ? state.changeStatusEntity.message.toString()
                        : 'Failed to update status',
                  );
                  staffBloc.add(
                    ViewStaffRecordsFetchingEvent(
                      viewStaffApiParam: ViewRecordApiParam(
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
                  state.message.isNotEmpty == true
                      ? state.message.toString()
                      : 'Error updating status',
                );
              } else if (state is GlobalDeleteRecordSuccessStatus) {
                ToastService.instance.showSuccess(
                  context,
                  state.deleteRecordEntity.message?.isNotEmpty == true
                      ? state.deleteRecordEntity.message.toString()
                      : 'Record deleted successfully',
                );
                // Refresh list after single delete
                staffBloc.add(
                  ViewStaffRecordsFetchingEvent(
                    viewStaffApiParam: ViewRecordApiParam(
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
                  state.message.isNotEmpty == true
                      ? state.message.toString()
                      : 'Error deleting record',
                );
              } else if (state is GlobalDeleteMultipleRecordsSuccessStatus) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.deleteRecordEntity.message?.isNotEmpty == true
                          ? state.deleteRecordEntity.message.toString()
                          : 'Records deleted successfully',
                    ),
                  ),
                );
                // Refresh list after bulk delete
                staffBloc.add(
                  ViewStaffRecordsFetchingEvent(
                    viewStaffApiParam: ViewRecordApiParam(
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message.isNotEmpty == true
                          ? state.message.toString()
                          : 'Error deleting records',
                    ),
                  ),
                );
              }
            },
            child: buildFilterFieldsDesktop,
          ),
        ),

        // if (isMultipleSelection) buildSelectionActions(),
        SliverToBoxAdapter(child: SizedBox(height: 15)),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [_buildPaginationWidget],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: BlocConsumer(
              bloc: staffBloc,
              listener: (context, state) {
                if (state is StaffViewLoadedSuccessStatus) {
                  // Reset data source when new data arrives
                  pageText = state.viewStaffModel.pageText.toString();
                  _dataSource = null;
                }
                if (state is StaffViewLoadedFailureStatus) {
                  ToastService.instance.showError(
                    context,
                    state.error.toString(),
                  );
                }
              },

              builder: (context, state) {
                switch (state.runtimeType) {
                  case StaffLoadingStatus:
                    return const Center(child: CircularProgressIndicator());
                  case StaffViewLoadedSuccessStatus:
                    final successData = (state as StaffViewLoadedSuccessStatus)
                        .viewStaffModel
                        .record;

                    if (state.viewStaffModel.status == 1) {
                      // Lazy initialization - create data source only once
                      _dataSource ??= StaffDataSource(
                        staffData: state.viewStaffModel.record ?? [],
                        value: null, // We don't need a global value anymore
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
                                ? (state.viewStaffModel.record ?? [])
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
                                                  .viewStaffModel
                                                  .record
                                                  ?.length ??
                                              0)) {
                                    final record =
                                        state.viewStaffModel.record![idx];
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

                        onEdit: (staff) {
                          final editStaffModel = EditStaffModel(
                            sFName: staff.uFirstName.toString(),
                            sLName: staff.uLastName.toString(),
                            sLoginEmailID: staff.uPersonalEmail.toString(),
                            sEmailID: staff.uEmail.toString(),
                            sMobileNumber: staff.uMobileNumber.toString(),
                            sAltMobileNumber: staff.uAlternateNumber.toString(),

                            sRole: staff.uRole.toString(),
                            sAccessPanel:
                                staff.uAccessPanel?.toString().split(',') ?? [],
                            rKey: staff.rKey.toString(),
                          );
                          context.pushNamed(
                            EditStaffDetailsPage.routeName,
                            extra: editStaffModel,
                          );
                        },
                        onDelete: (staff) {
                          log(name: 'Delete Staff rKey', staff.rKey.toString());
                          // Wait a short delay to ensure deletion is complete before refreshing
                          Future.delayed(const Duration(milliseconds: 500), () {
                            staffBloc.add(
                              ViewStaffRecordsFetchingEvent(
                                viewStaffApiParam: ViewRecordApiParam(),
                              ),
                            );
                          });
                        },

                        onChanged: (value, staff) {
                          if (value == '5') {
                            // Clear previous reason and open dialog to capture reason from user
                            // reasonController.clear();
                            showDialog(
                              context: context,
                              builder: (context) => customAlertBoxWidget(
                                staff.rKey.toString(),
                                '',
                                value.toString(),
                              ),
                            ).then((_) {
                              // After dialog closes, refresh list
                              staffBloc.add(
                                ViewStaffRecordsFetchingEvent(
                                  viewStaffApiParam: ViewRecordApiParam(
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
                          } else {
                            // For other statuses, call API immediately
                            globalBloc.add(
                              GlobalChangeUserStatusEvent(
                                param: ChangeStaffParam(
                                  rKey: staff.rKey.toString(),
                                  rPanel: 'view-staff',
                                  rStatus: value!,

                                  statusReason: reasonController.text,
                                ),
                              ),
                            );
                          }
                        },
                        context: context,

                        // onStatusUpdate: (StaffRecords, String) {},
                      );
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        pageQty = state.viewStaffModel.pageQty ?? 1;
                      });
                    });

                    return state.viewStaffModel.status != 1
                        ? Center(
                            child: Text(
                              state.viewStaffModel.message ??
                                  'Refresh to load data',
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
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
                                selectionMode: isMultipleSelection
                                    ? SelectionMode.multiple
                                    : SelectionMode.single,
                                onSelectionChanged: (addedRows, removedRows) {
                                  if (_dataSource == null) return;
                                  setState(() {
                                    selectedRows.addAll(addedRows);
                                    selectedRows.removeWhere(
                                      (row) => removedRows.contains(row),
                                    );

                                    final selectedRecords = selectedRows
                                        .map((row) {
                                          final index = _dataSource!.rows
                                              .indexOf(row);
                                          if (index >= 0 &&
                                              index <
                                                  state
                                                      .viewStaffModel
                                                      .record!
                                                      .length) {
                                            return state
                                                .viewStaffModel
                                                .record?[index]
                                                .toJson();
                                          }
                                          return null;
                                        })
                                        .where((record) => record != null)
                                        .cast<Map<String, dynamic>>()
                                        .toList();
                                    handleSelectionChanged(selectedRecords);

                                    print(
                                      'DEBUG: Selected ${selectedRows.length} rows',
                                    );
                                    print(
                                      'DEBUG: Added: ${addedRows.length}, Removed: ${removedRows.length}',
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
                                columnWidthMode: ColumnWidthMode.fill,
                                columns: buildGridColumns(),
                              ),
                            ),
                          );
                  case StaffViewLoadedFailureStatus:
                    final failureState = state as StaffViewLoadedFailureStatus;
                    return Center(
                      child: RefreshButton(
                        onPressed: () {
                          log(
                            failureState.error.toString(),
                            name: 'Retry Fetching Staff Records',
                          );
                          staffBloc.add(
                            ViewStaffRecordsFetchingEvent(
                              viewStaffApiParam: ViewRecordApiParam(
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
                      ),
                    );
                  default:
                    return SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ],
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
          key: _stateKey,
          appBar: !Responsive.isDesktop(context)
              ? MobileAppBar(context, _stateKey, 'View Staff')
              : DesktopAppBar(context, _stateKey, 'View Staff', false),

          drawer: !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : null,
          body: _buildTabletView(),
          // floatingActionButton:
        );
      },
    );
  }

  Widget get _buildPaginationWidget => TableBottomWidget(
    pageText: pageText,
    currentPage: pageNo,
    pageQty: pageQty,
    onPagePressed: (pageNumber) {
      setState(() {
        pageNo = pageNumber;
      });
      staffBloc.add(
        ViewStaffRecordsFetchingEvent(
          viewStaffApiParam: ViewRecordApiParam(
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
        staffBloc.add(
          ViewStaffRecordsFetchingEvent(
            viewStaffApiParam: ViewRecordApiParam(
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
      if (pageNo != null && pageNo! >= 1) {
        setState(() {
          pageNo = pageNo! - 1;
          staffBloc.add(
            ViewStaffRecordsFetchingEvent(
              viewStaffApiParam: ViewRecordApiParam(
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
      if (pageNo != null && pageQty != null && pageNo! <= pageQty!) {
        setState(() {
          pageNo = pageNo! + 1;
          staffBloc.add(
            ViewStaffRecordsFetchingEvent(
              viewStaffApiParam: ViewRecordApiParam(
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
        staffBloc.add(
          ViewStaffRecordsFetchingEvent(
            viewStaffApiParam: ViewRecordApiParam(
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
