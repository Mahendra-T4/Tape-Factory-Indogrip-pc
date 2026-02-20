import 'package:flutter/widgets.dart';

class CoreApiParams {
  final String vendor;
  final String coreType;
  final String coreDate;
  final String coreQuantity;
  final String coreBillNumber;
  final BuildContext context;
  final String? rKey;

  CoreApiParams({
    required this.vendor,
    required this.coreType,
    required this.coreDate,
    required this.coreQuantity,
    required this.coreBillNumber,
    required this.context,
    required this.rKey
  });
}
