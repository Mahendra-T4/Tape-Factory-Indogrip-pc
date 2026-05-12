import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/features/dashboard/presentation/page/dashboard_builder.dart';
import 'package:indogrip/features/dashboard/presentation/widget/default_setting_widget.dart';
import 'package:indogrip/features/dashboard/presentation/widget/profit_loss_analytics.dart';
import 'package:indogrip/features/dashboard/presentation/widget/stretch_stock_widget.dart';
import 'package:indogrip/features/dashboard/presentation/widget/tape_stock_widget.dart';

class IndoGripDashboard extends StatefulWidget {
  const IndoGripDashboard({super.key});
  static const String routeName = '/indo-grip-dashboard';

  @override
  State<IndoGripDashboard> createState() => _IndoGripDashboardState();
}

class _IndoGripDashboardState extends DashboardBuilder {
  final GlobalKey<ScaffoldState> _stateKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    log('User Key: ${HiveService.getUserId()}');
    log('User Panels: ${HiveService.getPanels()}');
    log('User Role: ${HiveService.getRole()}');
  }

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
        return Column(
          children: [
            // AppBar is handled by ShellScaffold on desktop, mobile appbar for smaller screens
            if (!Responsive.isDesktop(context))
              MobileAppBar(context, _stateKey, 'Dashboard'),
            if (Responsive.isDesktop(context))
              DesktopAppBar(context, _stateKey, 'Dashboard', false),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildWelcomeHeader,
                    ProfitandLossAnalyticsWidget(
                      fromDateController: fromDateController,
                      toDateController: toDateController,
                      // onFromChanged: (value) {},
                      // onToChanged: (value) {},
                    ),
                    // productWidget,
                    // SalesDashboard(),
                    TapeStockWidget(),
                    SizedBox(height: 16),
                    StretchStockWidget(),
                    SizedBox(height: 16),
                    buildPredictCalculationFormWidget,
                    SizedBox(height: 16),
                    buildPredictCalculation2FormWidget,
                    desktopWidgetWrapper,
                    DefaultSettingWidget(),
                    const SizedBox(height: 200),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget get _buildWelcomeHeader {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      constraints: BoxConstraints(minHeight: 160),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A3A52), Color(0xFF2980B9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 1.0],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF3498DB).withOpacity(0.25),
            spreadRadius: 2,
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 2,
                ),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 2,
                ),
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 120),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, Admin!',
                        style: TextStyle(
                          fontSize: Responsive.isDesktop(context) ? 36 : 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Here\'s what\'s happening with your inventory today.',
                        style: TextStyle(
                          fontSize: Responsive.isDesktop(context) ? 16 : 14,
                          color: Colors.white.withOpacity(0.92),
                          letterSpacing: 0.3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule,
                              color: Colors.white.withOpacity(0.9),
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Last updated: ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 24),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/indogrip-logo.png',
                    height: 90,
                    width: 90,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
