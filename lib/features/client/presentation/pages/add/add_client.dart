import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/api%20service/csv_urls.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/client/data/model/add_client_param.dart';
import 'package:indogrip/features/client/presentation/bloc/client_bloc.dart';
import 'package:indogrip/features/client/presentation/pages/add/add_client_builder.dart';
import 'package:indogrip/features/client/presentation/pages/view/view_client.dart';
import 'package:indogrip/features/client/presentation/widgets/download_csv_button_client.dart';
import 'package:indogrip/features/client/presentation/widgets/upload_csv_button_client.dart';
import 'package:indogrip/features/staff/presentation/pages/edit/edit_add_staff_page.dart';

class AddClientPanel extends StatefulWidget {
  const AddClientPanel({super.key});
  static const String routeName = '/addClient';

  @override
  State<AddClientPanel> createState() => _AddClientPanelState();
}

class _AddClientPanelState extends AddClientPanelBuilder {
  late ClientBloc _clientBloc;
  final GlobalKey<ScaffoldState> _statekey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? csvFile;

  // Controllers for form fields

  @override
  void initState() {
    _clientBloc = ClientBloc();
    super.initState();
  }

  // Centralized submit handler so both the button and Enter key can reuse it
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _clientBloc.add(
        AddClientOnRecordEvent(
          apiParams: ClientApiParams(
            cConsigneeName: cNameController.text,
            cMobileNumber: cMobileNumberController.text,
            cAlternateNumber: cAlterMobileNumberController.text,
            cGSTIN: cGSTINController.text,
            cOwnerName: oOwnerNameContoller.text,
            cOwnerMobileNumber: oMobileNumberController.text,
            cOwnerAlternateNumber: oAlterMobileNumberController.text,
            cPurchaseManagerName: pManagerNameController.text,
            cPurchaseManagerNumber: pManagerMobileNumberController.text,
            cPurchaseManagerAlternateNumber: pAlterMobileNumberController.text,
            cUnitOne: unit1Controller.text,
            cUnitTwo: unit2Controller.text,
            cUnitThree: unit3Controller.text,
            cUnitFour: unit4Controller.text,
            cUnitFive: unit5Controller.text,
          ),
        ),
      );
    }
  }

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
          key: _statekey,
          appBar: !Responsive.isDesktop(context)
              ? MobileAppBar(context, _statekey, 'Add Client')
              : null,
          drawer: !Responsive.isDesktop(context) ? SideMenuWidget() : null,
          body: SafeArea(
            child: Responsive.isDesktop(context)
                ? _desktopView()
                : _tabletView(),
          ),
        );
      },
    );
  }

  Widget _desktopView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SideMenuWidget(),
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
                    onInvoke: (_intent) => _submitForm(),
                  ),
                },
                child: Focus(
                  autofocus: true,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DesktopAppBar(context, _statekey, 'Add Client', false),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * .18,
                              child: DownloadClientFileButton(
                                csvURL: CSVUrls.clientCSVFilePath,
                                defaultFileName: 'import-client-sample.csv',
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * .18,
                              // flex: 4,
                              child: UploadClientFileButton(
                                activity: 'import-client',
                                csvFile: csvFile,
                              ),
                            ),
                          ],
                        ),
                        clientInfoSectionDesktop(),
                        unitWidget,
                        ownerInfoDesktop(),
                        purchaseManagerSectionDesktop(),
                        submitBtn(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tabletView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    onInvoke: (_intent) => _submitForm(),
                  ),
                },
                child: Focus(
                  autofocus: true,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        clientInfoSectionTablet(),
                        ownerInfoTablet(),
                        purchaseManagerSectionTablet(),
                        submitBtn(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget submitBtn() {
    return BlocConsumer(
      bloc: _clientBloc,
      listener: (context, state) {
        if (state is AddClientOnRecordSuccessStatus) {
          if (state.successResponse.status == 1) {
            context.pushNamed(ViewClientPanel.routeName);
            if (!context.mounted) return;
            ToastService.instance.showSuccess(
              context,
              state.successResponse.message.toString(),
            );
          } else {
            if (!context.mounted) return;
            ToastService.instance.showError(
              context,
              state.successResponse.message ?? 'try again later',
            );
          }
        }
        if (state is AddClientOnRecordFailureStatus) {
          if (!context.mounted) return;
          ToastService.instance.showError(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is ClientLoadingStatus) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 35, bottom: 20),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).height * 0.32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: CustomButton(
                        label: 'Submit',
                        onPressed: _submitForm,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
