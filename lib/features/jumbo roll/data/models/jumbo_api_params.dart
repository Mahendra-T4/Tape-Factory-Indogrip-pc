import 'package:flutter/widgets.dart';

class JumboRollApiParams {
  final String billDate;
  final String billNumber;
  final String rollNumber;
  final String vendorKey;
  final String base;
  final String mic;
  final String length;
  final String width;
  final String netWeight;
  final String amountPerKG;
  final String remark;
  String? rKey;
  final BuildContext context;

  JumboRollApiParams({
    required this.vendorKey,
    required this.amountPerKG,
    required this.billDate,
    required this.billNumber,
    required this.rollNumber,
    required this.base,
    required this.mic,
    required this.length,
    required this.width,
    required this.netWeight,
    required this.remark,
    this.rKey,
    required this.context,
  });
}
