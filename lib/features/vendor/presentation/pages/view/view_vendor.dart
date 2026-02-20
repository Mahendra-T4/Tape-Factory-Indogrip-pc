import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/utils/widgets/textfield_label.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/data/model/change_status_param.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/data_filtration.dart';
import 'package:indogrip/features/global/presentation/widget/pagination_widget.dart';
import 'package:indogrip/features/global/presentation/widget/search_fields.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:indogrip/features/vendor/presentation/bloc/vendor_bloc.dart';
import 'package:indogrip/features/vendor/presentation/pages/edit/edit_vendor.dart';
import 'package:indogrip/features/vendor/presentation/pages/profile/vendor_profile.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:indogrip/features/vendor/data/vendor_data_source.dart';
import 'package:indogrip/features/vendor/presentation/pages/view/view_vendor_builder.dart';

class ViewVendorPanel extends StatefulWidget {
  const ViewVendorPanel({super.key});
  static const String routeName = '/viewVendor';

  @override
  State<ViewVendorPanel> createState() => _ViewVendorPanelState();
}

class _ViewVendorPanelState extends ViewVendorBuilder {
  final GlobalKey<ScaffoldState> _stateKey = GlobalKey<ScaffoldState>();
  final GlobalKey _key = GlobalKey();
  late Map<String, double> columnWidths = {};
  bool isChecked = false;
  VendorDataSource? _dataSource;
  List<DataGridRow> selectedRows = [];

  @override
  void dispose() {
    selectedRows.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    vendorBloc = VendorBloc();
    globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    vendorBloc.add(
      ViewVendorRecordsFetchingEvent(
        param: ViewRecordApiParam(
          keyword: searchController.text,
          filterBy: recordValue ?? '',
          orderBy: filterValue ?? '',
          pageNo: pageNo.toString(),
          sortBy: entryValue ?? '',
          fromDate: fromDateController.text,
          toDate: toDateController.text,
        ),
      ),
    );
  }

