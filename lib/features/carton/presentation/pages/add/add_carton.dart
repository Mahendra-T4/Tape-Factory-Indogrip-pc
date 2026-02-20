import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/indents/enter_key_indent.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/features/carton/presentation/pages/add/add_caton_builder.dart';

class AddCartonPanel extends StatefulWidget {
  const AddCartonPanel({super.key});
  static const String routeName = '/addCarton';

  @override
  State<AddCartonPanel> createState() => _AddCartonPanelState();
}

class _AddCartonPanelState extends AddCartonBuilder {
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
          key: statekey,
          appBar: !Responsive.isDesktop(context)
              ? MobileAppBar(context, statekey, 'Add Client')
              : null,
          drawer: !Responsive.isDesktop(context) ? SideMenuWidget() : null,
          body: Responsive.isDesktop(context)
              ? buildCartonDesktopView
              : buildCartonTabletView,
        );
      },
    );
  }

  Widget get buildCartonDesktopView => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      DesktopAppBar(context, statekey, 'Add Carton', false),
      Expanded(
        child: SingleChildScrollView(
          child: Shortcuts(
            shortcuts: <LogicalKeySet, Intent>{
              LogicalKeySet(LogicalKeyboardKey.enter): const SubmitIntent(),
              LogicalKeySet(LogicalKeyboardKey.numpadEnter):
                  const SubmitIntent(),
            },
            child: Actions(
              actions: <Type, Action<Intent>>{
                SubmitIntent: CallbackAction<SubmitIntent>(
                  onInvoke: (intent) => formSubmit(),
                ),
              },
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    // vendorWidgetTile,
                    buildCartonInfoSectionDesktop,
                    SizedBox(height: 30),
                    buildSubmitBtn(),

                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );

  Widget get buildCartonTabletView => Shortcuts(
    shortcuts: <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.enter): const SubmitIntent(),
      LogicalKeySet(LogicalKeyboardKey.numpadEnter): const SubmitIntent(),
    },
    child: Actions(
      actions: <Type, Action<Intent>>{
        SubmitIntent: CallbackAction(onInvoke: (intent) => formSubmit()),
      },
      child: Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(height: 30),
            buildCartonInfoSectionTablet,
            SizedBox(height: 30),
            buildSubmitBtn(),

            SizedBox(height: 30),
          ],
        ),
      ),
    ),
  );
}
