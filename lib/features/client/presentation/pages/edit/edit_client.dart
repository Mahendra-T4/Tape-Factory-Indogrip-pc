import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/extension/split_number_ext.dart';
import 'package:indogrip/core/indents/enter_key_indent.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/api%20service/csv_urls.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/client/data/model/edit_client_api_param.dart';
import 'package:indogrip/features/client/data/model/view_staff_modeld.dart';
import 'package:indogrip/features/client/presentation/bloc/client_bloc.dart';
import 'package:indogrip/features/client/presentation/pages/edit/edit_client_builder.dart';
import 'package:indogrip/features/client/presentation/pages/view/view_client.dart';
import 'package:indogrip/features/client/presentation/widgets/download_csv_button_client.dart';
import 'package:indogrip/features/client/presentation/widgets/upload_csv_button_client.dart';

class EditClientParam {
  final ClientRecord record;
  final List<ClientUnitList>? unit;
  EditClientParam({required this.record, this.unit});
}

class EditClient extends StatefulWidget {
  final EditClientParam param;
  const EditClient({super.key, required this.param});
  static const String routeName = '/edit-client';

  @override
  State<EditClient> createState() => _EditClientState();
}

class _EditClientState extends EditClientBuilder {
  late ClientBloc _clientBloc;
  final GlobalKey<ScaffoldState> _statekey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitted = false; // Add this to track form submission attempts

  _formSubmit() {
    if (_formKey.currentState!.validate()) {
      _clientBloc.add(
        UpdateClientDetailsOnRecordEvent(
          apiParams: EditClientApiParam(
            cConsigneeName: cNameController.text,
            cMobileNumber: cMobileNumberController.text,
            cGSTIN: cGSTINController.text,
            cOwnerName: oOwnerNameContoller.text,
            cOwnerMobileNumber: oMobileNumberController.text,
            cPurchaseManagerName: pManagerNameController.text,
            cPurchaseManagerNumber: pManagerMobileNumberController.text,
            rKey: widget.param.record.rKey.toString(),
            uPassword: passwordController.text,
            uConfirmPassword: cPassController.text,
          ),
        ),
      );
    }
  }

  void loadUnitDataInController() {
    log('Unit Data: ${widget.param.unit}');
    if (widget.param.unit != null && widget.param.unit!.isNotEmpty) {
      for (var unit in widget.param.unit!) {
        if (unit.unitIndex != null) {
          switch (unit.unitIndex) {
            case 1:
              unit1Controller.text = unit.unitName ?? '';
              break;
            case 2:
              unit2Controller.text = unit.unitName ?? '';
              break;
            case 3:
              unit3Controller.text = unit.unitName ?? '';
              break;
            case 4:
              unit4Controller.text = unit.unitName ?? '';
              break;
            case 5:
              unit5Controller.text = unit.unitName ?? '';
              break;
            default:
              break;
          }
        }
      }
    }
  }

  @override
  void initState() {
    _clientBloc = ClientBloc();
    loadUnitDataInController();
    cMobileNumberController.text = widget.param.record.cMobileNumber!
        .splitNumber();
    // cAlterMobileNumberController.text =
    //     widget.param.c?.splitNumber() ?? '';
    // gstinController.text = widget.param.cGSTIN;
    cNameController.text = widget.param.record.cConsigneeName.toString();
    oOwnerNameContoller.text = widget.param.record.cOwnerName.toString();
    oMobileNumberController.text = widget.param.record.cOwnerMobileNumber!
        .splitNumber();
    pManagerNameController.text = widget.param.record.cPurchaseManagerName
        .toString();
    cGSTINController.text = widget.param.record.cGSTIN.toString();
    pManagerMobileNumberController.text = widget
        .param
        .record
        .cPurchaseManagerNumber!
        .splitNumber();
    pAlterManagerMobileNumberController.text =
        widget.param.record.cAlternateNumber != ''
        ? widget.param.record.cAlternateNumber!.splitNumber()
        : '';
    oAlterMobileNumberController.text =
        widget.param.record.cOwnerAlternateNumber?.splitNumber() ?? '';
    super.initState();
  }

  File? csvFile;

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

  Widget get headerButton => Row(
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
        child: UploadClientFileButton(activity: 'upload-csv', csvFile: csvFile),
      ),
    ],
  );

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
                    onInvoke: (intent) => _formSubmit(),
                  ),
                },
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DesktopAppBar(context, _statekey, 'Edit Client', false),
                      headerButton,
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
                LogicalKeySet(LogicalKeyboardKey.enter): SubmitIntent(),
                LogicalKeySet(LogicalKeyboardKey.numpadEnter): SubmitIntent(),
              },
              child: Actions(
                actions: <Type, Action<Intent>>{
                  SubmitIntent: CallbackAction<SubmitIntent>(
                    onInvoke: (intent) => _formSubmit(),
                  ),
                },
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
      ],
    );
  }

  Widget submitBtn() {
    return BlocConsumer(
      bloc: _clientBloc,
      listener: (context, state) {
        if (state is UpdateClientDetailsOnRecordSuccessStatus) {
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
        } else if (state is UpdateClientDetailsOnRecordFailureStatus) {
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _clientBloc.add(
                              UpdateClientDetailsOnRecordEvent(
                                apiParams: EditClientApiParam(
                                  cConsigneeName: cNameController.text,
                                  cMobileNumber: cMobileNumberController.text,
                                  cAlternateNumber:
                                      cAlterMobileNumberController.text,
                                  cGSTIN: cGSTINController.text,
                                  cOwnerName: oOwnerNameContoller.text,
                                  cOwnerMobileNumber:
                                      oMobileNumberController.text,
                                  cPurchaseManagerName:
                                      pManagerNameController.text,
                                  cPurchaseManagerNumber:
                                      pManagerMobileNumberController.text,
                                  rKey: widget.param.record.rKey.toString(),
                                  uPassword: passwordController.text,
                                  uConfirmPassword: cPassController.text,
                                  cUnitOne: unit1Controller.text,
                                  cUnitTwo: unit2Controller.text,
                                  cUnitThree: unit3Controller.text,
                                  cUnitFour: unit4Controller.text,
                                  cUnitFive: unit5Controller.text,
                                ),
                              ),
                            );
                          }
                        },
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
