import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/widgets/custom_date_picker.dart';
import 'package:indogrip/core/utils/widgets/custom_textfield.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/core/widgets/labal_text.dart';
import 'package:indogrip/features/global/data/model/change_status_param.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/base_filter_field.dart';
import 'package:indogrip/features/global/presentation/widget/custom_field.dart';
import 'package:indogrip/features/global/presentation/widget/file_export_button.dart';
import 'package:indogrip/features/global/presentation/widget/multi_delete_button.dart';
import 'package:indogrip/features/global/presentation/widget/refresh_button.dart';
import 'package:indogrip/features/global/presentation/widget/search_field_round.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/widgets/micron_dropdown_widget.dart';
import 'package:indogrip/features/print/print_sticker.dart';
import 'package:indogrip/features/round/data/models/add_batch_param.dart';
import 'package:indogrip/features/round/data/models/view_round_modeld.dart';
import 'package:indogrip/features/round/data/round_file_exporter.dart';
import 'package:indogrip/features/round/domain/repositories/add_round_repo.dart';
import 'package:indogrip/features/round/presentation/bloc/round_bloc.dart';
import 'package:indogrip/features/round/presentation/pages/view/view_round.dart';
import 'package:indogrip/features/round/presentation/widgets/master_roll_size_widget.dart';
import 'package:indogrip/features/round/presentation/widgets/show_widget.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';

abstract class ViewRoundBuilder extends State<ViewRoundPanel> {
  // BatchDetailsModel batchDetailsModel = BatchDetailsModel();
  bool isMultipleSelection = false;
  late final RoundBloc roundBloc;
  List<Map<String, dynamic>> selectedItems = [];
  int? pageNo = 1;
  int? pageQty;
  bool isAbsorb = false;
  // late RoundBloc roundBloc;
  TextEditingController weightController = TextEditingController();
  TextEditingController displayMicController = TextEditingController();
  TextEditingController displayMFGController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  TextEditingController tapLengthController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController batchMRPController = TextEditingController();
  TextEditingController batchOperatorController = TextEditingController();
  TextEditingController batchPackedByController = TextEditingController();
  TextEditingController tapeLengthController = TextEditingController();

  final reasonController = TextEditingController();
  final batchRemarkController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  Key refreshKey = UniqueKey();

  var recordValue, filterValue, entryValue;

  String? selectedMic;
  String? selectedBase;
  String? cutMMMeter;

  late final GlobalBloc globalBloc;

  clearFiltersOnRefresh() {
    recordValue = null;
    filterValue = null;
    entryValue = null;
    selectedBase = null;
    selectedMic = null;
    cutMMMeter = null;

    fromDateController.clear();
    toDateController.clear();
    searchController.clear();

    refreshKey = UniqueKey();

    callEvent();
  }

  @override
  void initState() {
    super.initState();
    roundBloc = RoundBloc(addRoundRepository: AddRoundRepository());
    globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    roundBloc.add(
      ViewRoundRecordsFetchingEvent(
        param: ViewRecordApiParam(
          keyword: searchController.text,
          filterBy: recordValue ?? '',
          orderBy: filterValue.toString(),
          pageNo: pageNo.toString(),
          sortBy: entryValue.toString(),
        ),
      ),
    );
    // showValue = null;
  }

