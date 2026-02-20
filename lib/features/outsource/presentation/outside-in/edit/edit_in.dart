import 'package:flutter/material.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/utils/widgets/heading_text.dart';
import 'package:indogrip/features/outsource/data/model/view_tap_in_model.dart';
import 'package:indogrip/features/outsource/presentation/outside-in/edit/edit_in_builder.dart';

class EditOutSourceIN extends StatefulWidget {
  final TapRecord record;
  const EditOutSourceIN({super.key, required this.record});
  static const String routeName = '/outsource/in/edit';

  @override
  State<EditOutSourceIN> createState() => _OutSourceINState();
}

class _OutSourceINState extends EditOutsourceInBuilder {
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
          key: stateKey,
          appBar: !Responsive.isDesktop(context)
              ? MobileAppBar(context, stateKey, 'Edit Inventory-IN')
              : DesktopAppBar(context, stateKey, 'Edit Inventory-IN', false),
          drawer: !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : null,

          body: _buildOutsourceDesktop,
        );
      },
    );
  }

  Widget get _buildOutsourceDesktop => Row(
    children: [
      // const SideMenuWidget(),
      Expanded(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // DesktopAppBar(context, stateKey, 'Add Outsource In', false),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      headerButton,
                      buildProductHeaderDesktop,

                      buildSectionTitle('Bill Information'),
                      buildBillingSectionDesktop,
                      buildMainProductSectionDesktop,
                      // buildRemarkDesktop,
                      submitButton,
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );

 
}
