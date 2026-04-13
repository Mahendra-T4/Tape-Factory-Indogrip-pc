import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/carton/data/models/add_carton_api_param.dart';
import 'package:indogrip/features/carton/presentation/bloc/carton_bloc.dart';
import 'package:indogrip/features/carton/presentation/pages/add/add_carton.dart';
import 'package:indogrip/features/carton/presentation/pages/view/view_carton.dart';
import 'package:indogrip/features/carton/presentation/widgets/master_carton_type.dart';
import 'package:indogrip/features/global/presentation/widget/vendor_list_widget.dart';
import 'package:intl/intl.dart';

abstract class AddCartonBuilder extends State<AddCartonPanel> {
  late CartonBloc cartonBloc;

  @override
  void initState() {
    cartonBloc = CartonBloc();
    super.initState();
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
          AddCartonOnRecordEvent(
            apiParams: CartonApiParams(
              cartonType: selectedCartonType.toString(),
              cartonDate: dataController.text,
              cartonQuantity: qntController.text,
              billNumber: billNumberController.text,
              vendorKey: selectedVendor,
              rKey: '',
              context: context,
            ),
          ),
        );
      }
    }
  }

  final GlobalKey<ScaffoldState> statekey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey();

  // Form Controllers
  TextEditingController dataController = TextEditingController();
  TextEditingController qntController = TextEditingController();
  TextEditingController billNumberController = TextEditingController();

  FocusNode dataFocusNode = FocusNode();
  FocusNode qntFocusNode = FocusNode();
  FocusNode billNumberFocusNode = FocusNode();

  // Form Values
  String? selectedCartonType;
  String? selectedCore;
  String? selectedBatch;

  // Form Validation Status
  bool isSubmitPressed = false;
  String? selectedVendor;
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
    dataController.clear();
    qntController.clear();
    billNumberController.clear();
    setState(() {
      selectedCartonType = null;
      selectedCore = null;
      selectedBatch = null;
      isSubmitPressed = false;
    });
  }

  Widget get vendorDropdown => Expanded(
    // flex: 2,
    child: VendorListWidget(
      value: selectedVendor,
      onChanged: (vendor) {
        setState(() {
          selectedVendor = vendor;
        });
      },
    ),
  );

  Widget get vendorWidgetTile => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: kDefaultHorizontalPadding,
      vertical: 30,
    ),
    child: Row(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        vendorDropdown,
        const Expanded(child: SizedBox()),
        if (Responsive.isDesktop(context)) const Expanded(child: SizedBox()),
      ],
    ),
  );

  //! Desktop View

  Widget get buildCartonInfoSectionDesktop => Column(
    spacing: 20,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: 10,
        ),
        child: Row(
          spacing: 16,
          children: [
            vendorDropdown,
            Expanded(child: buildDateField('Date', dataController)),
            Expanded(
              child: buildFormField('Bill No', [
                FilteringTextInputFormatter.digitsOnly,
                // LengthLimitingTextInputFormatter(10),
              ], billNumberController),
            ),
          ],
        ),
      ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   children: [buildSectionTitle('Carton Details')],
      // ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: 10,
        ),
        child: Row(
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
              child: buildFormField('Quantity', [
                FilteringTextInputFormatter.digitsOnly,
                // LengthLimitingTextInputFormatter(10),
              ], qntController),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    ],
  );

  //! Tablet View

  Widget get buildCartonInfoSectionTablet => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: 10,
        ),
        child: Row(
          spacing: 16,
          children: [
            vendorDropdown,
            Expanded(
              // flex: 2,
              child: MasterCartonTypeDropDown(
                selectCartonType: selectedCartonType,
                onChanged: (val) => setState(() => selectedCartonType = val),
              ),
            ),
            // Expanded(child: SizedBox()),
          ],
        ),
      ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   children: [buildSectionTitle('Carton Details')],
      // ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: 10,
        ),
        child: Row(
          spacing: 16,
          children: [
            Expanded(child: buildDateField('Date', dataController)),
            Expanded(
              child: buildFormField('Quantity', [
                FilteringTextInputFormatter.digitsOnly,
                // LengthLimitingTextInputFormatter(10),
              ], qntController),
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
          spacing: 16,
          children: [
            Expanded(
              child: buildFormField('Bill No', [
                FilteringTextInputFormatter.digitsOnly,
                // LengthLimitingTextInputFormatter(10),
              ], billNumberController),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    ],
  );

  Widget buildFormSection(List<Widget> fields) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth =
              (constraints.maxWidth - 48) /
              3; // 3 columns with consistent spacing
          return Wrap(
            spacing: 24,
            runSpacing: 24,
            children: fields
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
                    'yyyy-MM-dd',
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

  Widget buildSubmitBtn() => BlocConsumer(
    bloc: cartonBloc,
    listener: (context, state) {
      if (state is AddCartonOnRecordSuccessStatus) {
        if (state.addCartonEntity.status == 1) {
          context.pushNamed(ViewCartonPanel.routeName);
          ToastService.instance.showSuccess(
            context,
            state.addCartonEntity.message.toString(),
          );
        } else {
          ToastService.instance.showError(
            context,
            state.addCartonEntity.message ?? 'try again later',
          );
        }
      } else if (state is AddCartonOnRecordFailureStatus) {
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
          vertical: kDefaultVerticalPadding,
        ),
        child: Row(
          spacing: 16,
          children: [
            if (Responsive.isDesktop(context)) Expanded(child: SizedBox()),
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
