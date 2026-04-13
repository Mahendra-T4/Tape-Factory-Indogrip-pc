import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/heading_text.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/domain/repositories/global_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/vendor_list_widget.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/jumbo_api_params.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/bloc/jumbo_roll_bloc.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/add/add_jumbo_roll.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/view/view_jumbo_roll.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/widgets/base_dropdown_widget.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/widgets/micron_dropdown_widget.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/widgets/width_dropdown_widget.dart';
import 'package:intl/intl.dart';

abstract class AddJumboRollBuilder extends State<AddJumboRollPanel> {
  late JumboRollBloc _jumboRollBloc;
  late final GlobalBloc _globalBloc;
  File? csvFile;

  formSubmit() {
    if (validateForm()) {
      final apiParams = JumboRollApiParams(
        billDate: _dateController.text,
        billNumber: _billNoController.text,
        rollNumber: _rollNoController.text,
        length: _lengthController.text,
        width: selectedWidth ?? '',
        base: selectedBase ?? '',
        mic: selectedMic ?? '',
        netWeight: _weightController.text,
        remark: _remarkController.text,
        context: context,
        vendorKey: selectedVendor.toString(),
        amountPerKG: amountPerKGController.text,
      );
      _jumboRollBloc.add(AddJumboRollOnRecordEvent(apiParams: apiParams));
    }
  }

  @override
  void initState() {
    _jumboRollBloc = JumboRollBloc();
    _globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    super.initState();
  }

  final GlobalKey<FormState> formKey = GlobalKey();

  final _dateController = TextEditingController();
  final _billNoController = TextEditingController();
  final _rollNoController = TextEditingController();
  final _lengthController = TextEditingController();
  final _weightController = TextEditingController();
  final _remarkController = TextEditingController();
  final amountPerKGController = TextEditingController();
  final importFileDateController = TextEditingController();

  String? selectedWidth;
  String? selectedBase;
  String? selectedMic;
  String? selectedVendor;
  double squareMeter = 0.0;

  // Keep the same lists

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

