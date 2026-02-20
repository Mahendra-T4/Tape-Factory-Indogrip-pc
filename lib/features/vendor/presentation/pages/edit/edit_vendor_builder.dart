import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/ragex/regax.dart';
import 'package:indogrip/core/utils/widgets/custom_optional_field.dart';
import 'package:indogrip/core/utils/widgets/gen_validation_field.dart';
import 'package:indogrip/core/utils/widgets/heading_text.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/features/vendor/presentation/pages/edit/edit_vendor.dart';
import 'package:indogrip/features/vendor/presentation/widgets/vendor_fields.dart';

abstract class EditVendorPanelBuilder extends State<EditVendorPanel> {
  final TextEditingController cNameController = TextEditingController();
  final TextEditingController cMobileNumberController = TextEditingController();
  final TextEditingController cAlterMobileNumberController =
      TextEditingController();
  final TextEditingController cGSTINController = TextEditingController();
  final TextEditingController oOwnerNameContoller = TextEditingController();
  final TextEditingController oMobileNumberController = TextEditingController();
  final TextEditingController oAlterMobileNumberController =
      TextEditingController();
  final TextEditingController rManagerNameController = TextEditingController();
  final TextEditingController rManagerMobileNumberController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();
  final TextEditingController rManagerAlterMobileNumberController =
      TextEditingController();
  @override
  void dispose() {
    // customerNameController.dispose();
    // personNameController.dispose();
    // mobileNumberController.dispose();
    // alternateMobileController.dispose();
    // gstinController.dispose();
    super.dispose();
  }

