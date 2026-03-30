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
  final String? cGSTIN;
  final String? cUnitOne;
  final String? cUnitTwo;
  final String? cUnitThree;
  final String? cUnitFour;
  final String? cUnitFive;
  final String? cMobileNumber;
  final String? cAlternateNumber;
  final String? cOwnerName;
  final String? cOwnerMobileNumber;
  final String? cOwnerAlternateNumber;
  final String? cPurchaseManagerName;
  final String? cPurchaseManagerNumber;
  final String? cPurchaseManagerAlternateNumber;
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
