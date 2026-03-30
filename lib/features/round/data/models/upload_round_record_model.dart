class UploadRoundRecordModel {
  final int? status;
  final String? message;
  final RoundMissRecord? missRecord;

  UploadRoundRecordModel({this.status, this.message, this.missRecord});

  factory UploadRoundRecordModel.fromJson(Map<String, dynamic> json) {
    return UploadRoundRecordModel(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      missRecord: RoundMissRecord.fromJson(json['missRecord'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'missRecord': missRecord?.toJson(),
  };
}

class RoundMissRecord {
  final String? vendorKey;
  final String? billDate;
  final String? billNumber;
  final String? rollNumber;
  final String? base;
  final String? mic;
  final dynamic length;
  final String? width;
  final String? netWeight;
  final String? totalSquareMtr;
  final dynamic amountPerKG;
  final String? rollCost;
  final String? remark;
  final String? rKey;
  final String? msg;

  RoundMissRecord({
    this.vendorKey,
    this.billDate,
    this.billNumber,
    this.rollNumber,
    this.base,
    this.mic,
    this.length,
    this.width,
    this.netWeight,
    this.totalSquareMtr,
    this.amountPerKG,
    this.rollCost,
    this.remark,
    this.rKey,
    this.msg,
  });

  factory RoundMissRecord.fromJson(Map<String, dynamic> json) {
    return RoundMissRecord(
      vendorKey: json['vendorKey'],
      billDate: json['billDate'],
      billNumber: json['billNumber']?.toString(),
      rollNumber: json['rollNumber'],
      base: json['base'],
      mic: json['mic'],
      length: json['length'],
      width: json['width'],
      netWeight: json['netWeight'],
      totalSquareMtr: json['totalSquareMtr'],
      amountPerKG: json['amountPerKG'],
      rollCost: json['rollCost'],
      remark: json['remark'],
      rKey: json['rKey'],
      msg: json['msg'],
    );
  }

  Map<String, dynamic> toJson() => {
    'vendorKey': vendorKey,
    'billDate': billDate,
    'billNumber': billNumber,
    'rollNumber': rollNumber,
    'base': base,
    'mic': mic,
    'length': length,
    'width': width,
    'netWeight': netWeight,
    'totalSquareMtr': totalSquareMtr,
    'amountPerKG': amountPerKG,
    'rollCost': rollCost,
    'remark': remark,
    'rKey': rKey,
    'msg': msg,
  };
}
