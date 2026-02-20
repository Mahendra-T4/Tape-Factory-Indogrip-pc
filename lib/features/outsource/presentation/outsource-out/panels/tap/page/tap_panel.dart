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
import 'package:indogrip/features/global/data/model/change_status_param.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/data_filtration.dart';
import 'package:indogrip/features/global/presentation/widget/pagination_widget.dart';
import 'package:indogrip/features/outsource/data/model/view_tap_in_model.dart';
import 'package:indogrip/features/outsource/presentation/outside-in/edit/edit_in.dart';
import 'package:indogrip/features/outsource/presentation/outsource-out/panels/tap/page/tape_builder.dart';
import 'package:indogrip/features/outsource/presentation/state/bloc.out/inventory_out_bloc.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:indogrip/features/outsource/data/data%20source/tap_data_source.dart';

class TapPanel extends StatefulWidget {
  const TapPanel({super.key});
  static const String routeName = '/outsource/out/tap';

  @override
  State<TapPanel> createState() => _TapPanelState();
}

class _TapPanelState extends TapeBuilder {
  final GlobalKey<ScaffoldState> _stateKey = GlobalKey<ScaffoldState>();
  final GlobalKey _key = GlobalKey();

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
              ? MobileAppBar(context, _stateKey, 'Tape')
              : DesktopAppBar(context, _stateKey, 'Tape', false),
          drawer: !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : null,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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

                        eventCall();
                      } else {
                        ToastService.instance.showSuccess(
                          context,
                          state.changeStatusEntity.message.toString(),
                        );
                        eventCall();
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
                      eventCall();
                    } else if (state is GlobalDeleteRecordErrorStatus) {
                      ToastService.instance.showError(
                        context,
                        state.message.toString(),
                      );
                    } else if (state
                        is GlobalDeleteMultipleRecordsSuccessStatus) {
                      ToastService.instance.showSuccess(
                        context,
                        state.deleteRecordEntity.message.toString(),
                      );
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text(
                      //       state.deleteRecordEntity.message ?? 'Records deleted',
                      //     ),
                      //   ),
                      // );
                      eventCall();
                      setState(() {
                        selectedRows.clear();
                        // selectedItems.clear();
                        // isMultipleSelection = false;
                      });
                    } else if (state
                        is GlobalDeleteMultipleRecordsErrorStatus) {
                      ToastService.instance.showSuccess(
                        context,
                        state.message.toString(),
                      );
                    }
                  },
                  child: Column(
                    children: [
                      DateFiltration(
                        fromDateController: fromDateController,
                        toDateController: toDateController,
                        onFromChanged: (value) {
                          setState(() {
                            fromDateController.text = value;
                          });
                          eventCall();
                        },
                        onToChanged: (value) {
                          setState(() {
                            toDateController.text = value;
                          });
                          eventCall();
                        },
                      ),
                      searchFields,
                      extraFilterFields,

                      SizedBox(height: 15),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      refreshButton,
                      if (isMultipleSelection)
                        ElevatedButton.icon(
                          onPressed: () async {
                            await TapPrintMultipleStickers(selectedItems);
                          },
                          icon: const Icon(Icons.print),
                          label: const Text('Print Stickers'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      SizedBox(width: 10),
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
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),

                      // style: ElevatedButton.styleFrom(
                      //   backgroundColor: isMultipleSelection
                      //       ? Colors.green
                      //       : Colors.grey.shade400,
                      //   foregroundColor: Colors.white,
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: 15),

                // buildSelectionActions(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [_buildPaginationWidget],
                  ),
                ),
                _buildContentWidget,
                const SizedBox(height: 16),
              ],
            ),
          ),
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
      eventCall();
    },
    onFirstPressed: () {
      setState(() {
        pageNo = 1;
        eventCall();
      });
    },
    onPreviousPressed: () {
      if (pageNo >= 1) {
        setState(() {
          pageNo = pageNo - 1;
          eventCall();
        });
      }
    },
    onNextPressed: () {
      if (pageNo >= 1) {
        setState(() {
          pageNo = pageNo + 1;
          eventCall();
        });
      }
    },
    onLastPressed: () {
      setState(() {
        pageNo = pageQty;
        eventCall();
      });
    },
  );

  Widget get _buildContentWidget => BlocConsumer(
    bloc: inventoryOutBloc,
    buildWhen: (previous, current) {
      // Always rebuild to handle state changes
      return true;
    },
    listener: (context, state) {
      if (state is InventoryOutTapLoadedSuccessStatus) {
        dataSource = null;
      }
    },
    builder: (context, state) {
      switch (state.runtimeType) {
        case const (InventoryOutLoadingStatus):
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
            ),
          );
        case const (InventoryOutTapLoadedSuccessStatus):
          final tapData = (state as InventoryOutTapLoadedSuccessStatus).model;
          if (tapData.status == 1) {
            dataSource ??= TapDataSource(
              TapData: tapData.record!,
              isAllChecked: false,
              onStatusChanged: (value) {
                setState(() {
                  isChecked = value;
                  if (value) {
                    selectedRows = List.from(dataSource!.rows);
                    handleSelectionChanged(tapData.record!);
                  } else {
                    setState(() {
                      selectedRows.clear();
                      selectedItems.clear();
                      isMultipleSelection = false;
                    });
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
                  // Update selectedItems whenever checkbox changes
                  final selectedData = selectedRows.map((row) {
                    final rowIndex = dataSource!.rows.indexOf(row);
                    return tapData.record?[rowIndex];
                  }).toList();
                  handleSelectionChanged(
                    selectedData.whereType<TapRecord>().toList(),
                  );
                });
              },
              onEdit: (tap) {
                context.pushNamed(EditOutSourceIN.routeName, extra: tap);
              },

              onChanged: (value, tap) {
                setState(() {
                  status = value;
                });

                globalBloc.add(
                  GlobalChangeUserStatusEvent(
                    param: ChangeStaffParam(
                      rKey: tap.rKey.toString(),
                      rPanel: 'view-inventory',
                      rStatus: value.toString(),
                      statusReason: '',
                    ),
                  ),
                );
                eventCall();
              },
              printLabel: (tap) async {
                // Load sticker details for this specific row
                await initBatchKey(tap.rKey.toString());
                // Dialog will fetch sticker details using tap.rKey
                if (mounted) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return customAlertBoxWidget(tap, tapData);
                    },
                  );
                }
              },
            );
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              pageQty = state.model.pageQty ?? 1;
            });
          });
          return tapData.status != 1
              ? Expanded(
                  child: Center(
                    child: Text(tapData.message ?? 'Refresh to load data'),
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

                        final selectedData = selectedRows.map((row) {
                          final index = dataSource!.rows.indexOf(row);
                          return tapData.record?[index];
                        }).toList();
                        handleSelectionChanged(
                          selectedData.whereType<TapRecord>().toList(),
                        );
                      });
                    },
                    source: dataSource!,
                    columns: buildGridColumns(),
                  ),
                );
        case const (InventoryOutTapFailedStatus):
          return SizedBox.shrink();
        default:
          return SizedBox.shrink();
      }
    },
  );
}
