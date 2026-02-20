import 'package:flutter/widgets.dart';

class CartonApiParams {
  
  final String cartonType;
  final String cartonDate;
  final String cartonQuantity;
  final String billNumber;
  final String? vendorKey;
  final String rKey;
  String? password;
  String? confirmPassword;
  final BuildContext context;

  CartonApiParams({
    required this.cartonType,
    required this.cartonDate,
    required this.cartonQuantity,
    required this.billNumber,
    required this.rKey,
    this.vendorKey,
    this.password,
    this.confirmPassword,
    required this.context,
  });
}
