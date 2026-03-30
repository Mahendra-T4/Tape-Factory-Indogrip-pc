import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/scroll_behavier.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/utils/widgets/textfield_label.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';

import 'package:indogrip/features/global/presentation/widget/pagination_widget.dart';
import 'package:indogrip/features/global/presentation/widget/refresh_button.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/bloc/jumbo_roll_bloc.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/edit/edit_jump_roll.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/widgets/jumbo_detail_box.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:indogrip/features/jumbo%20roll/data/jumboroll_data_source.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/view/view_jumboroll_builder.dart';

class ViewJumboRollPanel extends StatefulWidget {
  const ViewJumboRollPanel({super.key});
  static const String routeName = '/viewJumboRoll';

  @override
  State<ViewJumboRollPanel> createState() => _ViewJumboRollPanelState();
}

class _ViewJumboRollPanelState extends ViewJumboRollBuilder {
  // late JumboRollBloc jumboRollBloc;
  late final GlobalBloc globalBloc;
  final GlobalKey<ScaffoldState> _stateKey = GlobalKey<ScaffoldState>();
  final GlobalKey _key = GlobalKey();
  late Map<String, double> columnWidths = {};
  bool isChecked = false;

  List<DataGridRow> selectedRows = [];

  @override
  void dispose() {
    selectedRows.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    pageNo = 1; // Initialize current page
    pageQty = 1; // Initialize total pages
    jumboRollBloc = JumboRollBloc();
    jumboRollBloc.add(
      FetchViewJumboRollRecordEvent(param: ViewRecordApiParam()),
    );
    _initializeDataSource();
  }

  void _initializeDataSource() {}

