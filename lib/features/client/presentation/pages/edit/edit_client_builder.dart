import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/ragex/regax.dart';
import 'package:indogrip/core/utils/widgets/custom_optional_field.dart';
import 'package:indogrip/core/utils/widgets/gen_validation_field.dart';
import 'package:indogrip/core/utils/widgets/heading_text.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/features/client/presentation/pages/edit/edit_client.dart';

abstract class EditClientBuilder extends State<EditClient> {
  final TextEditingController cNameController = TextEditingController();
  final TextEditingController cMobileNumberController = TextEditingController();
  final TextEditingController cAlterMobileNumberController =
      TextEditingController();
  final TextEditingController cGSTINController = TextEditingController();
  final TextEditingController oOwnerNameContoller = TextEditingController();
  final TextEditingController oMobileNumberController = TextEditingController();
  final TextEditingController oAlterMobileNumberController =
      TextEditingController();
  final TextEditingController pManagerNameController = TextEditingController();
  final TextEditingController pManagerMobileNumberController =
      TextEditingController();
  final TextEditingController pAlterManagerMobileNumberController =
      TextEditingController();
  // final TextEditingController gstinController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPassController = TextEditingController();

  final TextEditingController unit1Controller = TextEditingController();
  final TextEditingController unit2Controller = TextEditingController();
  final TextEditingController unit3Controller = TextEditingController();
  final TextEditingController unit4Controller = TextEditingController();
  final TextEditingController unit5Controller = TextEditingController();

  @override
  void dispose() {
    // Client Information
    cNameController.dispose();
    cMobileNumberController.dispose();
    cGSTINController.dispose();
    cAlterMobileNumberController.dispose();

    // Owner Information
    oOwnerNameContoller.dispose();
    oMobileNumberController.dispose();
    oAlterMobileNumberController.dispose();

    // Purchase Manager Information
    pManagerNameController.dispose();
    pManagerMobileNumberController.dispose();
    pAlterManagerMobileNumberController.dispose();

    // Password Controllers
    passwordController.dispose();
    cPassController.dispose();

    super.dispose();
  }

  // Widget get loadUnitDataInController => widget.param.unit

  Widget get oAlternateMobileNumberField => Expanded(
    child: Padding(
      padding: const EdgeInsets.only(top: 12),
      child: CustomOptionalField(
        spacing: 10,

        controller: oAlterMobileNumberController,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        labelText: "Alternate Mobile Number",
        compareController: oMobileNumberController,
        sameValueError:
            "Alternate number cannot be same as Owner Mobile Number",
      ),
    ),
  );

  Widget get gstinField => Expanded(
    child: GeneralOptionalField(
      controller: cGSTINController,
      reg: Regex.phone,
      regReturn: "Enter Valid GSTIN",
      keyboardType: TextInputType.text,
      inputFormatters: [
        // FilteringTextInputFormatter.digitsOnly,
        // LengthLimitingTextInputFormatter(10),
      ],
      labelText: "Enter GSTIN",
    ),
  );

  Widget get pAlternateMobileNumberField => Expanded(
    child: CustomOptionalField(
      spacing: 10,
      controller: pAlterManagerMobileNumberController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      labelText: "Alternate Mobile Number",
      compareController: pManagerMobileNumberController,
      sameValueError: "Alternate number cannot be same as Owner Mobile Number",
    ),
  );

