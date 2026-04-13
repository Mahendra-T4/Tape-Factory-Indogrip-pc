import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/extension/split_number_ext.dart';
import 'package:indogrip/core/ragex/regax.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/utils/widgets/custom_optional_field.dart';
import 'package:indogrip/core/utils/widgets/gen_validation_field.dart';
import 'package:indogrip/features/client/data/model/view_staff_api_param.dart';
import 'package:indogrip/features/staff/presentation/bloc/staff_bloc.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/features/staff/presentation/pages/edit/edit_add_staff_page.dart';
import 'package:indogrip/features/staff/presentation/widgets/access_panel_widget.dart';
import 'package:indogrip/features/staff/presentation/widgets/select_role_dropdown.dart';

abstract class EditStaffBuilder extends State<EditStaffDetailsPage> {
  late StaffBloc staffBloc;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    staffBloc = StaffBloc();

    // Prefill selected skills from the incoming model so the multi-select shows preselected values
    selectedSkills = List<String>.from(widget.editStaffModel.sAccessPanel);

    // Also prefill some basic form controllers from the model
    fNameController.text = widget.editStaffModel.sFName.toString();
    lNameController.text = widget.editStaffModel.sLName.toString();
    emailController.text = widget.editStaffModel.sEmailID.toString();
    pEmailController.text = widget.editStaffModel.sLoginEmailID.toString();
    mobNumberController.text = widget.editStaffModel.sMobileNumber
        .splitNumber();
    altMobController.text = widget.editStaffModel.sAltMobileNumber
        .splitNumber();
    selectedRole = widget.editStaffModel.sRole.toString();
    rights = selectedSkills.isEmpty ? [] : selectedSkills.join(',').split(',');
  }

  void _handleSubmit() {
    if (formKey.currentState!.validate()) {
      widget.editStaffModel.rKey.toString();
      staffBloc.add(
        UpdateStaffDetailsEvent(
          editStaffApiParam: EditStaffApiParam(
            uFirstName: fNameController.text,
            uLastName: lNameController.text,
            uEmail: emailController.text,
            uPersonalEmail: pEmailController.text,
            uMobileNumber: mobNumberController.text,
            uAlternateNumber: altMobController.text,
            uRole: selectedRole.toString(),
            uAccessPanel: selectedSkills.isEmpty
                ? widget.editStaffModel.sAccessPanel.join(',').split(',')
                : selectedSkills.join(',').split(','),
            uPassword: passwordController.text,
            uConfirmPassword: cPasswordController.text,
            rKey: widget.editStaffModel.rKey.toString(),
          ),
        ),
      );
    }
  }

  void submitForm() {
    _handleSubmit();
  }

  final ScrollController scrollController = ScrollController();
  List<String> selectedSkills = [];
  bool isAddressSame = false;
  List<String> rights = [];

  // State variables for required buttons
  bool isAddressSelected = false;
  bool isbankSelected = false;
  bool isIDProofSelected = false;
  bool isAgreementSelected = false;
  bool isOfferSelected = false;
  bool is10thMarksheetSelected = false;
  bool is12thMarksheetSelected = false;
  bool isGraduationSelected = false;

  String? selectedRole; // Added for role selection

  // State variable to track if "Submit" button was pressed
  bool isSubmitPressed = false;

  // Controllers and initial values
  TextEditingController joiningDateController = TextEditingController();
  TextEditingController contractDateController = TextEditingController();
  TextEditingController dobDateController = TextEditingController();
  TextEditingController careerDateController = TextEditingController();

  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pEmailController = TextEditingController();
  TextEditingController mobNumberController = TextEditingController();
  TextEditingController altMobController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  FocusNode fNameFocusNode = FocusNode();
  FocusNode lNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode pEmailFocusNode = FocusNode();
  FocusNode mobNumberFocusNode = FocusNode();
  FocusNode altMobFocusNode = FocusNode();
  FocusNode passwordFucusNode = FocusNode();
  FocusNode cPasswordFocusNode = FocusNode();

  var departmentValue,
      positionValue,
      genderValue,
      stateValue,
      cityValue,
      rStateValue,
      rCityValue,
      rAddressProofValue,
      bankValue,
      idProofValue,
      addressProofValue;
  bool isValue = false;

  Widget get alterMobileWidget => Expanded(
    child: GeneralOptionalField(
      spacing: 10,
      controller: altMobController,
      reg: Regex.phone,

      keyboardType: TextInputType.text,

      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (value == mobNumberController.text) {
            return 'Alternate Mobile Number should not be same as Mobile Number';
          }
          if (!RegExp(Regex.phone).hasMatch(value)) {
            return 'Please enter a valid 10-digit mobile number starting with 6-9';
          }
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      labelText: 'Alternate Number',
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
    ),
  );

  Widget get personalEmailField => Expanded(
    child: GeneralOptionalField(
      spacing: 10,
      controller: pEmailController,
      reg: Regex.email,

      keyboardType: TextInputType.emailAddress,

      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (value == emailController.text) {
            return 'Personal Email ID should not be same as Login Email ID';
          }
          if (!RegExp(Regex.email).hasMatch(value)) {
            return 'Please enter a valid email address';
          }
        }
        return null;
      },
      inputFormatters: [LengthLimitingTextInputFormatter(50)],
      labelText: 'Personal Email ID',
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
    ),
  );

  Widget buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),

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
    );
  }

  Widget buildFormRow(List<Widget> children) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .expand(
            (child) => [
              Expanded(child: child),
              if (child != children.last) const SizedBox(width: 24),
            ],
          )
          .toList(),
    );
  }

  Widget buildPermissionsSectionDesktop() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RoleSelector(
                      selectedRole: selectedRole,
                      onChanged: (String? value) {
                        setState(() {
                          selectedRole = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        const Text(
                          "Access Panel*",
                          style: TextStyle(
                            color: Color(0xFF3D475C),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: AccessPanelWidget(
                            onConfirm: (values) {
                              setState(() {
                                // Store the selected values
                                selectedSkills = values;
                                // Convert to comma-separated string for API
                                rights = values.join(',').split(',');
                              });
                            },
                            selectedSkills: selectedSkills,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (Responsive.isDesktop(context))
                    Expanded(child: SizedBox()),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                // const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldlabelText("Password*"),
                      formTextField(
                        passwordController,
                        '',
                        'Password must contain at least 8 characters, including uppercase, lowercase, number and special character.',
                        TextInputType.visiblePassword,
                        [
                          // // FilteringTextInputFormatter.allow(Regex.password),
                          // LengthLimitingTextInputFormatter(50),
                        ],
                        "Password",
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldlabelText("Confirm Password*"),
                      formTextField(
                        cPasswordController,
                        '',
                        'Password must contain at least 8 characters, including uppercase, lowercase, number and special character.',
                        TextInputType.visiblePassword,
                        [LengthLimitingTextInputFormatter(50)],
                        "Password",
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleSubmit(),
                      ),
                    ],
                  ),
                ),
                if (Responsive.isDesktop(context)) Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPermissionsSectionTablet() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Column(
        children: [
          // First row with Role Selector and Rights
          SizedBox(
            height: 100, // Specify a fixed height or adjust as needed
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RoleSelector(
                    selectedRole: selectedRole,
                    onChanged: (String? value) {
                      setState(() {
                        selectedRole = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Access Panel*",
                        style: TextStyle(
                          color: Color(0xFF3D475C),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: AccessPanelWidget(
                          onConfirm: (values) {
                            setState(() {
                              // Store the selected values
                              selectedSkills = values;
                              // Convert to comma-separated string for API
                              rights = values;
                            });
                          },
                          selectedSkills: selectedSkills,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Second row with Password field
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldlabelText("Password*"),
                    formTextField(
                      passwordController,
                      '',
                      'Enter password.',
                      TextInputType.visiblePassword,
                      [
                        // FilteringTextInputFormatter.allow(Regex.password),
                        // LengthLimitingTextInputFormatter(50),
                      ],
                      "Password",
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldlabelText("Confirm Password*"),
                    formTextField(
                      cPasswordController,
                      '',
                      'Enter password.',
                      TextInputType.visiblePassword,
                      [
                        // FilteringTextInputFormatter.allow(Regex.password),
                        // LengthLimitingTextInputFormatter(50),
                      ],
                      "Password",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //! Generate Row

  Widget generalRowDesktop() {
    return Column(
      children: [
        buildSectionTitle("General Details"),
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 40, right: 40),
          child: Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldlabelText("First Name*"),
                    formTextField(
                      fNameController,
                      Regex.name,
                      "Name should be 2-30 characters long and contain only letters",
                      TextInputType.name,
                      [
                        // FilteringTextInputFormatter.allow(Regex.name,),
                        LengthLimitingTextInputFormatter(30),
                      ],
                      "First Name",
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldlabelText("Last Name*"),
                    formTextField(
                      lNameController,
                      Regex.name,
                      'Name should be 2-30 characters long and contain only letters',
                      TextInputType.name,
                      [
                        // FilteringTextInputFormatter.allow(Regex.name),
                        LengthLimitingTextInputFormatter(50),
                      ],
                      "Last Name",
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldlabelText("Login Email ID*"),
                    formTextField(
                      emailController,
                      Regex.email,
                      "Please enter a valid email address",
                      TextInputType.emailAddress,
                      [
                        // FilteringTextInputFormatter.allow(Regex.email),
                        LengthLimitingTextInputFormatter(50),
                      ],
                      "Email ID",
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget passwordWidget() {
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: 21),
          formTextField(
            passwordController,
            '',
            'Enter password.',
            TextInputType.text,
            [
              // FilteringTextInputFormatter.allow(Regex.password),
              // LengthLimitingTextInputFormatter(50),
            ],
            "Password",
          ),
        ],
      ),
    );
  }

  Widget generalRowTablet() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Column(
        children: [
          buildSectionTitle("General Details"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldlabelText("First Name*"),
                          formTextField(
                            fNameController,
                            Regex.name,
                            "Enter only Alphabetical characters.",
                            TextInputType.name,
                            [
                              // FilteringTextInputFormatter.allow(Regex.name),
                              LengthLimitingTextInputFormatter(50),
                            ],
                            "First Name",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldlabelText("Last Name*"),
                          formTextField(
                            lNameController,
                            Regex.name,
                            'Enter only Alphabetical characters.',
                            TextInputType.name,
                            [
                              // FilteringTextInputFormatter.allow(Regex.name),
                              LengthLimitingTextInputFormatter(50),
                            ],
                            "Last Name",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldlabelText("Login Email ID*"),
                          formTextField(
                            emailController,
                            Regex.email,
                            "Please enter email id.",
                            TextInputType.emailAddress,
                            [
                              // FilteringTextInputFormatter.allow(Regex.email),
                              LengthLimitingTextInputFormatter(50),
                            ],
                            "Email ID",
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //! Personal Details Row

  Widget personalDetailsRowDesktop() {
    return Column(
      children: [
        buildSectionTitle("Personal Details"),
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 40, right: 40),
          child: Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              personalEmailField,

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldlabelText("Mobile*"),
                    formTextFieldMobile(
                      mobNumberController,
                      Regex.phone,

                      'Please enter a valid 10-digit mobile number starting with 6-9',
                      TextInputType.number,
                      [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],

                      "Mobile no",
                    ),
                  ],
                ),
              ),
              alterMobileWidget,
            ],
          ),
        ),
      ],
    );
  }

  Widget personalDetailsRowTablet() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Column(
        children: [
          buildSectionTitle("Personal Details"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomOptionalField(
                        labelText: 'Personal Email ID',
                        controller: pEmailController,
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [
                          // FilteringTextInputFormatter.allow(Regex.email),
                          LengthLimitingTextInputFormatter(50),
                        ],
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldlabelText("Mobile*"),
                          formTextFieldMobile(
                            mobNumberController,
                            Regex.phone,
                            'Please enter mobile number.',
                            TextInputType.number,
                            [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            "Mobile no",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldlabelText("Alternate Number"),
                          formTextFieldMobile(
                            altMobController,
                            Regex.phone,
                            'Please enter alternate number.',
                            TextInputType.number,
                            [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            "Alternate no",
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //! Permission and Rights Section
}
