import 'package:flutter/material.dart';

import 'package:indogrip/features/carton/data/models/view_carton_model.dart';
import 'package:indogrip/features/carton/presentation/bloc/carton_bloc.dart';
import 'package:indogrip/features/carton/presentation/pages/view/view_carton.dart';
import 'package:indogrip/features/global/presentation/widget/refresh_button.dart';
import 'package:indogrip/features/global/presentation/widget/search_fields.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';

abstract class ViewCartonBuilder extends State<ViewCartonPanel> {
  Key refreshKey = UniqueKey();
  late CartonBloc cartonBloc;
  bool isMultipleSelection = false;
  List<ViewCartonRecord> selectedItems = [];
  String pageText = '';
  int? currentPage = 1;
  int? pageQty;
  final TextEditingController searchController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  List filterList = ["Newest", "Oldest"];
  List entryList = ["10", "25", "50", "100", "500"];
  var recordValue, filterValue, entryValue;

  void handleSelectionChanged(List<ViewCartonRecord> items) {
    setState(() {
      selectedItems = items;
    });
  }

  eventHandler() {
    cartonBloc.add(
      ViewCartonRecordEvent(
        param: ViewRecordApiParam(
          keyword: searchController.text.trim(),
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

  void handleBulkDelete() {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No cartons selected'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Implement bulk delete functionality
    print('Bulk deleting ${selectedItems.length} cartons');
  }

  void handleBulkEdit() {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No cartons selected'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Implement bulk edit functionality
    print('Bulk editing ${selectedItems.length} cartons');
  }

  Widget buildSelectionActions() {
    if (!isMultipleSelection || selectedItems.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            '${selectedItems.length} cartons selected',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: handleBulkEdit,
            icon: const Icon(Icons.edit),
            label: const Text('Edit Selected'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: handleBulkDelete,
            icon: const Icon(Icons.delete),
            label: const Text('Delete Selected'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

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
    ],
  );

  //! tablet

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
}
