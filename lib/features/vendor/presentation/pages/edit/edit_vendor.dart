import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/extension/split_number_ext.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/staff/presentation/pages/edit/edit_add_staff_page.dart';
import 'package:indogrip/features/vendor/data/models/edit_vendor_api_param.dart';
import 'package:indogrip/features/vendor/data/models/view_vendor_model.dart';
import 'package:indogrip/features/vendor/presentation/bloc/vendor_bloc.dart';
import 'package:indogrip/features/vendor/presentation/pages/edit/edit_vendor_builder.dart';
import 'package:indogrip/features/vendor/presentation/pages/view/view_vendor.dart';

class EditVendorPanel extends StatefulWidget {
  const EditVendorPanel({super.key, required this.param});
  final VendorRecord param;
  static const routeName = '/edit-Vendor';

  @override
  State<EditVendorPanel> createState() => _EditVendorPanelState();
}

class _EditVendorPanelState extends EditVendorPanelBuilder {
  late VendorBloc _vendorBloc;
  final GlobalKey<ScaffoldState> _statekey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _formSubmit() {
    if (_formKey.currentState!.validate()) {
      _vendorBloc.add(
        EditVendorOnRecordEvent(
          apiParams: EditVendorApiParam(
            vCompanyName: cNameController.text,
            vMobileNumber: cMobileNumberController.text,
            vGSTIN: cGSTINController.text,
            vOwnerName: oOwnerNameContoller.text,
            vOwnerMobileNumber: oMobileNumberController.text,
            vRepresentativeName: rManagerNameController.text,
            vRepresentativeMobile: rManagerMobileNumberController.text,
            rKey: widget.param.rKey.toString(),
            uPassword: passwordController.text,
            uConfirmPassword: cPasswordController.text,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    _vendorBloc = VendorBloc();
    cNameController.text = widget.param.vCompanyName.toString();
    cMobileNumberController.text = widget.param.vCompanyMobileNumber!
        .splitNumber();
    cGSTINController.text = widget.param.vCompanyGSTIN.toString();
    oOwnerNameContoller.text = widget.param.vVendorName.toString();

    oMobileNumberController.text = widget.param.vVendorMobileNumber!
        .splitNumber();
    rManagerNameController.text = widget.param.vRepresentativeName.toString();
    rManagerMobileNumberController.text = widget.param.vRepresentativeNumber!
        .splitNumber();
    rManagerAlterMobileNumberController.text = widget.param.vRAlternateNumber!
        .splitNumber();
    oAlterMobileNumberController.text = widget.param.vAlternateNumber!
        .splitNumber();
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
              ? MobileAppBar(context, _statekey, 'Edit Vendor')
              : null,
          drawer: !Responsive.isDesktop(context) ? SideMenuWidget() : null,
          body: SafeArea(
            child: Responsive.isDesktop(context) ? _desktopView() : _tabletView(),
          ),
        );
      }
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
                      DesktopAppBar(context, _statekey, 'Edit Vendor', false),
                      vendorInfoSectionDesktop(),
                      ownerInfoDesktop(),
                      purchaseManagerSectionDesktop(),
                      submitBtn(),
                      SizedBox(height: 50),
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
                  SubmitIntent: CallbackAction<SubmitIntent>(
                    onInvoke: (intent) => _formSubmit(),
                  ),
                },
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      vendorInfoSectionTablet(),
                      ownerInfoDesktop(),
                      purchaseManagerSectionDesktop(),
                      submitBtn(),
                      SizedBox(height: 50),
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
        if (state is UpdateVendorOnRecordSuccessStatus) {
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
        } else if (state is UpdateVendorOnRecordFailureStatus) {
          ToastService.instance.showError(
            context,
            state.errorMessage.toString(),
          );
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
                              EditVendorOnRecordEvent(
                                apiParams: EditVendorApiParam(
                                  vCompanyName: cNameController.text,
                                  vMobileNumber: cMobileNumberController.text,
                                  vGSTIN: cGSTINController.text,
                                  vOwnerName: oOwnerNameContoller.text,
                                  vOwnerMobileNumber:
                                      oMobileNumberController.text,
                                  vRepresentativeName:
                                      rManagerNameController.text,
                                  vRepresentativeMobile:
                                      rManagerMobileNumberController.text,
                                  rKey: widget.param.rKey.toString(),
                                  uPassword: passwordController.text,
                                  uConfirmPassword: cPasswordController.text,
                                  vAlternateNumber:
                                      cAlterMobileNumberController.text,
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