  Widget get searchFields => SearchFields(
    isStatus: true,
    controller: searchController,
    onSearch: (keyword) {
      vendorBloc.add(
        ViewVendorRecordsFetchingEvent(
          param: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue.toString(),
            orderBy: filterValue.toString(),
            pageNo: pageNo.toString(),
            sortBy: entryValue.toString(),
            fromDate: fromDateController.text,
            toDate: toDateController.text,
          ),
        ),
      );
    },
    orderByValue: filterValue,
    onChangedStatus: (status) {
      setState(() {
        recordValue = status;
      });
      vendorBloc.add(
        ViewVendorRecordsFetchingEvent(
          param: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue.toString(),
            orderBy: filterValue.toString(),
            pageNo: pageNo.toString(),
            sortBy: entryValue.toString(),
            fromDate: fromDateController.text,
            toDate: toDateController.text,
          ),
        ),
      );
    },
    onChangedOrder: (order) {
      setState(() {
        filterValue = order;
      });
      vendorBloc.add(
        ViewVendorRecordsFetchingEvent(
          param: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue.toString(),
            orderBy: filterValue.toString(),
            pageNo: pageNo.toString(),
            sortBy: entryValue.toString(),
            fromDate: fromDateController.text,
            toDate: toDateController.text,
          ),
        ),
      );
    },
    onChangedSort: (sortBy) {
      setState(() {
        entryValue = sortBy ?? 10;
      });
      vendorBloc.add(
        ViewVendorRecordsFetchingEvent(
          param: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue.toString(),
            orderBy: filterValue.toString(),
            pageNo: pageNo.toString(),
            sortBy: entryValue.toString(),
            fromDate: fromDateController.text,
            toDate: toDateController.text,
          ),
        ),
      );
    },
  );

  Widget get buildFilterFieldsDesktop => Padding(
    padding: const EdgeInsets.only(top: kDefaultVerticalPadding - 30),
    child: Column(
      children: [
        DateFiltration(
          fromDateController: fromDateController,
          toDateController: toDateController,
        ),
        searchFields,
        // SizedBox(height: 15),
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            refreshButton,
            if (isMultipleSelection) buildSelectionActions(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      isMultipleSelection = !isMultipleSelection;
                      if (!isMultipleSelection) {
                        selectedItems.clear();
                      }
                    });
                  },
                  icon: Icon(
                    isMultipleSelection
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: Colors.blue,
                  ),
                  label: Text(
                    isMultipleSelection
                        ? 'Multiple Selection'
                        : 'Single Selection',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 15),
      ],
    ),
  );

  Widget _buildDesktopView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (Responsive.isDesktop(context)) SideMenuWidget(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (Responsive.isDesktop(context))
                DesktopAppBar(context, _stateKey, 'View Vendors', false),

              // searchFields,
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
                      vendorBloc.add(
                        ViewVendorRecordsFetchingEvent(
                          param: ViewRecordApiParam(
                            keyword: searchController.text,
                            filterBy: recordValue.toString(),
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
                      vendorBloc.add(
                        ViewVendorRecordsFetchingEvent(
                          param: ViewRecordApiParam(
                            keyword: searchController.text,
                            filterBy: recordValue.toString(),
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
                    vendorBloc.add(
                      ViewVendorRecordsFetchingEvent(
                        param: ViewRecordApiParam(
                          keyword: searchController.text,
                          filterBy: recordValue.toString(),
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
                    vendorBloc.add(
                      ViewVendorRecordsFetchingEvent(
                        param: ViewRecordApiParam(
                          keyword: searchController.text,
                          filterBy: recordValue.toString(),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [_buildPaginationWidget],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // buildSelectionActions(),
                      BlocConsumer(
                        bloc: vendorBloc,
                        listener: (context, state) {
                          if (state is ViewVendorRecordsLoadedSuccessStatus) {
                            _dataSource = null;
                          }
                          if (state is ViewVendorRecordsErrorStatus) {
                            ToastService.instance.showError(
                              context,
                              state.errorMessage,
                            );
                          }
                        },
                        builder: (context, state) {
                          switch (state.runtimeType) {
                            case const (VendorLoadingStatus):
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            case const (ViewVendorRecordsLoadedSuccessStatus):
                              final successState =
                                  (state as ViewVendorRecordsLoadedSuccessStatus)
                                      .viewVendorModel;
                              _dataSource ??= VendorDataSource(
                                context: context,
                                vendorData: successState.record ?? [],
                                isAllChecked: isChecked,
                                onChanged: (value, vendor) {
                                  if (value == '5') {
                                    // Clear previous reason and open dialog to capture reason from user
                                    reasonController.clear();
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          customAlertBoxWidget(
                                            vendor.rKey.toString(),
                                            '',
                                            value.toString(),
                                          ),
                                    ).then((_) {
                                      // After dialog closes, refresh the list to reset any UI changes
                                      // The API response will update the status if successful
                                      vendorBloc.add(
                                        ViewVendorRecordsFetchingEvent(
                                          param: ViewRecordApiParam(
                                            keyword: searchController.text,
                                            filterBy: recordValue.toString(),
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
                                    // For other statuses, call API directly (no reason required)
                                    globalBloc.add(
                                      GlobalChangeUserStatusEvent(
                                        param: ChangeStaffParam(
                                          rKey: vendor.rKey.toString(),
                                          rPanel: 'view-vendor',
                                          rStatus: value.toString(),
                                          statusReason: '',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                // onStatusChanged: (value) {
                                //   setState(() {
                                //     isChecked = value;
                                //     if (value) {
                                //       selectedRows = List.from(
                                //         _dataSource!.rows,
                                //       );
                                //     } else {
                                //       selectedRows.clear();
                                //     }
                                //     handleSelectionChanged(
                                //       value
                                //           ? List.from(
                                //               successState.record!.toList(),
                                //             )
                                //           : [],
                                //     );
                                //   });
                                // },
                                onCheckboxChanged: (checked, index) {
                                  if (_dataSource == null) return;
                                  setState(() {
                                    if (checked) {
                                      selectedRows.add(
                                        _dataSource!.rows[index],
                                      );
                                    } else {
                                      selectedRows.remove(
                                        _dataSource!.rows[index],
                                      );
                                    }
                                    final selectedRecords = selectedRows
                                        .map((row) {
                                          final idx = _dataSource!.rows.indexOf(
                                            row,
                                          );
                                          if (idx != -1 &&
                                              idx <
                                                  (successState
                                                          .record
                                                          ?.length ??
                                                      0)) {
                                            final record =
                                                successState.record![idx];
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
                                onEdit: (value) {
                                  context.pushNamed(
                                    EditVendorPanel.routeName,
                                    extra: value,
                                  );
                                },
                                onDelete: (value) {
                                  vendorBloc.add(
                                    ViewVendorRecordsFetchingEvent(
                                      param: ViewRecordApiParam(
                                        keyword: searchController.text,
                                        filterBy: recordValue.toString(),
                                        orderBy: filterValue.toString(),
                                        pageNo: pageNo.toString(),
                                        sortBy: entryValue.toString(),
                                        fromDate: fromDateController.text,
                                        toDate: toDateController.text,
                                      ),
                                    ),
                                  );
                                },
                                onProfile: (value) {
                                  context.pushNamed(
                                    VendorProfile.routeName,
                                    extra: value,
                                  );
                                },
                                onStatusChanged: (bool) {},
                              );

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  pageQty = state.viewVendorModel.pageQty ?? 1;
                                });
                              });
                              return successState.status == 1
                                  ? Expanded(
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
                                          if (_dataSource == null) return;
                                          setState(() {
                                            selectedRows.addAll(addedRows);
                                            selectedRows.removeWhere(
                                              (row) =>
                                                  removedRows.contains(row),
                                            );

                                            final selectedRecords = selectedRows
                                                .map((row) {
                                                  final index = _dataSource!
                                                      .rows
                                                      .indexOf(row);
                                                  if (index >= 0 &&
                                                      index <
                                                          state
                                                              .viewVendorModel
                                                              .record!
                                                              .length) {
                                                    return state
                                                        .viewVendorModel
                                                        .record?[index]
                                                        .toJson();
                                                  }
                                                  return null;
                                                })
                                                .where(
                                                  (record) => record != null,
                                                )
                                                .cast<Map<String, dynamic>>()
                                                .toList();
                                            handleSelectionChanged(
                                              selectedRecords,
                                            );
                                          });
                                        },
                                        onColumnResizeUpdate:
                                            (
                                              ColumnResizeUpdateDetails details,
                                            ) {
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
                                    )
                                  : Expanded(
                                      child: Center(
                                        child: Text(
                                          successState.message ??
                                              'Refresh to load data',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    );

                            case const (ViewVendorRecordsErrorStatus):
                              return Center(
                                child: Text(
                                  (state as ViewVendorRecordsErrorStatus)
                                      .errorMessage,
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
        columnName: Vendor.srNo,
        columnWidthMode: ColumnWidthMode.fitByCellValue,
        width: 70,
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
        columnName: Vendor.vendorCode,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Vendor Code")),
        ),
      ),
      GridColumn(
        columnName: Vendor.ownerName,
        width: 300,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Owner Name")),
        ),
      ),

      GridColumn(
        columnName: Vendor.ownerMobile,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Owner Mobile")),
        ),
      ),
      GridColumn(
        columnName: Vendor.companyName,
        width: 300,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Text(
            'Company Name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Vendor.mobileNumber,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Mobile Number")),
        ),
      ),
      GridColumn(
        columnName: Vendor.gstin,
        width: 180,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("GSTIN")),
        ),
      ),

      GridColumn(
        columnName: Vendor.representativeManager,
        width: 200,
        label: Container(
          color: Colors.grey[100],
          child: Center(child: const Text('Representative Manager')),
        ),
      ),
      GridColumn(
        columnName: Vendor.representativeMobile,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(
            child: TextFieldlabelText("Representative Mobile"),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Status',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: Center(child: TextFieldlabelText("Status")),
        ),
      ),
      GridColumn(
        columnName: 'actions',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Actions")),
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
              ? MobileAppBar(context, _stateKey, 'View Vendors')
              : null,
          drawer: !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : null,
          body: _buildDesktopView(),
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
      vendorBloc.add(
        ViewVendorRecordsFetchingEvent(
          param: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue.toString(),
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
        vendorBloc.add(
          ViewVendorRecordsFetchingEvent(
            param: ViewRecordApiParam(
              keyword: searchController.text,
              filterBy: recordValue.toString(),
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
      if (pageNo != null && pageQty != null && pageNo! <= pageQty!) {
        setState(() {
          pageNo = pageNo! - 1;
          vendorBloc.add(
            ViewVendorRecordsFetchingEvent(
              param: ViewRecordApiParam(
                keyword: searchController.text,
                filterBy: recordValue.toString(),
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
      if (pageNo != null && pageNo! >= 1) {
        setState(() {
          pageNo = pageNo! + 1;
          vendorBloc.add(
            ViewVendorRecordsFetchingEvent(
              param: ViewRecordApiParam(
                keyword: searchController.text,
                filterBy: recordValue.toString(),
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
        vendorBloc.add(
          ViewVendorRecordsFetchingEvent(
            param: ViewRecordApiParam(
              keyword: searchController.text,
              filterBy: recordValue.toString(),
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
