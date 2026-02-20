import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/extension/split_number_ext.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/dimens.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';

import 'package:indogrip/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:indogrip/features/auth/presentation/view/login_panel.dart';
import 'package:indogrip/features/profile/profile_builder.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  static const String routeName = '/profile';

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends UProfileBuilder {
  final GlobalKey<ScaffoldState> _statekey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    authBloc = AuthBloc();
    fNameController.text = HiveService.getFName().toString();
    lNameController.text = HiveService.getLName().toString();
    eMailController.text = HiveService.getEmail().toString();
    String alterNumber = HiveService.getAlternateMobile()
        .toString()
        .splitNumber();
    altPhoneController.text = alterNumber.splitNumber();
    phoneController.text = HiveService.getMobile().toString().splitNumber();
    altEmailController.text = HiveService.getUserEmail().toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
     stream: InternetConnectionService().connectionStream,
        initialData: true, // Assume connected initially
        builder: (context, snapshot) {
          // Handle error state
          if (snapshot.hasError) {
            return const NoInternetConnection();
          }

          // Handle disconnected state
          if (snapshot.data == false) {
            return const NoInternetConnection();
          }

          // Handle loading state
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
        return Scaffold(
          key: _statekey,
          appBar: !Responsive.isDesktop(context)
              ? MobileAppBar(context, _statekey, 'Profile')
              : null,
          drawer: !Responsive.isDesktop(context) ? SideMenuWidget() : null,
          body: Responsive.isDesktop(context) ? desktopView() : tabletView(),
        );
      }
    );
  }

  Widget desktopView() {
    return Row(
      children: [
        // SideMenuWidget(),
        Expanded(
          flex: 8,
          child: Column(
            children: [
              DesktopAppBar(context, _statekey, 'Profile', false),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${HiveService.getFName()} ${HiveService.getLName()}'s Profile",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: Responsive.isDesktop(context) ? 1 : 2,
                              child: Container(
                                margin: const EdgeInsets.only(right: 24),
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 120,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Theme.of(
                                            context,
                                          ).primaryColor.withOpacity(0.2),
                                          width: 4,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: Center(
                                          child: Icon(
                                            Icons.person,
                                            size: 100,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      '${HiveService.getFName()} ${HiveService.getLName()}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "Manager",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    _buildInfoItem(
                                      Icons.email_outlined,
                                      HiveService.getEmail().toString(),
                                    ),
                                    const SizedBox(height: 12),
                                    _buildInfoItem(
                                      Icons.phone_outlined,
                                      HiveService.getMobile().toString(),
                                    ),
                                    const SizedBox(height: 12),
                                    _buildInfoItem(
                                      Icons.admin_panel_settings_outlined,
                                      "Admin",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    DefaultTabController(
                                      length: 2,

                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Container(
                                              height: 48,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: TabBar(
                                                dividerColor:
                                                    Colors.transparent,
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                indicator: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.04),
                                                      blurRadius: 4,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                labelColor: Theme.of(
                                                  context,
                                                ).primaryColor,
                                                unselectedLabelColor:
                                                    Colors.grey.shade600,
                                                tabs: const [
                                                  Tab(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.person_outline,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          "Account Settings",
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Tab(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.lock_outline,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text("Change Password"),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height /
                                                1.5,
                                            child: TabBarView(
                                              children: [
                                                accountSetting(context),
                                                changePassword(context),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget tabletView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${HiveService.getFName()} ${HiveService.getLName()}'s Profile",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.2),
                            width: 4,
                          ),
                        ),
                        child: ClipOval(
                          child: Center(
                            child: Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${HiveService.getFName()} ${HiveService.getLName()}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Manager",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildInfoItem(
                                    Icons.email_outlined,
                                    HiveService.getEmail().toString(),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: _buildInfoItem(
                                    Icons.phone_outlined,
                                    HiveService.getMobile().toString(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildInfoItem(
                              Icons.admin_panel_settings_outlined,
                              "Admin",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TabBar(
                              padding: const EdgeInsets.all(4),
                              indicator: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              labelColor: Theme.of(context).primaryColor,
                              unselectedLabelColor: Colors.grey.shade600,
                              tabs: const [
                                Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.person_outline),
                                      SizedBox(width: 8),
                                      Text("Account Settings"),
                                    ],
                                  ),
                                ),
                                Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.lock_outline),
                                      SizedBox(width: 8),
                                      Text("Change Password"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child: TabBarView(
                            children: [
                              tabletAccountTab(),
                              tabletChangePasswordTab(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tabletAccountTab() {
    Size size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      child: Form(
        key: accountFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.width * 0.04),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Spacer(flex: 1),
                  Expanded(
                    flex: 21,
                    child: Text(
                      "Personal Details",
                      style: TextStyle(
                        fontFamily: "Inter",
                        color: Color(0xFF3D475C),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Spacer(flex: 2),
                ],
              ),
            ),
            SizedBox(height: size.width * 0.04),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Spacer(flex: 2),
                      Expanded(
                        flex: 14,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFieldlabelText("Email ID*"),
                            formTextField2(
                              eMailController,
                              [],
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              "Please enter email id.",
                              TextInputType.emailAddress,
                              (value) {
                                if (value.isEmpty) {
                                  return "Please enter email id.";
                                } else if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return "Please enter a valid email address.";
                                }
                                return null;
                              },
                              "Email ID",
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 1),
                      Expanded(
                        flex: 14,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFieldlabelText("Personal Email*"),
                            formTextField2(
                              altEmailController,
                              [],
                              '[0-9]+',
                              'Please enter personal email.',
                              TextInputType.emailAddress,
                              (value) {
                                if (value.isEmpty) {
                                  return "Please enter email id.";
                                } else if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return "Please enter a valid email address.";
                                }
                                return null;
                              },
                              "Personal Email",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Spacer(flex: 2),
                  Expanded(
                    flex: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFieldlabelText("Mobile No*"),
                        formTextField2(
                          phoneController,
                          [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          '[a-zA-Z0-9]+',
                          "Please enter mobile number.",
                          TextInputType.number,
                          (value) {
                            if (value.isEmpty) {
                              return "Please enter mobile number.";
                            } else if (value.length < 10) {
                              return "Mobile number must be at least 10 digits.";
                            }
                            return null;
                          },
                          "Mobile No",
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 1),
                  Expanded(
                    flex: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFieldlabelText("Alternate Mobile*"),
                        formTextField2(
                          altPhoneController,
                          [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          '[0-9]+',
                          'Please enter alternate mobile number.',
                          TextInputType.number,
                          (value) {
                            if (value.isEmpty) {
                              return "Please enter mobile number.";
                            } else if (value.length < 10) {
                              return "Mobile number must be at least 10 digits.";
                            }
                            return null;
                          },
                          "Alternate Mobile no",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [uProfileSubmitBtn()],
            ),
          ],
        ),
      ),
    );
  }

  Widget get fNameField => Expanded(
    // flex: 14,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldlabelText("First Name*"),
        formTextField2(
          fNameController,
          [],
          '[a-zA-Z]+',
          "Please enter first name.",
          TextInputType.emailAddress,
          (value) {
            if (value.isEmpty) {
              return "Please enter first name.";
            }
            // else if (!RegExp(
            //   r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
            // ).hasMatch(value)) {
            //   return "Please enter a valid email address.";
            // }
            return null;
          },
          "Email ID",
        ),
      ],
    ),
  );

  Widget get lNameField => Expanded(
    // flex: 14,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldlabelText("Last Name*"),
        formTextField2(
          lNameController,
          [],
          '[a-zA-Z]+',
          "Please enter Last name.",
          TextInputType.emailAddress,
          (value) {
            if (value.isEmpty) {
              return "Please enter Last name.";
            }
            // else if (!RegExp(
            //   r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
            // ).hasMatch(value)) {
            //   return "Please enter a valid email address.";
            // }
            return null;
          },
          "Email ID",
        ),
      ],
    ),
  );

  Widget accountSetting(BuildContext context) {
    //bool isValue = false;
    Size size = MediaQuery.sizeOf(context);

    return SingleChildScrollView(
      child: Form(
        key: accountFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Personal Details",
                    style: TextStyle(
                      fontFamily: "Inter",
                      color: Color(0xFF3D475C),
                      fontSize: 21,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  // Spacer(flex: 2),
                ],
              ),
            ),
            userProfileImageWidget,
            SizedBox(height: size.width * 0.03),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    spacing: 20,
                    children: [
                      fNameField,
                      // const Spacer(flex: 1),
                      lNameField,
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Spacer(flex: 2),
                      Expanded(
                        flex: 14,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFieldlabelText("Email ID*"),
                            formTextField2(
                              eMailController,
                              [],
                              '[a-zA-Z0-9]+',
                              "Please enter email id.",
                              TextInputType.emailAddress,
                              (value) {
                                if (value.isEmpty) {
                                  return "Please enter email id.";
                                } else if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return "Please enter a valid email address.";
                                }
                                return null;
                              },
                              "Email ID",
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 1),
                      Expanded(
                        flex: 14,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFieldlabelText("Personal Email*"),
                            formTextField2(
                              altEmailController,
                              [],
                              '[0-9]+',
                              'Please enter personal email.',
                              TextInputType.emailAddress,
                              (value) {
                                if (value.isEmpty) {
                                  return "Please enter email id.";
                                } else if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return "Please enter a valid email address.";
                                }
                                return null;
                              },
                              "Personal Email",
                            ),
                          ],
                        ),
                      ),
                      // const Spacer(flex: 1),
                      // Expanded(
                      //   flex: 14,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       TextFieldlabelText("Alternate Number"),
                      //       formTextFieldOptional(
                      //         '[0-9]+',
                      //         'Please enter alternate number.',
                      //         TextInputType.number,
                      //         "Alternate no",
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 14,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFieldlabelText("Mobile*"),
                            formTextField2(
                              phoneController,
                              [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              '[0-9]+',
                              'Please enter mobile number.',
                              TextInputType.number,
                              (value) {
                                if (value.isEmpty) {
                                  return "Please enter mobile number.";
                                } else if (value.length < 10) {
                                  return "Mobile number must be at least 10 digits.";
                                }
                                return null;
                              },
                              "Mobile no",
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 1),
                      Expanded(
                        flex: 14,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFieldlabelText("Alternate Number"),
                            formTextField2(
                              altPhoneController,
                              [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              '[0-9]+',
                              'Please enter alternate number.',
                              TextInputType.number,
                              (value) {
                                if (value.isEmpty) {
                                  return "Please enter mobile number.";
                                } else if (value.length < 10) {
                                  return "Mobile number must be at least 10 digits.";
                                }
                                return null;
                              },
                              "Alternate no",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Data Management Section
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 30),
              child: Text(
                "Data Management",
                style: TextStyle(
                  fontFamily: "Inter",
                  color: Color(0xFF3D475C),
                  fontSize: 21,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Clear Application Data",
                    style: TextStyle(
                      fontFamily: "Inter",
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "This will delete all your local app data, preferences, and cache. You will need to log in again.",
                    style: TextStyle(
                      fontFamily: "Inter",
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                      onPressed: () => _showClearDataConfirmation(context),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Clear All Data'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [uProfileSubmitBtn()],
            ),
          ],
        ),
      ),
    );
  }

  tabletChangePasswordTab() {
    Size size = MediaQuery.sizeOf(context);
    return Form(
      key: passwordFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.width * 0.07),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // const Spacer(flex: 1),
                Expanded(
                  flex: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Password*",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColourPalette.textFieldLabelColor,
                          fontSize: Dimens.textFieldLabelFontSize,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: currentPasswordController,
                        obscureText: isCrtShowPass,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter current password";
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
                              isCrtShowPass
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 20,
                            ),
                            onTap: () {
                              print("object");
                              setState(() {
                                isCrtShowPass = !isCrtShowPass;
                              });
                            },
                          ),
                        ),
                        onChanged: (val) {},
                      ),
                      //TextFieldlabelText("Current Password"),
                      //formTextField('[a-zA-Z0-9]+', "Please enter Current Password.", TextInputType.emailAddress, "Current Password"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.width * 0.07),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  flex: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "New Password*",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColourPalette.textFieldLabelColor,
                          fontSize: Dimens.textFieldLabelFontSize,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: newPasswordController,
                        obscureText: isShowPass,
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
                              isShowPass
                                  ? Icons.visibility_off
                                  : Icons.visibility,
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
                const Spacer(flex: 1),
                Expanded(
                  flex: 14,
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
                        controller: confirmPasswordController,
                        obscureText: isShowConfirm,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm your password";
                          } else if (value != newPasswordController.text) {
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
                              isShowConfirm
                                  ? Icons.visibility_off
                                  : Icons.visibility,
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
              ],
            ),
          ),
          SizedBox(height: size.width * 0.07),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                width: size.height * 0.31,
                child: cPassButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget changePassword(BuildContext context) {
    return Form(
      key: passwordFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              children: [
                const Spacer(flex: 1),
                Expanded(
                  flex: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Password*",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColourPalette.textFieldLabelColor,
                          fontSize: Dimens.textFieldLabelFontSize,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: currentPasswordController,
                        obscureText: isCrtShowPass,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter current password";
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
                              isCrtShowPass
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 20,
                            ),
                            onTap: () {
                              print("object");
                              setState(() {
                                isCrtShowPass = !isCrtShowPass;
                              });
                            },
                          ),
                        ),
                        onChanged: (val) {},
                      ),
                      //TextFieldlabelText("Current Password"),
                      //formTextField('[a-zA-Z0-9]+', "Please enter Current Password.", TextInputType.emailAddress, "Current Password"),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "New Password*",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColourPalette.textFieldLabelColor,
                          fontSize: Dimens.textFieldLabelFontSize,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: newPasswordController,
                        obscureText: isShowPass,
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
                              isShowPass
                                  ? Icons.visibility_off
                                  : Icons.visibility,
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
                const Spacer(flex: 1),
                Expanded(
                  flex: 14,
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
                        controller: confirmPasswordController,
                        obscureText: isShowConfirm,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm your password";
                          } else if (value != newPasswordController.text) {
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
                              isShowConfirm
                                  ? Icons.visibility_off
                                  : Icons.visibility,
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
                const Spacer(flex: 1),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).height * 0.3,
                  child: cPassButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cPassButton() {
    return BlocConsumer(
      bloc: authBloc,
      listener: (context, state) {
        if (state is AuthNavigateToLoginPanelActionStatus) {
          // Handle logout and navigation in a safe way
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              HiveService.logout(context).then((_) {
                if (mounted) {
                  GoRouter.of(context).goNamed(IndoGripLoginPanel.routeName);
                }
              });
            }
          });
        }
      },
      builder: (context, state) {
        if (state is AuthTFourLoadingStatus) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        return CustomButton(
          label: 'Change Password',
          onPressed: () {
            if (passwordFormKey.currentState!.validate()) {
              authBloc.add(
                AuthUserChangePasswordEvent(
                  currentPass: currentPasswordController.text,
                  newPassword: newPasswordController.text,
                  confirmPassword: confirmPasswordController.text,
                  context: context,
                ),
              );
            }
          },
        );
      },
    );
  }

  /// Show confirmation dialog for clearing all data
  Future<void> _showClearDataConfirmation(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Clear All Data?',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This action will permanently delete:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• All user profile information'),
                    Text('• Login credentials'),
                    Text('• Preferences and settings'),
                    Text('• Cached data'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You will need to log in again to use the app.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel', style: TextStyle(fontSize: 14)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _clearAllDataAndLogout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete All Data'),
            ),
          ],
        );
      },
    );
  }

  /// Clear all data and logout user
  Future<void> _clearAllDataAndLogout(BuildContext context) async {
    try {
      // Show loading indicator
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext loadingContext) {
            return const Center(child: CircularProgressIndicator.adaptive());
          },
        );
      }

      // Clear all data
      await HiveService.clearAllData();

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Navigate to login
      if (mounted) {
        GoRouter.of(context).goNamed(IndoGripLoginPanel.routeName);
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data cleared successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error clearing data: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
