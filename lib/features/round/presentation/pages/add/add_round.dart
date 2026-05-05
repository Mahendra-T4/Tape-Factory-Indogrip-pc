import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/indents/enter_key_indent.dart';

import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/features/round/presentation/pages/add/add_round_builder.dart';

class AddRoundPanel extends StatefulWidget {
  const AddRoundPanel({super.key});
  static const String routeName = '/addRound';

  @override
  State<AddRoundPanel> createState() => _AddRoundPanelState();
}

class JumboRoll {
  final String id;
  final String name;

  JumboRoll({required this.id, required this.name});
}

class _AddRoundPanelState extends AddRoundBuilder {
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
              ? MobileAppBar(context, stateKey, 'Add Round')
              : null,
          drawer: !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : null,
          body: Responsive.isDesktop(context)
              ? _roundDesktopView
              : _roundTabletView,
        );
      },
    );
  }

  Widget get _roundDesktopView => Row(
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
                SubmenuButton: CallbackAction(
                  onInvoke: (intent) => formSubmit(),
                ),
              },
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DesktopAppBar(context, stateKey, 'Add Round', false),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     SizedBox(
                    //       width: MediaQuery.sizeOf(context).width * .18,
                    //       child: DownloadClientFileButton(
                    //         defaultFileName: 'import-round-sample.csv',
                    //         csvURL: CSVUrls.roundCSVFilePath,
                    //       ),
                    //     ),
                    //     SizedBox(width: 20),
                    //     // SizedBox(
                    //     //   width: MediaQuery.sizeOf(context).width * .18,
                    //     //   child: UploadRoundFileButton(),
                    //     // ),
                    //   ],
                    // ),
                    buildScannedBarcodeAddField,
                    roundInfoDesktop,
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );

  Widget get _roundTabletView => Shortcuts(
    shortcuts: <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.enter): const SubmitIntent(),
      LogicalKeySet(LogicalKeyboardKey.numpadEnter): const SubmitIntent(),
    },
    child: Actions(
      actions: <Type, Action<Intent>>{
        SubmenuButton: CallbackAction(onInvoke: (intent) => formSubmit()),
      },
      child: Form(
        key: formKey,
        child: SingleChildScrollView(child: roundTabletView),
      ),
    ),
  );
}
