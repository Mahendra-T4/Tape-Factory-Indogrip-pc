import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/Assets/assets.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/widgets/custom_date_picker.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/core/widgets/labal_text.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/base_filter_field.dart';
import 'package:indogrip/features/global/presentation/widget/custom_field.dart';
import 'package:indogrip/features/global/presentation/widget/multi_delete_button.dart';
import 'package:indogrip/features/global/presentation/widget/refresh_button.dart';
import 'package:indogrip/features/global/presentation/widget/search_field_round.dart';
import 'package:indogrip/features/global/presentation/widget/vendor_list_widget.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/widgets/micron_dropdown_widget.dart';
import 'package:indogrip/features/outsource/data/data%20source/tap_data_source.dart';
import 'package:indogrip/features/outsource/data/model/tap_sticker_info_model.dart';
import 'package:indogrip/features/outsource/data/model/view_tap_in_model.dart';
import 'package:indogrip/features/outsource/data/repositories/in_out_manager_repo.dart';
import 'package:indogrip/features/outsource/presentation/outside-in/models/add_batch_param.dart';
import 'package:indogrip/features/outsource/presentation/outsource-out/panels/tap/page/tap_panel.dart';
import 'package:indogrip/features/outsource/presentation/outsource-out/panels/tap/page/tape_sticker.dart';
import 'package:indogrip/features/outsource/presentation/state/bloc.in/inventory_bloc.dart';
import 'package:indogrip/features/outsource/presentation/state/bloc.out/inventory_out_bloc.dart';
import 'package:indogrip/features/round/presentation/widgets/master_roll_size_widget.dart';
import 'package:indogrip/features/round/presentation/widgets/show_widget.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

abstract class TapeBuilder extends State<TapPanel> {
  late final InventoryOutBloc inventoryOutBloc;
  late final InventoryBloc inventoryBloc;
  late final GlobalBloc globalBloc;
  bool isMultipleSelection = false;
  bool isChecked = false;
  List<TapRecord> selectedItems = [];
  List<int> highlightedIndices = [];
  String? showValue;
  final remarkController = TextEditingController();
  final tapLengthController = TextEditingController();
  final tapWidthController = TextEditingController();
  final displayMFGController = TextEditingController();
  Key refreshKey = UniqueKey();

  final weightController = TextEditingController();
  final batchMRPController = TextEditingController();
  final displayMicController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  String? vendorKey, micID, baseID, widthID, stockStatus;

  TapDataSource? dataSource;
  TextEditingController searchController = TextEditingController();

  String? recordValue, filterValue, entryValue;
  int pageNo = 1;
  int pageQty = 1;
  TapeStickerInfoModel stickerModel = TapeStickerInfoModel();

  initBatchKey(batchKey) async {
    setState(() {});
    stickerModel = await InventoryOutManagerRepository().loadTapeStickerDetails(
      batchKey,
    );
  }

  void handleSelectionChanged(List<TapRecord> items) {
    setState(() {
      selectedItems = items;
    });
  }

  void eventCall() {
    inventoryOutBloc.add(
      ViewTapInventoryFetchingEvent(
        param: ViewRecordApiParam(
          keyword: searchController.text,
          filterBy: stockStatus?.toString() ?? '',
          orderBy: filterValue?.toString() ?? '',
          pageNo: pageNo.toString(),
          sortBy: entryValue?.toString() ?? '10',
          vendorKey: vendorKey,
          baseID: baseID,
          micID: micID,
          widthID: widthID,
          fromDate: fromDateController.text,
          toDate: toDateController.text,
          tapeLength: tapLengthController.text,
          tapeWeight: tapWidthController.text,
        ),
      ),
    );
  }

  clearFiltersOnRefresh() {
    fromDateController.clear();
    toDateController.clear();
    tapLengthController.clear();
    tapWidthController.clear();
    searchController.clear();
    stockStatus = null;
    recordValue = null;
    filterValue = null;
    entryValue = null;
    widthID = null;
    baseID = null;
    micID = null;

    refreshKey = UniqueKey();

    eventCall();
  }

