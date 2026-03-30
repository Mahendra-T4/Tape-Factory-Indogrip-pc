import 'dart:developer' as developer;
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
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/data_filtration.dart';
import 'package:indogrip/features/global/presentation/widget/pagination_widget.dart';
import 'package:indogrip/features/global/presentation/widget/refresh_button.dart';
import 'package:indogrip/features/round/data/models/round_table_column.dart';
import 'package:indogrip/features/round/presentation/bloc/round_bloc.dart';
import 'package:indogrip/features/round/presentation/pages/edit/edit_round.dart';
import 'package:indogrip/features/round/presentation/pages/profile/round_profile.dart';
import 'package:indogrip/features/round/presentation/pages/view/view_round_builder.dart';
import 'package:indogrip/features/round/data/round_data_source.dart';
import 'package:indogrip/features/round/presentation/widgets/round_details_box.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ViewRoundPanel extends StatefulWidget {
  const ViewRoundPanel({super.key});
  static const String routeName = '/viewRound';

  @override
  State<ViewRoundPanel> createState() => _ViewRoundPanelState();
}

class _ViewRoundPanelState extends ViewRoundBuilder {
  final GlobalKey<ScaffoldState> _stateKey = GlobalKey<ScaffoldState>();
  final GlobalKey _key = GlobalKey();
  late Map<String, double> columnWidths = {};
  bool isChecked = false;
  RoundDataSource? _dataSource;
  List<DataGridRow> selectedRows = [];
  String pageText = '';

  @override
  void dispose() {
    selectedRows.clear();
    super.dispose();
  }

