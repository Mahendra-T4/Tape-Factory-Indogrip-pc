import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/ragex/regax.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/dimens.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/custom_optional_field.dart';
import 'package:indogrip/core/utils/widgets/gen_validation_field.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
// import 'package:indogrip/core/utils/widgets/text_field_option.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/presentation/widget/alternate_tf.dart';
import 'package:indogrip/features/staff/data/models/add_staff_param.dart';
import 'package:indogrip/features/staff/presentation/bloc/staff_bloc.dart';
import 'package:indogrip/features/staff/presentation/pages/add/add_statff.dart';
import 'package:indogrip/features/staff/presentation/pages/view/view_staff.dart';
import 'package:indogrip/features/staff/presentation/widgets/access_panel_widget.dart';
import 'package:indogrip/features/staff/presentation/widgets/select_role_dropdown.dart';

abstract class AddStaffBuilder extends ConsumerState<AddStaff> {
  late StaffBloc staffBloc;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    staffBloc = StaffBloc();
    super.initState();
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
  String selectedStatus = 'Active'; // Default status

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
  bool isShowPass = true;
  bool isShowConfirm = true;

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

  Widget get tabletChangePasswordTab {
    // Size size = MediaQuery.sizeOf(context);
    return Row(
      spacing: 16,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Password*",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColourPalette.textFieldLabelColor,
                  fontSize: Dimens.textFieldLabelFontSize,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: isShowPass,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).nextFocus();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter new password";
                  } else if (value.length < 8) {
                    return "Password must be at least 8 characters";
                  }
                  return null;
                },
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 15,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  //labelText: "Confirm Password",
                  //labelStyle: TextStyle(fontFamily: "Montserrat",fontSize: 15,color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9499A1)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  isDense: true,
                  disabledBorder: OutlineInputBorder(),
                  errorBorder: OutlineInputBorder(),
                  suffixIcon: InkWell(
                    child: Icon(
                      isShowPass ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                    ),
                    onTap: () {
                      print("object");
                      setState(() {
                        isShowPass = !isShowPass;
                      });
                    },
                  ),
                ),
                onChanged: (val) {},
              ),
              /*decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF9499A1)),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      //suffixIcon: const Icon(Icons.visibility_off),
                      isDense: true,
                    ),*/
              // TextFieldlabelText("New Password"),
              // formTextField('[0-9a-zA-Z]+', 'Please enter New Password.', TextInputType.emailAddress, "New Password"),
            ],
          ),
        ),
        // const Spacer(flex: 1),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextFieldlabelText("Confirm Password"),
              Text(
                "Confirm Password*",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColourPalette.textFieldLabelColor,
                  fontSize: Dimens.textFieldLabelFontSize,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: cPasswordController,
                obscureText: isShowConfirm,

                onFieldSubmitted: (_) => _handleSubmit(),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm your password";
                  } else if (value != passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 15,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  //labelText: "Confirm Password",
                  //labelStyle: TextStyle(fontFamily: "Montserrat",fontSize: 15,color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9499A1)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  isDense: true,
                  disabledBorder: OutlineInputBorder(),
                  errorBorder: OutlineInputBorder(),
                  suffixIcon: InkWell(
                    child: Icon(
                      isShowConfirm ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                    ),
                    onTap: () {
                      print("object");
                      setState(() {
                        isShowConfirm = !isShowConfirm;
                      });
                    },
                  ),
                ),
                onChanged: (val) {},
              ),
              //formTextField('[0-9a-zA-Z]+', 'Please enter Confirm Password.', TextInputType.emailAddress, "Confirm Password"),
            ],
          ),
        ),
        if (Responsive.isDesktop(context)) Expanded(child: SizedBox()),
      ],
    );
  }

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
                  const SizedBox(width: 20),
                  Expanded(
                    // flex: 14,
                    child: SizedBox(),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 45),
            tabletChangePasswordTab,
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
            height: 100,
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
          SizedBox(height: 20),

          const SizedBox(height: 40),
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
                      [],
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
                      'Please Confirm Password*.',
                      TextInputType.visiblePassword,
                      [],
                      "Password",
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleSubmit(),
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
                // flex: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldlabelText("First Name*"),
                    formTextField(
                      fNameController,
                      Regex.name,
                      "Name should be 2-30 characters long and contain only letters",
                      TextInputType.name,
                      [LengthLimitingTextInputFormatter(50)],
                      "First Name",
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                    ),
                  ],
                ),
              ),

              Expanded(
                // flex: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldlabelText("Last Name*"),
                    formTextField(
                      lNameController,
                      Regex.name,
                      'Name should be 2-30 characters long and contain only letters',
                      TextInputType.name,
                      [LengthLimitingTextInputFormatter(50)],
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
                      [LengthLimitingTextInputFormatter(50)],
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
            [],
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
                    formTextField(
                      mobNumberController,
                      Regex.phone,
                      'Please enter a valid 10-digit mobile number starting with 6-9',
                      TextInputType.number,
                      [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      "Mobile no",
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
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
                        labelText: 'Personal Email',
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
                      child: AlternateMobile(
                        controller: altMobController,
                        compareController: mobNumberController,
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

  Widget permissionAndRightsSectionDesktop() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Column(
        children: [
          buildSectionTitle("Permission and Rights"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildPermissionsSectionDesktop(),

                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    width: 200,
                    child: addStaffButton(),
                  ),
                ),
              ],
            ),
          ),

          // const Spacer(flex: 1),
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (formKey.currentState!.validate()) {
      staffBloc.add(
        AddStaffOnRecordEvent(
          addStaffParam: AddStaffParam(
            uFirstName: fNameController.text,
            uLastName: lNameController.text,
            uEmail: emailController.text,
            uPersonalEmail: pEmailController.text,
            uMobileNumber: mobNumberController.text,
            uAlternateNumber: altMobController.text,
            uRole: selectedRole.toString(),
            uAccessPanel: selectedSkills.join(',').split(','),
            uPassword: passwordController.text,
            uConfirmPassword: cPasswordController.text,
            uStatus: selectedStatus,
            context: context,
          ),
        ),
      );
    }
  }

  addStaffButton() {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          _handleSubmit();
        }
      },
      child: BlocConsumer(
        bloc: staffBloc,
        listener: (context, state) {
          if (state is StaffAddLoadedSuccessStatus) {
            if (state.addStaffEntity.status == 1) {
              if (context.mounted) {
                context.pushNamed(ViewStaffPanel.routeName);
                ToastService.instance.showSuccess(
                  context,
                  state.addStaffEntity.message.toString(),
                );
              }
            } else {
              if (context.mounted) {
                ToastService.instance.showError(
                  context,
                  state.addStaffEntity.message ?? 'try again later',
                );
              }
            }
          }
          if (state is StaffAddLoadedFailureStatus) {
            if (context.mounted) {
              ToastService.instance.showError(context, state.error);
            }
          }
        },
        builder: (context, state) {
          if (state is StaffLoadingStatus) {
            return Center(child: CircularProgressIndicator.adaptive());
          }
          return CustomButton(label: 'Submit', onPressed: _handleSubmit);
        },
      ),
    );
  }

  Widget permissionAndRightsSectionTablet() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Column(
        children: [
          buildSectionTitle("Permission and Rights"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildPermissionsSectionTablet(),

                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(width: 200, child: addStaffButton()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
