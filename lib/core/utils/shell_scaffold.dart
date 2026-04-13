import 'dart:async';
import 'dart:collection';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/Assets/assets.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/core/utils/widgets/outsource_side_option.dart';
import 'package:indogrip/core/utils/widgets/sidebar_panel_builder.dart';
import 'package:indogrip/core/utils/widgets/small_os_panel.dart';
import 'package:indogrip/core/utils/widgets/small_sidebar.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/carton/presentation/pages/add/add_carton.dart';
import 'package:indogrip/features/carton/presentation/pages/view/view_carton.dart';
import 'package:indogrip/features/chalan/presentation/page/chalan_panel.dart';
import 'package:indogrip/features/client/presentation/pages/add/add_client.dart';
import 'package:indogrip/features/client/presentation/pages/view/view_client.dart';
import 'package:indogrip/features/core/presentation/pages/add/add_core.dart';
import 'package:indogrip/features/core/presentation/pages/view/view_core.dart';
import 'package:indogrip/features/dashboard/presentation/page/deshboard.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/add/add_jumbo_roll.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/view/view_jumbo_roll.dart';
import 'package:indogrip/features/notifications/model/notification_model.dart';
import 'package:indogrip/features/notifications/view/provider/read_notification_provider.dart';
import 'package:indogrip/features/outsource/presentation/outside-in/pages/outsource_in.dart';
import 'package:indogrip/features/outsource/presentation/outsource-out/panels/packing%20strip/page/packing_strip_panel.dart';
import 'package:indogrip/features/outsource/presentation/outsource-out/panels/silica/page/silica_panel.dart';
import 'package:indogrip/features/outsource/presentation/outsource-out/panels/strach%20film/pages/stratch_film.dart';
import 'package:indogrip/features/outsource/presentation/outsource-out/panels/tap/page/tap_panel.dart';
import 'package:indogrip/features/round/presentation/pages/add/add_round.dart';
import 'package:indogrip/features/round/presentation/pages/view/view_round.dart';
import 'package:indogrip/features/staff/presentation/pages/add/add_statff.dart';
import 'package:indogrip/features/staff/presentation/pages/view/view_staff.dart';
import 'package:indogrip/features/vendor/presentation/pages/add/add_vendor.dart';
import 'package:indogrip/features/vendor/presentation/pages/view/view_vendor.dart';
import 'package:indogrip/features/wastage/presentation/pages/add/add_wastage.dart';
import 'package:indogrip/features/wastage/presentation/pages/view/view_wastage.dart';
import 'package:indogrip/core/utils/widgets/notification_popup.dart';
import 'package:retry/retry.dart';

class ShellScaffold extends ConsumerStatefulWidget {
  const ShellScaffold({super.key, this.child});
  final Widget? child;

