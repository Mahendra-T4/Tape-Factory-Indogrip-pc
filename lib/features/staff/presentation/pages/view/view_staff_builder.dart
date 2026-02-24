import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/constants/sizes.dart';
// import 'package:indogrip/core/theme/color_conts.dart'; // unused after removing local dropdown
import 'package:indogrip/core/utils/widgets/custom_textfield.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/data/model/change_status_param.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/data_filtration.dart';
import 'package:indogrip/features/global/presentation/widget/multi_delete_button.dart';
import 'package:indogrip/features/global/presentation/widget/refresh_button.dart';
import 'package:indogrip/features/global/presentation/widget/search_fields.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:indogrip/features/staff/data/models/view_staff_model.dart';
import 'package:indogrip/features/staff/presentation/bloc/staff_bloc.dart';
import 'package:indogrip/features/staff/presentation/pages/view/view_staff.dart';
import 'package:indogrip/features/staff/presentation/widgets/view_staff_status.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

abstract class ViewStaffBuilder extends State<ViewStaffPanel> {
  late final GlobalBloc globalBloc;
  final searchController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  int? pageNo = 1;
  int? pageQty;

  TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pageNo = 1;
    staffBloc = StaffBloc();
    globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    staffBloc.add(
      ViewStaffRecordsFetchingEvent(
        viewStaffApiParam: ViewRecordApiParam(
          keyword: searchController.text,
          filterBy: recordValue ?? '',
          orderBy: filterValue.toString(),
          pageNo: pageNo.toString(),
          sortBy: entryValue.toString(),
          fromDate: fromDateController.text,
          toDate: toDateController.text,
        ),
      ),
    );
  }

  bool isMultipleSelection = false;

  // String filterBy;

  String? changeStatus;

  late StaffBloc staffBloc;
  List<Map<String, dynamic>> selectedItems = [];
  List<StaffRecords> selectedStaff = [];

  void toggleMultipleSelection() {
    setState(() {
      isMultipleSelection = !isMultipleSelection;
      if (!isMultipleSelection) {
        selectedItems.clear();
        // Note: selectedRows will be cleared automatically when toggling off
        // because the SfDataGrid's showCheckboxColumn becomes false
      }
    });
  }

  Widget customAlertBoxWidget(String rKey, String reason, String value) =>
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
                'Change User Status',
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
                onPressed: () => context.pop(),
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
          staffBloc.add(
            ViewStaffRecordsFetchingEvent(
              viewStaffApiParam: ViewRecordApiParam(
                keyword: searchController.text,
                filterBy: recordValue ?? '',
                orderBy: filterValue.toString(),
                pageNo: pageNo.toString(),
                sortBy: entryValue.toString(),
                fromDate: fromDateController.text,
                toDate: toDateController.text,
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
                  rPanel: 'view-staff',
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

  // Define table columns
  List<GridColumn> buildGridColumns() {
    return [
      GridColumn(
        columnName: 'srno',
        columnWidthMode: ColumnWidthMode.fitByCellValue,
        width: 70,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Text(
            'S.No',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'staff_name',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Text(
            'Name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'department',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: Center(child: TextFieldlabelText("Role")),
        ),
      ),
      // GridColumn(
      //   columnName: 'position',
      //   width: 150,
      //   label: Container(
      //     color: Colors.grey[100],
      //     child: Center(child: TextFieldlabelText("Position")),
      //   ),
      // ),
      GridColumn(
        columnName: 'mobile',
        width: 130,
        label: Container(
          color: Colors.grey[100],
          child: Center(child: TextFieldlabelText("Mobile")),
        ),
      ),
      GridColumn(
        columnName: 'altmobile',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          child: Center(child: TextFieldlabelText("Alternate Mobile")),
        ),
      ),
      GridColumn(
        columnName: 'email',
        width: 200,
        label: Container(
          color: Colors.grey[100],
          child: Center(child: TextFieldlabelText("Email")),
        ),
      ),
      GridColumn(
        columnName: 'personalemail',
        width: 220,
        label: Container(
          color: Colors.grey[100],
          child: Center(child: TextFieldlabelText("Personal Email")),
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
        width: 160,
        label: Container(
          color: Colors.grey[100],
          child: Center(child: TextFieldlabelText("Actions")),
        ),
      ),
    ];
  }

  void handleSelectionChanged(List<Map<String, dynamic>> items) {
    setState(() {
      selectedItems = items;
    });
  }

  Widget buildSelectionActions() {
    if (!isMultipleSelection || selectedItems.isEmpty) {
      return const SizedBox();
    }

    return MultiDeleteButton(
      selectedItems: selectedItems,
      panel: 'view-staff',
      onPressed: () {
        setState(() {
          isMultipleSelection = false;
          selectedItems.clear();
        });
      },
    );
  }

  Widget get searchFields => SearchFields(
    isStatus: true,
    controller: searchController,
    onSearch: (keyword) {
      staffBloc.add(
        ViewStaffRecordsFetchingEvent(
          viewStaffApiParam: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue ?? '',
            orderBy: filterValue.toString(),
            pageNo: pageNo.toString(),
            sortBy: entryValue.toString(),
            fromDate: fromDateController.text,
            toDate: toDateController.text,
          ),
        ),
      );
    },
    panelStatus: Expanded(
      child: ViewStaffMasterStatus(
        value: recordValue.toString(),

        onChanged: (value) {
          recordValue = value;
          staffBloc.add(
            ViewStaffRecordsFetchingEvent(
              viewStaffApiParam: ViewRecordApiParam(
                keyword: searchController.text,
                filterBy: recordValue ?? '',
                orderBy: filterValue.toString(),
                pageNo: pageNo.toString(),
                sortBy: entryValue.toString(),
                fromDate: fromDateController.text,
                toDate: toDateController.text,
              ),
            ),
          );
        },
      ),
    ),
    onChangedOrder: (order) {
      setState(() {
        filterValue = order;
      });
      staffBloc.add(
        ViewStaffRecordsFetchingEvent(
          viewStaffApiParam: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue ?? '',
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
      staffBloc.add(
        ViewStaffRecordsFetchingEvent(
          viewStaffApiParam: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue ?? '',
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

  String? recordValue, filterValue, entryValue;
  Widget get buildFilterFieldsDesktop => Padding(
    padding: const EdgeInsets.only(
      // top: kDefaultVerticalPadding,
      left: 16,
      right: 16,
    ),
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
            TextButton.icon(
              onPressed: toggleMultipleSelection,
              icon: Icon(
                isMultipleSelection
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: Colors.blue,
              ),
              label: Text(
                isMultipleSelection ? 'Multiple Selection' : 'Single Selection',
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ],
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
        staffBloc.add(
          ViewStaffRecordsFetchingEvent(
            viewStaffApiParam: ViewRecordApiParam(
              keyword: searchController.text,
              filterBy: recordValue ?? '',
              orderBy: filterValue.toString(),
              pageNo: pageNo.toString(),
              sortBy: entryValue.toString(),
              fromDate: fromDateController.text,
              toDate: toDateController.text,
            ),
          ),
        );
      },
    ),
  );

  //! tablet

  // Widget get buildFilterFieldsTablet => Padding(
  //   padding: const EdgeInsets.only(top: kDefaultVerticalPadding),
  //   child: Column(
  //     spacing: 16,
  //     children: [
  //       searchFields,

  //       // SizedBox(height: 15),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           TextButton.icon(
  //             onPressed: toggleMultipleSelection,
  //             icon: Icon(
  //               isMultipleSelection
  //                   ? Icons.check_box
  //                   : Icons.check_box_outline_blank,
  //               color: Colors.blue,
  //             ),
  //             label: Text(
  //               isMultipleSelection ? 'Multiple Selection' : 'Single Selection',
  //               style: const TextStyle(color: Colors.blue),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   ),
  // );
}
