class JumboUploadFileResponseModel {
  final int? status;
  final String? message;
  final List<JumboMissRecord>? missRecord;

  JumboUploadFileResponseModel({this.status, this.message, this.missRecord});

  factory JumboUploadFileResponseModel.fromJson(Map<String, dynamic> json) {
    List<JumboMissRecord>? missRecords;

    if (json['missRecord'] != null) {
      if (json['missRecord'] is List) {
        // Handle empty list or list of records
        if ((json['missRecord'] as List).isEmpty) {
          missRecords = [];
        } else {
          missRecords = (json['missRecord'] as List)
              .map(
                (item) =>
                    JumboMissRecord.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
      } else if (json['missRecord'] is Map) {
        // Handle single map object
        missRecords = [
          JumboMissRecord.fromJson(json['missRecord'] as Map<String, dynamic>),
        ];
      }
    }

    return JumboUploadFileResponseModel(
      status: json['status'],
      message: json['message'],
      missRecord: missRecords,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'missRecord': missRecord?.map((m) => m.toJson()).toList(),
    };
  }
}

class JumboMissRecord {
  final dynamic vendorKey;
  final dynamic billDate;
  final dynamic billNumber;
  final dynamic rollNumber;
  final dynamic base;
  final dynamic mic;
  final dynamic length;
  final dynamic width;
  final dynamic netWeight;
  final dynamic totalSquareMtr;
  final dynamic amountPerKG;
  final dynamic rollCost;
  final dynamic remark;
  final dynamic rKey;
  final dynamic msg;

  JumboMissRecord({
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

  factory JumboMissRecord.fromJson(Map<String, dynamic> json) {
    return JumboMissRecord(
      vendorKey: json['vendorKey'],
      billDate: json['billDate'],
      billNumber: json['billNumber'],
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
