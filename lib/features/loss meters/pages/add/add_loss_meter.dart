import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/heading_text.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/features/loss%20meters/pages/add/add_lossmeter.dart';
import 'package:intl/intl.dart';

abstract class AddLossMeterBuilder extends State<AddLossMeterPanel> {
  final GlobalKey<ScaffoldState> stateKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey();

  // Form Controllers
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController registerDateController = TextEditingController();
  TextEditingController sizeMeterController = TextEditingController();
  TextEditingController courirMeterController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController billNoController = TextEditingController();

  // Form Values
  String? selectedJumboRoll;
  String? selectedCore;
  String? selectedBatch;

  // Form Validation Status
  bool isSubmitPressed = false;

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
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    dobController.clear();
    addressController.clear();
    registerDateController.clear();
    setState(() {
      selectedJumboRoll = null;
      selectedCore = null;
      selectedBatch = null;
      isSubmitPressed = false;
    });
  }

  //! Desktop View

  Widget get buildLossMeterSectionDesktop => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [buildSectionTitle('Select JumboRoll Details')],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: 10,
        ),
        child: Row(
          spacing: 16,
          children: [
            Expanded(
              flex: 2,
              child: buildDropdownField(
                'Select Jumbo Roll',
                ['Jumbo Roll 1', 'Jumbo Roll 2', 'Jumbo Roll 3'],
                selectedJumboRoll,
                (val) => setState(() => selectedJumboRoll = val),
              ),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [buildSectionTitle('Meter Details')],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: 10,
        ),
        child: Row(
          spacing: 16,
          children: [
            Expanded(
              child: buildFormField('Total Consume Meter', [
                FilteringTextInputFormatter.digitsOnly,
                // LengthLimitingTextInputFormatter(10),
              ], dobController),
            ),
            Expanded(
              child: buildFormField('Total Receive Meter', [
                FilteringTextInputFormatter.digitsOnly,
                // LengthLimitingTextInputFormatter(10),
              ], remarkController),
            ),
            Expanded(
              child: buildFormField('Loss Meters', [
                FilteringTextInputFormatter.digitsOnly,
                // LengthLimitingTextInputFormatter(10),
              ], remarkController),
            ),
          ],
        ),
      ),
    ],
  );

  //! Tablet View

  Widget get buildLossMeterSectionTablet => Column(
    spacing: 10,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [buildSectionTitle('Select JumboRoll Details')],
      ),
      // SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: 10,
        ),
        child: Row(
          children: [
            Expanded(
              child: buildDropdownField(
                'Select Jumbo Roll',
                ['Jumbo Roll 1', 'Jumbo Roll 2', 'Jumbo Roll 3'],
                selectedJumboRoll,
                (val) => setState(() => selectedJumboRoll = val),
              ),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [buildSectionTitle('Meter Details')],
      ),

      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: 10,
        ),
        child: Row(
          spacing: 16,
          children: [
            Expanded(
              child: buildFormField('Total Consume Meter', [
                FilteringTextInputFormatter.digitsOnly,
                // LengthLimitingTextInputFormatter(10),
              ], dobController),
            ),
            Expanded(
              child: buildFormField('Total Receive Meter', [
                FilteringTextInputFormatter.digitsOnly,
                // LengthLimitingTextInputFormatter(10),
              ], remarkController),
            ),
          ],
        ),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: 10,
        ),
        child: Row(
          children: [
            Expanded(
              child: buildFormField('Loss Meters', [
                FilteringTextInputFormatter.digitsOnly,
                // LengthLimitingTextInputFormatter(10),
              ], remarkController),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    ],
  );

  Widget get submitButton => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: kDefaultHorizontalPadding,
      vertical: 10,
    ),
    child: Row(
      spacing: 16,
      children: [
        if (Responsive.isDesktop(context)) Expanded(child: SizedBox()),

        Expanded(child: SizedBox()),
        Expanded(
          child: SizedBox(
            height: 48,
            child: CustomButton(
              label: 'Submit',
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  // TODO: Handle form submission
                }
              },
            ),
          ),
        ),
      ],
    ),
  );

  Widget buildFormSection(List<Widget> fields) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth =
              (constraints.maxWidth - 40) /
              3; // 3 columns max, 40px total spacing
          return Wrap(
            spacing: 20,
            runSpacing: 20,
            children:
                fields
                    .map((field) => SizedBox(width: itemWidth, child: field))
                    .toList(),
          );
        },
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
            hint: Text(label),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF2D8FCF),
            ),
            items:
                items
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
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