  Widget _buildDesktopView() {
    return CustomScrollView(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      slivers: [
        SliverToBoxAdapter(
          child: DateFiltration(
            fromDateController: fromDateController,
            toDateController: toDateController,
            onFromChanged: (value) {
              setState(() {
                fromDateController.text = value;
              });
              callEvent();
            },
            onToChanged: (value) {
              setState(() {
                toDateController.text = value;
              });
              callEvent();
            },
          ),
        ),
        SliverToBoxAdapter(child: searchFields),

        SliverToBoxAdapter(
          child: BlocListener<GlobalBloc, GlobalState>(
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
                  callEvent();
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
                callEvent();
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
                callEvent();
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
        ),
        SliverToBoxAdapter(child: SizedBox(height: 15)),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [_buildPaginationWidget],
              ),
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //   child: RoundDetailBox(),
        // ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: BlocConsumer(
                bloc: roundBloc,
                listener: (context, state) {
                  if (state is ViewRoundRecordsLoadedSuccessStatus) {
                    pageText = state.viewRoundModel.pageText.toString();
                    _dataSource = null;
                  }
                  if (state is ViewRoundRecordsLoadedSuccessStatus &&
                      state.viewRoundModel.status == 1 &&
                      state.viewRoundModel.record != null &&
                      state.viewRoundModel.record!.isNotEmpty) {
                    // fetchBatchDetails(
                    //   state.viewRoundModel.record!.first.rKey,
                    // );
                  }
                  if (state is ViewRoundRecordsErrorStatus) {
                    ToastService.instance.showError(
                      context,
                      state.errorMessage.toString(),
                    );
                  }
                },
                buildWhen: (previous, current) {
                  // Always rebuild to handle state changes
                  return true;
                },
                builder: (context, state) {
                  if (state is RoundLoadingStatus) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (state is ViewRoundRecordsLoadedSuccessStatus) {
                    final successData = state.viewRoundModel;

                    if (state.viewRoundModel.status == 1) {
                      // Lazy initialization - create data source only once
                      _dataSource ??= RoundDataSource(
                        context: context,
                        roundData: successData.record!,
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
                                ? (state.viewRoundModel.record ?? [])
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
                                                  .viewRoundModel
                                                  .record
                                                  ?.length ??
                                              0)) {
                                    final record =
                                        state.viewRoundModel.record![idx];
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
                            EditRoundPanel.routeName,
                            extra: value,
                          );
                          print('Carton Type ID : ${value.cartonType}');
                        },
                        onDelete: (value) {
                          callEvent();
                        },
                        onProfile: (value) {
                          context.pushNamed(
                            RoundProfile.routeName,
                            extra: value,
                          );
                        },
                        stickerPopup: (value) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return customAlertBoxWidget(value, successData);
                            },
                          );
                          // print(successData);
                        },

                        onChanged: (statusValue, record) {
                          globalBloc.add(
                            GlobalChangeUserStatusEvent(
                              param: ChangeStaffParam(
                                rKey: record.rKey.toString(),
                                rPanel: 'view-round',
                                rStatus: statusValue.toString(),
                                statusReason: '',
                              ),
                            ),
                          );
                          callEvent();
                        },
                      );
                    }

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        pageQty = state.viewRoundModel.pageQty ?? 1;
                      });
                    });

                    return state.viewRoundModel.status == 1
                        ? Column(
                            children: [
                              RoundDetailBox(
                                availableCarton: state
                                    .viewRoundModel
                                    .availableCarton
                                    .toString(),
                                totalPieces: state.viewRoundModel.totalPieces
                                    .toString(),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: ScrollConfiguration(
                                  behavior: HorizontalMouseScrollBehavior(),
                                  child: AbsorbPointer(
                                    absorbing: isAbsorb,
                                    child: SfDataGrid(
                                      showHorizontalScrollbar: true,
                                      key: _key,
                                      rowsPerPage: 50,
                                      // allowPullToRefresh: true,
                                      allowColumnsResizing: true,
                                      columnResizeMode:
                                          ColumnResizeMode.onResizeEnd,
                                      isScrollbarAlwaysShown: true,

                                      showVerticalScrollbar: true,
                                      showCheckboxColumn: isMultipleSelection,
                                      onCellTap:
                                          (DataGridCellTapDetails details) {
                                            if (_dataSource != null) {
                                              _dataSource!.highlightedRowIndex =
                                                  details
                                                      .rowColumnIndex
                                                      .rowIndex -
                                                  1;
                                            }
                                          },
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
                                                            .viewRoundModel
                                                            .record!
                                                            .length) {
                                                  return state
                                                      .viewRoundModel
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
                                      onColumnResizeUpdate: (details) {
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
                                ),
                              ),
                            ],
                          )
                        : Expanded(
                            child: Center(
                              child: Text(
                                state.viewRoundModel.message ??
                                    'Refresh to load data',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                  } else if (state is ViewRoundRecordsErrorStatus) {
                    developer.log(
                      name: 'Error Status',
                      state.errorMessage.toString(),
                    );
                    return Center(
                      child: RefreshButton(
                        onPressed: () {
                          callEvent();
                        },
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  List<GridColumn> buildGridColumns() {
    return [
      GridColumn(
        columnName: RoundTableColumn.srNo,
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
        columnName: RoundTableColumn.rollNumber,
        columnWidthMode: ColumnWidthMode.fill,
        width: 200,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const TextFieldlabelText('Roll NO.'),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.width,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Width')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.base,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Base')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.mic,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('MIC')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.length,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Length')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.totalWeight,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Total Weight')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.amountPerKG,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Amount Per KG')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.cutMMMeter,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Cut MM Meter')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.roundCount,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Round')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.tapeLength,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Tape Length')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.wastagePercentage,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Wastage')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.conversionRate,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Conversion')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.usedLength,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Used Length')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.piecesPerCarton,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Pieces/Carton')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.usedSquareMeter,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Used Sq. Meter')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.rollCost,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Roll Cost')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.totalSquareMtr,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Total Sqr. Meter')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.ratePerSquareMeter,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Rate/Sqr. Meter')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.cartonMaterialCost,
        columnWidthMode: ColumnWidthMode.fill,
        width: 200,
        label: Container(
          color: Colors.grey[100],
          child: const Center(
            child: TextFieldlabelText('Carton Material Cost'),
          ),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.cartonRate,
        columnWidthMode: ColumnWidthMode.fill,
        width: 250,
        label: Container(
          color: Colors.grey[100],
          child: const Center(
            child: TextFieldlabelText('Carton + Conversion + Wastage'),
          ),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.marginWithTenPercentage,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('10% Margin')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.marginWithTwelvePercentage,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('12% Margin')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.marginWithFifteenPercentage,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('15% Margin')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.totalCarton,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Total Carton')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.availableCarton,
        columnWidthMode: ColumnWidthMode.fill,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: const Center(child: TextFieldlabelText('Available Carton')),
        ),
      ),
      GridColumn(
        columnName: RoundTableColumn.roundStatusLabel,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: Center(child: TextFieldlabelText("Status")),
        ),
      ),

      GridColumn(
        columnName: 'actions',
        columnWidthMode: ColumnWidthMode.fitByColumnName,
        width: 250,
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
              ? MobileAppBar(context, _stateKey, 'View Round')
              : DesktopAppBar(context, _stateKey, 'View Round', false),
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
    currentPage: pageNo,
    pageQty: pageQty,
    onPagePressed: (pageNumber) {
      setState(() {
        pageNo = pageNumber;
      });
      roundBloc.add(
        ViewRoundRecordsFetchingEvent(
          param: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue ?? '',
            orderBy: filterValue.toString(),
            pageNo: pageNo.toString(),
            sortBy: entryValue.toString(),
            cutMMMeterID: cutMMMeter,
            micID: selectedMic,
            baseID: selectedBase,
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
        roundBloc.add(
          ViewRoundRecordsFetchingEvent(
            param: ViewRecordApiParam(
              keyword: searchController.text,
              filterBy: recordValue ?? '',
              orderBy: filterValue.toString(),
              pageNo: pageNo.toString(),
              sortBy: entryValue.toString(),
              cutMMMeterID: cutMMMeter,
              micID: selectedMic,
              baseID: selectedBase,
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
          roundBloc.add(
            ViewRoundRecordsFetchingEvent(
              param: ViewRecordApiParam(
                keyword: searchController.text,
                filterBy: recordValue ?? '',
                orderBy: filterValue.toString(),
                pageNo: pageNo.toString(),
                sortBy: entryValue.toString(),
                cutMMMeterID: cutMMMeter,
                micID: selectedMic,
                baseID: selectedBase,
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
        if (pageNo! < pageQty!) {
          setState(() {
            pageNo = pageNo! + 1;
            roundBloc.add(
              ViewRoundRecordsFetchingEvent(
                param: ViewRecordApiParam(
                  keyword: searchController.text,
                  filterBy: recordValue ?? '',
                  orderBy: filterValue.toString(),
                  pageNo: pageNo.toString(),
                  sortBy: entryValue.toString(),
                  cutMMMeterID: cutMMMeter,
                  micID: selectedMic,
                  baseID: selectedBase,
                  fromDate: fromDateController.text,
                  toDate: toDateController.text,
                ),
              ),
            );
          });
        }
      }
    },
    onLastPressed: () {
      if (pageNo != null) {
        setState(() {
          pageNo = pageQty;
          roundBloc.add(
            ViewRoundRecordsFetchingEvent(
              param: ViewRecordApiParam(
                keyword: searchController.text,
                filterBy: recordValue ?? '',
                orderBy: filterValue.toString(),
                pageNo: pageNo.toString(),
                sortBy: entryValue.toString(),
                cutMMMeterID: cutMMMeter,
                micID: selectedMic,
                baseID: selectedBase,
                fromDate: fromDateController.text,
                toDate: toDateController.text,
              ),
            ),
          );
        });
      }
    },
  );
}
