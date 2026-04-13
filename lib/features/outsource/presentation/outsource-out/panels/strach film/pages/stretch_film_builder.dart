import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/Assets/assets.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/utils/widgets/custom_date_picker.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/base_filter_field.dart';
import 'package:indogrip/features/global/presentation/widget/custom_field.dart';
import 'package:indogrip/features/global/presentation/widget/multi_delete_button.dart';
import 'package:indogrip/features/global/presentation/widget/refresh_button.dart';
import 'package:indogrip/features/global/presentation/widget/search_field_round.dart';
import 'package:indogrip/features/global/presentation/widget/vendor_list_widget.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/widgets/micron_dropdown_widget.dart';
import 'package:indogrip/features/outsource/data/data%20source/stretch_film_datasource.dart';
import 'package:indogrip/features/outsource/data/model/stretchfilm_sticker_model.dart';
import 'package:indogrip/features/outsource/data/model/view_stretchfilm_model.dart';
import 'package:indogrip/features/outsource/data/repositories/in_out_manager_repo.dart';
import 'package:indogrip/features/outsource/presentation/outside-in/models/add_batch_param.dart';
import 'package:indogrip/features/outsource/presentation/outsource-out/panels/strach%20film/pages/print_stretch_sticker.dart';
import 'package:indogrip/features/outsource/presentation/outsource-out/panels/strach%20film/pages/stratch_film.dart';
import 'package:indogrip/features/outsource/presentation/state/bloc.in/inventory_bloc.dart';
import 'package:indogrip/features/outsource/presentation/state/bloc.out/inventory_out_bloc.dart';
import 'package:indogrip/features/outsource/presentation/widget/master_stretch_film_widget.dart';
import 'package:indogrip/features/round/presentation/widgets/core_dropdown.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

abstract class StretchFilmBuilder extends State<StretchFilmPanel> {
  Key refreshKey = UniqueKey();
  late final InventoryOutBloc inventoryOutBloc;
  late final GlobalBloc globalBloc;
  late final InventoryBloc inventoryBloc;
  String? pageText;
  bool isMultipleSelection = false;
  List<StretchRecord> selectedItems = [];
  String? vendorKey, coreID, filmSizeID, stockStatus;
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  // late final GlobalBloc globalBloc;

  TextEditingController searchController = TextEditingController();
  String? showValue;
  final remarkController = TextEditingController();
  final tapLengthController = TextEditingController();

  final weightController = TextEditingController();
  final batchMRPController = TextEditingController();
  final displayMicController = TextEditingController();
  final displayMFGController = TextEditingController();
  int pageNo = 1;
  int pageQty = 1;
  String? baseID;
  String? micID;

  StretchFilmStickerModel stretchFilmStickerModel = StretchFilmStickerModel();

  Future<void> loadStickerData(batchKey) async {
    setState(() {});
    stretchFilmStickerModel = await InventoryOutManagerRepository()
        .loadStretchFilmStickerDetails(batchKey);
  }

  void handleSelectionChanged(List<StretchRecord> items) {
    setState(() {
      selectedItems = items;
    });
  }

