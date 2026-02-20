import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/data_filtration.dart';
import 'package:indogrip/features/global/presentation/widget/pagination_widget.dart';
import 'package:indogrip/features/outsource/data/data%20source/stretch_film_datasource.dart';
import 'package:indogrip/features/outsource/data/model/view_stretchfilm_model.dart';
import 'package:indogrip/features/outsource/presentation/outside-in/edit%20-%20stretch/edit_stretch_in.dart';
import 'package:indogrip/features/outsource/presentation/outsource-out/panels/strach%20film/pages/stretch_film_builder.dart';
import 'package:indogrip/features/outsource/presentation/state/bloc.in/inventory_bloc.dart';
import 'package:indogrip/features/outsource/presentation/state/bloc.out/inventory_out_bloc.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class StretchFilmPanel extends StatefulWidget {
  const StretchFilmPanel({super.key});
  static const String routeName = '/outsource/out/stretch-film-panel';

  @override
  State<StretchFilmPanel> createState() => _StratchFilmPanelState();
}

class _StratchFilmPanelState extends StretchFilmBuilder {
  final GlobalKey<ScaffoldState> _stateKey = GlobalKey<ScaffoldState>();
  final GlobalKey _key = GlobalKey();
  late ScrollController _horizontalScrollController;

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
    inventoryOutBloc = InventoryOutBloc();
    globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    inventoryBloc = InventoryBloc();
    inventoryOutBloc.add(
      ViewStretchFilmInventoryFetchingEvent(
        param: ViewRecordApiParam(
          keyword: searchController.text,
          filterBy: stockStatus?.toString() ?? '',
          orderBy: filterValue?.toString() ?? '',
          pageNo: pageNo.toString(),
          sortBy: entryValue?.toString() ?? '10',
          vendorKey: vendorKey?.toString() ?? '',
          coreID: coreID?.toString() ?? '',
          filmSizeID: filmSizeID?.toString() ?? '',
          fromDate: fromDateController.text,
          toDate: toDateController.text,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
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
              ? MobileAppBar(context, _stateKey, 'Stretch Film')
              : DesktopAppBar(context, _stateKey, 'Stretch Film', false),
          drawer: !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : null,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
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
                        callEvent();
                      } else {
                        ToastService.instance.showSuccess(
                          context,
                          state.changeStatusEntity.message.toString(),
                        );
                        callEvent();
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
                    } else if (state
                        is GlobalDeleteMultipleRecordsSuccessStatus) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.deleteRecordEntity.message ??
                                'Records deleted',
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
                    } else if (state
                        is GlobalDeleteMultipleRecordsErrorStatus) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  child: !Responsive.isDesktop(context)
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: searchFields,
                        )
                      : Column(
                          children: [
                            DateFiltration(
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
                            searchFields,
                            extraFilterFields,
                            SizedBox(height: 15),
                            Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                refreshButton,
                                if (isMultipleSelection)
                                  buildSelectionActions(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: toggleMultipleSelection,
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
                                        style: const TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // SizedBox(height: 15),
                          ],
                        ),
                ),
                const SizedBox(height: 16),
                _buildPaginationWidget,

                // const SizedBox(height: 10),
                _buildContentWidget,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget get _buildPaginationWidget => ScrollConfiguration(
    behavior: ScrollConfiguration.of(
      context,
    ).copyWith(scrollbars: true, physics: const ClampingScrollPhysics()),
    child: Scrollbar(
      controller: _horizontalScrollController,
      child: SingleChildScrollView(
        controller: _horizontalScrollController,
        scrollDirection: Axis.horizontal,
        child: TableBottomWidget(
          currentPage: pageNo,
          pageQty: pageQty,
          onPagePressed: (pageNumber) {
            setState(() {
              pageNo = pageNumber;
            });
            callEvent();
          },
          onFirstPressed: () {
            setState(() {
              pageNo = 1;
              callEvent();
            });
          },
          onPreviousPressed: () {
            if (pageNo >= 1) {
              setState(() {
                pageNo = pageNo - 1;
                callEvent();
              });
            }
          },
          onNextPressed: () {
            if (pageNo >= 1) {
              setState(() {
                pageNo = pageNo + 1;
                callEvent();
              });
            }
          },
          onLastPressed: () {
            setState(() {
              pageNo = pageQty;
              callEvent();
            });
          },
        ),
      ),
    ),
  );

  Widget get _buildContentWidget => BlocConsumer(
    bloc: inventoryOutBloc,
    buildWhen: (previous, current) {
      // Always rebuild to handle state changes
      return true;
    },
    listener: (context, state) {
      if (state is InventoryOutStretchFilmLoadedSuccessStatus) {
        dataSource = null;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            pageQty = state.model.pageQty ?? 1;
          });
        });
      }
    },
    builder: (context, state) {
      switch (state.runtimeType) {
        case InventoryOutLoadingStatus:
          return Expanded(
            child: const Center(child: CircularProgressIndicator()),
          );
        case InventoryOutStretchFilmLoadedSuccessStatus:
          final loadedState =
              (state as InventoryOutStretchFilmLoadedSuccessStatus).model;

          if (loadedState.status == 1) {
            dataSource ??= StretchFilmDataSource(
              stretchData: loadedState.record!,
              isAllChecked: false,
              onStatusChanged: (value) {
                setState(() {
                  if (value) {
                    selectedRows = List.from(dataSource!.rows);
                  } else {
                    selectedRows.clear();
                  }
                });
              },
              onCheckboxChanged: (checked, index) {
                setState(() {
                  if (checked) {
                    selectedRows.add(dataSource!.rows[index]);
                  } else {
                    selectedRows.remove(dataSource!.rows[index]);
                  }
                });
              },

              onChanged: (statusValue, StretchRecord) {
                setState(() {
                  recordValue = statusValue;
                });
              },
              printLabel: (StretchRecord) async {
                await loadStickerData(StretchRecord.rKey.toString());

                showDialog(
                  context: context,
                  builder: (context) {
                    return customAlertBoxWidget(StretchRecord);
                  },
                );
              },
              onEdit: (StretchRecord) {
                context.pushNamed(
                  EditStretchOutSourceIN.routeName,
                  extra: StretchRecord,
                );
              },
            );
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              pageQty = state.model.pageQty ?? 1;
            });
          });

          // pageQty = loadedState.pageQty;
          return loadedState.status != 1
              ? Expanded(
                  child: Center(
                    child: Text(loadedState.message ?? 'Refresh to load data'),
                  ),
                )
              : Expanded(
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

                        final selectedRecords = selectedRows
                            .map((row) {
                              final index = dataSource!.rows.indexOf(row);
                              if (index >= 0 &&
                                  index < loadedState.record!.length) {
                                return loadedState.record![index];
                              }
                              return null;
                            })
                            .where((record) => record != null)
                            .cast<StretchRecord>()
                            .toList();
                        handleSelectionChanged(selectedRecords);
                      });
                    },
                    source: dataSource!,
                    columns: buildGridColumns(),
                  ),
                );
        case InventoryOutStretchFilmFailedStatus:
          final errorState =
              (state as InventoryOutStretchFilmFailedStatus).errorMessage;
          return Center(child: Text(errorState));
        default:
          return const SizedBox.shrink();
      }
    },
  );
}