  Widget get ownerNameField => Expanded(
    child: Padding(
      padding: const EdgeInsets.only(top: 13),
      child: GeneralOptionalField(
        spacing: 10,
        controller: oOwnerNameContoller,
        validator: (value) {
          final v = value?.trim() ?? '';
          if (v.isEmpty) return null; // optional field: no input -> valid
          // Disallow digits
          if (RegExp(r'\d').hasMatch(v)) {
            return 'Digits are not allowed in name';
          }
          // Enforce length 2..30
          if (v.length < 2) {
            return 'Name must be 3 characters';
          }
          // Allow letters, spaces and common punctuation (- ' . ,)
          if (!RegExp(r"^[A-Za-z][A-Za-z\s\-\.'(),]{1,29}").hasMatch(v)) {
            return 'Name contains invalid characters';
          }
          return null;
        },
        keyboardType: TextInputType.name,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\d')),
          LengthLimitingTextInputFormatter(30),
        ],
        labelText: 'Owner Name',
      ),
    ),
  );

  Widget get unit1 => Expanded(
    child: GeneralOptionalField(
      controller: unit1Controller,
      reg: Regex.name,

      regReturn: "",
      keyboardType: TextInputType.name,
      inputFormatters: [
        // FilteringTextInputFormatter.,
        // LengthLimitingTextInputFormatter(10),
      ],
      labelText: 'Unit-One',
    ),
  );
  Widget get unit2 => Expanded(
    child: GeneralOptionalField(
      controller: unit2Controller,
      reg: Regex.name,

      regReturn: "",
      keyboardType: TextInputType.name,
      inputFormatters: [
        // FilteringTextInputFormatter.,
        // LengthLimitingTextInputFormatter(10),
      ],
      labelText: 'Unit-Two',
    ),
  );

  Widget get unit3 => Expanded(
    child: GeneralOptionalField(
      controller: unit3Controller,
      reg: Regex.name,

      regReturn: "",
      keyboardType: TextInputType.name,
      inputFormatters: [
        // FilteringTextInputFormatter.,
        // LengthLimitingTextInputFormatter(10),
      ],
      labelText: 'Unit-Three',
    ),
  );

  Widget get unit4 => Expanded(
    child: GeneralOptionalField(
      controller: unit4Controller,
      reg: Regex.name,

      regReturn: "",
      keyboardType: TextInputType.name,
      inputFormatters: [
        // FilteringTextInputFormatter.,
        // LengthLimitingTextInputFormatter(10),
      ],
      labelText: 'Unit-Four',
    ),
  );

  Widget get unit5 => Expanded(
    child: GeneralOptionalField(
      controller: unit5Controller,
      reg: Regex.name,

      regReturn: "",
      keyboardType: TextInputType.name,
      inputFormatters: [
        // FilteringTextInputFormatter.,
        // LengthLimitingTextInputFormatter(10),
      ],
      labelText: 'Unit-Five',
    ),
  );

  Widget get unitWidget => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 20,
    children: [
      buildSectionTitle("Units"),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(spacing: 16, children: [unit1, unit2, unit3]),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          spacing: 16,
          children: [
            unit4,
            unit5,
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    ],
  );

  Widget get ownerMobileField => Expanded(
    child: Padding(
      padding: const EdgeInsets.only(top: 12),
      child: GeneralOptionalField(
        controller: oMobileNumberController,
        reg: Regex.phone,
        regReturn: "Enter Valid Owner Mobile Number",
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        labelText: 'Owner Mobile Number',
      ),
    ),
  );

  Widget get clientMobileField => Expanded(
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: GeneralOptionalField(
        controller: cMobileNumberController,
        reg: Regex.phone,
        regReturn: "Enter Valid Mobile Number",
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        labelText: 'Mobile Number',
      ),
    ),
  );

  Widget get pManagerField => Expanded(
    child: GeneralOptionalField(
      controller: pManagerNameController,
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
      keyboardType: TextInputType.name,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\d')),
        LengthLimitingTextInputFormatter(30),
      ],
      labelText: 'Purchase Manager Name',
    ),
  );

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

  Widget get consigneeNameField => Expanded(
    child: GeneralOptionalField(
      spacing: 10,
      controller: cNameController,
      validator: (value) {
        final v = value?.trim() ?? '';
        if (value == null || value.isEmpty) {
          return 'Company Name is required';
        }

        // Disallow digits
        if (RegExp(r'\d').hasMatch(v)) {
          return 'Digits are not allowed in name';
        }
        // Enforce length 2..30
        if (v.length < 2) {
          return 'Name must be 3 characters';
        }
        // Allow letters, spaces and common punctuation (- ' . ,)
        if (!RegExp(r"^[A-Za-z][A-Za-z\s\-\.'(),]{1,29}").hasMatch(v)) {
          return 'Name contains invalid characters';
        }
        return null;
      },

      keyboardType: TextInputType.text,

      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\d')),
        // LengthLimitingTextInputFormatter(30),
      ],
      labelText: 'Consignee Name*',
    ),
  );

  Widget get pManagerMobileNumberField => Expanded(
    child: GeneralOptionalField(
      controller: pManagerMobileNumberController,
      reg: Regex.phone,

      regReturn: "Enter valid 10-digit mobile number starting with 6-9",
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      labelText: 'Purchase Manager Mobile Number',
    ),
  );

  //! client info section

  Widget clientInfoSectionDesktop() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle("Client Information"),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            spacing: 16,
            children: [
              consigneeNameField,
              clientMobileField,
              // clientMobileField,
              cAlterMobileField,
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            spacing: 16,
            children: [
              gstinField,
              Expanded(child: SizedBox()),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ],
    );
  }

  Widget clientInfoSectionTablet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle("Client Information"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldlabelText("Consignee Name*"),
                    formTextField(
                      cNameController,
                      Regex.name,
                      "Enter Consignee Name",
                      TextInputType.name,
                      [
                        // FilteringTextInputFormatter.allow(Regex.name),
                        LengthLimitingTextInputFormatter(50),
                      ],
                      'Consignee Name',
                    ),
                  ],
                ),
              ),
              clientMobileField,
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              gstinField,
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
              // SizedBox(width: 16),
              ownerMobileField,
              oAlternateMobileNumberField,
            ],
          ),
        ),
      ],
    );
  }

  Widget ownerInfoTablet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle("Owner Information"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ownerNameField, ownerMobileField],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              oAlternateMobileNumberField,
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ],
    );
  }

  //! purchase manager section

  Widget purchaseManagerSectionDesktop() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle("Purchase Manager Information"),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            spacing: 13,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pManagerField,

              pManagerMobileNumberField,

              pAlternateMobileNumberField,
            ],
          ),
        ),
      ],
    );
  }

  Widget purchaseManagerSectionTablet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle("Purchase Manager Information"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [pManagerField, pManagerMobileNumberField],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pAlternateMobileNumberField,
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ],
    );
  }
}