  void callEvent() {
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
          baseID: baseID?.toString(),
          micID: micID?.toString(),
        ),
      ),
    );
  }

  clearFiltersOnRefresh() {
    searchController.clear();
    fromDateController.clear();
    toDateController.clear();

    setState(() {
      baseID = null;
      micID = null;
      filmSizeID = null;
      coreID = null;
      vendorKey = null;
    });

    refreshKey =
        UniqueKey(); // Force rebuild of filter widgets if they rely on this key

    callEvent();
  }

  String? recordValue, filterValue, entryValue;

  StretchFilmDataSource? dataSource;
  List<DataGridRow> selectedRows = [];

  Widget get refreshButton => SizedBox(
    width: MediaQuery.sizeOf(context).width * .15,
    height: 35,
    child: RefreshButton(
      onPressed: () {
        clearFiltersOnRefresh();
      },
    ),
  );

  Widget get extraFilterFields => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: kDefaultHorizontalPadding - 5,
    ),
    child: Column(
      key: refreshKey,
      spacing: 10,
      children: [
        Row(
          spacing: 16,
          children: [
            Expanded(
              child: VendorListWidget(
                onChanged: (value) {
                  setState(() {
                    vendorKey = value;
                  });
                  callEvent();
                },
                isFilter: true,
              ),
            ),

            Expanded(
              child: CoreDropdown(
                size: 37,
                onChanged: (value) {
                  setState(() {
                    coreID = value;
                  });
                  callEvent();
                },
                isFilter: true,
                selectedCore: '',
              ),
            ),
            Expanded(
              child: MasterStretchFilmWidget(
                onChanged: (value) {
                  setState(() {
                    filmSizeID = value;
                  });
                  callEvent();
                },
                isFilter: true,
                size: 37,
              ),
            ),
            Expanded(
              child: BaseFilterDropdownWidget(
                onChanged: (value) {
                  setState(() {
                    baseID = value;
                  });
                  callEvent();
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: MicronDropdownWidget(
                onChanged: (value) {
                  setState(() {
                    micID = value;
                  });
                  callEvent();
                },
                isFilter: true,
                size: 37,
              ),
            ),
            Expanded(child: SizedBox()),
            Expanded(child: SizedBox()),
            Expanded(child: SizedBox()),
          ],
        ),
      ],
    ),
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

  // String? recordValue;

  Widget customAlertBoxWidget(StretchRecord data) {
    displayMicController.text = stretchFilmStickerModel
        .record!
        .batchInformation!
        .displayMic
        .toString();

    displayMFGController.text = stretchFilmStickerModel
        .record!
        .batchInformation!
        .displayMFG
        .toString();

    batchMRPController.text = stretchFilmStickerModel
        .record!
        .batchInformation!
        .batchMRP
        .toString();

    remarkController.text = stretchFilmStickerModel
        .record!
        .batchInformation!
        .batchRemark
        .toString();

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
              onPressed: () {
                context.pop();
                inventoryOutBloc.add(
                  ViewStretchFilmInventoryFetchingEvent(
                    param: ViewRecordApiParam(
                      keyword: searchController.text,
                      filterBy: recordValue?.toString() ?? '',
                      orderBy: filterValue?.toString() ?? '',
                      pageNo: pageNo.toString(),
                      sortBy: entryValue?.toString() ?? '10',
                    ),
                  ),
                );
              },
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
                  _buildDetailRow('Carton Price', data.cartonPrice.toString()),
                  _buildDetailRow(
                    'Transport Price',
                    data.transportPrice.toString(),
                  ),
                  _buildDetailRow('Quantity', data.quantity.toString()),
                ]),
                const SizedBox(height: 16),
                _buildSection('Production Details', [
                  _buildDetailRow(
                    'Gross Weight',
                    data.additionalInfo!.grossWeight.toString(),
                  ),
                  _buildDetailRow(
                    'Core',
                    data.additionalInfo!.coreLabel.toString(),
                  ),
                  _buildDetailRow(
                    'Stretch Film Size',
                    data.additionalInfo!.stretchFilmSize.toString(),
                  ),
                  _buildDetailRow(
                    'Net Weight',
                    data.additionalInfo!.netWeight.toString(),
                  ),

                  // _buildDetailRow(
                  //   'Tape Length',
                  //   data.additionalInfo.tapeLength.toString(),
                  // ),
                ]),

                const SizedBox(height: 16),
                // Form Fields
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ShowWidget(
                    //   value: showValue,
                    //   onChanged: (val) {
                    //     // update dialog-local UI and keep parent state in sync
                    //     dialogSetState(() {
                    //       showValue = val?.toString();
                    //     });
                    //     if (mounted) setState(() {});
                    //     log('Selected Show Value: $showValue');
                    //   },
                    // ),
                    // SizedBox(height: 18),
                    // if (showValue?.trim() == '2') ...[
                    //   _buildFormField(
                    //     'Weight',

                    //     CustomField(controller: weightController),
                    //   ),
                    // ],
                    _buildFormField(
                      'Display MFG',
                      CustomDatePicker(controller: displayMFGController),
                    ),
                    SizedBox(height: 15),

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
                    _buildFormField(
                      'Remark',
                      CustomField(controller: remarkController),
                    ),
                  ],
                ),

                SizedBox(height: 30),
                submitBatchButton(
                  data.rKey,
                  stretchFilmStickerModel.record!.batchInformation!.batchKey
                      .toString(),
                ), //!--------------------------------------------
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
                callEvent();
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
                context.pushNamed(
                  PrintStretchFilmSticker.routeName,
                  extra: data.rKey,
                );
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
          context.pushNamed(PrintStretchFilmSticker.routeName, extra: rKey);
          context.pop();
          callEvent();
          if (context.mounted) {
            ToastService.instance.showSuccess(
              context,
              state.response.message.toString(),
            );
          }
        } else {
          if (context.mounted) {
            ToastService.instance.showError(
              context,
              state.response.message ?? 'try again later',
            );
          }
        }
      }
      if (state is InventoryInRecordAddErrorStatus) {
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
                  displayValue: showValue.toString(),
                  inventoryKey: rKey.toString(),
                  remark: remarkController.text,
                  batchMRP: batchMRPController.text,
                  displayMFG: displayMFGController.text,

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

  List<GridColumn> buildGridColumns() {
    return [
      GridColumn(
        columnName: StretchFilm.srNo,
        width: 70,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'S. No.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: StretchFilm.inventoryCode,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Serial Number',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: StretchFilm.date,
        width: 120,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Date',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: StretchFilm.companyName,
        width: 200,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Vendor Name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: StretchFilm.billDate,
        width: 120,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Bill Date',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: StretchFilm.billNumber,
        width: 120,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Bill Number',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'grossWeight',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Gross Weight',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: StretchFilm.netWeight,
        width: 120,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Net Weight',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'difference',
        width: 100,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Difference',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'lessWeight',
        width: 100,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Less KG',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'actualWeight',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Actual Weight',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: StretchFilm.filmSize,
        width: 120,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Film Size',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: StretchFilm.core,
        width: 100,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Core',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'mic',
        width: 100,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'MIC',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'base',
        width: 100,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Base',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: StretchFilm.cartonPrice,
        width: 120,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Total Price',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: StretchFilm.transportPrice,
        width: 130,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Transportation Price',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: StretchFilm.actualPrice,
        width: 120,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Actual Price',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'perKGPrice',
        width: 120,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Per KG Price',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'margin',
        width: 100,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Margin',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'qty',
        width: 100,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Quantity',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: StretchFilm.remark,
        width: 150,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Remarks',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: StretchFilm.inventoryStatusLabel,
        width: 140,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Inventory Status',
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

  Widget get searchFields => RoundSearchFields(
    key: refreshKey,
    isStatus: true,
    // controller: searchController,
    onSearch: (keyword) {
      setState(() {
        searchController.text = keyword;
      });
      callEvent();
    },
    onChangedStatus: (status) {
      setState(() {
        stockStatus = status;
      });
      callEvent();
    },
    onChangedOrder: (order) {
      setState(() {
        filterValue = order;
      });
      callEvent();
    },
    onChangedSort: (sortBy) {
      setState(() {
        entryValue = sortBy;
      });
      callEvent();
    },
  );

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
              await StretchFilmPrintMultipleStickers(selectedItems);
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
            panel: 'stretch-film',
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

  Future<void> StretchFilmPrintMultipleStickers(
    List<StretchRecord> selectedItems,
  ) async {
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
          developer.log(name: 'Load Tap Factory Error', e.toString());
        }

        // Process indogrip sticker logo (bottom)
        final indogripBytes = indogrip.buffer.asUint8List();
        try {
          indogripStickerImage = pw.MemoryImage(indogripBytes);
        } catch (e) {
          developer.log(name: 'Load Indogrip Sticker Error', e.toString());
        }
      } catch (e) {
        developer.log(name: 'Load Images Error', e.toString());
      }

      // Add pages for each selected item
      for (var selectedItem in selectedItems) {
        // Load sticker data for this item
        StretchFilmStickerModel? stickerData;
        try {
          await loadStickerData(selectedItem.rKey.toString());
          stickerData = stretchFilmStickerModel;
        } catch (e) {
          developer.log(name: 'Load Sticker Data Error', e.toString());
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
            developer.log(name: 'Quantity Parse Error', e.toString());
            quantity = 1;
          }
        }

        // Add pages based on quantity
        for (int i = 0; i < quantity; i++) {
          pdf.addPage(
            pw.Page(
              pageFormat: PdfPageFormat(
                PdfPageFormat.inch * 4.9, // width = 4 inches
                PdfPageFormat.inch * 3.4, // height = 6 inches
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

                      // Sticker details
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Batch Code: ${record.batchInformation!.batchCode.toString()}',
                            style: style,
                          ),
                          pw.Text(
                            'Serial Number: ${record.inventoryInformation?.inventoryCode.toString()}',
                            style: style,
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Mic: ${record.batchInformation!.displayMic.toString()}',
                            style: style,
                          ),
                          pw.Text(
                            'Base: ${record.inventoryInformation!.additionalInfo!.baseLabel ?? "N/A"}',
                            style: style,
                          ),
                        ],
                      ),

                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'MFG: ${record.batchInformation!.displayMFGLabel ?? "N/A"}',
                            style: style,
                          ),
                          pw.Text(
                            'MRP: ${record.batchInformation!.batchMRP ?? "N/A"}',
                            style: style,
                          ),
                        ],
                      ),

                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Size/Width: ${record.inventoryInformation!.additionalInfo!.stretchFilmSize ?? "N/A"}',
                            style: style,
                          ),

                          pw.Text(
                            'Weight: ${record.inventoryInformation!.additionalInfo!.grossWeight?.toString() ?? "N/A"}',
                            style: style,
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Operation: ${record.inventoryInformation!.additionalInfo!.coreCode?.toString() ?? "N/A"}',
                            style: style,
                          ),
                          pw.Text(
                            'Remark: ${record.batchInformation!.batchRemark?.toString() ?? "N/A"}',
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
        name: 'Indogrip Stretch Film Stickers',
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
