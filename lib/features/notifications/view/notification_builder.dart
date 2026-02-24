import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:indogrip/core/utils/widgets/textfield_label.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/multi_delete_button.dart';
import 'package:indogrip/features/notifications/repository/notification_repo.dart';
import 'package:indogrip/features/notifications/data/notification_data_source.dart';
import 'package:indogrip/features/notifications/view/notification_responsive.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

abstract class NotificationBuilder extends State<Notifications> {
  final GlobalKey<ScaffoldState> stateKey = GlobalKey<ScaffoldState>();
  NotificationDataSource? dataSource;
  late final GlobalBloc globalBloc;
  List<Map<String, dynamic>> selectedItems = [];
  final GlobalKey key = GlobalKey();
  bool isChecked = false;
  List<int> selectedIndices =
      []; // Store indices instead of DataGridRow objects
  bool isMultipleSelection = false;
  String? filterBy;
  @override
  void initState() {
    super.initState();
    globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    globalBloc.add(LoadNotificationsEvent());
  }

  Widget buildSelectionActions() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          MultiDeleteButton(
            selectedItems: selectedItems,
            panel: 'admin-notification',
            keyField:
                'notificationKey', // Specify the correct field name for notifications
            onPressed: () {
              log('MultiDeleteButton onPressed called');
              log(
                'Selected items for deletion: ${selectedItems.map((e) => e['notificationKey']).toList()}',
              );
              if (selectedItems.isNotEmpty) {
                globalBloc.add(
                  GlobalDeleteMultipleRecordsEvent(
                    rKeys: selectedItems
                        .map((item) => item['notificationKey'].toString())
                        .toList(),
                    rPanel: 'admin-notification',
                  ),
                );
              } else {
                log('selectedItems is empty!');
              }
            },
          ),
        ],
      ),
    );
  }

  void handleSelectionChanged(List<Map<String, dynamic>> items) {
    log('handleSelectionChanged called with ${items.length} items');
    if (items.isNotEmpty) {
      log('First item keys: ${items.first.keys.toList()}');
      log('First item notificationKey: ${items.first['notificationKey']}');
    }
    setState(() {
      selectedItems = items;
      log('selectedItems updated to ${selectedItems.length} items');
    });
  }

  List<GridColumn> buildGridColumns() {
    return [
      GridColumn(
        columnName: NotificationColumn.srNo,
        columnWidthMode: ColumnWidthMode.fitByCellValue,
        width: 70,
        minimumWidth: 50,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Text(
            'Sr No',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      // GridColumn(
      //   columnName: NotificationColumn.action,
      //   width: 250,
      //   label: Container(
      //     color: Colors.grey[100],
      //     child: const Center(child: TextFieldlabelText("Action")),
      //   ),
      // ),
      GridColumn(
        columnName: NotificationColumn.message,
        columnWidthMode: ColumnWidthMode.fill,
        minimumWidth: 200,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText("Message")),
        ),
      ),
      GridColumn(
        columnName: NotificationColumn.date,
        columnWidthMode: ColumnWidthMode.fitByColumnName,
        minimumWidth: 150,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText("Date")),
        ),
      ),
      GridColumn(
        columnName: NotificationColumn.panel,

        width: 200,
        minimumWidth: 100,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText("Panel")),
        ),
      ),
      // GridColumn(
      //   columnName: NotificationColumn.status,
      //   width: 100,
      //   label: Container(
      //     color: Colors.grey[100],
      //     child: const Center(child: TextFieldlabelText("Status")),
      //   ),
      // ),
      GridColumn(
        columnName: 'actions',
        width: 200,
        minimumWidth: 150,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText("Actions")),
        ),
      ),
    ];
  }

  void handleMarkAsRead(dynamic notification) async {
    // Show loading
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final result = await NotificationRepository.markNotificationAsRead(
      notification.notificationKey.toString(),
    );

    // Dismiss loading dialog
    if (mounted) {
      Navigator.pop(context);
    }

    // Show result message
    if (mounted) {
      if (result.status == 1) {
        ToastService.instance.showSuccess(context, result.message.toString());
        // Refresh the notifications
        // ref.invalidate(notificationProvider);
        globalBloc.add(LoadNotificationsEvent());
      } else {
        ToastService.instance.showError(context, result.message.toString());
      }
    }
  }
}