  void callEvent() {
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
          tapeLength: tapeLengthController.text,
        ),
      ),
    );
  }

  void toggleMultipleSelection() {
    setState(() {
      isMultipleSelection = !isMultipleSelection;
      if (!isMultipleSelection) {
        selectedItems.clear();
      }
    });
  }

  void handleSelectionChanged(List<Map<String, dynamic>> items) {
    setState(() {
      selectedItems = items;
    });
  }

  Widget customAlertBoxWidget2(String rKey, String reason, String value) =>
      AlertDialog(
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
                'Reason for Blocking User',
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
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Text('Enter a Reason for Blocking User'),

            CustomTextField(controller: reasonController),
          ],
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
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
              changeUserStatusButton(rKey.toString(), reason, value.toString()),
            ],
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
      );

  Widget changeUserStatusButton(
    String rKey,
    String reason,
    String value,
  ) => BlocConsumer<GlobalBloc, GlobalState>(
    bloc: globalBloc,
    listener: (context, state) {
      if (state is GlobalChangeUserStatusSuccessStatus) {
        if (state.changeStatusEntity.status == 1) {
          if (!context.mounted) return;
          ToastService.instance.showSuccess(
            context,
            state.changeStatusEntity.message.toString(),
          );
          // Only close dialog after successful status change
          Navigator.of(context).pop();
          // Refresh the staff list
          roundBloc.add(
            ViewRoundRecordsFetchingEvent(
              param: ViewRecordApiParam(
                keyword: searchController.text,
                filterBy: recordValue ?? '',
                orderBy: filterValue.toString(),
                pageNo: pageNo.toString(),
                sortBy: entryValue.toString(),
              ),
            ),
          );
        } else {
          if (!context.mounted) return;
          ToastService.instance.showError(
            context,
            state.changeStatusEntity.message.toString(),
          );
        }
      }
      if (state is GlobalChangeUserStatusErrorStatus) {
        if (!context.mounted) return;
        ToastService.instance.showError(context, state.message.toString());
      }
    },
    builder: (context, state) {
      if (state is GlobalLoadingStatus) {
        return const Center(child: CircularProgressIndicator());
      }
      return TextButton(
        onPressed: () {
          if (reasonController.text.isNotEmpty) {
            globalBloc.add(
              GlobalChangeUserStatusEvent(
                param: ChangeStaffParam(
                  rKey: rKey.toString(),
                  rPanel: 'view-round',
                  rStatus: value.toString(),
                  statusReason: reasonController.text,
                ),
              ),
            );
            reasonController.clear();
          } else {
            ToastService.instance.showWarning(context, 'Please enter reason');
          }
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Submit'),
      );
    },
  );

  void handleBulkDelete() {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No rounds selected'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Implement bulk delete functionality
    print('Bulk deleting ${selectedItems.length} rounds');
  }

  void handleBulkEdit() {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No rounds selected'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Implement bulk edit functionality
    print('Bulk editing ${selectedItems.length} rounds');
  }

  Widget buildSelectionActions() {
    if (!isMultipleSelection || selectedItems.isEmpty) {
      return const SizedBox();
    }

    return MultiDeleteButton(
      selectedItems: selectedItems,
      panel: 'view-round',
      onPressed: () {
        setState(() {
          isMultipleSelection = false;
          selectedItems.clear();
        });
      },
    );
  }

  Widget get searchFields => RoundSearchFields(
    key: refreshKey,
    isStatus: true,
    controller: searchController,
    onSearch: (keyword) {
      callEvent();
    },
    orderByValue: filterValue,
    onChangedStatus: (status) {
      setState(() {
        recordValue = status;
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
        entryValue = sortBy ?? 10;
      });

      if (entryValue == '50' || entryValue == '100' || entryValue == '200') {
        setState(() {
          isAbsorb = true;
        });
      } else {
        setState(() {
          isAbsorb = false;
        });
      }
      callEvent();
    },
  );

  Widget get extraFilterFields => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: kDefaultHorizontalPadding - 5,
    ),
    child: Row(
      key: refreshKey,
      spacing: 16,
      children: [
        Expanded(
          child: MicronDropdownWidget(
            onChanged: (value) {
              setState(() {
                selectedMic = value;
              });
              callEvent();
            },
            isFilter: true,
            size: 37,
          ),
        ),
        Expanded(
          child: MasterRoleSizeSelector(
            onChanged: (value) {
              setState(() {
                cutMMMeter = value;
              });
              callEvent();
            },
            isFilter: true,
            size: 37,
            selectedRole: cutMMMeter,
          ),
        ),
        // Expanded(child: SizedBox()),
        Expanded(
          child: BaseFilterDropdownWidget(
            onChanged: (value) {
              setState(() {
                selectedBase = value;
              });
              callEvent();
            },
          ),
        ),
        Expanded(
          // flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              LabelText('Tape Length'),
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
                  controller: tapeLengthController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter Tap Length',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
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
                      borderSide: BorderSide(
                        color: Color(0xFF2D8FCF),
                        width: 1.5,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: ColourPalette.textFieldLabelColor,
                  ),
                  onChanged: (value) {
                    // setState(() {
                    //   tapeLengthController. value;
                    // });
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
                          tapeLength: value.toString(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget get refreshButton => SizedBox(
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
  );

  Widget get buildFilterFieldsDesktop => Column(
    key: refreshKey,
    children: [
      extraFilterFields,
      SizedBox(height: 15),
      Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          refreshButton,
          if (isMultipleSelection) buildSelectionActions(),
          SizedBox(width: 10),
          FileExportButton(
            onPressed: () async {
              await RoundFileExporter.exportRoundDataExcelFile(
                context: context,
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
                  tapeLength: tapeLengthController.text,
                ),
              );
            },
          ),

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
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  Widget customAlertBoxWidget(RoundRecord data, ViewRoundModel model) {
    String? showValue = data.batchInformation!.showFor.toString();

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: Container(
        width: MediaQuery.sizeOf(context).width * 0.6,
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
                context.pop();
              },
            ),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: _buildSection('Jumbo Information', [
                    _buildDetailRow('Roll Number', data.rollNumber ?? '-'),
                    _buildDetailRow('Width', data.width.toString()),
                    _buildDetailRow('Base', data.base.toString()),
                    _buildDetailRow('MIC', data.mic.toString()),
                    _buildDetailRow('Length', data.length.toString()),
                    _buildDetailRow(
                      'Total Weight',
                      data.totalWeight.toString(),
                    ),
                    _buildDetailRow('Amount/KG', data.amountPerKG.toString()),
                  ]),
                ),
                // const SizedBox(height: 16),
                Expanded(
                  child: _buildSection('Production Details', [
                    _buildDetailRow('Cut MM Meter', data.cutMMMeter.toString()),
                    _buildDetailRow('Round Count', data.roundCount.toString()),
                    _buildDetailRow('Tape Length', data.tapeLength.toString()),
                    _buildDetailRow(
                      'Damage Pieces',
                      data.damagePieces.toString(),
                    ),
                    _buildDetailRow(
                      'Wastage',
                      data.wastagePercentage.toString(),
                    ),
                    _buildDetailRow(
                      'Conversion Rate',
                      data.conversionRate.toString(),
                    ),
                    _buildDetailRow('Core', data.coreLabel.toString()),
                  ]),
                ),
              ],
            ),

            Row(
              spacing: 16,
              children: [
                // const SizedBox(height: 16),
                Expanded(
                  child: _buildSection('Additional Info', [
                    _buildDetailRow(
                      'Material Cost',
                      "₹ ${data.cartonMaterialCost}",
                    ),
                    _buildDetailRow(
                      'Carton + Conversion + Wastage',
                      "₹ ${data.cartonRate}",
                    ),
                    _buildDetailRow('', ""),
                  ]),
                ),
                // const SizedBox(height: 16),
                Expanded(
                  child: _buildSection('Margin Percentage', [
                    _buildDetailRow('10%', '₹ ${data.marginWithTenPercentage}'),
                    _buildDetailRow(
                      '12%',
                      '₹ ${data.marginWithTwelvePercentage}',
                    ),
                    _buildDetailRow(
                      '15%',
                      '₹ ${data.marginWithFifteenPercentage}',
                    ),
                  ]),
                ),
              ],
            ),

            // const SizedBox(height: 16),
            // Form Fields
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setDialogState) {
                // Initialize controller values
                batchMRPController.text = data.batchInformation!.batchMRP ?? '';

                batchOperatorController.text =
                    data.batchInformation!.batchOperator ?? '';
                batchPackedByController.text =
                    data.batchInformation!.batchPackedBy ?? '';

                displayMicController.text =
                    data.batchInformation!.displayMic != null
                    ? data.batchInformation!.displayMic.toString()
                    : '';

                displayMFGController.text =
                    data.batchInformation!.batchDateText != null
                    ? data.batchInformation!.batchDateText.toString()
                    : '';

                weightController.text = data.batchInformation!.showFor == 2
                    ? data.batchInformation!.displayValue.toString()
                    : '';

                tapLengthController.text = data.batchInformation!.showFor == 1
                    ? data.batchInformation!.displayValue.toString()
                    : '';

                remarkController.text =
                    data.batchInformation!.batchRemark ?? '';

                return Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          child: ShowWidget(
                            value: showValue,
                            onChanged: (val) {
                              print('ShowWidget onChanged: val=$val');
                              setDialogState(() {
                                showValue = val;
                                print(
                                  'After setDialogState: showValue=$showValue',
                                );
                              });
                            },
                          ),
                        ),
                        if (showValue == '2')
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                final show = showValue == '2';
                                print(
                                  'Building Weight field: show=$show, showValue=$showValue',
                                );
                                if (show) {
                                  return _buildFormField(
                                    'Weight',
                                    CustomField(controller: weightController),
                                  );
                                }
                                return SizedBox.shrink();
                              },
                            ),
                          ),
                        if (showValue == '1')
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                final show = showValue == '1';
                                print(
                                  'Building Tape Length field: show=$show, showValue=$showValue',
                                );
                                if (show) {
                                  return _buildFormField(
                                    'Display Tape Length',
                                    CustomField(
                                      controller: tapLengthController,
                                    ),
                                  );
                                }
                                return SizedBox.shrink();
                              },
                            ),
                          ),

                        // Expanded(child: SizedBox(height: 18)),
                      ],
                    ),

                    // SizedBox(height: 10),
                    // Weight field - show when showValue == '2'
                    Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          child: _buildFormField(
                            'Display MFG',
                            CustomDatePicker(controller: displayMFGController),
                          ),
                        ),
                        Expanded(
                          child: _buildFormField(
                            'Display Mic',
                            CustomField(controller: displayMicController),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          child: _buildFormField(
                            'Batch MRP',
                            CustomField(
                              controller: batchMRPController,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  final mrp = double.tryParse(value) ?? 0.0;
                                  if (mrp < data.marginWithTenPercentage) {
                                    ToastService.instance.showWarning(
                                      context,
                                      'Batch MRP cannot be less than 10% margin (${data.marginWithTenPercentage})',
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: _buildFormField(
                            'Batch Operator',
                            CustomField(controller: batchOperatorController),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          child: _buildFormField(
                            'Batch Packed By',
                            CustomField(controller: batchPackedByController),
                          ),
                        ),
                        Expanded(
                          child: _buildFormField(
                            'Remark',
                            CustomField(controller: remarkController),
                          ),
                        ),
                        // Display Tape Length field - show when showValue == '1'
                      ],
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 5),
            BlocConsumer(
              bloc: roundBloc,
              listener: (context, state) {
                if (state is AddBatchLoadedSuccessStatus) {
                  if (state.addBatchModel.status == 1) {
                    context.pushNamed(
                      PrintSticker.routeName,
                      extra: data.rKey,
                      // arguments: data,
                    );
                    callEvent();
                    context.pop();
                    // context.pushNamed(
                    //   PrintSticker.routeName,
                    //   extra: rKey,
                    //   // arguments: data,
                    // );
                    if (context.mounted) {
                      ToastService.instance.showSuccess(
                        context,
                        state.addBatchModel.message.toString(),
                      );
                    }
                  } else {
                    callEvent();
                    if (context.mounted) {
                      ToastService.instance.showError(
                        context,
                        state.addBatchModel.message.toString(),
                      );
                    }
                  }
                }
                if (state is AddBatchFailedToAddStatus) {
                  if (context.mounted) {
                    ToastService.instance.showSuccess(
                      context,
                      state.error.toString(),
                    );
                  }
                }
              },
              builder: (context, state) {
                if (state is RoundLoadingStatus) {
                  return Center(child: CircularProgressIndicator());
                }
                return Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // print('BatchKey => ${batchDetailsModel
                      //           .record
                      //           !.batchInformation
                      //           !.batchKey}');
                      roundBloc.add(
                        AddBatchOnRecordEvent(
                          apiParam: AddBatchParam(
                            displayMFG: displayMFGController.text,
                            displayMic: displayMicController.text,
                            displayValue: tapLengthController.text.isNotEmpty
                                ? tapLengthController.text
                                : weightController.text,
                            roundKey: data.rKey.toString(),
                            remark: remarkController.text,
                            batchMRP: batchMRPController.text,
                            batchOperator: batchOperatorController.text,
                            batchPackedBy: batchPackedByController.text,
                            rKey: data.batchInformation?.batchKey,
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
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>((
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
            ), //!--------------------------------------------
          ],
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actions: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                context.pop();
                callEvent();
              },
              style:
                  ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ).copyWith(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>((
                      Set<MaterialState> states,
                    ) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.grey.shade700;
                      }
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.grey.shade800;
                      }
                      return null;
                    }),
                  ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.close, size: 20),
                  const SizedBox(width: 8),
                  const Text('Close'),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                context.pushNamed(
                  PrintSticker.routeName,
                  extra: data.rKey,
                  // arguments: data,
                );
                context.pop();
              },
              style:
                  ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
                  const Icon(Icons.visibility, size: 20),
                  const SizedBox(width: 8),
                  const Text('View'),
                ],
              ),
            ),
          ],
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(10),
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
          // const SizedBox(height: 5),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildFormField(String label, Widget child) {
    return Column(
      spacing: 10,
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

        SizedBox(width: double.infinity, child: child),
      ],
    );
  }
}
