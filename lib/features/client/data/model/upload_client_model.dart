class UploadClientResponse {
  final int? status;
  final String? message;
  final List<ClientMissRecord>? missRecord;

  UploadClientResponse({this.status, this.message, this.missRecord});

  factory UploadClientResponse.fromJson(Map<String, dynamic> json) {
    return UploadClientResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      missRecord: (json['missRecord'] as List<dynamic>? ?? [])
          .map((e) => ClientMissRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ClientMissRecord {
  final String? cConsigneeName;
  final dynamic cGSTIN;
  final dynamic cUnitOne;
  final dynamic cUnitTwo;
  final dynamic cUnitThree;
  final dynamic cUnitFour;
  final dynamic cUnitFive;
  final dynamic cMobileNumber;
  final dynamic cAlternateNumber;
  final dynamic cOwnerName;
  final dynamic cOwnerMobileNumber;
  final dynamic cOwnerAlternateNumber;
  final dynamic cPurchaseManagerName;
  final dynamic cPurchaseManagerNumber;
  final dynamic cPurchaseManagerAlternateNumber;
  final String? reason;

  ClientMissRecord({
    this.cConsigneeName,
    this.cGSTIN,
    this.cUnitOne,
    this.cUnitTwo,
    this.cUnitThree,
    this.cUnitFour,
    this.cUnitFive,
    this.cMobileNumber,
    this.cAlternateNumber,
    this.cOwnerName,
    this.cOwnerMobileNumber,
    this.cOwnerAlternateNumber,
    this.cPurchaseManagerName,
    this.cPurchaseManagerNumber,
    this.cPurchaseManagerAlternateNumber,
    this.reason,
  });

  factory ClientMissRecord.fromJson(Map<String, dynamic> json) {
    return ClientMissRecord(
      cConsigneeName: json['cConsigneeName'] ?? '',
      cGSTIN: json['cGSTIN'] ?? '',
      cUnitOne: json['cUnitOne'] ?? '',
      cUnitTwo: json['cUnitTwo'] ?? '',
      cUnitThree: json['cUnitThree'] ?? '',
      cUnitFour: json['cUnitFour'] ?? '',
      cUnitFive: json['cUnitFive'] ?? '',
      cMobileNumber: json['cMobileNumber'] ?? '',
      cAlternateNumber: json['cAlternateNumber'] ?? '',
      cOwnerName: json['cOwnerName'] ?? '',
      cOwnerMobileNumber: json['cOwnerMobileNumber'] ?? '',
      cOwnerAlternateNumber: json['cOwnerAlternateNumber'] ?? '',
      cPurchaseManagerName: json['cPurchaseManagerName'] ?? '',
      cPurchaseManagerNumber: json['cPurchaseManagerNumber'] ?? '',
      cPurchaseManagerAlternateNumber:
          json['cPurchaseManagerAlternateNumber'] ?? '',
      reason: json['reason'] ?? '',
    );
  }
}
