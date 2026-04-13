import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/utils/widgets/custom_textfield.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/data/model/change_status_param.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/multi_delete_button.dart';
import 'package:indogrip/features/global/presentation/widget/refresh_button.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:indogrip/features/vendor/presentation/bloc/vendor_bloc.dart';
import 'package:indogrip/features/vendor/presentation/pages/view/view_vendor.dart';

abstract class ViewVendorBuilder extends State<ViewVendorPanel> {
  List<Map<String, dynamic>> selectedItems = [];
  late VendorBloc vendorBloc;
  late final GlobalBloc globalBloc;
  final TextEditingController searchController = TextEditingController();
  final reasonController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  String? recordValue, filterValue, entryValue;

  int? pageNo = 1;
  int? pageQty;

  bool isMultipleSelection = false;
  // List<Map<String, dynamic>> selectedItems = [];

  // Define table columns

  eventHandler() {
    vendorBloc.add(
      ViewVendorRecordsFetchingEvent(
        param: ViewRecordApiParam(
          keyword: searchController.text,
          filterBy: recordValue.toString(),
          orderBy: filterValue.toString(),
          pageNo: pageNo.toString(),
          sortBy: entryValue.toString(),
          fromDate: fromDateController.text,
          toDate: toDateController.text,
        ),
      ),
    );
  }

  Key refreshKey = UniqueKey();

  void clearFiltersOnRefresh() {
    fromDateController.clear();
    toDateController.clear();
    searchController.clear();

    // Change key to force rebuild of dropdown widgets
    refreshKey = UniqueKey();

    setState(() {
      recordValue = null;
      filterValue = null;
      entryValue = null;
    });

    eventHandler();
  }

  void handleSelectionChanged(List<Map<String, dynamic>> items) {
    setState(() {
      selectedItems = items;
      print('DEBUG: selectedItems updated with ${items.length} items');
      if (items.isNotEmpty) {
        print('DEBUG: First item keys: ${items.first.keys.toList()}');
        print('DEBUG: First item rKey: ${items.first['rKey']}');
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
          context.pop();
          // Refresh the staff list
          eventHandler();
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
                  rPanel: 'view-vendor',
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

  Widget buildSelectionActions() {
    if (!isMultipleSelection || selectedItems.isEmpty) {
      return const SizedBox();
    }

    return MultiDeleteButton(
      panel: 'view-vendor',
      selectedItems: selectedItems,

      onPressed: () {
        setState(() {
          isMultipleSelection = false;
          selectedItems.clear();
        });
      },
    );
  }
}
