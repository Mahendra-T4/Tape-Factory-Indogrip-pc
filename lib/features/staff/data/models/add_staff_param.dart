// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';

class AddStaffParam {
  final String uFirstName;
  final String uLastName;
  final String uEmail;
  final String uPersonalEmail;
  final String uMobileNumber;
  final String uAlternateNumber;
  final String uRole;
  final List<String> uAccessPanel;
  final String uPassword;
  final String uConfirmPassword;
  final String uStatus;
  final String? rKey;
  final BuildContext context;

  AddStaffParam({
    required this.uFirstName,
    required this.uLastName,
    required this.uEmail,
    required this.uPersonalEmail,
    required this.uMobileNumber,
    required this.uAlternateNumber,
    required this.uRole,
    required this.uAccessPanel,
    required this.uPassword,
    required this.uConfirmPassword,
    required this.uStatus,
    this.rKey,
    required this.context,
  });
}