  Widget get cAlterMobileField => Expanded(
    child: GeneralOptionalField(
      controller: cAlterMobileNumberController,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (value == cMobileNumberController.text) {
            return "Alternate number cannot be same as Client Mobile Number";
          }
          if (!RegExp(Regex.phone).hasMatch(value)) {
            return 'Enter valid 10-digit mobile number starting with 6-9';
          }
        }
        return null;
      },
      keyboardType: TextInputType.name,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      labelText: 'Alternate Mobile',
    ),
  );

  Widget get oAlternateMobileNumberField => Expanded(
    child: CustomOptionalField(
      spacing: 10,
      validator: (value) {
        if (value!.isNotEmpty || RegExp(Regex.phone).hasMatch(value)) {
          if (value == oMobileNumberController.text) {
            return "Alternate number cannot be same as Owner Mobile Number";
          }
        }
        return null;
      },
      controller: oAlterMobileNumberController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      labelText: "Alternate Mobile Number",

      sameValueError: "Alternate number cannot be same as Owner Mobile Number",
    ),
  );

  Widget get pAlternateMobileNumberField => Expanded(
    child: CustomOptionalField(
      spacing: 10,
      controller: rManagerAlterMobileNumberController,
      validator: (value) {
        if (value!.isNotEmpty || RegExp(Regex.phone).hasMatch(value)) {
          if (value == rManagerMobileNumberController.text) {
            return "Alternate number cannot be same as Owner Mobile Number";
          }
        }
        return null;
      },
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      labelText: "Alternate Mobile Number",

      sameValueError: "Alternate number cannot be same as Owner Mobile Number",
    ),
  );

  Widget get companyNameField => Expanded(
    child: GeneralOptionalField(
      spacing: 10,
      controller: cNameController,
      reg: Regex.name,

      keyboardType: TextInputType.text,
      validator: (value) {
        final v = value?.trim() ?? '';
        if (value == null || value.isEmpty) {
          return 'Company Name is required';
        }
        if (v.isEmpty) return null; // optional field: no input -> valid
        // Disallow digits
        if (RegExp(r'\d').hasMatch(v)) {
          return 'Digits are not allowed in name';
        }
        // Enforce length 2..30
        if (v.length < 2 || v.length > 30) {
          return 'Name must be 2-30 characters';
        }
        // Allow letters, spaces and common punctuation (- ' . ,)
        if (!RegExp(r"^[A-Za-z][A-Za-z\s\-\.'(),]{1,29}").hasMatch(v)) {
          return 'Name contains invalid characters';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\d')),
        // LengthLimitingTextInputFormatter(30),
      ],
      labelText: 'Company Name*',
    ),
  );

  Widget get companyMobileField => Expanded(
    child: GeneralOptionalField(
      spacing: 10,
      controller: cMobileNumberController,
      reg: Regex.phone,

      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Company Mobile is required';
        }
        if (!RegExp(Regex.phone).hasMatch(value)) {
          return 'Mobile Number must be 10 digits';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      labelText: 'Mobile Number*',
      regReturn: '',
    ),
  );

  Widget get gstinWidget => Expanded(
    child: GeneralOptionalField(
      spacing: 10,
      controller: cGSTINController,
      reg: '',
      regReturn: "Enter Valid Owner Name",
      keyboardType: TextInputType.text,
      inputFormatters: [
        // FilteringTextInputFormatter.digitsOnly,
        // LengthLimitingTextInputFormatter(50),
      ],
      labelText: 'GSTIN',
    ),
  );

  Widget get ownerNameField => Expanded(
    child: GeneralOptionalField(
      spacing: 10,
      controller: oOwnerNameContoller,
      keyboardType: TextInputType.text,
      validator: (value) {
        final v = value?.trim() ?? '';
        if (v.isEmpty) return null; // optional field: no input -> valid
        // Disallow digits
        if (RegExp(r'\d').hasMatch(v)) {
          return 'Digits are not allowed in name';
        }
        // Enforce length 2..30
        if (v.length < 2 || v.length > 30) {
          return 'Name must be 2-30 characters';
        }
        // Allow letters, spaces and common punctuation (- ' . ,)
        if (!RegExp(r"^[A-Za-z][A-Za-z\s\-\.'(),]{1,29}").hasMatch(v)) {
          return 'Name contains invalid characters';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\d')),
        // LengthLimitingTextInputFormatter(30),
      ],
      labelText: 'Owner Name',
    ),
  );

  Widget get ownerMobileField => Expanded(
    child: GeneralOptionalField(
      spacing: 10,
      controller: oMobileNumberController,
      reg: Regex.name,
      regReturn:
          "Name must be 3-30 characters and contain only letters and spaces",
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isNotEmpty) {
          if (!RegExp(Regex.phone).hasMatch(value)) {
            return 'Mobile Number must be 10 digits';
          }
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      labelText: 'Mobile Number',
    ),
  );

  Widget get rManagerNameField => Expanded(
    child: GeneralOptionalField(
      spacing: 10,
      controller: rManagerNameController,

      keyboardType: TextInputType.text,
      validator: (value) {
        final v = value?.trim() ?? '';
        if (v.isEmpty) return null; // optional field: no input -> valid
        // Disallow digits
        if (RegExp(r'\d').hasMatch(v)) {
          return 'Digits are not allowed in name';
        }
        // Enforce length 2..30
        if (v.length < 2 || v.length > 30) {
          return 'Name must be 2-30 characters';
        }
        // Allow letters, spaces and common punctuation (- ' . ,)
        if (!RegExp(r"^[A-Za-z][A-Za-z\s\-\.'(),]{1,29}").hasMatch(v)) {
          return 'Name contains invalid characters';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\d')),
        // LengthLimitingTextInputFormatter(30),
      ],
      labelText: 'Representative Name',
    ),
  );

  Widget get rManagerMobileField => Expanded(
    child: GeneralOptionalField(
      spacing: 10,
      controller: rManagerMobileNumberController,
      reg: Regex.phone,

      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isNotEmpty) {
          if (!RegExp(Regex.phone).hasMatch(value)) {
            return 'Mobile must be 10 digits';
          }
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      labelText: 'Mobile Number',
    ),
  );

  //! client info section

  Widget vendorInfoSectionDesktop() {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle("Vendor Information"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            spacing: 16,
            children: [companyNameField, companyMobileField, cAlterMobileField],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            spacing: 16,
            children: [
              gstinWidget,
              Expanded(child: SizedBox()),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ],
    );
  }

  Widget vendorInfoSectionTablet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle("Vendor Information"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldlabelText("Company Name*"),
                      formTextFieldVendor(
                        '[a-zA-Z ]+',
                        "",
                        [],
                        TextInputType.name,

                        controller: cNameController,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldlabelText("Mobile Number*"),
                      formTextFieldVendor(
                        '[0-9]{10}',
                        "",
                        [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],

                        TextInputType.phone,

                        controller: cMobileNumberController,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldlabelText("GSTIN*"),
                      formTextFieldVendor(
                        '',
                        "",
                        [],
                        TextInputType.text,
                        controller: cGSTINController,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ],
    );
  }

  //! owner info section

  Widget ownerInfoDesktop() {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle("Owner Information"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ownerNameField,

              ownerMobileField,

              oAlternateMobileNumberField,
            ],
          ),
        ),
      ],
    );
  }

  //! purchase manager section

  Widget purchaseManagerSectionDesktop() {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle("Representative Information"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              rManagerNameField,
              rManagerMobileField,

              pAlternateMobileNumberField,
            ],
          ),
        ),
      ],
    );
  }
}
