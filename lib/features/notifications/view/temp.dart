// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:indogrip/core/responsive/responsive.dart';
// import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
// import 'package:indogrip/core/service/connectivity/not_connected.dart';
// import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
// import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
// import 'package:indogrip/core/utils/sidebar.dart';
// import 'package:indogrip/core/utils/widgets/textfield_label.dart';
// import 'package:indogrip/core/utils/widgets/toast_service.dart';
// import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
// import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
// import 'package:indogrip/features/global/presentation/widget/multi_delete_button.dart';
// import 'package:indogrip/features/notifications/repository/notification_repo.dart';
// import 'package:indogrip/features/notifications/data/notification_data_source.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// class NotificationItem {
//   final String title;
//   final String message;
//   final DateTime time;
//   final NotificationType type;
//   final bool isRead;

//   NotificationItem({
//     required this.title,
//     required this.message,
//     required this.time,
//     required this.type,
//     this.isRead = false,
//   });
// }

// enum NotificationType { info, success, warning, error }

// class Notifications extends ConsumerStatefulWidget {
//   const Notifications({Key? key}) : super(key: key);
//   static const String routeName = '/notifications';

//   @override
//   ConsumerState<Notifications> createState() => _NotificationsState();
// }

// class _NotificationsState extends ConsumerState<Notifications> {
//   final GlobalKey<ScaffoldState> stateKey = GlobalKey<ScaffoldState>();
//   late NotificationDataSource dataSource;
//   late final GlobalBloc globalBloc;
//   List<Map<String, dynamic>> selectedItems = [];
//   final GlobalKey _key = GlobalKey();
//   bool isChecked = false;
//   List<DataGridRow> selectedRows = [];
//   @override
//   void initState() {
//     super.initState();
//     globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
//   }

//   Widget buildSelectionActions() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           MultiDeleteButton(
//             selectedItems: selectedItems,
//             panel: 'view-client',
//             onPressed: () {
//               if (selectedItems.isNotEmpty) {
//                 globalBloc.add(
//                   GlobalDeleteMultipleRecordsEvent(
//                     rKeys: selectedItems
//                         .map((item) => item['notificationKey'].toString())
//                         .toList(),
//                     rPanel: 'admin-notification',
//                   ),
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final notification = ref.watch(notificationProvider);

//     return StreamBuilder(
//       stream: InternetConnectionService().connectionStream,
//       initialData: true, // Assume connected initially
//       builder: (context, snapshot) {
//         // Handle error state
//         if (snapshot.hasError) {
//           return const NoInternetConnection();
//         }

//         // Handle disconnected state
//         if (snapshot.data == false) {
//           return const NoInternetConnection();
//         }