  @override
  ConsumerState<ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends ConsumerState<ShellScaffold>
    with SingleTickerProviderStateMixin {
  bool isShowPanel = true;
  late AnimationController _controller;
  late Animation<double> _animation;
  NotificationModel notificationModel = NotificationModel();
  Timer? _notificationTimer;

  TooltipThemeData get _buildTooltipTheme => TooltipThemeData(
    waitDuration: Duration(milliseconds: 500),
    // showDuration: Duration(seconds: 2),
    decoration: BoxDecoration(
      color: Colors.black87,
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w400,
    ),
  );

  // Notification queue management
  Queue<Record> notificationQueue = Queue();
  bool isShowingNotification = false;
  // Track keys already queued to avoid duplicates
  final Set<String> queuedNotificationKeys = <String>{};

  Future<NotificationModel> fetchNotifications() async {
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'admin-notification',
                'userKey': HiveService.getUserId(),
                'filterBy': '1',
              }),
            ).timeout(
              const Duration(seconds: 5),
              onTimeout: () => throw TimeoutException('Request timed out'),
            ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );
      if (response.statusCode == 200) {
        notificationModel = NotificationModel.fromJson(response.data);
        developer.log(
          'Notifications fetched successfully: ${notificationModel.message}',
          name: 'Fetch Notifications',
        );

        // Add all notifications to queue
        if (notificationModel.record != null &&
            notificationModel.record!.isNotEmpty) {
          for (var notification in notificationModel.record!) {
            final key = notification.notificationKey?.toString() ?? '';
            if (key.isEmpty) continue;
            if (!queuedNotificationKeys.contains(key)) {
              notificationQueue.add(notification);
              queuedNotificationKeys.add(key);
            }
          }
          // Start showing notifications one by one
          _showNextNotification();
        }
      } else {
        developer.log(
          'Failed to fetch notifications',
          name: 'Fetch Notifications',
        );
      }
    } on DioException catch (e) {
      developer.log('DioException: $e', name: 'Fetch Notifications');
    } catch (e) {
      print(e);
    }
    return notificationModel;
  }

  Future<void> _showNextNotification() async {
    if (notificationQueue.isEmpty || isShowingNotification) return;

    isShowingNotification = true;

    // Dequeue next notification to ensure it isn't shown again
    final Record notification = notificationQueue.removeFirst();
    // Remove key from queued set
    try {
      final k = notification.notificationKey?.toString() ?? '';
      if (k.isNotEmpty) queuedNotificationKeys.remove(k);
    } catch (_) {}

    if (mounted) {
      await NotificationPopup.show(
        context,
        notification,
        onPressed: () {
          _handleNotificationAction(notification);
        },
        onClose: () {
          // When dismissed, just mark that we're not showing and show next
          isShowingNotification = false;
          Future.delayed(const Duration(milliseconds: 500), () {
            _showNextNotification();
          });
        },
      );
    }
  }

  void _handleNotificationAction(Record notification) async {
    // Mark notification as read
    await ref
        .read(
          readNotificationProvider(
            notification.notificationKey.toString(),
          ).notifier,
        )
        .markAsRead(notification.notificationKey.toString());

    // Give a small delay to update the state
    await Future.delayed(const Duration(milliseconds: 500));

    final state = ref.read(
      readNotificationProvider(notification.notificationKey.toString()),
    );
    developer.log(
      'Notification State - Status: ${state.status}, Message: ${state.message}',
      name: 'Mark Notification Debug',
    );

    if (state.status == Notification.success) {
      if (state.model?.status == 1) {
        developer.log(
          state.model!.message.toString(),
          name: 'Mark Notification as Read Success',
        );
        if (mounted) {
          ToastService.instance.showSuccess(
            context,
            state.model!.message.toString(),
          );
        }
      } else {
        developer.log(
          'Mark Notification Failed: ${state.model?.message}',
          name: 'Mark Notification as Read Failed',
        );
        if (mounted) {
          ToastService.instance.showError(
            context,
            state.model?.message ?? 'Failed to mark notification as read',
          );
        }
      }
    } else if (state.status == Notification.error) {
      developer.log(
        'Mark Notification Error: ${state.message}',
        name: 'Mark Notification as Read Error',
      );
      if (mounted) {
        ToastService.instance.showError(
          context,
          state.message ?? 'Error marking notification as read',
        );
      }
    }

    isShowingNotification = false;
    // Show next notification after a small delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _showNextNotification();
    });
  }

  bool isStaff = false;
  bool isClient = false;
  bool isVendor = false;
  bool isJumboRoll = false;
  bool isRound = false;
  bool isWastage = false;
  bool isCarton = false;
  bool isCore = false;
  bool isOutsourceOut = false;
  bool isOutsourceOut2 = false;

  @override
  void initState() {
    super.initState();
    // notificationModel
    // _selectedIndex =
    //     widget.navigateIndex ?? 2; // Default to Home if not provided
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Fetch and display notifications
    fetchNotifications();

    // Start periodic timer to fetch notifications every 2 hours
    _notificationTimer = Timer.periodic(
      const Duration(hours: 2),
      (_) => fetchNotifications(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _notificationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isShowPanel
          ? Row(
              children: [
                // if (Responsive.isDesktop(context))
                Container(
                  width: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2C3E50), Color(0xFF1A1A2E)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      // Modern logo container
                      InkWell(
                        onTap: () {
                          setState(() {
                            isShowPanel = !isShowPanel;
                          });
                        },
                        child: TooltipTheme(
                          data: _buildTooltipTheme,
                          child: Tooltip(
                            message: 'Tap to Minimize menu',
                            child: Container(
                              width: 100,
                              height: 100,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                // shape: BoxShape.circle,
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: Image.asset(
                                Assets.indoGripLogoImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: ClipRRect(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              ListTile(
                                onTap: () {
                                  context.goNamed(IndoGripDashboard.routeName);
                                },
                                leading: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.dashboard, // Transfer/Exchange icon
                                    size: 20,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                title: Text(
                                  'Dashboard',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ),

                              if (HiveService.getPanels()!.contains('7') ||
                                  HiveService.getRole() == '1' ||
                                  HiveService.getRole() == '2')
                                ListTile(
                                  onTap: () {
                                    context.goNamed(ChalanPanel.routeName);
                                  },
                                  leading: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.dashboard, // Transfer/Exchange icon
                                      size: 20,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                  title: Text(
                                    'Challan',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ),

                              if (['1', '8', '2'].any(
                                    (p) => HiveService.getPanels()!.contains(p),
                                  ) &&
                                  ['1', '2'].contains(HiveService.getRole()))
                                _buildSectionHeader('Account'),

                              if (HiveService.getPanels()!.contains('1') ||
                                  HiveService.getRole() == '1')
                                SidebarPanelBuilder(
                                  isRolePanel: HiveService.getRole() == '2'
                                      ? false
                                      : true,
                                  currentTap: isStaff,
                                  onTap: () {
                                    setState(() {
                                      isStaff = !isStaff;
                                    });
                                  },
                                  panel1: 'Add',
                                  panel2: 'View',
                                  icon: Icons.people,
                                  title: 'Staff',
                                  routeName: [
                                    AddStaff.routeName,
                                    ViewStaffPanel.routeName,
                                  ],
                                ),
                              if (HiveService.getPanels()!.contains('8') ||
                                  HiveService.getRole() == '1')
                                SidebarPanelBuilder(
                                  currentTap: isClient,
                                  isRolePanel: HiveService.getRole() == '2'
                                      ? false
                                      : true,
                                  onTap: () {
                                    setState(() {
                                      isClient = !isClient;
                                    });
                                  },
                                  panel1: 'Add',
                                  panel2: 'View',
                                  icon: Icons.people,
                                  title: 'Client',
                                  routeName: [
                                    AddClientPanel.routeName,
                                    ViewClientPanel.routeName,
                                  ],
                                ),
                              if (HiveService.getPanels()!.contains('2') ||
                                  HiveService.getRole() == '1')
                                SidebarPanelBuilder(
                                  isRolePanel: HiveService.getRole() == '2'
                                      ? false
                                      : true,
                                  currentTap: isVendor,
                                  onTap: () {
                                    setState(() {
                                      isVendor = !isVendor;
                                    });
                                  },
                                  panel1: 'Add',
                                  panel2: 'View',
                                  icon: Icons.store_outlined,
                                  title: 'Vendor',
                                  routeName: [
                                    AddVendorPanel.routeName,
                                    ViewVendorPanel.routeName,
                                  ],
                                ),
                              if (['3', '4'].any(
                                    (p) => HiveService.getPanels()!.contains(p),
                                  ) &&
                                  ['1', '2'].contains(HiveService.getRole()))
                                // if (HiveService.getPanels()!.contains('3') &&
                                //     HiveService.getPanels()!.contains('4'))
                                _buildSectionHeader('Operations'),
                              if (HiveService.getPanels()!.contains('3') ||
                                  HiveService.getRole() == '1')
                                SidebarPanelBuilder(
                                  isRolePanel: HiveService.getRole() == '2'
                                      ? false
                                      : true,
                                  currentTap: isJumboRoll,
                                  onTap: () {
                                    setState(() {
                                      isJumboRoll = !isJumboRoll;
                                    });
                                  },
                                  panel1: 'Add',
                                  panel2: 'View',
                                  icon: Icons.rotate_90_degrees_ccw_outlined,
                                  title: 'Jumbo Roll',
                                  routeName: [
                                    AddJumboRollPanel.routeName,
                                    ViewJumboRollPanel.routeName,
                                  ],
                                ),
                              if (HiveService.getPanels()!.contains('4') ||
                                  HiveService.getRole() == '1')
                                SidebarPanelBuilder(
                                  isRolePanel: HiveService.getRole() == '2'
                                      ? false
                                      : true,
                                  currentTap: isRound,
                                  onTap: () {
                                    setState(() {
                                      isRound = !isRound;
                                    });
                                  },
                                  panel1: 'Add',
                                  panel2: 'View',
                                  icon: Icons.circle_outlined,
                                  title: 'Round',
                                  routeName: [
                                    AddRoundPanel.routeName,
                                    ViewRoundPanel.routeName,
                                  ],
                                ),
                              if (['5'].any(
                                    (p) => HiveService.getPanels()!.contains(p),
                                  ) &&
                                  ['1', '2'].contains(HiveService.getRole()))
                                // if (HiveService.getPanels()!.contains('5'))
                                _buildSectionHeader('Stock'),
                              if (HiveService.getPanels()!.contains('5') ||
                                  HiveService.getRole() == '1')
                                ListTile(
                                  onTap: () {
                                    context.goNamed(OutSourceIN.routeName);
                                  },
                                  leading: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons
                                          .swap_horiz_outlined, // Transfer/Exchange icon
                                      size: 20,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                  title: Text(
                                    'Inventory - IN',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ),
                              // _buildSectionHeader('Outsource-OUT'),
                              if (HiveService.getPanels()!.contains('5') ||
                                  HiveService.getRole() == '1')
                                OutSourceSidePanelBuilder(
                                  currentTap: isOutsourceOut,
                                  title: 'Inventory',
                                  onTap: () {
                                    setState(() {
                                      isOutsourceOut = !isOutsourceOut;
                                    });
                                  },
                                  panel1: 'Tape',
                                  panel2: 'Stretch Film',
                                  // panel3: 'Silica',
                                  // panel4: 'Packing Strip',
                                  icon: Icons.circle_outlined,
                                  routeName: [
                                    TapPanel.routeName,
                                    StretchFilmPanel.routeName,
                                    // SilicaPanel.routeName,
                                    // PackingStripPanel.routeName,
                                  ],
                                ),
                              if (HiveService.getPanels()!.contains('6') ||
                                  HiveService.getRole() == '1') ...[
                                _buildSectionHeader('General'),

                                SidebarPanelBuilder(
                                  isRolePanel: HiveService.getRole() == '2'
                                      ? false
                                      : true,
                                  currentTap: isWastage,
                                  onTap: () {
                                    setState(() {
                                      isWastage = !isWastage;
                                    });
                                  },
                                  panel1: 'Add',
                                  panel2: 'View',
                                  icon: Icons.delete_outline,
                                  title: 'Wastage Peace',
                                  routeName: [
                                    AddWastagePanel.routeName,
                                    ViewWastagePanel.routeName,
                                  ],
                                ),
                              ],

                              // _buildExpandableMenuItem(
                              //   'Estimation',
                              //   Icons.calculate_outlined, // Calculator/Estimation icon
                              //   [AddEstimation(), ViewstaffPage()],
                              //   ['ADD', 'VIEW'],
                              // ),
                              // _buildExpandableMenuItem(
                              //   'Loss Meters',
                              //   Icons.trending_down_outlined, // Downward trend/Loss icon
                              //   [AddLossMeterPanel(), ViewLossMeterPanel()],
                              //   ['ADD', 'VIEW'],
                              // ),
                              if (['9', '10'].any(
                                    (p) => HiveService.getPanels()!.contains(p),
                                  ) &&
                                  ['1', '2'].contains(HiveService.getRole()))
                                _buildSectionHeader('Stock Maintenance'),
                              if (HiveService.getPanels()!.contains('9') ||
                                  HiveService.getRole() == '1')
                                SidebarPanelBuilder(
                                  isRolePanel: HiveService.getRole() == '2'
                                      ? false
                                      : true,
                                  currentTap: isCarton,
                                  onTap: () {
                                    setState(() {
                                      isCarton = !isCarton;
                                    });
                                  },
                                  panel1: 'Add',
                                  panel2: 'View',
                                  icon: Icons.inventory_2_outlined,
                                  title: 'Carton',
                                  routeName: [
                                    AddCartonPanel.routeName,
                                    ViewCartonPanel.routeName,
                                  ],
                                ),

                              if (HiveService.getPanels()!.contains('10') ||
                                  HiveService.getRole() == '1')
                                SidebarPanelBuilder(
                                  isRolePanel: HiveService.getRole() == '2'
                                      ? false
                                      : true,
                                  currentTap: isCore,
                                  onTap: () {
                                    setState(() {
                                      isCore = !isCore;
                                    });
                                  },
                                  panel1: 'Add',
                                  panel2: 'View',
                                  icon: Icons.category_outlined,
                                  title: 'Core',
                                  routeName: [
                                    AddCorePanel.routeName,
                                    ViewCorePanel.routeName,
                                  ],
                                ),

                              // _buildSectionHeader('Miss Record'),
                              // OutSourceSidePanelBuilder2(
                              //   currentTap: isOutsourceOut2,
                              //   title: 'Miss Record Panel',
                              //   onTap: () {
                              //     setState(() {
                              //       isOutsourceOut2 = !isOutsourceOut2;
                              //     });
                              //   },
                              //   panel1: 'Client',
                              //   panel2: 'Vendor',
                              //   panel3: 'Jumbo Roll',
                              //   panel4: 'Round',
                              //   panel5: 'Tape',
                              //   panel6: 'Stretch Film',
                              //   icon: Icons.circle_outlined,
                              //   routeName: [
                              //     ClientMissRecordPanel.routeName,
                              //     VendorMissRecordPanel.routeName,
                              //     JumboRollMissRecordPanel.routeName,
                              //     RoundMissRecordPanel.routeName,
                              //     TapeMissRecordPanel.routeName,
                              //     StretchFilmMissRecordPanel.routeName,
                              //   ],
                              // ),

                              // _buildSectionHeader('Logout'),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: widget.child,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                // if (Responsive.isDesktop(context))
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2C3E50), Color(0xFF1A1A2E)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      // Modern logo container
                      InkWell(
                        onTap: () {
                          setState(() {
                            isShowPanel = !isShowPanel;
                          });
                        },
                        child: TooltipTheme(
                          data: _buildTooltipTheme,
                          child: Tooltip(
                            message: 'Tap to Maximize menu',

                            child: Container(
                              width: 50,
                              height: 50,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                // shape: BoxShape.circle,
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Image.asset(
                                Assets.indoGripLogoImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: ClipRRect(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              TooltipTheme(
                                data: _buildTooltipTheme,
                                child: Tooltip(
                                  message: 'Dashboard',
                                  child: ListTile(
                                    onTap: () {
                                      context.goNamed(
                                        IndoGripDashboard.routeName,
                                      );
                                    },
                                    leading: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons
                                            .dashboard, // Transfer/Exchange icon
                                        size: 20,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                    // title: Text(
                                    //   'Dashboard',
                                    //   style: TextStyle(
                                    //     fontSize: 14,
                                    //     fontWeight: FontWeight.w500,
                                    //     color: Colors.white.withOpacity(0.9),
                                    //   ),
                                    // ),
                                  ),
                                ),
                              ),

                              if (HiveService.getPanels()!.contains('7') ||
                                  HiveService.getRole() == '1' ||
                                  HiveService.getRole() == '2')
                                TooltipTheme(
                                  data: _buildTooltipTheme,
                                  child: Tooltip(
                                    message: 'Challan',
                                    child: ListTile(
                                      onTap: () {
                                        context.goNamed(ChalanPanel.routeName);
                                      },
                                      leading: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.note, // Transfer/Exchange icon
                                          size: 20,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                      // title: Text(
                                      //   'Challan',
                                      //   style: TextStyle(
                                      //     fontSize: 14,
                                      //     fontWeight: FontWeight.w500,
                                      //     color: Colors.white.withOpacity(0.9),
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                ),

                              // if (['1', '8', '2'].any(
                              //       (p) => HiveService.getPanels()!.contains(p),
                              //     ) &&
                              //     ['1', '2'].contains(HiveService.getRole()))
                              //   _buildSectionHeader('Account'),
                              if (HiveService.getPanels()!.contains('1') ||
                                  HiveService.getRole() == '1')
                                SmallSidebarPanelBuilder(
                                  isRolePanel: HiveService.getRole() == '2'
                                      ? false
                                      : true,
                                  currentTap: isStaff,
                                  onTap: () {
                                    setState(() {
                                      isStaff = !isStaff;
                                    });
                                  },
                                  panel1: 'Add Staff',
                                  panel2: 'View Staff',
                                  icon: Icons.people,
                                  title: 'Staff',
                                  routeName: [
                                    AddStaff.routeName,
                                    ViewStaffPanel.routeName,
                                  ],
                                ),
                              if (HiveService.getPanels()!.contains('8') ||
                                  HiveService.getRole() == '1')
                                SmallSidebarPanelBuilder(
                                  currentTap: isClient,
                                  isRolePanel: HiveService.getRole() == '2'
                                      ? false
                                      : true,
                                  onTap: () {
                                    setState(() {
                                      isClient = !isClient;
                                    });
                                  },
                                  panel1: 'Add Client',
                                  panel2: 'View Client',
                                  icon: Icons.people,
                                  title: 'Client',
                                  routeName: [
                                    AddClientPanel.routeName,
                                    ViewClientPanel.routeName,
                                  ],
                                ),
                              if (HiveService.getPanels()!.contains('2') ||
                                  HiveService.getRole() == '1')
                                SmallSidebarPanelBuilder(
                                  isRolePanel: HiveService.getRole() == '2'
                                      ? false
                                      : true,
                                  currentTap: isVendor,
                                  onTap: () {
                                    setState(() {
                                      isVendor = !isVendor;
                                    });
                                  },
                                  panel1: 'Add Vendor',
                                  panel2: 'View Vendor',
                                  icon: Icons.store_outlined,
                                  title: 'Vendor',
                                  routeName: [
                                    AddVendorPanel.routeName,
                                    ViewVendorPanel.routeName,
                                  ],
                                ),
                              // if (['3', '4'].any(
                              //       (p) => HiveService.getPanels()!.contains(p),
                              //     ) &&
                              //     ['1', '2'].contains(HiveService.getRole()))
                              // if (HiveService.getPanels()!.contains('3') &&
                              //     HiveService.getPanels()!.contains('4'))
                              // _buildSectionHeader('Operations'),
                              if (HiveService.getPanels()!.contains('3') ||
                                  HiveService.getRole() == '1')
                                SmallSidebarPanelBuilder(
                                  isRolePanel: HiveService.getRole() == '2'
                                      ? false
                                      : true,
                                  currentTap: isJumboRoll,
                                  onTap: () {
                                    setState(() {
                                      isJumboRoll = !isJumboRoll;
                                    });
                                  },
                                  panel1: 'Add Jumbo',
                                  panel2: 'View Jumbo',
                                  icon: Icons.rotate_90_degrees_ccw_outlined,
                                  title: 'Jumbo Roll',
                                  routeName: [
                                    AddJumboRollPanel.routeName,
                                    ViewJumboRollPanel.routeName,
                                  ],
                                ),
                              if (HiveService.getPanels()!.contains('4') ||
                                  HiveService.getRole() == '1')
                                SmallSidebarPanelBuilder(
                                  isRolePanel: HiveService.getRole() == '2'
                                      ? false
                                      : true,
                                  currentTap: isRound,
                                  onTap: () {
                                    setState(() {
                                      isRound = !isRound;
                                    });
                                  },
                                  panel1: 'Add Round',
                                  panel2: 'View Round',
                                  icon: Icons.circle_outlined,
                                  title: 'Round',
                                  routeName: [
                                    AddRoundPanel.routeName,
                                    ViewRoundPanel.routeName,
                                  ],
                                ),
                              // if (['5'].any(
                              //       (p) => HiveService.getPanels()!.contains(p),
                              //     ) &&
                              //     ['1', '2'].contains(HiveService.getRole()))
                              //   // if (HiveService.getPanels()!.contains('5'))
                              //   _buildSectionHeader('Stock'),
                              if (HiveService.getPanels()!.contains('5') ||
                                  HiveService.getRole() == '1')
                                TooltipTheme(
                                  data: _buildTooltipTheme,
                                  child: Tooltip(
                                    message: 'Inventory - IN',
                                    child: ListTile(
                                      onTap: () {
                                        context.goNamed(OutSourceIN.routeName);
                                      },
                                      leading: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons
                                              .swap_horiz_outlined, // Transfer/Exchange icon
                                          size: 20,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                      // title: Text(
                                      //   'Inventory - IN',
                                      //   style: TextStyle(
                                      //     fontSize: 14,
                                      //     fontWeight: FontWeight.w500,
                                      //     color: Colors.white.withOpacity(0.9),
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                ),
                              // _buildSectionHeader('Outsource-OUT'),
                              if (HiveService.getPanels()!.contains('5') ||
                                  HiveService.getRole() == '1')
                                SmallOutSourceSidePanelBuilder(
                                  currentTap: isOutsourceOut,
                                  title: 'Inventory',
                                  onTap: () {
                                    setState(() {
                                      isOutsourceOut = !isOutsourceOut;
                                    });
                                  },
                                  panel1: 'Tape',
                                  panel2: 'Stretch Film',
                                  // panel3: 'Silica',
                                  // panel4: 'Packing Strip',
                                  icon: Icons.circle_outlined,
                                  routeName: [
                                    TapPanel.routeName,
                                    StretchFilmPanel.routeName,
                                    // SilicaPanel.routeName,
                                    // PackingStripPanel.routeName,
                                  ],
                                ),

                              // if (HiveService.getPanels()!.contains('6') ||
                              //     HiveService.getRole() == '1') ...[
                              //   _buildSectionHeader('General'),
                              SmallSidebarPanelBuilder(
                                isRolePanel: HiveService.getRole() == '2'
                                    ? false
                                    : true,
                                currentTap: isWastage,
                                onTap: () {
                                  setState(() {
                                    isWastage = !isWastage;
                                  });
                                },
                                panel1: 'Add Wastage',
                                panel2: 'View Wastage',
                                icon: Icons.delete_outline,
                                title: 'Wastage Peace',
                                routeName: [
                                  AddWastagePanel.routeName,
                                  ViewWastagePanel.routeName,
                                ],
                              ),
                              // ],

                              // _buildExpandableMenuItem(
                              //   'Estimation',
                              //   Icons.calculate_outlined, // Calculator/Estimation icon
                              //   [AddEstimation(), ViewstaffPage()],
                              //   ['ADD', 'VIEW'],
                              // ),
                              // _buildExpandableMenuItem(
                              //   'Loss Meters',
                              //   Icons.trending_down_outlined, // Downward trend/Loss icon
                              //   [AddLossMeterPanel(), ViewLossMeterPanel()],
                              //   ['ADD', 'VIEW'],
                              // ),
                              // if (['9', '10'].any(
                              //       (p) => HiveService.getPanels()!.contains(p),
                              //     ) &&
                              //     ['1', '2'].contains(HiveService.getRole()))
                              //   _buildSectionHeader('Stock Maintenance'),
                              if (HiveService.getPanels()!.contains('9') ||
                                  HiveService.getRole() == '1')
                                SmallSidebarPanelBuilder(
                                  isRolePanel: HiveService.getRole() == '2'
                                      ? false
                                      : true,
                                  currentTap: isCarton,
                                  onTap: () {
                                    setState(() {
                                      isCarton = !isCarton;
                                    });
                                  },
                                  panel1: 'Add Carton',
                                  panel2: 'View Carton',
                                  icon: Icons.inventory_2_outlined,
                                  title: 'Carton',
                                  routeName: [
                                    AddCartonPanel.routeName,
                                    ViewCartonPanel.routeName,
                                  ],
                                ),

                              if (HiveService.getPanels()!.contains('10') ||
                                  HiveService.getRole() == '1')
                                SmallSidebarPanelBuilder(
                                  isRolePanel: HiveService.getRole() == '2'
                                      ? false
                                      : true,
                                  currentTap: isCore,
                                  onTap: () {
                                    setState(() {
                                      isCore = !isCore;
                                    });
                                  },
                                  panel1: 'Add Core',
                                  panel2: 'View Core',
                                  icon: Icons.category_outlined,
                                  title: 'Core',
                                  routeName: [
                                    AddCorePanel.routeName,
                                    ViewCorePanel.routeName,
                                  ],
                                ),

                              // _buildSectionHeader('Miss Record'),
                              // OutSourceSidePanelBuilder2(
                              //   currentTap: isOutsourceOut2,
                              //   title: 'Miss Record Panel',
                              //   onTap: () {
                              //     setState(() {
                              //       isOutsourceOut2 = !isOutsourceOut2;
                              //     });
                              //   },
                              //   panel1: 'Client',
                              //   panel2: 'Vendor',
                              //   panel3: 'Jumbo Roll',
                              //   panel4: 'Round',
                              //   panel5: 'Tape',
                              //   panel6: 'Stretch Film',
                              //   icon: Icons.circle_outlined,
                              //   routeName: [
                              //     ClientMissRecordPanel.routeName,
                              //     VendorMissRecordPanel.routeName,
                              //     JumboRollMissRecordPanel.routeName,
                              //     RoundMissRecordPanel.routeName,
                              //     TapeMissRecordPanel.routeName,
                              //     StretchFilmMissRecordPanel.routeName,
                              //   ],
                              // ),

                              // _buildSectionHeader('Logout'),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: widget.child,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.grey[400],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildExpandableMenuItem(
    String title,
    IconData icon,
    final bool selected,
    final VoidCallback onTap,
    List<Widget> screens,
    List<String> screenNames,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.white.withOpacity(0.9)),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        trailing: Icon(
          Icons.expand_more_rounded,
          size: 18,
          color: Colors.white.withOpacity(0.5),
        ),
        children: List.generate(
          screenNames.length,
          (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white.withOpacity(0.05),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 24),
              title: Text(
                screenNames[index],
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              leading: Icon(
                title.toLowerCase().contains('Account')
                    ? (index == 0
                          ? Icons.post_add_rounded
                          : Icons.fact_check_rounded)
                    : title.toLowerCase().contains('Stock Maintenance')
                    ? (index == 0
                          ? Icons.add_chart_rounded
                          : Icons.analytics_rounded)
                    : title.toLowerCase().contains('')
                    ? (index == 0
                          ? Icons.electric_bolt_rounded
                          : Icons.electrical_services_rounded)
                    : (index == 0
                          ? Icons.add_rounded
                          : Icons.visibility_rounded),
                size: 18,
                color: Colors.white.withOpacity(0.7),
              ),
              onTap: onTap,
              hoverColor: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableMenuItemSingleWidget(
    String title,
    IconData icon,
    final bool selected,
    final VoidCallback onTap,
    Widget screens,
    String screenNames,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.white.withOpacity(0.9)),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        trailing: Icon(
          Icons.expand_more_rounded,
          size: 18,
          color: Colors.white.withOpacity(0.5),
        ),
        children: List.generate(
          screenNames.length,
          (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white.withOpacity(0.05),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 24),
              title: Text(
                screenNames[index],
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              leading: Icon(
                title.toLowerCase().contains('stamp')
                    ? (index == 0
                          ? Icons.post_add_rounded
                          : Icons.fact_check_rounded)
                    : title.toLowerCase().contains('income')
                    ? (index == 0
                          ? Icons.add_chart_rounded
                          : Icons.analytics_rounded)
                    : title.toLowerCase().contains('electricity')
                    ? (index == 0
                          ? Icons.electric_bolt_rounded
                          : Icons.electrical_services_rounded)
                    : (index == 0
                          ? Icons.add_rounded
                          : Icons.visibility_rounded),
                size: 18,
                color: Colors.white.withOpacity(0.7),
              ),
              onTap: onTap,
              hoverColor: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
      ),
    );
  }
}
