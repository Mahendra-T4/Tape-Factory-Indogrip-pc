import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/data_filtration.dart';
import 'package:indogrip/features/notifications/data/notification_data_source.dart';
import 'package:indogrip/features/notifications/view/notification_builder.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class NotificationItem {
  final String title;
  final String message;
  final DateTime time;
  final NotificationType type;
  final bool isRead;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

enum NotificationType { info, success, warning, error }

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);
  static const String routeName = '/notifications';

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends NotificationBuilder {
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: InternetConnectionService().connectionStream,
      initialData: true, // Assume connected initially
      builder: (context, snapshot) {
        // Handle error state
        if (snapshot.hasError) {
          return const NoInternetConnection();
        }

        // Handle disconnected state
        if (snapshot.data == false) {
          return const NoInternetConnection();
        }

        // Handle loading state
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          backgroundColor: Colors.white,
          key: stateKey,
          appBar: Responsive.isDesktop(context)
              ? DesktopAppBar(context, stateKey, 'Notification', false)
              : MobileAppBar(context, stateKey, ''),

          drawer: !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : null,
          body: Column(
            children: [
              DateFiltration(
                readUnread: true,
                fromDateController: fromDateController,
                toDateController: toDateController,
                onReadUnreadChanged: (value) {
                  setState(() {
                    filterBy = value;
                    globalBloc.add(
                      LoadNotificationsEvent(
                        filterBy: int.parse(filterBy.toString()),
                      ),
                    );
                  });
                },
              ),

              Expanded(
                child: BlocConsumer(
                  bloc: globalBloc,
                  listener: (context, state) {},
                  builder: (context, state) {
                    switch (state.runtimeType) {
                      case GlobalLoadingStatus:
                        return const Center(child: CircularProgressIndicator());
                      case LoadNotificationsSuccessStatus:
                        final notification =
                            (state as LoadNotificationsSuccessStatus)
                                .notifications;
                        dataSource = NotificationDataSource(
                          notificationData: notification.record ?? [],
                          onMarkAsRead: (notification) {
                            handleMarkAsRead(notification);
                          },
                          context: context,
                          isAllChecked: isChecked,
                          onStatusChanged: (value) {
                            setState(() {
                              isChecked = value;
                              if (value) {
                                selectedRows = List.from(dataSource.rows);
                              } else {
                                selectedRows.clear();
                              }
                              final selectedData = value
                                  ? (state.notifications.record ?? [])
                                        .map((record) => record.toJson())
                                        .cast<Map<String, dynamic>>()
                                        .toList()
                                  : <Map<String, dynamic>>[];
                              handleSelectionChanged(selectedData);
                            });
                          },
                          onCheckboxChanged: (checked, index) {
                            if (dataSource == null) return;
                            setState(() {
                              if (checked) {
                                selectedRows.add(dataSource.rows[index]);
                              } else {
                                selectedRows.remove(dataSource.rows[index]);
                              }
                              final selectedRecords = selectedRows
                                  .map((row) {
                                    final idx = dataSource.rows.indexOf(row);
                                    if (idx != -1 &&
                                        idx <
                                            (state
                                                    .notifications
                                                    .record
                                                    ?.length ??
                                                0)) {
                                      final record =
                                          state.notifications.record![idx];
                                      return record.toJson();
                                    }
                                    return null;
                                  })
                                  .where((record) => record != null)
                                  .cast<Map<String, dynamic>>()
                                  .toList();
                              handleSelectionChanged(selectedRecords);
                            });
                          },
                          onDelete: (Record) {},
                        );
                        return state.notifications.status != 1
                            ? Center(
                                child: Text(
                                  state.notifications.message.toString(),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        spacing: 10,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          // refreshButton,
                                          if (isMultipleSelection)
                                            buildSelectionActions(),
                                          TextButton.icon(
                                            onPressed: () {
                                              setState(() {
                                                isMultipleSelection =
                                                    !isMultipleSelection;
                                                if (!isMultipleSelection) {
                                                  selectedItems.clear();
                                                }
                                              });
                                            },
                                            icon: Icon(
                                              isMultipleSelection
                                                  ? Icons.check_box
                                                  : Icons
                                                        .check_box_outline_blank,
                                              color: Colors.blue,
                                            ),
                                            label: Text(
                                              isMultipleSelection
                                                  ? 'Multiple Selection'
                                                  : 'Single Selection',
                                              style: const TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // if (selectedItems.isNotEmpty)
                                    //   buildSelectionActions(),
                                    Expanded(
                                      child: SfDataGrid(
                                        showHorizontalScrollbar: true,
                                        columnResizeMode:
                                            ColumnResizeMode.onResizeEnd,
                                        isScrollbarAlwaysShown: true,
                                        showVerticalScrollbar: true,
                                        showCheckboxColumn: isMultipleSelection,
                                        selectionMode: isMultipleSelection
                                            ? SelectionMode.multiple
                                            : SelectionMode.single,

                                        key: key,
                                        rowsPerPage: 10,
                                        allowColumnsResizing: true,
                                        highlightRowOnHover: true,

                                        source: dataSource,
                                        columns: buildGridColumns(),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                      case LoadNotificationsErrorStatus:
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.error, size: 64, color: Colors.red),
                              const SizedBox(height: 16),
                              Text(
                                'Something went wrong while loading notifications.',
                              ),
                            ],
                          ),
                        );
                      default:
                        return Text('Unknown state: ${state.runtimeType}');
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
