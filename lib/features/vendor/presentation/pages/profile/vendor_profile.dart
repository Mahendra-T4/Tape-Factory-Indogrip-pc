import 'package:flutter/material.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/features/vendor/data/models/view_vendor_model.dart';
import 'package:indogrip/features/vendor/presentation/pages/profile/vendor_profile_builder.dart';

class VendorProfile extends StatefulWidget {
  final VendorRecord vendor;
  const VendorProfile({super.key, required this.vendor});
  static const String routeName = '/vendor/profile';

  @override
  State<VendorProfile> createState() => _VendorProfileState();
}

class _VendorProfileState extends VendorProfileBuilder {
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
              ? MobileAppBar(context, _stateKey, 'Vendor Profile')
              : DesktopAppBar(context, _stateKey, 'Vendor Profile', true),
          drawer: !Responsive.isDesktop(context) ? const SideMenuWidget() : null,
          body: Center(child: contentBuilderWidget),
        );
      }
    );
  }
}