  Widget customAlertBoxWidget() => AlertDialog(
    titlePadding: EdgeInsets.zero,
    title: Container(
      width: 550,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.sticky_note_2, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          const Text(
            'Sticker Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => context.pop(),
          ),
        ],
      ),
    ),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sure you want to Upload this File?'),
          const SizedBox(height: 16),
          vendorListWidget,
          const SizedBox(height: 16),
          _buildDateField('Bill Date', importFileDateController),
        ],
      ),
    ),
    contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
    actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
    actions: [
      Row(
        children: [
          TextButton(
            onPressed: () => context.pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Close'),
          ),
          // uploadButton,
        ],
      ),
    ],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    backgroundColor: Colors.white,
  );

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
    padding: const EdgeInsets.symmetric(
      horizontal: kDefaultHorizontalPadding,
      vertical: 30,
    ),
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
                  Expanded(
                    child: _buildDateField('Bill Date', _dateController),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Bill No.', [
                      FilteringTextInputFormatter.digitsOnly,
                      // LengthLimitingTextInputFormatter(10),
                    ], _billNoController),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Roll No. / Packet No.', [
                      FilteringTextInputFormatter.digitsOnly,
                      // LengthLimitingTextInputFormatter(10),
                    ], _rollNoController),
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
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultHorizontalPadding,
            vertical: 10,
          ),
          child: Row(
            children: [
              Expanded(child: _buildDateField('Bill Date', _dateController)),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField('Bill No.', [
                  FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ], _billNoController),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultHorizontalPadding,
            vertical: 30,
          ),
          child: Row(
            spacing: 16,
            children: [
              Expanded(
                child: _buildTextField('Roll No. / Packet No.', [
                  FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ], _rollNoController),
              ),
              Expanded(
                child: BaseDropdownWidget(
                  value: selectedBase.toString(),
                  onChanged: (val) => setState(() => selectedBase = val),
                ),
              ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: WidthDropdownWidget(
                  value: selectedWidth,
                  onChanged: (val) {
                    setState(() => selectedWidth = val);
                    // _calculateSquareMeter();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: BaseDropdownWidget(
                  value: selectedBase.toString(),
                  onChanged: (val) => setState(() => selectedBase = val),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MicronDropdownWidget(
                  value: selectedMic.toString(),
                  onChanged: (val) => setState(() => selectedMic = val),
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
                // const SizedBox(width: 16),
                Expanded(
                  child: MicronDropdownWidget(
                    value: selectedMic.toString(),
                    onChanged: (val) => setState(() => selectedMic = val),
                  ),
                ),
                Expanded(
                  child: WidthDropdownWidget(
                    value: selectedWidth,
                    onChanged: (val) {
                      setState(() => selectedWidth = val);
                      // _calculateSquareMeter();
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
      spacing: 16,
      children: [
        Expanded(
          child: _buildTextField(
            'Length',
            [
              FilteringTextInputFormatter.digitsOnly,
              // LengthLimitingTextInputFormatter(10),
            ],

            _lengthController,
            // onChanged: (val) => _calculateSquareMeter(),
          ),
        ),

        Expanded(
          child: _buildTextField('Net Weight', [
            FilteringTextInputFormatter.digitsOnly,
            // LengthLimitingTextInputFormatter(10),
          ], _weightController),
        ),
        Expanded(child: buildAmountPerKgField),
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

                _lengthController,
                // onChanged: (val) => _calculateSquareMeter(),
              ),
            ),
            Expanded(
              child: _buildTextField('Net Weight', [
                FilteringTextInputFormatter.digitsOnly,
                // LengthLimitingTextInputFormatter(10),
              ], _weightController),
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
            Expanded(child: buildRemark),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
      SizedBox(height: 25),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          // vertical: kDefaultVerticalPadding,
        ),
        child: Row(
          spacing: 16,
          children: [
            Expanded(child: buildAmountPerKgField),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    ],
  );

  Widget get buildRemark =>
      _buildTextField('Remark', [], _remarkController, maxLines: 1);
  // Widget get buildAmountPerKg =>

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

  Widget buildSubmitButton() {
    return BlocConsumer(
      bloc: _jumboRollBloc,
      listener: (context, state) {
        if (state is AddJumboRollOnRecordSuccessStatus) {
          if (state.jumboRoleEntity.status == 1) {
            context.pushNamed(ViewJumboRollPanel.routeName);
            if (!context.mounted) return;
            ToastService.instance.showSuccess(
              context,
              state.jumboRoleEntity.message.toString(),
            );
          } else {
            if (!context.mounted) return;
            ToastService.instance.showError(
              context,
              state.jumboRoleEntity.message ?? 'try again later',
            );
          }
        } else if (state is AddJumboRollOnRecordFailureStatus) {
          if (!context.mounted) return;
          ToastService.instance.showError(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is JumboRollLoadingStatus) {
          return const Center(child: CircularProgressIndicator());
        }
        return Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.25,
            child: CustomButton(
              label: 'Submit',
              onPressed: () {
                if (validateForm()) {
                  final apiParams = JumboRollApiParams(
                    billDate: _dateController.text,
                    billNumber: _billNoController.text,
                    rollNumber: _rollNoController.text,
                    length: _lengthController.text,
                    width: selectedWidth ?? '',
                    base: selectedBase ?? '',
                    mic: selectedMic ?? '',
                    netWeight: _weightController.text,
                    remark: _remarkController.text,
                    context: context,
                    vendorKey: selectedVendor.toString(),
                    amountPerKG: amountPerKGController.text,
                  );
                  _jumboRollBloc.add(
                    AddJumboRollOnRecordEvent(apiParams: apiParams),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget get buildAmountPerKgField => Consumer(
    builder: (context, ref, child) {
      final setting = ref.watch(settingProvider);
      return setting.when(
        data: (data) {
          if (data.status == 1)
            amountPerKGController.text = data.record!.first.amountPerKG
                .toString();
          return data.status != 1
              ? Center(child: Text(data.message.toString()))
              : _buildTextField('Amount Per Kg', [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ], amountPerKGController);
        },
        error: (error, stackTrace) => SizedBox.shrink(),
        loading: () => Center(child: CircularProgressIndicator.adaptive()),
      );
    },
  );

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
        Row(
          children: [
            Icon(Icons.square_foot, color: Colors.blue[300], size: 20),
            const SizedBox(width: 8),
            TextFieldlabelText('Square Meter'),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.04),
            border: Border.all(color: Colors.blue[100] ?? Colors.blue),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.calculate, color: Colors.blue[200], size: 20),
              const SizedBox(width: 14),
              Text(
                squareMeter.toStringAsFixed(2),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF2C3E50),
                  letterSpacing: 1.1,
                ),
              ),
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
            hint: Text('Select $label'),
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
