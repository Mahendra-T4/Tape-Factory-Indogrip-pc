import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/scroll_behavier.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/utils/widgets/textfield_label.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/data/model/change_status_param.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/data_filtration.dart';
import 'package:indogrip/features/global/presentation/widget/pagination_widget.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:indogrip/features/wastage/data/model/edit_wastage_api_param.dart';
import 'package:indogrip/features/wastage/data/model/view_wastage_table_column.dart';
import 'package:indogrip/features/wastage/domain/repositories/add_wastage_main_repo.dart';
import 'package:indogrip/features/wastage/presentation/bloc/wastage_bloc.dart';
import 'package:indogrip/features/wastage/presentation/pages/edit/edit_wastage.dart';
import 'package:indogrip/features/wastage/presentation/pages/profile/wastage_profile.dart';
import 'package:indogrip/features/wastage/presentation/pages/view/view_wastage_builder.dart';
import 'package:indogrip/features/wastage/data/wastage_data_source.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ViewWastagePanel extends StatefulWidget {
  const ViewWastagePanel({super.key});
  static const String routeName = '/viewWastage';

  @override
  State<ViewWastagePanel> createState() => _ViewWastagePanelState();
}

class _ViewWastagePanelState extends ViewWastageBuilder {
  final GlobalKey<ScaffoldState> _stateKey = GlobalKey<ScaffoldState>();
  bool isNotEmpty = false;

  late final GlobalBloc globalBloc;
  final GlobalKey _key = GlobalKey();
  late Map<String, double> columnWidths = {};
  bool isChecked = false;
  WastageDataSource? _dataSource;
  List<DataGridRow> selectedRows = [];

  @override
  void dispose() {
    selectedRows.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    wastageBloc = WastageBloc(addWastageRepository: AddWastageRepository());
    globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    eventHandler();
  }

