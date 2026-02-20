import 'package:flutter/material.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/features/round/data/models/view_round_modeld.dart';
import 'package:indogrip/features/round/presentation/pages/profile/round_profile_builder.dart';

class RoundProfile extends StatefulWidget {
  final RoundRecord round;
  const RoundProfile({super.key, required this.round});
  static const String routeName = '/round/profile';

  @override
  State<RoundProfile> createState() => _RoundProfileState();
}

class _RoundProfileState extends RoundProfileBuilder {
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
              ? MobileAppBar(context, _stateKey, 'Round Profile')
              : DesktopAppBar(context, _stateKey, 'Round Profile', true),
          drawer: !Responsive.isDesktop(context) ? const SideMenuWidget() : null,
          body: Responsive.isDesktop(context)
              ? contentBuilderWidget
              : contentBuilderTabletWidget,
        );
      }
    );
  }
}
