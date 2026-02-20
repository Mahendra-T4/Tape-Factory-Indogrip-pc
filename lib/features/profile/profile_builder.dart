import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/file_picker.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/auth/data/models/uProfile_params.dart';
import 'package:indogrip/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:indogrip/features/auth/presentation/view/login_panel.dart';
import 'package:indogrip/features/profile/profile.dart';

abstract class UProfileBuilder extends State<Profile> {
  late AuthBloc authBloc;
  final GlobalKey<FormState> accountFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();
  File? profileImage;

  //! Updata Profile
  FocusNode fNameFocusNode = FocusNode();
  FocusNode lNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode altEmailFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode altPhoneFocusNode = FocusNode();

  final fNameController = TextEditingController();
  final lNameController = TextEditingController();

  final eMailController = TextEditingController();
  final altEmailController = TextEditingController();
  final phoneController = TextEditingController();
  final altPhoneController = TextEditingController();

  //! Change Pass

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode crPassFocusNode = FocusNode();
  FocusNode nPassFocusNode = FocusNode();
  FocusNode cPassFocusNode = FocusNode();
  bool isCrtShowPass = true;
  bool isShowPass = true;
  bool isShowConfirm = true;
  bool isAddressSame = false;

  bool isAddressSelected = false;
  bool isIDProofSelected = false;
  bool isbankSelected = false;
  bool is10thMarksheetSelected = false;
  bool is12thMarksheetSelected = false;
  bool isGraduationSelected = false;
  bool isSubmitPressed = false;

  void uProfile() {
    final formState = accountFormKey.currentState;
    if (formState != null) {
      bool isValid = formState.validate();
      if (fNameController.text.isEmpty) {
        FocusScope.of(context).requestFocus(fNameFocusNode);
      } else if (lNameController.text.isEmpty) {
        FocusScope.of(context).requestFocus(lNameFocusNode);
      } else if (eMailController.text.isEmpty) {
        FocusScope.of(context).requestFocus(emailFocusNode);
      } else if (altEmailController.text.isEmpty) {
        FocusScope.of(context).requestFocus(altEmailFocusNode);
      } else if (phoneController.text.isEmpty) {
        FocusScope.of(context).requestFocus(phoneFocusNode);
      } else if (altPhoneController.text.isEmpty) {
        FocusScope.of(context).requestFocus(altPhoneFocusNode);
      }

      if (isValid) {
        // formState.save();
        authBloc.add(
          AuthUpdateUserProfileDetailsEvent(
            context: context,
            uProfileParams: UProfileParams(
              profileImage,
              uFirstName: fNameController.text,
              uLastName: lNameController.text,
              uEmail: eMailController.text,
              uMobile: phoneController.text,
              uAlternateNumber: altPhoneController.text,
              uPersonalEmail: altEmailController.text,
              context: context,
            ),
          ),
        );
      }
    }
  }

  Widget get userProfileImageWidget => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Stack(
        children: [
          profileImage != null
              ? Container(
                  padding: const EdgeInsets.all(16),
                  height: 120,
                  width: 120,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                    image: profileImage != null
                        ? DecorationImage(
                            image: FileImage(profileImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: profileImage == null
                      ? Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey.shade400,
                        )
                      : SizedBox.shrink(),
                )
              : Container(
                  padding: const EdgeInsets.all(16),
                  height: 120,
                  width: 120,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                    image: profileImage != null
                        ? DecorationImage(
                            image: NetworkImage(
                              HiveService.userImage().toString(),
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
          Positioned(
            bottom: 5,
            right: 5,
            child: InkWell(
              onTap: () async {
                if (!mounted) return;
                final File? pickedFile =
                    await FilePickerService.pickFileFromDevice(profileImage);
                if (pickedFile != null) {
                  setState(() {
                    profileImage = pickedFile;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Icon(Icons.edit, size: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ],
  );

  Widget uProfileSubmitBtn() => BlocConsumer(
    bloc: authBloc,
    listener: (context, state) async {
      if (state is AuthUpdateUserProfileDetailsSuccessStatus) {
        if (state.updateProfileEntity.status == 1) {
          if (context.mounted) {
            ToastService.instance.showSuccess(
              context,
              state.updateProfileEntity.message.toString(),
            );
            Future.delayed(Duration(seconds: 1), () {
              context.go(IndoGripLoginPanel.routeName);
              HiveService.logout(context);
            });
          }
        } else {
          if (context.mounted) {
            ToastService.instance.showError(
              context,
              state.updateProfileEntity.message.toString(),
            );
          }
        }
      }
      if (state is AuthUpdateProfileFailedErrorStatus) {
        if (context.mounted) {
          ToastService.instance.showError(context, state.error);
        }
      }
    },
    builder: (context, state) {
      if (state is AuthTFourLoadingStatus) {
        Center(child: CircularProgressIndicator.adaptive());
      }
      return Container(
        width: MediaQuery.sizeOf(context).height * 0.29,
        margin: const EdgeInsets.only(right: 20),
        child: CustomButton(label: 'Submit', onPressed: uProfile),
      );
    },
  );
}
