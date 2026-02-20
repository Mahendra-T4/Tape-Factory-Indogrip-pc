import 'dart:io';

import 'package:flutter/widgets.dart';

class UProfileParams {
  final File? profileImage;
  final String uFirstName;
  final String uLastName;
  final String uEmail;
  final String uMobile;
  final String uAlternateNumber;
  final String uPersonalEmail;
  final BuildContext context;

  UProfileParams(
    this.profileImage, {
    required this.uFirstName,
    required this.uLastName,
    required this.uEmail,
    required this.uMobile,
    required this.uAlternateNumber,
    required this.uPersonalEmail,
    required this.context,
  });
}
