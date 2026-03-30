import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/carton/presentation/widgets/master_carton_type.dart';
import 'package:indogrip/features/global/domain/repositories/global_repo.dart';
import 'package:indogrip/features/global/presentation/widget/uploadFile_button.dart';
import 'package:indogrip/features/round/data/models/add_round_param_model.dart';
import 'package:indogrip/features/round/data/models/master_jumboRoll_model.dart';
import 'package:indogrip/features/round/domain/repositories/add_round_repo.dart';
import 'package:indogrip/features/round/presentation/bloc/round_bloc.dart';
import 'package:indogrip/features/round/presentation/pages/add/add_round.dart';
import 'package:indogrip/features/round/presentation/pages/view/view_round.dart';
import 'package:indogrip/features/round/presentation/widgets/core_dropdown.dart';
import 'package:indogrip/features/round/presentation/widgets/master_jumbo_roll_drowdown.dart';
import 'package:indogrip/features/round/presentation/widgets/master_roll_size_widget.dart';
import 'package:intl/intl.dart';

abstract class AddRoundBuilder extends State<AddRoundPanel> {
  late RoundBloc _roundBloc;
  File? csvFile;
  String? selectedCartonType;

  @override
  void initState() {
    _roundBloc = RoundBloc(addRoundRepository: AddRoundRepository());
    super.initState();
  }

  formSubmit() {
    if (formKey.currentState?.validate() ?? false) {
      _roundBloc.add(
        AddRoundONRecordEvent(
          addRoundParam: AddRoundParam(
            jumboRoll: selectedJumbo,
            rollSize: selectedSize.toString(),
            rollCore: selectedCore.toString(),
            round: roundController.text,
            meters: meterController.text,
            damagePieces: damagePiecesController.text,
            wastagePercentage: wastagePercentageController.text,
            cartonType: selectedCartonType.toString(),
            conversionRate: conversionRateController.text,
          ),
        ),
      );
    }
  }

  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<ScaffoldState> stateKey = GlobalKey<ScaffoldState>();
  // Form Controllers
  TextEditingController roundController = TextEditingController();
  TextEditingController meterController = TextEditingController();
  TextEditingController damagePiecesController = TextEditingController();
  TextEditingController wastagePercentageController = TextEditingController();
  TextEditingController conversionRateController = TextEditingController();
  TextEditingController searchJumboController = TextEditingController();

  // Form Values
  String? gender;
  String? selectedCourse;
  String? selectedBatch;
  String? selectedSize;
  String? selectedCore;

  // Form Validation Status
  bool isSubmitPressed = false;

  // Multi-select field variables
  List<String> selectedItems = [];

  Widget get wastagePercentageField => Consumer(
    builder: (context, ref, child) {
      final setting = ref.watch(settingProvider);

      return setting.when(
        data: (data) {
          if (data.status == 1)
            wastagePercentageController.text = data
                .record!
                .first
                .wastagePercentage
                .toString();
          return data.status != 1
              ? Center(child: Text(data.message.toString()))
              : buildFormField('Wastage Percentage', [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ], wastagePercentageController);
        },
        error: (error, stackTrace) => SizedBox.shrink(),
        loading: () => Center(child: CircularProgressIndicator.adaptive()),
      );
    },
  );

  Widget get conversionRateField => Consumer(
    builder: (context, ref, child) {
      final setting = ref.watch(settingProvider);

      return setting.when(
        data: (data) {
          if (data.status == 1)
            conversionRateController.text = data.record!.first.conversionRate
                .toString();
          return data.status != 1
              ? Center(child: Text(data.message.toString()))
              : buildFormField('Conversion Rate', [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ], conversionRateController);
        },
        error: (error, stackTrace) => SizedBox.shrink(),
        loading: () => Center(child: CircularProgressIndicator.adaptive()),
      );
    },
  );

