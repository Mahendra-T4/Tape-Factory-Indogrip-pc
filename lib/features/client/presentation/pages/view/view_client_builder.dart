import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/features/client/presentation/bloc/client_bloc.dart';
import 'package:indogrip/features/client/presentation/pages/view/view_client.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/data_filtration.dart';
import 'package:indogrip/features/global/presentation/widget/multi_delete_button.dart';
import 'package:indogrip/features/global/presentation/widget/refresh_button.dart';
import 'package:indogrip/features/global/presentation/widget/search_fields.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';

abstract class ViewClientBuilder extends State<ViewClientPanel> {
  late final GlobalBloc globalBloc;
  late ClientBloc clientBloc;
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  bool isMultipleSelection = false;
  List<Map<String, dynamic>> selectedItems = [];
  int pageNo = 1;
  int pageQty = 1;

  @override
  void initState() {
    super.initState();
    globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    clientBloc = ClientBloc();
    clientBloc.add(
      ViewClientRecordsFetchingEvent(
        viewClientApiParam: ViewRecordApiParam(
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
    // _initializeDataSource();
  }

  final TextEditingController searchController = TextEditingController();

  // Sample data

  void handleSelectionChanged(List<Map<String, dynamic>> items) {
    setState(() {
      selectedItems = items;
    });
  }

  void handleBulkDelete() {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No clients selected'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Implement bulk delete functionality
    print('Bulk deleting ${selectedItems.length} clients');
  }

  Widget get searchFields => SearchFields(
    isStatus: true,
    controller: searchController,
    statusValue: recordValue,
    orderByValue: filterValue,
    sortByValue: entryValue,
    onSearch: (keyword) {
      clientBloc.add(
        ViewClientRecordsFetchingEvent(
          viewClientApiParam: ViewRecordApiParam(
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
    onChangedStatus: (status) {
      setState(() {
        recordValue = status;
      });
      clientBloc.add(
        ViewClientRecordsFetchingEvent(
          viewClientApiParam: ViewRecordApiParam(
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
    onChangedOrder: (order) {
      setState(() {
        filterValue = order;
      });
      clientBloc.add(
        ViewClientRecordsFetchingEvent(
          viewClientApiParam: ViewRecordApiParam(
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
        entryValue = sortBy;
      });
      log('Entry Value: $entryValue');
      clientBloc.add(
        ViewClientRecordsFetchingEvent(
          viewClientApiParam: ViewRecordApiParam(
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

  void handleBulkEdit() {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No clients selected'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Implement bulk edit functionality
    print('Bulk editing ${selectedItems.length} clients');
  }

  Widget buildSelectionActions() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          MultiDeleteButton(
            selectedItems: selectedItems,
            panel: 'view-client',
            onPressed: () {
              if (selectedItems.isNotEmpty) {
                globalBloc.add(
                  GlobalDeleteMultipleRecordsEvent(
                    rKeys: selectedItems
                        .map((item) => item['rKey'].toString())
                        .toList(),
                    rPanel: 'view-staff',
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search clients...',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey[400]),
              ),
              onChanged: (value) {
                // Implement search functionality
              },
            ),
          ),
        ],
      ),
    );
  }

  String? recordValue, filterValue, entryValue;
  Widget get buildFilterFieldsDesktop => Padding(
    padding: const EdgeInsets.only(top: kDefaultVerticalPadding - 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              onPressed: () {
                setState(() {
                  isMultipleSelection = !isMultipleSelection;
                  if (!isMultipleSelection) {
                    selectedItems.clear();
                  }
                });
              },
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
        SizedBox(height: 5),
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
        clientBloc.add(
          ViewClientRecordsFetchingEvent(
            viewClientApiParam: ViewRecordApiParam(
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
}
