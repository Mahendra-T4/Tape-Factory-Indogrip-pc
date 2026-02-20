import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/indents/enter_key_indent.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/features/round/data/models/view_round_modeld.dart';
import 'package:indogrip/features/round/presentation/pages/edit/edit_round_builder.dart';
import 'package:indogrip/features/round/presentation/widgets/core_dropdown.dart';
import 'package:indogrip/features/round/presentation/widgets/master_jumbo_roll_drowdown.dart';
import 'package:indogrip/features/round/presentation/widgets/master_roll_size_widget.dart';

class EditRoundPanel extends StatefulWidget {
  const EditRoundPanel({super.key, required this.record});
  final RoundRecord record;
  static const String routeName = '/edit/round';

  @override
  State<EditRoundPanel> createState() => _EditRoundPanelState();
}

class JumboRoll {
  final String id;
  final String name;

  JumboRoll({required this.id, required this.name});
}

class _EditRoundPanelState extends EditRoundBuilder {
  @override
  void initState() {
    selectedJumbo = widget.record.jumboKey;
    roundController.text = widget.record.roundCount.toString();
    meterController.text = widget.record.tapeLength.toString();
    selectedCore = widget.record.coreID?.toString();
    selectedSize = widget.record.rollSizeID?.toString();
    selectedJumbo = widget.record.jumboKey;
    wastagePercentageController.text = widget.record.wastagePercentage
        .toString();
    selectedCartonType = widget.record.cartonType.toString();
    damagePiecesController.text = widget.record.damagePieces.toString();
    conversionRateController.text = widget.record.conversionRate.toString();
    log(name: 'Carton Type ID', widget.record.cartonType.toString());

    // selectedCartonType = widget.recor.toString();
    super.initState();
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
              ? MobileAppBar(context, stateKey, 'Edit Round')
              : DesktopAppBar(context, stateKey, 'Edit Round', true),
          drawer: !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : const SizedBox(),
          body: Responsive.isDesktop(context)
              ? roundDesktopWidgetWrapper
              : _roundTabletView,
        );
      }
    );
  }

  Widget get roundDesktopWidgetWrapper => Shortcuts(
    shortcuts: <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.enter): const SubmitIntent(),
      LogicalKeySet(LogicalKeyboardKey.numpadEnter): const SubmitIntent(),
    },
    child: Actions(
      actions: <Type, Action<Intent>>{
        SubmitIntent: CallbackAction(onInvoke: (intent) => formSubmit()),
      },
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultHorizontalPadding,
            vertical: kDefaultVerticalPadding,
          ),
          child: ListView(
            // spacing: 30,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              headerButton,
              SizedBox(height: 15),
              Row(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    // flex: 2,
                    child: MasterJumboRoll(
                      selectedJumbo: selectedJumbo.toString(),
                      onChanged: (values) {
                        log(name: 'Roll Key', values.toString());
                        setState(() {
                          selectedJumbo = values.toString();
                          ;
                        });
                      },
                      controller: searchJumboController,
                    ),
                  ),

                  Expanded(
                    child: MasterRoleSizeSelector(
                      selectedRole: selectedSize,
                      onChanged: (String? value) {
                        setState(() {
                          selectedSize = value;
                        });
                      },
                    ),
                  ),
                  // const SizedBox(width: 16),
                  Expanded(
                    child: CoreDropdown(
                      selectedCore: selectedCore,
                      onChanged: (value) {
                        setState(() {
                          selectedCore = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              middleRowDesktopWidget,
              SizedBox(height: 25),
              Row(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: buildFormField('Conversion Rate', [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ], conversionRateController),
                  ),
                  Expanded(child: buildFormField('Round', [], roundController)),

                  Expanded(
                    child: buildFormField('Tape Length', [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ], meterController),
                  ),
                  // Expanded(child: const SizedBox()),
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [SizedBox(width: 200, child: addRoundButton())],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget get roundInfoDesktop => Shortcuts(
    shortcuts: <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.enter): const SubmitIntent(),
      LogicalKeySet(LogicalKeyboardKey.numpadEnter): const SubmitIntent(),
    },
    child: Actions(
      actions: <Type, Action<Intent>>{
        SubmitIntent: CallbackAction(onInvoke: (intent) => formSubmit()),
      },
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildSectionTitle("Round Information"),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultHorizontalPadding,
                vertical: kDefaultVerticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget get _roundTabletView => SingleChildScrollView(child: roundTabletView);
}
