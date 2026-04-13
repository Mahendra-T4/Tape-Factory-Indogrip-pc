import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/service/api%20service/csv_urls.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/carton/presentation/widgets/master_carton_type.dart';
import 'package:indogrip/features/client/presentation/widgets/download_csv_button_client.dart';
import 'package:indogrip/features/global/presentation/widget/uploadFile_button.dart';
import 'package:indogrip/features/round/data/models/add_round_param_model.dart';
import 'package:indogrip/features/round/data/models/master_jumboRoll_model.dart';
import 'package:indogrip/features/round/domain/repositories/add_round_repo.dart';
import 'package:indogrip/features/round/presentation/bloc/round_bloc.dart';
import 'package:indogrip/features/round/presentation/pages/edit/edit_round.dart';
import 'package:indogrip/features/round/presentation/pages/view/view_round.dart';
import 'package:indogrip/features/round/presentation/widgets/master_jumbo_roll_drowdown.dart';
import 'package:intl/intl.dart';

abstract class EditRoundBuilder extends State<EditRoundPanel> {
  late RoundBloc roundBloc;

  @override
  void initState() {
    roundBloc = RoundBloc(addRoundRepository: AddRoundRepository());
    super.initState();
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
  String? selectedCartonType;
  File? csvFile;

  formSubmit() {
    roundBloc.add(
      UpdateRoundRecordsEvent(
        addRoundParam: AddRoundParam(
          jumboRoll: selectedJumbo,
          rollSize: selectedSize ?? '',
          rollCore: selectedCore ?? '',
          round: roundController.text,
          meters: meterController.text,
          damagePieces: damagePiecesController.text,
          wastagePercentage: wastagePercentageController.text,
          conversionRate: conversionRateController.text,
          cartonType: selectedCartonType.toString(),
          rKey: widget.record.rKey,
        ),
      ),
    );
  }

  Widget get headerButton => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      SizedBox(
        width: MediaQuery.sizeOf(context).width * .18,
        child: DownloadClientFileButton(
          defaultFileName: 'import-round-sample.csv',
          csvURL: CSVUrls.roundCSVFilePath,
        ),
      ),
      SizedBox(
        width: MediaQuery.sizeOf(context).width * .18,
        child: UploadFileButton(),
      ),
    ],
  );

  // Form Validation Status
  bool isSubmitPressed = false;

  // Multi-select field variables
  List<String> selectedItems = [];

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
      Expanded(
        child: buildFormField('Wastage Percentage', [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ], wastagePercentageController),
      ),
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
        Row(
          spacing: 16,
          children: [
            Expanded(
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
          ],
        ),
        Row(
          spacing: 16,
          children: [
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
            Expanded(
              child: buildFormField('Wastage Percentage', [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ], wastagePercentageController),
            ),

            Expanded(
              child: buildFormField('Conversion Rate', [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ], conversionRateController),
            ),
          ],
        ),
        Row(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(width: 16),
            Expanded(
              child: buildFormField('Meters', [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ], meterController),
            ),
            Expanded(child: buildFormField('Round', [], roundController)),
          ],
        ),
        SizedBox(height: 50),
        Row(
          spacing: 16,
          children: [
            Expanded(child: SizedBox()),
            Expanded(child: SizedBox()),
            Expanded(child: addRoundButton()),
          ],
        ),
      ],
    ),
  );

  Widget addRoundButton() => BlocConsumer<RoundBloc, RoundState>(
    bloc: roundBloc,
    listener: (context, state) {
      if (state is UpdateRoundRecordsSuccessStatus) {
        if (state.successResponse.status == 1) {
          context.pushNamed(ViewRoundPanel.routeName);
          ToastService.instance.showSuccess(
            context,
            state.successResponse.message.toString(),
          );
        } else {
          ToastService.instance.showError(
            context,
            state.successResponse.message ?? 'try again later',
          );
        }
      }
      if (state is UpdateRoundRecordsFailureStatus) {
        ToastService.instance.showError(context, state.errorMessage);
      }
    },
    builder: (context, state) {
      if (state is RoundLoadingStatus) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }
      return CustomButton(label: 'Submit', onPressed: formSubmit);
    },
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
      children: [
        TextFieldlabelText(label),
        Container(
          margin: const EdgeInsets.only(top: 10),
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