  List<GridColumn> buildGridColumns() {
    return [
      GridColumn(
        columnName: WTableColumn.SrNo,
        columnWidthMode: ColumnWidthMode.fill,
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
        columnName: WTableColumn.consigneeName,
        width: 300,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Consignee Name")),
        ),
      ),
      GridColumn(
        columnName: WTableColumn.wastageDate,
        width: 180,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Wastage Date")),
        ),
      ),
      GridColumn(
        columnName: WTableColumn.billNumber,
        width: 180,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Bill No")),
        ),
      ),
      GridColumn(
        columnName: WTableColumn.Weight,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Weight")),
        ),
      ),
      GridColumn(
        columnName: WTableColumn.pricePerKG,
        width: 200,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Price/kg")),
        ),
      ),
      GridColumn(
        columnName: WTableColumn.price,
        width: 200,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Price")),
        ),
      ),
      GridColumn(
        columnName: WTableColumn.Remark,
        width: 130,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Remark")),
        ),
      ),
      GridColumn(
        columnName: 'Status',
        width: 130,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText("Status")),
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

  Widget _buildDesktopView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                  eventHandler();
                } else {
                  ToastService.instance.showError(
                    context,
                    state.changeStatusEntity.message ?? 'try again later',
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
                eventHandler();
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
                eventHandler();
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
            child: Column(
              children: [
                DateFiltration(
                  fromDateController: fromDateController,
                  toDateController: toDateController,
                ),
                searchFields,
              ],
            ),
          ),

          refreshButton,
          SizedBox(height: 15),
          if (isNotEmpty) _buildPaginationWidget,

          // SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: BlocConsumer(
              bloc: wastageBloc,
              listener: (context, state) {
                if (state is ViewWastageFromRecordsSuccessStatus) {
                  if (state.viewWastageModel.status == 1) {
                    pageText = state.viewWastageModel.pageText ?? '';
                    if (state.viewWastageModel.status == 1) {
                      setState(() {
                        isNotEmpty = true;
                      });
                    } else {
                      setState(() {
                        isNotEmpty = false;
                      });
                    }
                  }
                  _dataSource = null;
                }
              },
              buildWhen: (previous, current) {
                // Always rebuild to handle state changes
                return true;
              },
              builder: (context, state) {
                if (state is WastageLoadingStatus) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (state is ViewWastageFromRecordsSuccessStatus) {
                  final successData = state.viewWastageModel;
                  // Lazy initialization - create data source only once
                  _dataSource ??= WastageDataSource(
                    wastageData: successData.record ?? [],
                    isAllChecked: isChecked,
                    onStatusChanged: (value) {
                      setState(() {
                        isChecked = value;
                        if (value) {
                          selectedRows = List.from(_dataSource?.rows ?? []);
                        } else {
                          selectedRows.clear();
                        }
                        handleSelectionChanged(
                          value ? List.from(successData.record!) : [],
                        );
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
                                      (state.viewWastageModel.record?.length ??
                                          0)) {
                                final record =
                                    state.viewWastageModel.record![idx];
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
                      final editWastageParam = EditWastageApiParam(
                        wastageDate: value.wastageDate.toString(),
                        wastageClient: value.wastageClient.toString(),
                        billNumber: value.billNumber.toString(),
                        width: value.weight.toString(),
                        price_kg: value.pricePerKG.toString(),
                        rKey: value.rKey.toString(),
                        remark: value.remark.toString(),
                      );

                      context.pushNamed(
                        EditWastagePanel.routeName,
                        extra: editWastageParam,
                      );
                    },
                    onDelete: (value) {
                      wastageBloc.add(
                        ViewWastageFromRecords(
                          param: ViewRecordApiParam(
                            keyword: searchController.text,
                            filterBy: recordValue ?? '',
                            orderBy: filterValue.toString(),
                            pageNo: currentPage.toString(),
                            sortBy: entryValue.toString(),
                          ),
                        ),
                      );
                    },
                    onProfile: (value) {
                      context.pushNamed(WastageProfile.routeName, extra: value);
                    },
                    onChanged: (statusValue, WastageRecord) {
                      globalBloc.add(
                        GlobalChangeUserStatusEvent(
                          param: ChangeStaffParam(
                            rKey: WastageRecord.rKey.toString(),
                            rPanel: 'view-wastage',
                            rStatus: statusValue.toString(),
                            statusReason: '',
                          ),
                        ),
                      );
                      eventHandler();
                    },
                  );

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      pageQty = successData.pageQty ?? 1;
                    });
                  });
                  return successData.status == 1
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                        final index = _dataSource!.rows.indexOf(
                                          row,
                                        );
                                        if (index >= 0 &&
                                            index <
                                                state
                                                    .viewWastageModel
                                                    .record!
                                                    .length) {
                                          return state
                                              .viewWastageModel
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
                                      columnWidths[details.column.columnName] =
                                          details.width;
                                    });
                                    return true;
                                  },
                              source: _dataSource!,
                              columns: buildGridColumns(),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            // Table Header
                            ScrollConfiguration(
                              behavior: HorizontalMouseScrollBehavior(),
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                color: Colors.grey[100],
                                child: Row(
                                  children: buildGridColumns()
                                      .map(
                                        (column) => Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                              vertical: 12.0,
                                            ),
                                            child: column.label,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                            // Message below header
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                state.viewWastageModel.message ??
                                    'try again later',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                } else if (state is ViewWastageFromRecordsFailureStatus) {
                  return SizedBox.shrink();
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
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
              ? MobileAppBar(context, _stateKey, 'View Wastage')
              : DesktopAppBar(context, _stateKey, 'View Wastage', false),
          drawer: !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : null,
          body: _buildDesktopView(),
        );
      },
    );
  }

  Widget get _buildPaginationWidget => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: TableBottomWidget(
      currentPage: currentPage,
      pageQty: pageQty,
      pageText: pageText,
      onPagePressed: (pageNumber) {
        setState(() {
          currentPage = pageNumber;
        });
        eventHandler();
        // Page number button clicked
      },
      onFirstPressed: () {
        setState(() {
          currentPage = 1;
          eventHandler();
        });
      },
      onPreviousPressed: () {
        if (currentPage != null &&
            pageQty != null &&
            currentPage! <= pageQty!) {
          setState(() {
            currentPage = currentPage! - 1;
            eventHandler();
          });
        }
      },
      onNextPressed: () {
        if (currentPage != null && currentPage! >= 1) {
          setState(() {
            currentPage = currentPage! + 1;
            eventHandler();
          });
        }
      },
      onLastPressed: () {
        setState(() {
          currentPage = pageQty!;
          eventHandler();
        });
      },
    ),
  );
}
