import 'package:flutter/material.dart';
import 'package:indogrip/core/utils/widgets/delete_alert.dart';
import 'package:indogrip/features/notifications/model/notification_model.dart';
import 'package:indogrip/features/notifications/view/widget/read_notification_widget.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class NotificationDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<Record> notificationData = [];
  bool isAllChecked;
  final Function(bool) onStatusChanged;
  final Function(bool, int) onCheckboxChanged;
  final Function(Record) onMarkAsRead;
  final BuildContext context;
  final Function(Record) onDelete;
  final void Function()? onSuccess;

  NotificationDataSource({
    required this.notificationData,
    required this.onMarkAsRead,
    required this.context,
    required this.onStatusChanged,
    required this.onCheckboxChanged,
    required this.isAllChecked,
    required this.onDelete,
    this.onSuccess,
  }) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = notificationData.asMap().entries.map<DataGridRow>((entry) {
      final data = entry.value;
      return DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: NotificationColumn.srNo,
            value: data.sNo.toString(),
          ),
          // DataGridCell<String>(
          //   columnName: NotificationColumn.action,
          //   value: data.notificationAction.toString(),
          // ),
          DataGridCell<String>(
            columnName: NotificationColumn.message,
            value: data.notificationMsg.toString(),
          ),
          DataGridCell<String>(
            columnName: NotificationColumn.date,
            value: data.notificationDate.toString(),
          ),
          DataGridCell<String>(
            columnName: NotificationColumn.panel,
            value: data.notificationPanel.toString(),
          ),
          // DataGridCell<String>(
          //   columnName: NotificationColumn.status,
          //   value: data.notificationStatus == 1 ? 'Read' : 'Unread',
          // ),
          DataGridCell<Widget>(
            columnName: 'actions',
            value: _buildActionButtons(data),
          ),
        ],
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'actions') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: cell.value as Widget,
          );
        }
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SelectableText(
            cell.value?.toString() ?? '',
            maxLines: 1,
            toolbarOptions: const ToolbarOptions(copy: true, selectAll: true),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(Record notification) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 8,
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (notification.notificationStatus == 1)
              ReadNotificationWidget(
                notification: notification,
                onSuccess: onSuccess,
              ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
              onPressed: () {
                DeleteConfirmationAlert.show(
                  context,
                  title: 'Delete Record',
                  message: 'Are Your to Delete This Notification Record',
                  itemName: '${notification.notificationMsg}',
                  onConfirm: () {
                    onDelete(notification);
                  },
                  rPanel: 'admin-notification',
                  item: notificationData,
                  index: notificationData.indexOf(notification),
                  rKey: notification.notificationKey.toString(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationColumn {
  static const String srNo = 'Sr No';
  static const String action = 'Action';
  static const String message = 'Message';
  static const String date = 'Date';
  static const String panel = 'Panel';
  static const String status = 'Status';
}