  Widget get middleRowDesktopWidget => Row(
    spacing: 16,
    children: [
      Expanded(
        // flex: 2,
        child: MasterCartonTypeDropDown(
          selectCartonType: selectedCartonType,
          onChanged: (val) => setState(() => selectedCartonType = val),
        ),
      ),
      Expanded(
        child: buildFormField('Damage Pieces', [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ], damagePiecesController),
      ),
      Expanded(child: wastagePercentageField),
    ],
  );

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFEEF2F5), width: 1),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: "Inter",
                color: Color(0xFF3D475C),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Add these variables in the state class
  final Color tfColor = Colors.white;
  final primaryColor = const Color(0xFF2D8FCF);

  // Sample data for jumbo rolls

  List<MJumboRollRecord> selectedJumboRolls = [];

  List<String> selectedJumbo = [];

  // Validation function
  bool validateForm() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      return true;
    }
    return false;
  }

  // Reset form
  void resetForm() {
    formKey.currentState?.reset();
    roundController.clear();
    meterController.clear();

    setState(() {
      gender = null;
      selectedCourse = null;
      selectedBatch = null;
      isSubmitPressed = false;
      selectedItems.clear();
    });
  }

  //! Desktop View for Round Information

  Widget get roundInfoDesktop => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 1200),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultHorizontalPadding,
            vertical: kDefaultVerticalPadding,
          ),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    // flex: 2,
                    child: MasterJumboRoll(
                      filter: '1',
                      selectedJumbo: selectedJumbo,
                      onChanged: (values) {
                        log(name: 'Roll Key', values.toString());
                        setState(() {
                          selectedJumbo = values;
                        });
                      },
                      controller: searchJumboController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MasterRoleSizeSelector(
                      selectedRole: selectedSize,
                      onChanged: (String? value) {
                        setState(() {
                          selectedSize = value;
                        });
                      },
                      isFilter: false,
                    ),
                  ),
                  const SizedBox(width: 16),
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
              const SizedBox(height: 16),
              middleRowDesktopWidget,
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: conversionRateField),
                  const SizedBox(width: 16),
                  Expanded(child: buildFormField('Round', [], roundController)),
                  const SizedBox(width: 16),
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
      ],
    ),
  );

  Widget addRoundButton() => BlocConsumer<RoundBloc, RoundState>(
    bloc: _roundBloc,
    listener: (context, state) {
      if (state is AddRoundLoadedSuccessStatus) {
        if (state.successResponse.status == 1) {
          context.pushNamed(ViewRoundPanel.routeName);
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
      if (state is RoundLoadingStatus) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }
      return CustomButton(label: 'Submit', onPressed: formSubmit);
    },
  );

  //! Tablet view for Round Information

  Widget get roundTabletView => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: kDefaultHorizontalPadding,
      vertical: kDefaultVerticalPadding,
    ),
    child: Column(
      spacing: 20,
      children: [
        // const SizedBox(height: 20),
        UploadFileButton(),
        Row(
          spacing: 16,
          children: [
            Expanded(
              // flex: 2,
              child: MasterJumboRoll(
                selectedJumbo: selectedJumbo,
                onChanged: (values) {
                  log(name: 'Roll Key', values.toString());
                  setState(() {
                    selectedJumbo = values;
                  });
                },
                controller: searchJumboController,
              ),
            ),

            Expanded(
              // flex: 1,
              child: MasterRoleSizeSelector(
                selectedRole: selectedSize,
                isFilter: false,
                onChanged: (val) => setState(() => selectedSize = val),
              ),
            ),
          ],
        ),

        Row(
          spacing: 16,
          children: [
            // const SizedBox(width: 16),
            Expanded(
              child: CoreDropdown(
                selectedCore: selectedCore,
                onChanged: (val) => setState(() => selectedCore = val),
              ),
            ),
            Expanded(
              child: buildFormField('Damage Pieces', [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ], damagePiecesController),
            ),
          ],
        ),

        Row(
          spacing: 16,
          children: [
            Expanded(child: wastagePercentageField),

            Expanded(child: conversionRateField),
          ],
        ),

        Row(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(width: 16),
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
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [SizedBox(width: 200, child: addRoundButton())],
        ),
      ],
    ),
  );

  Widget buildFormSection(List<Widget> fields) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 1),
          ...fields
              .expand(
                (field) => [
                  Expanded(flex: 14, child: field),
                  const Spacer(flex: 1),
                ],
              )
              .toList(),
          // const Spacer(flex: 1),
        ],
      ),
    );
  }

  Widget buildFormField(
    String label,
    List<TextInputFormatter>? inputFormatters,
    TextEditingController controller, {
    bool isEmail = false,
    bool isPhone = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        TextFieldlabelText(label),
        Container(
          // margin: const EdgeInsets.only(top: 10),
          height: 68,
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFF9499A1)),
                borderRadius: BorderRadius.circular(5),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
            ),
            inputFormatters: inputFormatters,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              if (isEmail && !value.contains('@')) {
                return 'Please enter a valid email';
              }
              if (isPhone && value.length != 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldlabelText(label),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: TextFormField(
            controller: controller,
            readOnly: true,
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
                setState(() {
                  controller.text = DateFormat(
                    'dd-MM-yyyy',
                  ).format(selectedDate);
                });
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFF9499A1)),
                borderRadius: BorderRadius.circular(5),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              suffixIcon: const Icon(
                Icons.calendar_month,
                color: Color(0xFF2D8FCF),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select $label';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget buildDropdownField(
    String label,
    List<String> items,
    String? value,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldlabelText(label),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            hint: Text('$label'),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF2D8FCF),
            ),
            items: items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: onChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select $label';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

// class MasterCartonType {}
