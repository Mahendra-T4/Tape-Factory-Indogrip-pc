class TapMissRecordResponse {
  final int? status;
  final String? message;
  final List<TapMissRecord>? missRecord;
  final dynamic importRecord;
  final String? redirect;

  TapMissRecordResponse({
    required this.status,
    required this.message,
    this.missRecord,
    this.importRecord,
    this.redirect,
  });

  factory TapMissRecordResponse.fromJson(Map<String, dynamic> json) {
    return TapMissRecordResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      missRecord: json['missRecord'] != null
          ? (json['missRecord'] as List<dynamic>)
                .map(
                  (item) =>
                      TapMissRecord.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : null,
      importRecord: json['importRecord'],
      redirect: json['redirect'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'missRecord': missRecord?.map((item) => item.toJson()).toList(),
      'importRecord': importRecord,
      'redirect': redirect,
    };
  }
}

class TapMissRecord {
  final String? inventoryCode;
  final String? vendorKey;
  final String? date;
  final String? billNumber;
  final dynamic cartonPrice;
  final dynamic transportAmount;
  final int? productType;
  final int? cutMMMeter;
  final int? base;
  final int? mic;
  final dynamic tapeLength;
  final dynamic tapeWeight;
  final String? stretchFilmSize;
  final String? coreID;
  final dynamic netWeight;
  final dynamic grossWeight;
  final int? quantity;
  final String? remarks;
  final String? reason;

  TapMissRecord({
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

  factory TapMissRecord.fromJson(Map<String, dynamic> json) {
    return TapMissRecord(
      inventoryCode: json['inventoryCode'],
      vendorKey: json['vendorKey'],
      date: json['date'],
      billNumber: json['billNumber'],
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

  Map<String, dynamic> toJson() {
    return {
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
}
