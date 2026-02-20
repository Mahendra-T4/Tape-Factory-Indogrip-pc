import 'package:flutter/material.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/features/wastage/data/model/view_wastage_model.dart';
import 'package:indogrip/features/wastage/presentation/pages/profile/wastage_profile_builder.dart';

class WastageProfile extends StatefulWidget {
  final WastageRecord wastage;
  const WastageProfile({super.key, required this.wastage});
  static const String routeName = '/wastage/profile';

  @override
  State<WastageProfile> createState() => _WastageProfileState();
}

class _WastageProfileState extends WastageProfileBuilder {
  final GlobalKey<ScaffoldState> _stateKey = GlobalKey<ScaffoldState>();
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
          key: _stateKey,
          appBar: !Responsive.isDesktop(context)
              ? MobileAppBar(context, _stateKey, 'Wastage Profile')
              : DesktopAppBar(context, _stateKey, 'Wastage Profile', true),
          drawer: !Responsive.isDesktop(context) ? const SideMenuWidget() : null,
          body: Responsive.isDesktop(context)
              ? contentBuilderWidget
              : contentBuilderDesktopWidget,
        );
      }
    );
  }
}
