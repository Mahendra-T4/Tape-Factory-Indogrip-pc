import 'package:flutter/material.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/features/client/data/model/view_staff_modeld.dart';
import 'package:indogrip/features/client/presentation/pages/profile/client_profile_builder.dart';

class ClientProfile extends StatefulWidget {
  final ClientRecord client;
  const ClientProfile({super.key, required this.client});
  static const String routeName = '/client/profile';

  @override
  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends ClientProfileBuilder {
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
              ? MobileAppBar(context, _stateKey, 'Client Profile')
              : DesktopAppBar(context, _stateKey, 'Client Profile', true),
          drawer: !Responsive.isDesktop(context) ? const SideMenuWidget() : null,
          body: Center(child: contentBuilderWidget),
        );
      }
    );
  }
}
