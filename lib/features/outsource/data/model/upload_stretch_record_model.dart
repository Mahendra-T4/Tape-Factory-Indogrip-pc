class UploadStretchRecordModel {
  final int? status;
  final String? message;
  final List<StretchMissRecord>? missRecord;

  UploadStretchRecordModel({this.status, this.message, this.missRecord});

  factory UploadStretchRecordModel.fromJson(Map<String, dynamic> json) {
    return UploadStretchRecordModel(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      missRecord: (json['missRecord'] as List<dynamic>? ?? [])
          .map((e) => StretchMissRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'missRecord': missRecord?.map((e) => e.toJson()).toList(),
  };
}

class StretchMissRecord {
  final dynamic inventoryCode;
  final String? vendorKey;
  final String? date;
  final String? billNumber;
  final dynamic cartonPrice;
  final dynamic transportAmount;
  final int? productType;
  final dynamic cutMMMeter;
  final String? base;
  final int? mic;
  final dynamic tapeLength;
  final dynamic tapeWeight;
  final dynamic stretchFilmSize;
  final String? coreID;
  final dynamic netWeight;
  final dynamic grossWeight;
  final int? quantity;
  final String? remarks;
  final String? reason;

  StretchMissRecord({
    this.inventoryCode,
    this.vendorKey,
    this.date,
    this.billNumber,
    this.cartonPrice,
    this.transportAmount,
    this.productType,
    this.cutMMMeter,
    this.base,
    this.mic,
    this.tapeLength,
    this.tapeWeight,
    this.stretchFilmSize,
    this.coreID,
    this.netWeight,
    this.grossWeight,
    this.quantity,
    this.remarks,
    this.reason,
  });

  factory StretchMissRecord.fromJson(Map<String, dynamic> json) {
    return StretchMissRecord(
      inventoryCode: json['inventoryCode'],
      vendorKey: json['vendorKey'],
      date: json['date'],
      billNumber: json['billNumber']?.toString(),
      cartonPrice: json['cartonPrice'],
      transportAmount: json['transportAmount'],
      productType: json['productType'],
      cutMMMeter: json['cutMMMeter'],
      base: json['base'],
      mic: json['mic'],
      tapeLength: json['tapeLength'],
      tapeWeight: json['tapeWeight'],
      stretchFilmSize: json['stretchFilmSize'],
      coreID: json['coreID'],
      netWeight: json['netWeight'],
      grossWeight: json['grossWeight'],
      quantity: json['quantity'],
      remarks: json['remarks'],
      reason: json['reason'],
    );
  }

  Map<String, dynamic> toJson() => {
    'inventoryCode': inventoryCode,
    'vendorKey': vendorKey,
    'date': date,
    'billNumber': billNumber,
    'cartonPrice': cartonPrice,
    'transportAmount': transportAmount,
    'productType': productType,
    'cutMMMeter': cutMMMeter,
    'base': base,
    'mic': mic,
    'tapeLength': tapeLength,
    'tapeWeight': tapeWeight,
    'stretchFilmSize': stretchFilmSize,
    'coreID': coreID,
    'netWeight': netWeight,
    'grossWeight': grossWeight,
    'quantity': quantity,
    'remarks': remarks,
    'reason': reason,
  };
}
