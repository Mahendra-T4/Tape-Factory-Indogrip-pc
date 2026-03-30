import 'package:flutter/material.dart';

import 'package:indogrip/features/carton/data/models/view_carton_model.dart';
import 'package:indogrip/features/carton/presentation/bloc/carton_bloc.dart';
import 'package:indogrip/features/carton/presentation/pages/view/view_carton.dart';
import 'package:indogrip/features/global/presentation/widget/refresh_button.dart';
import 'package:indogrip/features/global/presentation/widget/search_fields.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';

abstract class ViewCartonBuilder extends State<ViewCartonPanel> {
  late CartonBloc cartonBloc;
  bool isMultipleSelection = false;
  List<ViewCartonRecord> selectedItems = [];
  String pageText = '';
  int? currentPage = 1;
  int? pageQty;
  final TextEditingController searchController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  List recordList = [
    "All Records",
    "Requested",
    "In-Progress",
    "Approved",
    "Rejected",
    "Block",
  ];
  List filterList = ["Newest", "Oldest"];
  List entryList = ["10", "25", "50", "100", "500"];
  var recordValue, filterValue, entryValue;

  void handleSelectionChanged(List<ViewCartonRecord> items) {
    setState(() {
      selectedItems = items;
    });
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
            cartonBloc.add(
              ViewCartonRecordEvent(
                param: ViewRecordApiParam(
                  keyword: searchController.text,
                  filterBy: recordValue ?? '',
                  orderBy: filterValue.toString(),
                  pageNo: currentPage.toString(),
                  sortBy: entryValue.toString(),
                  fromDate: fromDateController.text,
                  toDate: toDateController.text,
                ),
              ),
            );
          },
        ),
      ),
    ],
  );

  //! tablet

  Widget get searchFields => SearchFields(
    isStatus: true,
    controller: searchController,
    onSearch: (keyword) {
      cartonBloc.add(
        ViewCartonRecordEvent(
          param: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue ?? '',
            orderBy: filterValue.toString(),
            pageNo: currentPage.toString(),
            sortBy: entryValue.toString(),
            fromDate: fromDateController.text,
            toDate: toDateController.text,
          ),
        ),
      );
    },
    onChangedStatus: (status) {
      setState(() {
        recordValue = status;
      });
      cartonBloc.add(
        ViewCartonRecordEvent(
          param: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue ?? '',
            orderBy: filterValue.toString(),
            pageNo: currentPage.toString(),
            sortBy: entryValue.toString(),
            fromDate: fromDateController.text,
            toDate: toDateController.text,
          ),
        ),
      );
    },
    onChangedOrder: (order) {
      setState(() {
        filterValue = order;
      });
      cartonBloc.add(
        ViewCartonRecordEvent(
          param: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue ?? '',
            orderBy: filterValue.toString(),
            pageNo: currentPage.toString(),
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
      cartonBloc.add(
        ViewCartonRecordEvent(
          param: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue ?? '',
            orderBy: filterValue.toString(),
            pageNo: currentPage.toString(),
            sortBy: entryValue.toString(),
            fromDate: fromDateController.text,
            toDate: toDateController.text,
          ),
        ),
      );
    },
  );
}
