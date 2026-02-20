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
import 'package:indogrip/features/carton/data/models/view_carton_model.dart';
import 'package:indogrip/features/carton/presentation/bloc/carton_bloc.dart';
import 'package:indogrip/features/carton/presentation/pages/edit/edit_caton_builder.dart';
import 'package:indogrip/features/carton/presentation/pages/view/view_carton.dart';

class EditCartonPanel extends StatefulWidget {
  const EditCartonPanel({super.key, required this.param});
  final ViewCartonRecord param;
  static const String routeName = '/edit-carton';

  @override
  State<EditCartonPanel> createState() => _EditCartonPanelState();
}

class _EditCartonPanelState extends EditCatonBuilder {
  @override
  void initState() {
    super.initState();
    dataController.text = widget.param.cartonDateText.toString();
    qntController.text = widget.param.cartonQuantity.toString();
    billNumberController.text = widget.param.cartonBillNumber.toString();
    selectedCartonType = widget.param.cartonType.toString();
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
        cartonBloc.add(
          EditCartonOnRecordEvent(
            apiParams: CartonApiParams(
              cartonType: selectedCartonType.toString(),
              cartonDate: dataController.text,
              cartonQuantity: qntController.text,
              rKey: widget.param.rKey.toString(),
              vendorKey: selectedVendor,
              billNumber: billNumberController.text,
              context: context,
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
              ? MobileAppBar(context, statekey, 'Edit Client')
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
                    DesktopAppBar(context, statekey, 'Edit Carton', false),
                    SizedBox(height: 30),
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
        SubmitIntent: CallbackAction<SubmitIntent>(
          onInvoke: (intent) => formSubmit(),
        ),
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

  Widget buildSubmitBtn() => BlocConsumer(
    bloc: cartonBloc,
    listener: (context, state) {
      if (state is EditCartonOnRecordSuccessStatus) {
        if (state.successResponse.status == 1) {
          context.pushNamed(ViewCartonPanel.routeName);
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
      } else if (state is EditCartonOnRecordFailureStatus) {
        ToastService.instance.showError(context, state.errorMessage.toString());
      }
    },
    builder: (context, state) {
      if (state is CartonLoadingStatus) {
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