  @override
  void initState() {
    super.initState();
    inventoryOutBloc = InventoryOutBloc();

    globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    inventoryBloc = InventoryBloc();

    inventoryOutBloc.add(
      ViewTapInventoryFetchingEvent(
        param: ViewRecordApiParam(
          keyword: searchController.text.trim(),
          filterBy: stockStatus?.toString() ?? '',
          orderBy: filterValue?.toString() ?? '',
          pageNo: pageNo.toString(),
          sortBy: entryValue?.toString() ?? '10',
          vendorKey: vendorKey,
          baseID: baseID,
          micID: micID,
          widthID: widthID,
          fromDate: fromDateController.text.trim(),
          toDate: toDateController.text.trim(),
        ),
      ),
    );
  }

  List<DataGridRow> selectedRows = [];

  void toggleHighlight(int rowIndex) {
    setState(() {
      if (highlightedIndices.contains(rowIndex)) {
        highlightedIndices.remove(rowIndex);
      } else {
        highlightedIndices.add(rowIndex);
      }
    });
  }

  // String? recordValue;
  // double _fontSize = 11;
  String? status;
  Widget get searchFields => RoundSearchFields(
    key: refreshKey,
    isStatus: true,
    controller: searchController,
    onSearch: (keyword) {
      // setState(() {
      //   searchController.text = keyword;
      // });
      eventCall();
    },
    onChangedStatus: (status) {
      setState(() {
        stockStatus = status;
      });
      eventCall();
    },
    onChangedOrder: (order) {
      setState(() {
        filterValue = order;
      });
      eventCall();
    },
    onChangedSort: (sortBy) {
      setState(() {
        entryValue = sortBy;
      });
      eventCall();
    },
  );