  Widget _buildDesktopView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search fields
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
                    jumboRollBloc.add(
                      FetchViewJumboRollRecordEvent(
                        param: ViewRecordApiParam(
                          keyword: searchController.text,
                          filterBy: recordValue?.toString() ?? '',
                          orderBy: filterValue?.toString() ?? '',
                          pageNo: pageNo.toString(),
                          sortBy: entryValue?.toString() ?? '',
                          vendorKey: vendorKey,
                          micID: micID,
                          baseID: baseID,
                          widthID: widthID,
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
                    jumboRollBloc.add(
                      FetchViewJumboRollRecordEvent(
                        param: ViewRecordApiParam(
                          keyword: searchController.text,
                          filterBy: recordValue?.toString() ?? '',
                          orderBy: filterValue?.toString() ?? '',
                          pageNo: pageNo.toString(),
                          sortBy: entryValue?.toString() ?? '',
                          vendorKey: vendorKey,
                          micID: micID,
                          baseID: baseID,
                          widthID: widthID,
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
                  jumboRollBloc.add(
                    FetchViewJumboRollRecordEvent(
                      param: ViewRecordApiParam(
                        keyword: searchController.text,
                        filterBy: recordValue?.toString() ?? '',
                        orderBy: filterValue?.toString() ?? '',
                        pageNo: pageNo.toString(),
                        sortBy: entryValue?.toString() ?? '',
                        vendorKey: vendorKey,
                        micID: micID,
                        baseID: baseID,
                        widthID: widthID,
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
                } else if (state is GlobalDeleteMultipleRecordsSuccessStatus) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.deleteRecordEntity.message ?? 'Records deleted',
                      ),
                    ),
                  );
                  // Refresh list after bulk delete
                  jumboRollBloc.add(
                    FetchViewJumboRollRecordEvent(
                      param: ViewRecordApiParam(
                        keyword: searchController.text,
                        filterBy: recordValue?.toString() ?? '',
                        orderBy: filterValue?.toString() ?? '',
                        pageNo: pageNo.toString(),
                        sortBy: entryValue?.toString() ?? '',
                        vendorKey: vendorKey,
                        micID: micID,
                        baseID: baseID,
                        widthID: widthID,
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [_buildPaginationWidget],
              ),
            ),

            // Selection actions widget
            SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: BlocConsumer(
                bloc: jumboRollBloc,

                listener: (context, state) {
                  if (state is FetchViewJumboRollRecordSuccessStatus) {
                    pageText = state.viewJumboRollModel.pageText.toString();
                    dataSource = null;
                    highlightedRowIndex = null;
                    // Reset data source when new data is fetched
                  }
                },
                buildWhen: (previous, current) {
                  // Always rebuild to handle state changes
                  return true;
                },
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case const (JumboRollLoadingStatus):
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    case const (FetchViewJumboRollRecordSuccessStatus):
                      final successData =
                          (state as FetchViewJumboRollRecordSuccessStatus)
                              .viewJumboRollModel;

                      dataSource ??= JumboRollDataSource(
                        context: context,
                        jumboRollData: successData.record ?? [],
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
                            final selectedData = value
                                ? (successData.record ?? [])
                                      .map((record) => record.toJson())
                                      .cast<Map<String, dynamic>>()
                                      .toList()
                                : <Map<String, dynamic>>[];
                            handleSelectionChanged(selectedData);
                          });
                        },
                        //
                        onCheckboxChanged: (checked, index) {
                          if (dataSource == null) return;
                          setState(() {
                            if (checked) {
                              selectedRows.add(dataSource!.rows[index]);
                            } else {
                              selectedRows.remove(dataSource!.rows[index]);
                            }
                            final selectedRecords = selectedRows
                                .map((row) {
                                  final idx = dataSource!.rows.indexOf(row);
                                  if (idx != -1 &&
                                      idx < (successData.record?.length ?? 0)) {
                                    final record = successData.record![idx];
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
                            EditJumboRollPanel.routeName,
                            extra: value,
                          );
                        },
                        onDelete: (roll) {
                          jumboRollBloc.add(
                            FetchViewJumboRollRecordEvent(
                              param: ViewRecordApiParam(),
                            ),
                          );
                          jumboRollBloc.add(
                            FetchViewJumboRollRecordEvent(
                              param: ViewRecordApiParam(
                                keyword: searchController.text,
                                filterBy: recordValue?.toString() ?? '',
                                orderBy: filterValue?.toString() ?? '',
                                pageNo: pageNo.toString(),
                                sortBy: entryValue?.toString() ?? '',
                                vendorKey: vendorKey,
                                micID: micID,
                                baseID: baseID,
                                widthID: widthID,
                                fromDate: fromDateController.text,
                                toDate: toDateController.text,
                              ),
                            ),
                          );
                        },
                        // onProfile: (p0) {},
                        stickerPopup: (value) {
                          JumboPrintStickers(value);
                        },
                      );
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          pageQty = successData.pageQty ?? 1;
                        });
                      });
                      return successData.status == 1
                          ? Column(
                              children: [
                                JumboDetailBox(
                                  availableJumbo: successData.availableJumbo
                                      .toString(),
                                  availableLength: successData.availableLength
                                      .toString(),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  child: ScrollConfiguration(
                                    behavior: HorizontalMouseScrollBehavior(),
                                    child: SfDataGrid(
                                      showHorizontalScrollbar: true,
                                      key: _key,
                                      rowsPerPage: 4,
                                      refreshIndicatorStrokeWidth: 100,
                                      allowPullToRefresh: true,
                                      allowColumnsResizing: true,
                                      highlightRowOnHover: true,

                                      columnResizeMode:
                                          ColumnResizeMode.onResizeEnd,
                                      isScrollbarAlwaysShown: true,
                                      showVerticalScrollbar: true,

                                      // refreshIndicatorDisplacement: 50,
                                      showCheckboxColumn: isMultipleSelection,
                                      selectionMode: isMultipleSelection
                                          ? SelectionMode.multiple
                                          : SelectionMode.single,
                                      onSelectionChanged: (addedRows, removedRows) {
                                        if (dataSource == null) return;
                                        setState(() {
                                          selectedRows.addAll(addedRows);
                                          selectedRows.removeWhere(
                                            (row) => removedRows.contains(row),
                                          );

                                          final selectedRecords = selectedRows
                                              .map((row) {
                                                final index = dataSource!.rows
                                                    .indexOf(row);
                                                if (index >= 0 &&
                                                    index <
                                                        successData
                                                            .record!
                                                            .length) {
                                                  return successData
                                                      .record?[index]
                                                      .toJson();
                                                }
                                                return null;
                                              })
                                              .where((record) => record != null)
                                              .cast<Map<String, dynamic>>()
                                              .toList();
                                          handleSelectionChanged(
                                            selectedRecords,
                                          );

                                          print(
                                            'DEBUG: Selected ${selectedRows.length} rows',
                                          );
                                          print(
                                            'DEBUG: Added: ${addedRows.length}, Removed: ${removedRows.length}',
                                          );
                                        });
                                      },
                                      onCellTap:
                                          (DataGridCellTapDetails details) {
                                            if (dataSource != null) {
                                              dataSource!.highlightedRowIndex =
                                                  details
                                                      .rowColumnIndex
                                                      .rowIndex -
                                                  1;
                                            }
                                          },
                                      onColumnResizeUpdate: (details) {
                                        setState(() {
                                          columnWidths[details
                                                  .column
                                                  .columnName] =
                                              details.width;
                                        });
                                        return true;
                                      },
                                      source: dataSource!,
                                      columns: buildGridColumns(),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Expanded(
                              child: Center(
                                child: Text(
                                  successData.message ??
                                      'No response from server',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            );
                    case const (FetchViewJumboRollRecordFailureStatus):
                      return Center(
                        child: RefreshButton(
                          onPressed: () {
                            log(
                              (state as FetchViewJumboRollRecordFailureStatus)
                                  .errorMessage,
                              name: 'FetchViewJumboRollRecordFailureStatus',
                            );
                            jumboRollBloc.add(
                              FetchViewJumboRollRecordEvent(
                                param: ViewRecordApiParam(
                                  keyword: searchController.text,
                                  filterBy: recordValue?.toString() ?? '',
                                  orderBy: filterValue?.toString() ?? '',
                                  pageNo: pageNo.toString(),
                                  sortBy: entryValue?.toString() ?? '',
                                  vendorKey: vendorKey,
                                  micID: micID,
                                  baseID: baseID,
                                  widthID: widthID,
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
            SizedBox(height: 100),
          ],
        ),
      ),
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
          child: const Text(
            'Sr No',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Vendor Code',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Vendor Code")),
        ),
      ),
      GridColumn(
        columnName: 'Vender Company',
        width: 250,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Vender Company")),
        ),
      ),

      GridColumn(
        columnName: 'Record Date ',
        columnWidthMode: ColumnWidthMode.fill,
        width: 250,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Text(
            'Record Date ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Bill Date',
        columnWidthMode: ColumnWidthMode.fill,
        width: 130,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Text(
            'Bill Date',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Bill No',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Bill No")),
        ),
      ),
      GridColumn(
        columnName: 'Roll/Packet No',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Roll/Packet No")),
        ),
      ),
      GridColumn(
        columnName: 'Base',
        width: 100,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Base")),
        ),
      ),
      GridColumn(
        columnName: 'Mic',
        width: 100,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Mic")),
        ),
      ),
      GridColumn(
        columnName: 'Length',
        width: 100,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Length")),
        ),
      ),
      GridColumn(
        columnName: 'Consume Length',
        width: 100,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Consume Length")),
        ),
      ),
      GridColumn(
        columnName: 'Available Length',
        width: 100,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Available Length")),
        ),
      ),
      GridColumn(
        columnName: 'Width',
        width: 100,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Width")),
        ),
      ),
      GridColumn(
        columnName: 'Net Weight',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Net Weight")),
        ),
      ),
      GridColumn(
        columnName: 'Square',
        width: 100,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Square Meter")),
        ),
      ),
      GridColumn(
        columnName: 'Amount Per KG',
        width: 100,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Amount Per KG")),
        ),
      ),
      GridColumn(
        columnName: 'Roll Cost',
        width: 100,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Roll Cost")),
        ),
      ),

      GridColumn(
        columnName: 'Remark',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Remark")),
        ),
      ),
      GridColumn(
        columnName: JumboRoll.jumboStatusLabel,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Stock Status")),
        ),
      ),
      if (HiveService.getRole() != '2')
        GridColumn(
          columnName: 'actions',
          width: 220,
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
              ? MobileAppBar(context, _stateKey, 'View Jumbo Rolls')
              : DesktopAppBar(context, _stateKey, 'View Jumbo Rolls', false),
          drawer: !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : null,
          body: _buildDesktopView(),

          // : SizedBox.shrink(),
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
      jumboRollBloc.add(
        FetchViewJumboRollRecordEvent(
          param: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue?.toString() ?? '',
            orderBy: filterValue?.toString() ?? '',
            pageNo: pageNo.toString(),
            sortBy: entryValue?.toString() ?? '',
            vendorKey: vendorKey,
            micID: micID,
            baseID: baseID,
            widthID: widthID,
            fromDate: fromDateController.text,
            toDate: toDateController.text,
          ),
        ),
      );
    },
    onFirstPressed: () {
      setState(() {
        pageNo = 1;
        jumboRollBloc.add(
          FetchViewJumboRollRecordEvent(
            param: ViewRecordApiParam(
              keyword: searchController.text,
              filterBy: recordValue?.toString() ?? '',
              orderBy: filterValue?.toString() ?? '',
              pageNo: pageNo.toString(),
              sortBy: entryValue?.toString() ?? '',
              vendorKey: vendorKey,
              micID: micID,
              baseID: baseID,
              widthID: widthID,
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
          jumboRollBloc.add(
            FetchViewJumboRollRecordEvent(
              param: ViewRecordApiParam(
                keyword: searchController.text,
                filterBy: recordValue?.toString() ?? '',
                orderBy: filterValue?.toString() ?? '',
                pageNo: pageNo.toString(),
                sortBy: entryValue?.toString() ?? '',
                vendorKey: vendorKey,
                micID: micID,
                baseID: baseID,
                widthID: widthID,
                fromDate: fromDateController.text,
                toDate: toDateController.text,
              ),
            ),
          );
        });
      }
    },
    onNextPressed: () {
      if (pageNo >= 1) {
        setState(() {
          pageNo = pageNo + 1;
          jumboRollBloc.add(
            FetchViewJumboRollRecordEvent(
              param: ViewRecordApiParam(
                keyword: searchController.text,
                filterBy: recordValue?.toString() ?? '',
                orderBy: filterValue?.toString() ?? '',
                pageNo: pageNo.toString(),
                sortBy: entryValue?.toString() ?? '',
                vendorKey: vendorKey,
                micID: micID,
                baseID: baseID,
                widthID: widthID,
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
        jumboRollBloc.add(
          FetchViewJumboRollRecordEvent(
            param: ViewRecordApiParam(
              keyword: searchController.text,
              filterBy: recordValue?.toString() ?? '',
              orderBy: filterValue?.toString() ?? '',
              pageNo: pageNo.toString(),
              sortBy: entryValue?.toString() ?? '',
              vendorKey: vendorKey,
              micID: micID,
              baseID: baseID,
              widthID: widthID,
              fromDate: fromDateController.text,
              toDate: toDateController.text,
            ),
          ),
        );
      });
    },
  );
}
