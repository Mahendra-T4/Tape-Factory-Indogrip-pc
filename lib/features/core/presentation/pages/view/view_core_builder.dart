import 'package:flutter/material.dart';
import 'package:indogrip/features/core/data/models/view_core_model.dart';
import 'package:indogrip/features/core/presentation/bloc/core_bloc.dart';
import 'package:indogrip/features/core/presentation/pages/view/view_core.dart';
import 'package:indogrip/features/global/presentation/widget/refresh_button.dart';
import 'package:indogrip/features/global/presentation/widget/search_fields.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';

abstract class ViewCoreBuilder extends State<ViewCorePanel> {
  Key refreshKey = UniqueKey();
  late CoreBloc coreBloc;
  bool isMultipleSelection = false;
  List<CoreDataRecord> selectedItems = [];
  String pageText = '';

  int? currentPage = 1;
  int? pageQty;
  final TextEditingController searchController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  var recordValue, filterValue, entryValue;

  void handleSelectionChanged(List<CoreDataRecord> items) {
    setState(() {
      selectedItems = items;
    });
  }

  eventHandler() {
    coreBloc.add(
      ViewCoreRecordEvent(
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
