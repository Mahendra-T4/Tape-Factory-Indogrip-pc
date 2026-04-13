import 'package:flutter/material.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/features/global/presentation/widget/multi_delete_button.dart';
import 'package:indogrip/features/global/presentation/widget/refresh_button.dart';
import 'package:indogrip/features/global/presentation/widget/search_fields.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:indogrip/features/wastage/data/model/view_wastage_model.dart';
import 'package:indogrip/features/wastage/presentation/bloc/wastage_bloc.dart';
import 'package:indogrip/features/wastage/presentation/pages/view/view_wastage.dart';

abstract class ViewWastageBuilder extends State<ViewWastagePanel> {
  Key refreshKey = UniqueKey();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  late WastageBloc wastageBloc;
  bool isMultipleSelection = false;
  List<Map<String, dynamic>> selectedItems = [];
  int? currentPage = 1;
  String pageText = '';
  int? pageQty;
  final TextEditingController searchController = TextEditingController();

  void toggleMultipleSelection() {
    setState(() {
      isMultipleSelection = !isMultipleSelection;
      if (!isMultipleSelection) {
        selectedItems.clear();
      }
    });
  }

  var recordValue, filterValue, entryValue;

  eventHandler() {
    wastageBloc.add(
      ViewWastageFromRecords(
        param: ViewRecordApiParam(
          toDate: toDateController.text.trim(),
          fromDate: fromDateController.text.trim(),
          keyword: searchController.text,
          filterBy: recordValue ?? '',
          orderBy: filterValue.toString(),
          pageNo: currentPage.toString(),
          sortBy: entryValue.toString(),
        ),
      ),
    );
  }

  clearFiltersOnRefresh() {
    searchController.clear();
    fromDateController.clear();
    toDateController.clear();
    setState(() {
      recordValue = null;
      filterValue = null;
      entryValue = null;
    });

    refreshKey = UniqueKey();

    eventHandler();
  }

  void handleSelectionChanged(List<Map<String, dynamic>> items) {
    setState(() {
      selectedItems = items;
    });
  }

  Widget get searchFields => SearchFields(
    key: refreshKey,
    isStatus: true,
    controller: searchController,
    onSearch: (keyword) {
      eventHandler();
    },
    onChangedStatus: (status) {
      setState(() {
        recordValue = status;
      });
      eventHandler();
    },
    onChangedOrder: (order) {
      setState(() {
        filterValue = order;
      });
      eventHandler();
    },
    onChangedSort: (sortBy) {
      setState(() {
        entryValue = sortBy ?? 10;
      });
      eventHandler();
    },
  );

  Widget get refreshButton => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      SizedBox(
        width: MediaQuery.sizeOf(context).width * .15,
        height: 35,
        child: RefreshButton(
          onPressed: () {
            clearFiltersOnRefresh();
          },
        ),
      ),
      SizedBox(width: 12),
    ],
  );

  Widget get buildFilterFieldsDesktop => Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isMultipleSelection) buildSelectionActions(),
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
                isMultipleSelection ? 'Multiple Selection' : 'Single Selection',
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget buildSelectionActions() {
    if (!isMultipleSelection || selectedItems.isEmpty) {
      return const SizedBox();
    }

    return MultiDeleteButton(
      selectedItems: selectedItems,
      panel: 'view-wastage',
      onPressed: () {
        setState(() {
          isMultipleSelection = false;
          selectedItems.clear();
        });
      },
    );
  }

  void handleBulkDelete() {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No entries selected'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Implement bulk delete functionality
    print('Bulk deleting ${selectedItems.length} entries');
  }

  void handleBulkEdit() {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No entries selected'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Implement bulk edit functionality
    print('Bulk editing ${selectedItems.length} entries');
  }
}
