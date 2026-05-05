import 'package:equatable/equatable.dart';
import 'package:indogrip/core/database/hive_service.dart';

class AddSilicaRequestEntity extends Equatable {
  final String vendorKey;
  final String billDate;
  final String billNo;
  final String serialNo;
  final String grossWeight;
  final String cost;
  final String transportCost;
  final String margin;
  final String remark;

  AddSilicaRequestEntity({
    required this.vendorKey,
    required this.billDate,
    required this.billNo,
    required this.serialNo,
    required this.grossWeight,
    required this.cost,
    required this.transportCost,
    required this.margin,
    required this.remark,
  });

  Map<String, dynamic> toJson() => {
    'userKey': HiveService.getUserId(),
    'vendorKey': vendorKey,
    'sBillDate': billDate,
    'sBillNo': billNo,
    'sSerialNo': serialNo,
    'sGrossWeight': grossWeight,
    'sCost': cost,
    'sTransportCost': transportCost,
    'sMargin': margin,
    'sRemark': remark,
  };

  @override
  List<Object> get props {
    return [
      vendorKey,
      billDate,
      billNo,
      serialNo,
      grossWeight,
      cost,
      transportCost,
      margin,
      remark,
    ];
  }
}