  Widget get refreshButton => Padding(
    padding: const EdgeInsets.only(right: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * .15,
          height: 35,
          child: RefreshButton(
            onPressed: () {
              setState(() {
                pageNo = 1;
              });
              clearFiltersOnRefresh();
            },
          ),
        ),
      ],
    ),
  );

  Widget get extraFilterFields => Column(
    spacing: 10,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding - 5,
        ),
        child: Row(
          key: refreshKey,
          spacing: 16,
          children: [
            Expanded(
              child: VendorListWidget(
                onChanged: (value) {
                  setState(() {
                    vendorKey = value;
                  });
                  eventCall();
                },
                isFilter: true,
              ),
            ),
            Expanded(
              child: MasterRoleSizeSelector(
                onChanged: (value) {
                  setState(() {
                    widthID = value;
                  });
                  eventCall();
                },
                isFilter: true,
                size: 37,
                selectedRole: widthID,
              ),
            ),
            Expanded(
              child: BaseFilterDropdownWidget(
                onChanged: (value) {
                  setState(() {
                    baseID = value;
                  });
                  eventCall();
                },
              ),
            ),
            Expanded(
              child: MicronDropdownWidget(
                onChanged: (value) {
                  setState(() {
                    micID = value;
                  });
                  eventCall();
                },
                isFilter: true,
                size: 37,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding - 5,
        ),
        child: Row(
          key: refreshKey,
          spacing: 16,
          children: [
            Expanded(
              child: _extraSearchTF(
                (value) {
                  inventoryOutBloc.add(
                    ViewTapInventoryFetchingEvent(
                      param: ViewRecordApiParam(
                        keyword: searchController.text,
                        filterBy: stockStatus?.toString() ?? '',
                        orderBy: filterValue?.toString() ?? '',
                        pageNo: pageNo.toString(),
                        sortBy: entryValue?.toString() ?? '10',
                        vendorKey: vendorKey,
                        baseID: baseID,
                        micID: micID,
                        widthID: widthID,
                        fromDate: fromDateController.text,
                        toDate: toDateController.text,
                        tapeLength: value.toString(),
                        tapeWeight: tapWidthController.text,
                      ),
                    ),
                  );
                },
                tapLengthController,
                'Enter Tape Length',
                'Tape Length',
              ),
            ),
            Expanded(
              child: _extraSearchTF(
                (value) {
                  inventoryOutBloc.add(
                    ViewTapInventoryFetchingEvent(
                      param: ViewRecordApiParam(
                        keyword: searchController.text,
                        filterBy: stockStatus?.toString() ?? '',
                        orderBy: filterValue?.toString() ?? '',
                        pageNo: pageNo.toString(),
                        sortBy: entryValue?.toString() ?? '10',
                        vendorKey: vendorKey,
                        baseID: baseID,
                        micID: micID,
                        widthID: widthID,
                        fromDate: fromDateController.text,
                        toDate: toDateController.text,
                        tapeLength: tapLengthController.text,
                        tapeWeight: value.toString(),
                      ),
                    ),
                  );
                },
                tapWidthController,
                'Enter Tape Weight',
                'Tape Weight',
              ),
            ),
            Expanded(child: SizedBox()),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    ],
  );

  Widget customAlertBoxWidget(TapRecord data, ViewTapInventoryModel model) {
    showValue = stickerModel.record!.batchInformation!.showFor.toString();
    // if (!mounted) return;
    batchMRPController.text = stickerModel.record!.batchInformation!.batchMRP
        .toString();
    weightController.text = stickerModel.record!.batchInformation!.displayValue
        .toString();
    displayMFGController.text = stickerModel
        .record!
        .batchInformation!
        .displayMFG
        .toString();
    displayMicController.text = stickerModel
        .record!
        .batchInformation!
        .displayMic
        .toString();

    // displayMicController.text = data.additionalInfo!.micLabel
    //     .toString();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tapLengthController.text = stickerModel
          .record!
          .batchInformation!
          .displayValue
          .toString();
    });

    remarkController.text = stickerModel.record!.batchInformation!.batchRemark
        .toString();
    // showValue = data..toString();
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: Container(
        width: 550,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.sticky_note_2, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Sticker Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (context, dialogSetState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection('Basic Information', [
                  _buildDetailRow(
                    'Base',
                    data.additionalInfo!.baseLabel.toString(),
                  ),
                  _buildDetailRow(
                    'MIC',
                    data.additionalInfo!.micLabel.toString(),
                  ),
                  _buildDetailRow(
                    'Length',
                    data.additionalInfo!.tapeLength.toString(),
                  ),
                ]),
                const SizedBox(height: 16),
                _buildSection('Production Details', [
                  _buildDetailRow(
                    'Cut MM Meter',
                    data.additionalInfo!.cutMMMeter.toString(),
                  ),

                  _buildDetailRow(
                    'Tape Length',
                    data.additionalInfo!.tapeLength.toString(),
                  ),
                ]),

                const SizedBox(height: 16),
                // Form Fields
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShowWidget(
                      value: showValue,
                      onChanged: (val) {
                        // update dialog-local UI and keep parent field in sync
                        dialogSetState(() {
                          showValue = val?.toString();
                        });
                        if (mounted) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {});
                          });
                        }
                        log('Selected Show Value: $showValue');
                      },
                    ),
                    SizedBox(height: 18),
                    _buildFormField(
                      'Display MFG',
                      CustomDatePicker(controller: displayMFGController),
                    ),
                    SizedBox(height: 10),

                    if (showValue?.trim() == '2') ...[
                      _buildFormField(
                        'Weight',
                        CustomField(controller: weightController),
                      ),
                    ],

                    _buildFormField(
                      'Display Mic',
                      CustomField(controller: displayMicController),
                    ),
                    _buildFormField(
                      'Batch MRP',
                      CustomField(
                        controller: batchMRPController,
                        onChanged: (value) {
                          final totalPrice =
                              data.cartonPrice! + data.transportPrice!;

                          if (value.isNotEmpty) {
                            final mrp = double.tryParse(value) ?? 0.0;
                            if (mrp < totalPrice) {
                              ToastService.instance.showError(
                                context,
                                'Batch MRP cannot be less than Total Price ($totalPrice)',
                              );
                            }
                          }
                        },
                      ),
                    ),

                    if (showValue?.trim() == '1') ...[
                      _buildFormField(
                        'Display Tape Length',
                        CustomField(controller: tapLengthController),
                      ),
                    ],
                  ],
                ),

                _buildFormField(
                  'Remark',
                  CustomField(controller: remarkController),
                ),
                SizedBox(height: 30),
                submitBatchButton(
                  data.rKey,
                  stickerModel.record!.batchInformation!.batchKey.toString(),
                ),
              ],
            );
          },
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actions: [
        Row(
          children: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                context.pushNamed(PrintTapeSticker.routeName, extra: data.rKey);
                context.pop();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('View'),
            ),
          ],
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
    );
  }

  Widget submitBatchButton(rKey, batchKey) => BlocConsumer(
    bloc: inventoryBloc,
    listener: (context, state) {
      if (state is InventoryInRecordAddedSuccessStatus) {
        if (state.response.status == 1) {
          context.pushNamed(PrintTapeSticker.routeName, extra: rKey);
          context.pop();
          eventCall();

          if (context.mounted) {
            ToastService.instance.showSuccess(
              context,
              state.response.message.toString(),
            );
          }
        } else {
          eventCall();
          if (context.mounted) {
            ToastService.instance.showError(
              context,
              state.response.message.toString(),
            );
          }
        }
      }
      if (state is InventoryInRecordAddErrorStatus) {
        eventCall();
        if (context.mounted) {
          ToastService.instance.showSuccess(context, state.message.toString());
        }
      }
    },
    builder: (context, state) {
      if (state is InventoryLoadingStatus) {
        return Center(child: CircularProgressIndicator());
      }
      return Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () {
            inventoryBloc.add(
              InsertBatchIntoRecordEvent(
                batchInfo: InsertBatch(
                  displayMic: displayMicController.text,
                  displayValue: tapLengthController.text,
                  inventoryKey: rKey.toString(),
                  remark: remarkController.text,
                  batchMRP: batchMRPController.text,
                  displayMFG: displayMFGController.text,

                  // : batchOperatorController.text,
                  // batchPackedBy: batchPackedByController.text,
                  rKey: batchKey,
                  showFor: showValue.toString(),
                ),
              ),
            );
          },
          style:
              ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ).copyWith(
                overlayColor: MaterialStateProperty.resolveWith<Color?>((
                  Set<MaterialState> states,
                ) {
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.blue.shade700;
                  }
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.blue.shade800;
                  }
                  return null;
                }),
              ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.save, size: 20),
              const SizedBox(width: 8),
              const Text('Save Changes'),
            ],
          ),
        ),
      );
    },
  );

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(String label, Widget child) {
    return Container(
      // padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(width: double.infinity, child: child),
        ],
      ),
    );
  }

  List<GridColumn> buildGridColumns() {
    return [
      GridColumn(
        columnName: Tap.srNo,
        width: 70,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(Tap.srNo, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn(
        columnName: Tap.inventoryCode,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Tap.inventoryCode,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Tap.date,
        width: 180,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(Tap.date, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn(
        columnName: Tap.vendorName,
        width: 300,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Tap.vendorName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Tap.billDate,
        width: 180,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Tap.billDate,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Tap.cartonPrice,
        width: 120,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Tap.cartonPrice,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Tap.transportPrice,
        width: 130,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Tap.transportPrice,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Tap.totalPrice,
        width: 130,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Tap.totalPrice,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Tap.cutMMMeter,
        width: 120,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Tap.cutMMMeter,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Tap.roundMeter,
        width: 120,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Tap.roundMeter,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Tap.micLabel,
        width: 100,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Tap.micLabel,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Tap.base,
        width: 100,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(Tap.base, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn(
        columnName: Tap.tapWeight,
        width: 100,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Tap.tapWeight,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Tap.quantity,
        width: 100,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Tap.quantity,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Tap.remark,
        width: 180,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Tap.remark,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Tap.inventoryStatusLabel,
        width: 120,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            'Stock Status',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),

      GridColumn(
        columnName: 'actions',
        width: 140,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Actions',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ];
  }

  void toggleMultipleSelection() {
    setState(() {
      isMultipleSelection = !isMultipleSelection;
      if (!isMultipleSelection) {
        selectedItems.clear();
        selectedRows.clear();
      }
    });
  }

  Widget buildSelectionActions() {
    if (!isMultipleSelection || selectedItems.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
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
          const SizedBox(width: 8),
          MultiDeleteButton(
            selectedItems: selectedItems.map((item) => item.toJson()).toList(),
            panel: 'tap',
            onPressed: () {
              setState(() {
                isMultipleSelection = false;
                selectedItems.clear();
                selectedRows.clear();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _extraSearchTF(
    void Function(String)? onChanged,
    TextEditingController controller,
    String hint,
    String label,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        LabelText(label),
        Container(
          height: 37,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,

            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              prefixIcon: Icon(
                Icons.search,
                color: Color(0xFF2D8FCF),
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF2D8FCF), width: 1.5),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            ),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: ColourPalette.textFieldLabelColor,
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Future<void> TapPrintMultipleStickers(List<TapRecord> selectedItems) async {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No items selected for printing'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Create PDF document
      final pdf = pw.Document();

      // Load images from assets
      pw.ImageProvider? tapFactoryImage;
      pw.ImageProvider? indogripStickerImage;

      try {
        final indogrip = await rootBundle.load(Assets.indogripSticker);
        final tapFactory = await rootBundle.load(Assets.theTapFactoryLogo);

        // Process tap factory logo (top)
        final tapFactoryBytes = tapFactory.buffer.asUint8List();
        try {
          tapFactoryImage = pw.MemoryImage(tapFactoryBytes);
        } catch (e) {
          log(name: 'Load Tap Factory Error', e.toString());
        }

        // Process indogrip sticker logo (bottom)
        final indogripBytes = indogrip.buffer.asUint8List();
        try {
          indogripStickerImage = pw.MemoryImage(indogripBytes);
        } catch (e) {
          log(name: 'Load Indogrip Sticker Error', e.toString());
        }
      } catch (e) {
        log(name: 'Load Images Error', e.toString());
      }

      // Add pages for each selected item
      for (var selectedItem in selectedItems) {
        // Load sticker data for this item
        TapeStickerInfoModel? stickerData;
        try {
          await initBatchKey(selectedItem.rKey.toString());
          stickerData = stickerModel;
        } catch (e) {
          log(name: 'Load Sticker Data Error', e.toString());
          continue; // Skip this item if data loading fails
        }

        if (stickerData == null || stickerData.record == null) {
          continue; // Skip if no data
        }

        // At this point, stickerData and stickerData.record are guaranteed to be non-null
        final record = stickerData.record!;

        pw.TextStyle style = pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.black,
        );

        // Get quantity from selected item, default to 1 if not available
        int quantity = 1;
        if (selectedItem.quantity != null) {
          try {
            quantity = int.parse(selectedItem.quantity.toString());
          } catch (e) {
            log(name: 'Quantity Parse Error', e.toString());
            quantity = 1;
          }
        }

        // Add pages based on quantity
        for (int i = 0; i < quantity; i++) {
          pdf.addPage(
            pw.Page(
              pageFormat: PdfPageFormat(
                PdfPageFormat.inch * 4.9, // width = 4.9 inches
                PdfPageFormat.inch * 3.4, // height = 3.4 inches
                marginTop: PdfPageFormat.inch * 0.7,
                marginRight:
                    PdfPageFormat.inch *
                    0.15, // equal margins for centered sticker
                marginLeft:
                    PdfPageFormat.inch *
                    0.15, // equal margins for centered sticker
              ),
              build: (pw.Context context) {
                return pw.Container(
                  alignment: pw.Alignment.center,
                  padding: pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 1.2),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          if (indogripStickerImage != null)
                            pw.Image(
                              indogripStickerImage,
                              width: 100,
                              height: 30,
                              fit: pw.BoxFit.contain,
                            ),
                          if (tapFactoryImage != null)
                            pw.Image(
                              tapFactoryImage,
                              width: 80,
                              height: 30,
                              fit: pw.BoxFit.contain,
                            ),
                        ],
                      ),

                      // Top logo (tap factory)
                      pw.SizedBox(height: 3),

                      //! Barcode - batchcode
                      pw.Align(
                        alignment: pw.Alignment.center,
                        child: pw.BarcodeWidget(
                          data: record.batchInformation!.batchID.toString(),
                          barcode: pw.Barcode.code128(),
                          textStyle: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          width: PdfPageFormat.inch * 2.8,
                          height: PdfPageFormat.inch * 0.6,
                        ),
                      ),
                      // Serial Number
                      // pw.Row(
                      //   mainAxisAlignment: pw.MainAxisAlignment.start,
                      //   children: [
                      //     pw.Text(
                      //       'Serial Number: ${record.inventoryInformation!.inventoryCode.toString()}',
                      //       style: style,
                      //     ),
                      //   ],
                      // ),
                      // pw.SizedBox(height: 5),

                      // Vendor Name and Pieces/Carton
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Serial Number: ${record.inventoryInformation!.inventoryCode.toString()}',
                            style: style,
                          ),
                          pw.Text(
                            'Pieces/Carton: ${record.inventoryInformation!.additionalInfo!.piecesPerCarton}',
                            style: style,
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 5),

                      // Width and Mic
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Width: ${record.inventoryInformation!.additionalInfo!.cutMMMeter}',
                            style: style,
                          ),
                          pw.Text(
                            'Mic: ${record.batchInformation!.displayMic}',
                            style: style,
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 5),

                      // Length/Weight and Base
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          record.batchInformation?.showFor == 1
                              ? pw.Text(
                                  'Length: ${record.batchInformation!.displayValue}',
                                  style: style,
                                )
                              : pw.Text(
                                  'Weight: ${record.batchInformation!.displayValue}',
                                  style: style,
                                ),
                          pw.Text(
                            'Base: ${record.inventoryInformation!.additionalInfo!.baseLabel}',
                            style: style,
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 5),

                      // MFG and MRP
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'MFG: ${record.batchInformation!.displayMFGLabel}',
                            style: style,
                          ),
                          pw.Text(
                            'MRP: ${record.batchInformation!.batchMRP}',
                            style: style,
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 5),

                      // Remark and Batch Code
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Remark: ${record.inventoryInformation!.remark}',
                            style: style,
                          ),
                          pw.Text(
                            'Batch Code: ${record.batchInformation!.batchCode}',
                            style: style,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
      }

      // Show printer picker and print
      await Printing.layoutPdf(
        onLayout: (format) {
          return pdf.save();
        },
        name: 'Indogrip Tape Stickers',
        format: PdfPageFormat.a4,
      );

      // Calculate total stickers printed
      int totalStickers = 0;
      for (var item in selectedItems) {
        int itemQuantity = 1;
        if (item.quantity != null) {
          try {
            itemQuantity = int.parse(item.quantity.toString());
          } catch (e) {
            itemQuantity = 1;
          }
        }
        totalStickers += itemQuantity;
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully sent $totalStickers sticker(s) to printer',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Clear selection after printing
      setState(() {
        selectedItems.clear();
        selectedRows.clear();
      });
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error printing stickers: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