//         // Handle loading state
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         return Scaffold(
//           backgroundColor: Colors.white,
//           key: stateKey,
//           appBar: Responsive.isDesktop(context)
//               ? DesktopAppBar(context, stateKey, 'Notification', false)
//               : MobileAppBar(context, stateKey, ''),

//           drawer: !Responsive.isDesktop(context)
//               ? const SideMenuWidget()
//               : null,
//           body: SafeArea(
//             child: notification.when(
//               data: (data) {
//                 return data.status != 1
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.notifications_off_outlined,
//                               size: 64,
//                               color: Colors.grey[400],
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               'No notifications',
//                               style: TextStyle(
//                                 color: Colors.grey[600],
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Expanded(
//                               child: _buildNotificationTable(data.record ?? []),
//                             ),
//                           ],
//                         ),
//                       );
//               },
//               error: (error, stackTrace) =>
//                   Center(child: Text('Error: $error')),
//               loading: () => const Center(child: CircularProgressIndicator()),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildNotificationTable(List<dynamic> records) {
//     dataSource = NotificationDataSource(
//       notificationData: records.cast(),
//       onMarkAsRead: (notification) {
//         _handleMarkAsRead(notification);
//       },
//       context: context,
//       isAllChecked: isChecked,
//       onStatusChanged: (value) {
//         setState(() {
//           isChecked = value;
//           if (value) {
//             selectedRows = List.from(_dataSource?.rows ?? []);
//           } else {
//             selectedRows.clear();
//           }
//           final selectedData = value
//               ? (state.viewClientModel.record ?? [])
//                     .map((record) => record.toJson())
//                     .cast<Map<String, dynamic>>()
//                     .toList()
//               : <Map<String, dynamic>>[];
//           handleSelectionChanged(selectedData);
//         });
//       },
//       onCheckboxChanged: (checked, index) {
//         if (dataSource == null) return;
//         setState(() {
//           if (checked) {
//             selectedRows.add(dataSource.rows[index]);
//           } else {
//             selectedRows.remove(dataSource.rows[index]);
//           }
//           final selectedRecords = selectedRows
//               .map((row) {
//                 final idx = dataSource.rows.indexOf(row);
//                 if (idx != -1 &&
//                     idx < (state.viewClientModel.record?.length ?? 0)) {
//                   final record = state.viewClientModel.record![idx];
//                   return record.toJson();
//                 }
//                 return null;
//               })
//               .where((record) => record != null)
//               .cast<Map<String, dynamic>>()
//               .toList();
//           handleSelectionChanged(selectedRecords);
//         });
//       },
//       onDelete: (Record) {},
//     );

//     return SfDataGrid(
//       showHorizontalScrollbar: true,
//       key: _key,
//       rowsPerPage: 10,
//       allowColumnsResizing: true,
//       highlightRowOnHover: true,
//       columnResizeMode: ColumnResizeMode.onResizeEnd,
//       isScrollbarAlwaysShown: true,
//       showVerticalScrollbar: true,
//       source: dataSource,
//       columns: _buildGridColumns(),
//     );
//   }

//   List<GridColumn> _buildGridColumns() {
//     return [
//       GridColumn(
//         columnName: NotificationColumn.srNo,
//         columnWidthMode: ColumnWidthMode.fitByCellValue,
//         width: 70,
//         label: Container(
//           color: Colors.grey[100],
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           alignment: Alignment.center,
//           child: const Text(
//             'Sr No',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//       GridColumn(
//         columnName: NotificationColumn.action,
//         width: 150,
//         label: Container(
//           color: Colors.grey[100],
//           child: const Center(child: TextFieldlabelText("Action")),
//         ),
//       ),
//       GridColumn(
//         columnName: NotificationColumn.message,
//         width: 300,
//         label: Container(
//           color: Colors.grey[100],
//           child: const Center(child: TextFieldlabelText("Message")),
//         ),
//       ),
//       GridColumn(
//         columnName: NotificationColumn.date,
//         width: 180,
//         label: Container(
//           color: Colors.grey[100],
//           child: const Center(child: TextFieldlabelText("Date")),
//         ),
//       ),
//       GridColumn(
//         columnName: NotificationColumn.panel,
//         width: 120,
//         label: Container(
//           color: Colors.grey[100],
//           child: const Center(child: TextFieldlabelText("Panel")),
//         ),
//       ),
//       // GridColumn(
//       //   columnName: NotificationColumn.status,
//       //   width: 100,
//       //   label: Container(
//       //     color: Colors.grey[100],
//       //     child: const Center(child: TextFieldlabelText("Status")),
//       //   ),
//       // ),
//       GridColumn(
//         columnName: 'actions',
//         width: 180,
//         label: Container(
//           color: Colors.grey[100],
//           child: const Center(child: TextFieldlabelText("Actions")),
//         ),
//       ),
//     ];
//   }

//   void _handleMarkAsRead(dynamic notification) async {
//     // Show loading
//     showDialog(
//       context: context,
//       builder: (context) => const Center(child: CircularProgressIndicator()),
//     );

//     final result = await NotificationRepository.markNotificationAsRead(
//       notification.notificationKey.toString(),
//     );

//     // Dismiss loading dialog
//     if (mounted) {
//       Navigator.pop(context);
//     }

//     // Show result message
//     if (mounted) {
//       if (result.status == 1) {
//         ToastService.instance.showSuccess(context, result.message.toString());
//         // Refresh the notifications
//         ref.invalidate(notificationProvider);
//       } else {
//         ToastService.instance.showError(context, result.message.toString());
//       }
//     }
//   }
// }
