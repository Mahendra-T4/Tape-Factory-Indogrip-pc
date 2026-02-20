import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/indents/enter_key_indent.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/utils/widgets/heading_text.dart';
import 'package:indogrip/features/wastage/presentation/pages/add/add_wastage_builder.dart';

class AddWastagePanel extends StatefulWidget {
  const AddWastagePanel({super.key});
  static const String routeName = '/addWastage';

  @override
  State<AddWastagePanel> createState() => _AddWastagePanelState();
}

class _AddWastagePanelState extends AddWastageBuilder {
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
              ? MobileAppBar(context, stateKey, 'Add Jumbo Roll')
              : null,
          drawer: !Responsive.isDesktop(context) ? const SideMenuWidget() : null,
        
          body: Responsive.isDesktop(context)
              ? _buildWastageDesktop
              : _buildWastageTablet,
        );
      }
    );
  }

  Widget get _buildWastageDesktop => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // const SideMenuWidget(),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DesktopAppBar(context, stateKey, 'Add Wastage', false),
                    SizedBox(height: 20),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [buildSectionTitle('Wastage Information')],
                    // ),
                    // SizedBox(height: 10),
                    wastageHeaderDesktop,
                    submitButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );

  Widget get _buildWastageTablet => Shortcuts(
    shortcuts: <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.enter): const SubmitIntent(),
      LogicalKeySet(LogicalKeyboardKey.numpadEnter): const SubmitIntent(),
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
            wastageHeaderTablet,
            SizedBox(height: 30),
            submitButton,
          ],
        ),
      ),
    ),
  );
}
