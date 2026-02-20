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
import 'package:indogrip/features/client/data/model/view_staff_api_param.dart';
import 'package:indogrip/features/staff/data/models/edit_staff_details_param_model.dart';
import 'package:indogrip/features/staff/presentation/bloc/staff_bloc.dart';
import 'package:indogrip/features/staff/presentation/pages/edit/edit_staff_builder.dart';
import 'package:indogrip/features/staff/presentation/pages/view/view_staff.dart';

class SubmitIntent extends Intent {
  const SubmitIntent();
}

class EditStaffDetailsPage extends StatefulWidget {
  final EditStaffModel editStaffModel;
  const EditStaffDetailsPage({super.key, required this.editStaffModel});
  static const String routeName = '/edit_staff_details';

  @override
  State<EditStaffDetailsPage> createState() => _EditStaffDetailsPageState();
}

class _EditStaffDetailsPageState extends EditStaffBuilder {
  @override
  void initState() {
    staffBloc = StaffBloc();
    fNameController.text = widget.editStaffModel.sFName.toString();
    lNameController.text = widget.editStaffModel.sLName.toString();
    emailController.text = widget.editStaffModel.sLoginEmailID.toString();
    mobNumberController.text = widget.editStaffModel.sMobileNumber
        .splitNumber();
    altMobController.text = widget.editStaffModel.sAltMobileNumber
        .splitNumber();
    pEmailController.text = widget.editStaffModel.sEmailID.toString();
    selectedRole = widget.editStaffModel.sRole;

    // Initialize both rights and selectedSkills with the access panel data
    rights = widget.editStaffModel.sAccessPanel;
    selectedSkills = List<String>.from(
      widget.editStaffModel.sAccessPanel,
    ); // Create a new list to avoid reference issues
    // set up submit key listener on dedicated focus node
    _submitFocusNode.onKeyEvent = (node, event) {
      if (event is KeyDownEvent &&
          event.logicalKey == LogicalKeyboardKey.enter) {
        _handleSubmit();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    };

    super.initState();
  }

  final GlobalKey<ScaffoldState> _statekey = GlobalKey<ScaffoldState>();
  final FocusNode _submitFocusNode = FocusNode();

  @override
  void dispose() {
    _submitFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.sizeOf(context);
    return Actions(
      actions: <Type, Action<Intent>>{
        SubmitIntent: CallbackAction<SubmitIntent>(
          onInvoke: (intent) {
            _handleSubmit();
            return null;
          },
        ),
      },
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.enter): const SubmitIntent(),
        },
        child: StreamBuilder(
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
                  ? MobileAppBar(context, _statekey, 'Edit Staff')
                  : null,
              drawer: !Responsive.isDesktop(context) ? SideMenuWidget() : null,
              body: SafeArea(
                child: Responsive.isDesktop(context)
                    ? _desktopView()
                    : _tabletView(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget permissionAndRightsSectionDesktop() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Column(
        children: [
          buildSectionTitle("Permission and Rights"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildPermissionsSectionDesktop(),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    width: 200,
                    child: editStaffButton(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DesktopAppBar(context, _statekey, 'Edit Staff', false),
                  generalRowDesktop(),
                  personalDetailsRowDesktop(),
                  permissionAndRightsSectionDesktop(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSubmit() {
    if (formKey.currentState!.validate()) {
      staffBloc.add(
        UpdateStaffDetailsEvent(
          editStaffApiParam: EditStaffApiParam(
            uFirstName: fNameController.text,
            uLastName: lNameController.text,
            uEmail: emailController.text,
            uPersonalEmail: pEmailController.text,
            uMobileNumber: mobNumberController.text,
            uAlternateNumber: altMobController.text,
            uRole: selectedRole.toString(),
            uAccessPanel: selectedSkills.isEmpty
                ? widget.editStaffModel.sAccessPanel.join(',').split(',')
                : selectedSkills.join(',').split(','),
            uPassword: passwordController.text,
            uConfirmPassword: cPasswordController.text,
            rKey: widget.editStaffModel.rKey.toString(),
          ),
        ),
      );
    }
  }

  editStaffButton() {
    return BlocConsumer(
      bloc: staffBloc,
      listener: (context, state) {
        if (state is UpdateStaffLoadedSuccessStatus) {
          if (state.successResponse.status == 1) {
            context.pushNamed(ViewStaffPanel.routeName);
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
        } else if (state is UpdateStaffLoadedFailureStatus) {
          ToastService.instance.showError(context, state.error.toString());
        }
      },
      builder: (context, state) {
        if (state is StaffLoadingStatus) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        return CustomButton(
          label: 'Submit',
          onPressed: () {
            if (formKey.currentState!.validate()) {
              staffBloc.add(
                UpdateStaffDetailsEvent(
                  editStaffApiParam: EditStaffApiParam(
                    uFirstName: fNameController.text,
                    uLastName: lNameController.text,
                    uEmail: emailController.text,
                    uPersonalEmail: pEmailController.text,
                    uMobileNumber: mobNumberController.text,
                    uAlternateNumber: altMobController.text,
                    uRole: selectedRole.toString(),
                    uAccessPanel: selectedSkills.isEmpty
                        ? widget.editStaffModel.sAccessPanel
                              .join(',')
                              .split(',')
                        : selectedSkills.join(',').split(','),
                    uPassword: passwordController.text,
                    uConfirmPassword: cPasswordController.text,
                    rKey: widget.editStaffModel.rKey.toString(),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget permissionAndRightsSectionTablet() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Column(
        children: [
          buildSectionTitle("Permission and Rights"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildPermissionsSectionTablet(),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(width: 200, child: editStaffButton()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabletView() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            generalRowTablet(),
            personalDetailsRowTablet(),
            permissionAndRightsSectionTablet(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
