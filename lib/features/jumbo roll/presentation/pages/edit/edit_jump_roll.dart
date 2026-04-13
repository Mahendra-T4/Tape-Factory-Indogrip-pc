import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/api%20service/csv_urls.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/client/presentation/widgets/download_csv_button_client.dart';
import 'package:indogrip/features/client/presentation/widgets/upload_csv_button_client.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/jumbo_api_params.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/view_jumbo_roll_model.dart';
import 'dart:developer' as developer;
import 'package:indogrip/features/jumbo%20roll/presentation/bloc/jumbo_roll_bloc.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/edit/edit_jumbo_roll_builder.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/view/view_jumbo_roll.dart';
import 'package:indogrip/features/staff/presentation/pages/edit/edit_add_staff_page.dart';

class EditJumboRollPanel extends StatefulWidget {
  const EditJumboRollPanel({super.key, required this.jumboRollRecords});
  final JumboRollRecord jumboRollRecords;

  static const String routeName = '/edit-jumbo-roll';

  @override
  State<EditJumboRollPanel> createState() => _EditJumboRollPanelState();
}

class _EditJumboRollPanelState extends EditJumboRollBuilder {
  final GlobalKey<ScaffoldState> _stateKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

    initializeValues();
    developer.log(
      name: 'Widget Param',
      '${widget.jumboRollRecords.baseLabel} and ${widget.jumboRollRecords.micLabel}',
    );

    // squareMeter = double.parse(widget.jumboRollRecords.jSquareMeter.toString());
  }

  initializeValues() {
    setState(() {
      dateController.text = widget.jumboRollRecords.jBillDate.toString();
      billNoController.text = widget.jumboRollRecords.jBillNumber.toString();
      rollNoController.text = widget.jumboRollRecords.jRollNumber.toString();
      lengthController.text = widget.jumboRollRecords.jLength.toString();
      weightController.text = widget.jumboRollRecords.jWeight.toString();
      selectedWidth = widget.jumboRollRecords.jwidthID.toString();
      selectedMic = widget.jumboRollRecords.jMic.toString();
      selectedBase = widget.jumboRollRecords.jBase.toString();

      remarkController.text = widget.jumboRollRecords.jRemark.toString();
      amountPerKGController.text = widget.jumboRollRecords.amountPerKG
          .toString();
      selectedVendor = widget.jumboRollRecords.vendorInfo!.vendorKey.toString();
    });
  }

  formSubmit() {
    if (mounted || formKey.currentState!.validate()) {
      final apiParams = JumboRollApiParams(
        billDate: dateController.text,
        billNumber: billNoController.text,
        rollNumber: rollNoController.text,
        length: lengthController.text,
        width: selectedWidth ?? '',
        base: selectedBase ?? '',
        mic: selectedMic ?? '',
        netWeight: weightController.text,
        remark: remarkController.text,
        context: context,
        vendorKey: selectedVendor.toString(),
        rKey: widget.jumboRollRecords.rKey.toString(),
        amountPerKG: amountPerKGController.text,
      );
      jumboRollBloc.add(UpdateJumboRollRecordsEvent(apiParams: apiParams));
    }
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
          key: _stateKey,
          appBar: !Responsive.isDesktop(context)
              ? MobileAppBar(context, _stateKey, 'Edit Jumbo Roll')
              : DesktopAppBar(context, _stateKey, 'Edit Jumbo Roll', true),
          drawer: !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : const SizedBox(),

          body: Responsive.isDesktop(context)
              ? _jumboDesktopView
              : _jumboTabletView,
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
                    headerButton,
                    vendorWidgetTile,
                    buildBasicDetailsDesktop(),
                    buildSpecificationsDesktop,
                    buildMeasurementsDesktop,
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

  Widget buildSubmitButton() {
    return BlocConsumer(
      listener: (context, state) {
        if (state is UpdateJumboRollRecordSuccessStatus) {
          if (state.successResponse.status == 1) {
            context.pushNamed(ViewJumboRollPanel.routeName);
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
        if (state is UpdateJumboRollFailedStatus) {
          if (!context.mounted) return;
          ToastService.instance.showError(
            context,
            state.errorMessage.toString(),
          );
        }
      },
      bloc: jumboRollBloc,
      builder: (context, state) {
        if (state is JumboRollLoadingStatus) {
          return const Center(child: CircularProgressIndicator());
        }
        return Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.25,
            child: CustomButton(label: 'Submit', onPressed: formSubmit),
          ),
        );
      },
    );
  }
}
