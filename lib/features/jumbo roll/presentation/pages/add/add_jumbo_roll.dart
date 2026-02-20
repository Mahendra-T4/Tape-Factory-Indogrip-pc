import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/api%20service/csv_urls.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/features/client/presentation/widgets/download_csv_button_client.dart';
import 'package:indogrip/features/global/presentation/widget/uploadFile_button.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/add/add_jumbo_roll_builder.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/widgets/upload_jumbo_file_button.dart';
import 'package:indogrip/features/staff/presentation/pages/edit/edit_add_staff_page.dart';

class AddJumboRollPanel extends StatefulWidget {
  const AddJumboRollPanel({super.key});
  static const String routeName = '/addJumboRoll';

  @override
  State<AddJumboRollPanel> createState() => _AddJumboRollPanelState();
}

class _AddJumboRollPanelState extends AddJumboRollBuilder {
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
              ? MobileAppBar(context, _stateKey, 'Add Jumbo Roll')
              : null,
          drawer: !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : null,

          body: Responsive.isDesktop(context)
              ? _jumboDesktopView
              : _jumboTabletView,
        );
      },
    );
  }

  Widget get _jumboDesktopView => Row(
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DesktopAppBar(context, _stateKey, 'Add Jumbo Roll', false),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * .18,
                          child: DownloadClientFileButton(
                            defaultFileName: 'import-jumbo-sample.csv',
                            csvURL: CSVUrls.jumboCSVFilePath,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * .18,
                          child: const UploadJumboFileButton(),
                        ),
                      ],
                    ),
                    vendorWidgetTile,
                    buildBasicDetailsDesktop(),
                    buildSpecificationsDesktop,
                    const SizedBox(height: 25),
                    buildMeasurementsDesktop,
                    const SizedBox(height: 25),
                    buidlRemarkDesktop,
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: kDefaultVerticalPadding,
                        horizontal: kDefaultHorizontalPadding,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(child: SizedBox()),
                          Expanded(child: SizedBox()),
                          buildSubmitButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );

  Widget get _jumboTabletView => SingleChildScrollView(
    child: Shortcuts(
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
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * .18,
                    child: DownloadClientFileButton(
                      defaultFileName: 'import-jumbo-sample.csv',
                      csvURL: CSVUrls.jumboCSVFilePath,
                    ),
                  ),
                  UploadFileButton(),
                ],
              ),
              vendorWidgetTile,
              buildBasicDetailsTablet(),
              buildSpecificationsTablet,
              buildMeasurementsTablet,
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultHorizontalPadding,
                  vertical: kDefaultVerticalPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Expanded(child: SizedBox()),
                    Expanded(child: SizedBox()),
                    buildSubmitButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
