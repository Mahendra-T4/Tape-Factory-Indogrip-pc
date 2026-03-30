import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
import 'package:indogrip/features/client/data/model/add_client_param.dart';
import 'package:indogrip/features/client/presentation/widgets/download_csv_button_client.dart';
import 'package:indogrip/features/client/presentation/widgets/upload_csv_button_client.dart';
import 'package:indogrip/features/vendor/presentation/bloc/vendor_bloc.dart';
import 'package:indogrip/features/vendor/presentation/pages/add/add_vendor_builder.dart';
import 'package:indogrip/features/vendor/presentation/pages/view/view_vendor.dart';
import 'package:indogrip/features/vendor/presentation/widgets/upload_vendor_button.dart';

class AddVendorPanel extends StatefulWidget {
  const AddVendorPanel({super.key});
  static const String routeName = '/addVendor';

  @override
  State<AddVendorPanel> createState() => _AddVendorPanelState();
}

class _AddVendorPanelState extends AddVendorPanelBuilder {
  late VendorBloc _vendorBloc;
  final GlobalKey<ScaffoldState> _statekey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? csvFile;

  _formSubmit() {
    if (_formKey.currentState!.validate()) {
      _vendorBloc.add(
        AddVendorOnRecordEvent(
          apiParams: ClientApiParams(
            cConsigneeName: cNameController.text,
            cMobileNumber: cMobileNumberController.text,
            cGSTIN: cGSTINController.text,
            cOwnerName: oOwnerNameContoller.text,
            cOwnerMobileNumber: oMobileNumberController.text,
            cOwnerAlternateNumber: oAlterMobileNumberController.text,
            cPurchaseManagerName: rManagerNameController.text,
            cPurchaseManagerNumber: rManagerMobileNumberController.text,
            cPurchaseManagerAlternateNumber: rAlterManagerNameController.text,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    _vendorBloc = VendorBloc();
    super.initState();
  }

  // Controllers for form fields

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
              ? MobileAppBar(context, _statekey, 'Add Vendor')
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
                    onInvoke: (intent) => _formSubmit(),
                  ),
                },
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DesktopAppBar(context, _statekey, 'Add Vendor', false),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * .18,
                            child: DownloadClientFileButton(
                              defaultFileName: 'import-vendor-sample.csv',
                              csvURL: CSVUrls.vendorCSVFilePath,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * .18,
                            child: UploadVendorFileButton(
                              activity: 'import-vendor',
                              csvFile: csvFile,
                            ),
                          ),
                        ],
                      ),
                      vendorInfoSectionDesktop(),
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
                LogicalKeySet(LogicalKeyboardKey.enter): const SubmitIntent(),
                LogicalKeySet(LogicalKeyboardKey.numpadEnter):
                    const SubmitIntent(),
              },
              child: Actions(
                actions: <Type, Action<Intent>>{
                  SubmitIntent: CallbackAction(
                    onInvoke: (intent) => _formSubmit(),
                  ),
                },
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      vendorInfoSectionTablet(),
                      ownerInfoTablet,
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
      bloc: _vendorBloc,
      listener: (context, state) {
        if (state is AddVendorOnRecordSuccessStatus) {
          if (state.successResponse.status == 1) {
            context.pushNamed(ViewVendorPanel.routeName);
            ToastService.instance.showSuccess(
              context,
              state.successResponse.message.toString(),
            );
          } else {
            ToastService.instance.showError(
              context,
              state.successResponse.message.toString(),
            );
          }
        }
      },
      builder: (context, state) {
        if (state is VendorLoadingStatus) {
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
                            _vendorBloc.add(
                              AddVendorOnRecordEvent(
                                apiParams: ClientApiParams(
                                  cConsigneeName: cNameController.text,
                                  cMobileNumber: cMobileNumberController.text,
                                  cGSTIN: cGSTINController.text,
                                  cOwnerName: oOwnerNameContoller.text,
                                  cOwnerMobileNumber:
                                      oMobileNumberController.text,
                                  cOwnerAlternateNumber:
                                      oAlterMobileNumberController.text,
                                  cPurchaseManagerName:
                                      rManagerNameController.text,
                                  cPurchaseManagerNumber:
                                      rManagerMobileNumberController.text,
                                  cPurchaseManagerAlternateNumber:
                                      rAlterManagerNameController.text,
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
