import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/utils/widgets/heading_text.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/features/global/presentation/widget/vendor_list_widget.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/bloc/jumbo_roll_bloc.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/edit/edit_jump_roll.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/widgets/base_dropdown_widget.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/widgets/micron_dropdown_widget.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/widgets/width_dropdown_widget.dart';
import 'package:intl/intl.dart';

abstract class EditJumboRollBuilder extends State<EditJumboRollPanel> {
  late JumboRollBloc jumboRollBloc;

  @override
  void initState() {
    jumboRollBloc = JumboRollBloc();
    super.initState();
  }

  final GlobalKey<FormState> formKey = GlobalKey();

  final dateController = TextEditingController();
  final billNoController = TextEditingController();
  final rollNoController = TextEditingController();
  final lengthController = TextEditingController();
  final weightController = TextEditingController();
  final remarkController = TextEditingController();
  final amountPerKGController = TextEditingController();

  String? selectedWidth;
  String? selectedBase;
  String? selectedMic;
  String? selectedVendor;
  double squareMeter = 0.0;

  dynamic rKey;

  // Keep the same lists

  // Form Validation Status
  bool isSubmitPressed = false;

  Widget get buildAmountPerKg =>
      _buildTextField('Amount Per KG', [], amountPerKGController, maxLines: 1);

  Widget get vendorListWidget => UnconstrainedBox(
    child: SizedBox(
      width: 300, // Adjust this width as needed
      child: VendorListWidget(
        value: selectedVendor,
        onChanged: (vendor) {
          setState(() {
            selectedVendor = vendor;
          });
        },
      ),
    ),
  );

  //! Basic Details Section
  Widget get vendorWidgetTile => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    child: Row(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          // flex: 2,
          child: VendorListWidget(
            value: selectedVendor,
            onChanged: (vendor) {
              setState(() {
                selectedVendor = vendor;
              });
            },
          ),
        ),
        const Expanded(child: SizedBox()),
        if (Responsive.isDesktop(context)) const Expanded(child: SizedBox()),
      ],
    ),
  );

  //! Basic Details Section

  Widget buildBasicDetailsDesktop() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildDateField('Bill Date', dateController)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Bill No.', [
                      FilteringTextInputFormatter.digitsOnly,
                      // LengthLimitingTextInputFormatter(10),
                    ], billNoController),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Roll No. / Packet No.', [
                      FilteringTextInputFormatter.digitsOnly,
                      // LengthLimitingTextInputFormatter(10),
                    ], rollNoController),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBasicDetailsTablet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        buildSectionTitle("Basic Information"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Expanded(child: _buildDateField('Bill Date', dateController)),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField('Bill No.', [
                  FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ], billNoController),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Row(
            spacing: 16,
            children: [
              Expanded(
                child: _buildTextField('Roll No. / Packet No.', [
                  FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ], rollNoController),
              ),
              Expanded(child: buildSquareMeterDisplay()),
            ],
          ),
        ),
      ],
    );
  }

  //! Specifications Section
  Widget get buildSpecificationsDesktop => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: kDefaultVerticalPadding,
        ),
        child: IntrinsicHeight(
          child: Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: WidthDropdownWidget(
                  value: selectedWidth,

                  onChanged: (val) {
                    setState(() => selectedWidth = val);
                  },
                ),
              ),

              Expanded(
                child: BaseDropdownWidget(
                  value: selectedBase,
                  onChanged: (val) => setState(() => selectedBase = val),
                ),
              ),

              Expanded(
                child: MicronDropdownWidget(
                  value: selectedMic,

                  onChanged: (value) {
                    setState(() => selectedMic = value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget get buildSpecificationsTablet => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          // vertical: kDefaultVerticalPadding,
        ),
        child: Column(
          spacing: 10,
          children: [
            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: BaseDropdownWidget(
                    value: selectedBase,
                    onChanged: (val) => setState(() => selectedBase = val),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: MicronDropdownWidget(
                    value: selectedMic,

                    onChanged: (value) {
                      setState(() => selectedMic = value);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );

  //! Measurements Section

  Widget get buildMeasurementsDesktop => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: kDefaultHorizontalPadding,
      // vertical: kDefaultVerticalPadding,
    ),
    child: Row(
      children: [
        Expanded(
          child: _buildTextField(
            'Length',
            [
              FilteringTextInputFormatter.digitsOnly,
              // LengthLimitingTextInputFormatter(10),
            ],

            lengthController,
            onChanged: (val) => _calculateSquareMeter(),
          ),
        ),

        const SizedBox(width: 16),
        Expanded(
          child: _buildTextField('Net Weight', [
            FilteringTextInputFormatter.digitsOnly,
            // LengthLimitingTextInputFormatter(10),
          ], weightController),
        ),
        const SizedBox(width: 16),
        Expanded(child: buildAmountPerKg),
      ],
    ),
  );

  Widget get buildMeasurementsTablet => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: kDefaultVerticalPadding,
        ),
        child: Row(
          spacing: 16,
          children: [
            Expanded(
              child: _buildTextField(
                'Length',
                [
                  FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ],

                lengthController,
                onChanged: (val) => _calculateSquareMeter(),
              ),
            ),

            Expanded(
              child: WidthDropdownWidget(
                value: selectedWidth,

                onChanged: (val) {
                  setState(() => selectedWidth = val);
                },
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          // vertical: kDefaultVerticalPadding,
        ),
        child: Row(
          spacing: 16,
          children: [
            Expanded(
              child: _buildTextField('Net Weight', [
                FilteringTextInputFormatter.digitsOnly,
                // LengthLimitingTextInputFormatter(10),
              ], weightController),
            ),
            Expanded(child: buildRemark),
          ],
        ),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,

          vertical: kDefaultVerticalPadding,
        ),
        child: Row(
          spacing: 16,
          children: [
            Expanded(child: buildAmountPerKg),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    ],
  );

  Widget get buildRemark =>
      _buildTextField('Remark', [], remarkController, maxLines: 1);

  Widget get buidlRemarkDesktop => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: kDefaultHorizontalPadding,
      vertical: kDefaultVerticalPadding,
    ),
    child: Row(
      spacing: 16,
      children: [
        Expanded(child: buildRemark),
        Expanded(child: SizedBox()),
        Expanded(child: SizedBox()),
      ],
    ),
  );

  void _calculateSquareMeter() {
    if (selectedWidth != null && lengthController.text.isNotEmpty) {
      setState(() {
        squareMeter =
            (double.parse(selectedWidth!) *
                double.parse(lengthController.text)) /
            1000;
      });
    }
    // return squareMeter.toInt();
  }

  void submitForm() {
    if (formKey.currentState?.validate() ?? false) {}
  }

  // Helper Widgets
  Widget _buildTextField(
    String label,
    List<TextInputFormatter>? inputFormatters,
    TextEditingController controller, {
    int maxLines = 1,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldlabelText(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter $label' : null,
        ),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldlabelText(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              controller.text = DateFormat('yyyy-MM-dd').format(date);
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please select date' : null,
        ),
      ],
    );
  }

  Widget buildSquareMeterDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldlabelText('Square Meter'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(squareMeter.toString()),
              // Text(
              //   squareMeter.toStringAsFixed(2),
              //   // style: const TextStyle(fontWeight: FontWeight.bold),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildFormSection(List<Widget> fields) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 2),
          ...fields
              .expand(
                (field) => [
                  Expanded(flex: 14, child: field),
                  const Spacer(flex: 1),
                ],
              )
              .toList(),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget buildFormField(
    String label,
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
}
