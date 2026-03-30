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
import 'package:indogrip/features/carton/presentation/bloc/carton_bloc.dart';
import 'package:indogrip/features/carton/presentation/pages/edit/edit_carton.dart';
import 'package:indogrip/features/carton/presentation/pages/view/view_carton_builder.dart';
import 'package:indogrip/features/carton/data/carton_data_source.dart';
import 'package:indogrip/features/global/data/model/change_status_param.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/data_filtration.dart';
import 'package:indogrip/features/global/presentation/widget/pagination_widget.dart';
import 'package:indogrip/features/global/presentation/widget/refresh_button.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ViewCartonPanel extends StatefulWidget {
  const ViewCartonPanel({super.key});
  static const String routeName = '/viewCarton';

  @override
  State<ViewCartonPanel> createState() => _ViewCartonPanelState();
}

class _ViewCartonPanelState extends ViewCartonBuilder {
  final GlobalKey<ScaffoldState> _stateKey = GlobalKey<ScaffoldState>();
  final GlobalKey _key = GlobalKey();
  late Map<String, double> columnWidths = {};

  bool isChecked = false;
  CartonDataSource? _dataSource;
  List<DataGridRow> selectedRows = [];
  late final GlobalBloc globalBloc;

  @override
  void dispose() {
    selectedRows.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    cartonBloc = CartonBloc();
    globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    cartonBloc.add(
      ViewCartonRecordEvent(
        param: ViewRecordApiParam(
          keyword: searchController.text,
          filterBy: recordValue ?? '',
          orderBy: filterValue.toString(),
          pageNo: currentPage.toString(),
          sortBy: entryValue.toString(),
          fromDate: fromDateController.text,
          toDate: toDateController.text,
        ),
      ),
    );
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
                  cartonBloc.add(
                    ViewCartonRecordEvent(
                      param: ViewRecordApiParam(
                        keyword: searchController.text,
                        filterBy: recordValue ?? '',
                        orderBy: filterValue.toString(),
                        pageNo: currentPage.toString(),
                        sortBy: entryValue.toString(),
                        fromDate: fromDateController.text,
                        toDate: toDateController.text,
                      ),
                    ),
                  );
                } else {
                  ToastService.instance.showError(
                    context,
                    state.changeStatusEntity.message.toString(),
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
                cartonBloc.add(
                  ViewCartonRecordEvent(
                    param: ViewRecordApiParam(
                      keyword: searchController.text,
                      filterBy: recordValue ?? '',
                      orderBy: filterValue.toString(),
                      pageNo: currentPage.toString(),
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
              } else if (state is GlobalDeleteMultipleRecordsSuccessStatus) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.deleteRecordEntity.message ?? 'Records deleted',
                    ),
                  ),
                );
                // Refresh list after bulk delete
                cartonBloc.add(
                  ViewCartonRecordEvent(
                    param: ViewRecordApiParam(
                      keyword: searchController.text,
                      filterBy: recordValue ?? '',
                      orderBy: filterValue.toString(),
                      pageNo: currentPage.toString(),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: refreshButton,
          ),
          SizedBox(height: 15),
          SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [_buildPaginationWidget],
            ),
          ),

          SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: BlocConsumer(
              bloc: cartonBloc,
              listener: (context, state) {
                if (state is FetchViewCartonRecordSuccessStatus) {
                  pageText = state.viewCartonModel.pageText.toString();
                  _dataSource = null;
                  // Reset data source when new data is fetched
                }
              },
              builder: (context, state) {
                switch (state.runtimeType) {
                  case const (CartonLoadingStatus):
                    return Center(child: CircularProgressIndicator.adaptive());
                  case const (FetchViewCartonRecordSuccessStatus):
                    final successState =
                        (state as FetchViewCartonRecordSuccessStatus)
                            .viewCartonModel;
                    _dataSource = CartonDataSource(
                      cartonData: successState.record ?? [],
                      isAllChecked: isChecked,
                      onStatusChanged: (value) {
                        setState(() {
                          isChecked = value;
                          if (value) {
                            selectedRows = List.from(_dataSource!.rows);
                          } else {
                            selectedRows.clear();
                          }
                          handleSelectionChanged(
                            value ? List.from(successState.record!) : [],
                          );
                        });
                      },
                      onCheckboxChanged: (checked, index) {
                        setState(() {
                          if (checked) {
                            selectedRows.add(_dataSource!.rows[index]);
                          } else {
                            selectedRows.remove(_dataSource!.rows[index]);
                          }
                          handleSelectionChanged(
                            selectedRows.map((row) {
                              final idx = _dataSource!.rows.indexOf(row);
                              return successState.record![idx];
                            }).toList(),
                          );
                        });
                      },
                      onEdit: (value) {
                        context.pushNamed(
                          EditCartonPanel.routeName,
                          extra: value,
                        );
                      },
                      onDelete: (value) {},
                      onProfile: (value) {},
                      onChanged: (statusValue, CartonRecord) {
                        globalBloc.add(
                          GlobalChangeUserStatusEvent(
                            param: ChangeStaffParam(
                              rKey: CartonRecord.rKey.toString(),
                              rPanel: 'view-carton',
                              rStatus: statusValue.toString(),
                              statusReason: '',
                            ),
                          ),
                        );
                        cartonBloc.add(
                          ViewCartonRecordEvent(
                            param: ViewRecordApiParam(
                              keyword: searchController.text,
                              filterBy: recordValue ?? '',
                              orderBy: filterValue.toString(),
                              pageNo: currentPage.toString(),
                              sortBy: entryValue.toString(),
                              fromDate: fromDateController.text,
                              toDate: toDateController.text,
                            ),
                          ),
                        );
                      },
                    );
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        pageQty = state.viewCartonModel.pageQty ?? 1;
                      });
                    });
                    return successState.status == 1
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                      return successState.record![index];
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
                                source: _dataSource!,
                                columns: buildGridColumns(),
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 200),
                              Text(
                                successState.message ?? 'Refresh to load data',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          );
                  case const (FetchViewCartonRecordFailureStatus):
                    return Center(
                      child: RefreshButton(
                        onPressed: () {
                          cartonBloc.add(
                            ViewCartonRecordEvent(
                              param: ViewRecordApiParam(
                                keyword: searchController.text,
                                filterBy: recordValue ?? '',
                                orderBy: filterValue.toString(),
                                pageNo: currentPage.toString(),
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
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  List<GridColumn> buildGridColumns() {
    return [
      GridColumn(
        columnName: Carton.srNo,
        columnWidthMode: ColumnWidthMode.fitByCellValue,
        width: 80,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const TextFieldlabelText('Sr No'),
        ),
      ),
      GridColumn(
        columnName: Carton.date,
        columnWidthMode: ColumnWidthMode.fill,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Date')),
        ),
      ),
      GridColumn(
        columnName: Carton.billNo,
        columnWidthMode: ColumnWidthMode.fill,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Bill No')),
        ),
      ),
      GridColumn(
        columnName: Carton.companyName,
        width: 300,
        columnWidthMode: ColumnWidthMode.fill,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Vendor Name')),
        ),
      ),

      GridColumn(
        columnName: Carton.cartonTypeText,
        columnWidthMode: ColumnWidthMode.fill,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Carton Type Name')),
        ),
      ),

      GridColumn(
        columnName: Carton.quantity,
        columnWidthMode: ColumnWidthMode.fill,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Quantity')),
        ),
      ),

      if (HiveService.getRole() != '2')
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
              ? MobileAppBar(context, _stateKey, 'View Cartons')
              : DesktopAppBar(context, _stateKey, 'View Cartons', false),
          drawer: !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : null,
          body: _buildDesktopView(),
        );
      },
    );
  }

  Widget get _buildPaginationWidget => TableBottomWidget(
    pageText: pageText,
    currentPage: currentPage,
    pageQty: pageQty,

    onPagePressed: (pageNumber) {
      setState(() {
        currentPage = pageNumber;
      });
      setState(() {
        final pageNumber = currentPage;
        cartonBloc.add(
          ViewCartonRecordEvent(
            param: ViewRecordApiParam(
              keyword: searchController.text,
              filterBy: recordValue ?? '',
              orderBy: filterValue.toString(),
              pageNo: currentPage.toString(),
              sortBy: entryValue.toString(),
              fromDate: fromDateController.text,
              toDate: toDateController.text,
            ),
          ),
        );
      });

      // Page number button clicked
    },
    onFirstPressed: () {
      setState(() {
        currentPage = 1;
        cartonBloc.add(
          ViewCartonRecordEvent(
            param: ViewRecordApiParam(
              keyword: searchController.text,
              filterBy: recordValue ?? '',
              orderBy: filterValue.toString(),
              pageNo: currentPage.toString(),
              sortBy: entryValue.toString(),
              fromDate: fromDateController.text,
              toDate: toDateController.text,
            ),
          ),
        );
      });
    },
    onPreviousPressed: () {
      if (currentPage != null && currentPage! >= 1) {
        setState(() {
          currentPage = currentPage! - 1;
          cartonBloc.add(
            ViewCartonRecordEvent(
              param: ViewRecordApiParam(
                keyword: searchController.text,
                filterBy: recordValue ?? '',
                orderBy: filterValue.toString(),
                pageNo: currentPage.toString(),
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
      if (currentPage != null && pageQty != null && currentPage! <= pageQty!) {
        setState(() {
          currentPage = currentPage! + 1;
          cartonBloc.add(
            ViewCartonRecordEvent(
              param: ViewRecordApiParam(
                keyword: searchController.text,
                filterBy: recordValue ?? '',
                orderBy: filterValue.toString(),
                pageNo: currentPage.toString(),
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
        currentPage = pageQty;
        cartonBloc.add(
          ViewCartonRecordEvent(
            param: ViewRecordApiParam(
              keyword: searchController.text,
              filterBy: recordValue ?? '',
              orderBy: filterValue.toString(),
              pageNo: currentPage.toString(),
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
