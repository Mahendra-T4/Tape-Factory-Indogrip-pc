import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';

import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/features/staff/presentation/pages/add/add_staff_builder.dart';

class AddStaff extends ConsumerStatefulWidget {
  const AddStaff({super.key});
  static const String routeName = '/addStaff';

  @override
  ConsumerState<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends AddStaffBuilder {
  final GlobalKey<ScaffoldState> _statekey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
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
          key: _statekey,
          appBar: !Responsive.isDesktop(context)
              ? MobileAppBar(context, _statekey, 'Add Staff')
              : null,
          drawer: !Responsive.isDesktop(context) ? SideMenuWidget() : null,
          body: SafeArea(
            child: Responsive.isDesktop(context) ? _desktopView() : _tabletView(),
          ),
        );
      }
    );
  }

  Widget _desktopView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SideMenuWidget(),
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DesktopAppBar(context, _statekey, 'Add Staff', false),
                  generalRowDesktop(),
                  personalDetailsRowDesktop(),

                  permissionAndRightsSectionDesktop(),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tabletView() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            generalRowTablet(),
            personalDetailsRowTablet(),
            permissionAndRightsSectionTablet(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
