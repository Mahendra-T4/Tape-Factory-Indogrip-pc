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

  void handleSelectionChanged(List<Map<String, dynamic>> items) {
    setState(() {
      selectedItems = items;
    });
  }

  Widget get searchFields => SearchFields(
    isStatus: true,
    controller: searchController,
    onSearch: (keyword) {
      wastageBloc.add(
        ViewWastageFromRecords(
          param: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue ?? '',
            orderBy: filterValue.toString(),
            pageNo: currentPage.toString(),
            sortBy: entryValue.toString(),
          ),
        ),
      );
    },
    onChangedStatus: (status) {
      setState(() {
        recordValue = status;
      });
      wastageBloc.add(
        ViewWastageFromRecords(
          param: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue ?? '',
            orderBy: filterValue.toString(),
            pageNo: currentPage.toString(),
            sortBy: entryValue.toString(),
          ),
        ),
      );
    },
    onChangedOrder: (order) {
      setState(() {
        filterValue = order;
      });
      wastageBloc.add(
        ViewWastageFromRecords(
          param: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue ?? '',
            orderBy: filterValue.toString(),
            pageNo: currentPage.toString(),
            sortBy: entryValue.toString(),
          ),
        ),
      );
    },
    onChangedSort: (sortBy) {
      setState(() {
        entryValue = sortBy ?? 10;
      });
      wastageBloc.add(
        ViewWastageFromRecords(
          param: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue ?? '',
            orderBy: filterValue.toString(),
            pageNo: currentPage.toString(),
            sortBy: entryValue.toString(),
          ),
        ),
      );
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
            wastageBloc.add(
              ViewWastageFromRecords(
                param: ViewRecordApiParam(
                  keyword: searchController.text,
                  filterBy: recordValue ?? '',
                  orderBy: filterValue.toString(),
                  pageNo: currentPage.toString(),
                  sortBy: entryValue.toString(),
                ),
              ),
            );
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
