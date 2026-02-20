class JumboMissRecordResponse {
  final int? status;
  final String? message;
  final MissRecord? missRecord;
  final String? redirect;

  JumboMissRecordResponse({
    this.status,
    this.message,
    this.missRecord,
    this.redirect,
  });

  factory JumboMissRecordResponse.fromJson(Map<String, dynamic> json) {
    return JumboMissRecordResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      missRecord: MissRecord.fromJson(
        json['missRecord'] as Map<String, dynamic>,
      ),
      redirect: json['redirect'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'missRecord': missRecord!.toJson(),
      'redirect': redirect,
    };
  }
}

class MissRecord {
  final String? vendorKey;
  final String? billDate;
  final String? billNumber;
  final String? rollNumber;
  final int? base;
  final int? mic;
  final dynamic length;
  final int? width;
  final dynamic netWeight;
  final dynamic totalSquareMtr;
  final dynamic amountPerKG;
  final dynamic rollCost;
  final String? remark;
  final String? rKey;
  final String? msg;

  MissRecord({
    required this.vendorKey,
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

  factory MissRecord.fromJson(Map<String, dynamic> json) {
    return MissRecord(
      vendorKey: json['vendorKey'],
      billDate: json['billDate'],
      billNumber: json['billNumber'],
      rollNumber: json['rollNumber'],
      base: json['base'],
      mic: json['mic'],
      length: json['length'],
      width: json['width'],
      netWeight: json['netWeight'],
      totalSquareMtr: (
        json['totalSquareMtr'],
        amountPerKG: json['amountPerKG'],
        rollCost: json['rollCost'],
        remark: json['remark'],
        rKey: json['rKey'],
        msg: json['msg'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
}
