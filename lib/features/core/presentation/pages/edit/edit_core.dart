import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/indents/enter_key_indent.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/carton/data/models/add_carton_api_param.dart';
import 'package:indogrip/features/core/data/models/core_api_param_entity.dart';
import 'package:indogrip/features/core/presentation/bloc/core_bloc.dart';
import 'package:indogrip/features/core/presentation/pages/edit/edit_core_builder.dart';
import 'package:indogrip/features/core/presentation/pages/view/view_core.dart';

class EditCorePanel extends StatefulWidget {
  const EditCorePanel({super.key, required this.param});
  final CartonApiParams param;

  static const String routeName = '/edit-core';

  @override
  State<EditCorePanel> createState() => _EditCorePanelState();
}

class _EditCorePanelState extends EditCoreBuilder {
  @override
  void initState() {
    super.initState();
    dataController.text = widget.param.cartonDate;
    qntController.text = widget.param.cartonQuantity;
    billNumberController.text = widget.param.billNumber;
    selectedCoreType = widget.param.cartonType;
    selectedVendor = widget.param.vendorKey;
  }

  formSubmit() {
    final formState = formKey.currentState;

    if (formState != null) {
      bool isValid = formState.validate();

      if (dataController.text.isEmpty) {
        FocusScope.of(context).requestFocus(dataFocusNode);
      } else if (qntController.text.isEmpty) {
        FocusScope.of(context).requestFocus(qntFocusNode);
      } else if (billNumberController.text.isEmpty) {
        FocusScope.of(context).requestFocus(billNumberFocusNode);
      }

      if (isValid) {
        coreBloc.add(
          EditCoreOnRecordEvent(
            apiParams: CoreApiParams(
              coreType: selectedCoreType.toString(),
              coreDate: dataController.text,
              coreQuantity: qntController.text,
              rKey: widget.param.rKey,
              coreBillNumber: billNumberController.text,
              context: context,
              vendor: selectedVendor.toString(),
            ),
          ),
        );
      }
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
          key: statekey,
          appBar: !Responsive.isDesktop(context)
              ? MobileAppBar(context, statekey, 'Add Core')
              : null,
          drawer: !Responsive.isDesktop(context) ? SideMenuWidget() : null,
          body: Responsive.isDesktop(context)
              ? buildCartonDesktopView
              : buildCartonTabletView,
        );
      }
    );
  }

  Widget get buildCartonDesktopView => Row(
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
                  children: [
                    DesktopAppBar(context, statekey, 'Add Carton', false),
                    SizedBox(height: 30),
                    buildCoreInfoSectionDesktop,
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
        SubmitIntent: CallbackAction<SubmitIntent>(
          onInvoke: (intent) => formSubmit(),
        ),
      },
      child: Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(height: 30),
            buildCoreInfoSectionTablet,
            SizedBox(height: 30),
            buildSubmitBtn(),

            SizedBox(height: 30),
          ],
        ),
      ),
    ),
  );

  Widget buildSubmitBtn() => BlocConsumer(
    bloc: coreBloc,
    listener: (context, state) {
      if (state is EditCoreOnRecordSuccessStatus) {
        if (state.successResponse.status == 1) {
          context.pushNamed(ViewCorePanel.routeName);
          if (!context.mounted) return;
          ToastService.instance.showSuccess(
            context,
            state.successResponse.message.toString(),
          );
        } else {
          if (!context.mounted) return;
          ToastService.instance.showError(
            context,
            state.successResponse.message.toString(),
          );
        }
      } else if (state is EditCoreOnRecordFailureStatus) {
        if (!context.mounted) return;
        ToastService.instance.showError(context, state.errorMessage.toString());
      }
    },
    builder: (context, state) {
      if (state is CoreLoadingStatus) {
        return Center(child: CircularProgressIndicator.adaptive());
      }
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: 10,
        ),
        child: Row(
          children: [
            Expanded(child: SizedBox()),
            Expanded(child: SizedBox()),
            Expanded(
              child: CustomButton(label: 'Submit', onPressed: formSubmit),
            ),
          ],
        ),
      );
    },
  );
}
