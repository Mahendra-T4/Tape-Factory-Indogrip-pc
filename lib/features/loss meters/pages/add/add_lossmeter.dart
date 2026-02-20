import 'package:flutter/material.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/features/loss%20meters/pages/add/add_loss_meter.dart';

class AddLossMeterPanel extends StatefulWidget {
  const AddLossMeterPanel({super.key});

  @override
  State<AddLossMeterPanel> createState() => _AddLossMeterPanelState();
}

class _AddLossMeterPanelState extends AddLossMeterBuilder {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: stateKey,
      appBar:
          !Responsive.isDesktop(context)
              ? MobileAppBar(context, stateKey, 'Add LossMeter')
              : null,
      drawer:
          !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : const SizedBox(),

      body: Responsive.isDesktop(context) ? desktopView : tabletView,
    );
  }

  Widget get desktopView => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SideMenuWidget(),
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DesktopAppBar(context, stateKey, 'Add LossMeter',false),
              SizedBox(height: 30),
              buildLossMeterSectionDesktop,
              SizedBox(height: 30),
              submitButton,

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    ],
  );

  Widget get tabletView => Column(
    children: [
      SizedBox(height: 30),
      buildLossMeterSectionTablet,
      SizedBox(height: 30),
      submitButton,

      SizedBox(height: 30),
    ],
  );
}
