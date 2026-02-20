import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/indents/enter_key_indent.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/heading_text.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/wastage/data/model/edit_wastage_api_param.dart';
import 'package:indogrip/features/wastage/presentation/bloc/wastage_bloc.dart';
import 'package:indogrip/features/wastage/presentation/pages/edit/edit_wastage_builder.dart';

class EditWastagePanel extends StatefulWidget {
  const EditWastagePanel({super.key, required this.param});
  final EditWastageApiParam param;
  static const String routeName = '/edit-wastage';

  @override
  State<EditWastagePanel> createState() => _EditWastagePanelState();
}

class _EditWastagePanelState extends EditWastageBuilder {
  @override
  void initState() {
    super.initState();
    // clientName will be set by the dropdown when it finds the matching client
    // clientName = widget.param.rKey;
    dateController.text = widget.param.wastageDate;
    billNoController.text = widget.param.billNumber;
    priceKGController.text = widget.param.price_kg;
    weigtController.text = widget.param.width;
    clientName = widget.param.wastageClient;
    remarkController.text = widget.param.remark;
  }

  fromSubmit() {
    if (formKey.currentState!.validate()) {
      wastageBloc.add(
        UpdateWastageOnRecordEvent(
          editWastageApiParam: EditWastageApiParam(
            billNumber: billNoController.text,
            price_kg: priceKGController.text,
            remark: remarkController.text,
            wastageClient: clientName.toString(),
            wastageDate: dateController.text,
            rKey: widget.param.rKey,
            width: weigtController.text,
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
          key: stateKey,
          appBar: !Responsive.isDesktop(context)
              ? MobileAppBar(context, stateKey, 'Edit Wastage')
              : DesktopAppBar(context, stateKey, 'Edit Wastage', true),
          drawer: !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : const SizedBox(),
        
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
                  onInvoke: (intent) => fromSubmit(),
                ),
              },
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),

                    wastageHeaderDesktop,
                    SizedBox(height: 20),
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
          onInvoke: (intent) => fromSubmit(),
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

  Widget get submitButton => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: kDefaultHorizontalPadding,
      vertical: 10,
    ),
    child: Row(
      children: [
        if (Responsive.isDesktop(context)) Expanded(child: SizedBox()),
        Expanded(child: SizedBox()),
        Expanded(child: SizedBox()),
        BlocConsumer(
          bloc: wastageBloc,
          listener: (context, state) {
            if (state is UpdateWastageOnRecordSuccessStatus) {
              if (state.successResponse.status == 1) {
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
            } else if (state is UpdateWastageOnRecordFailureStatus) {
              ToastService.instance.showError(
                context,
                state.message.toString(),
              );
            }
          },
          builder: (context, state) {
            if (state is WastageLoadingStatus) {
              return Center(child: CircularProgressIndicator());
            }
            return Expanded(
              child: SizedBox(
                child: CustomButton(label: 'Submit', onPressed: fromSubmit),
              ),
            );
          },
        ),
      ],
    ),
  );
}
