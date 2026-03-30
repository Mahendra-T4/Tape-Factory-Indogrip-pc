class UploadVendorResponse {
  final int? status;
  final String? message;
  final List<VendorMissRecord>? missRecord;

  UploadVendorResponse({this.status, this.message, this.missRecord});

  factory UploadVendorResponse.fromJson(Map<String, dynamic> json) {
    return UploadVendorResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      missRecord: (json['missRecord'] as List<dynamic>? ?? [])
          .map((e) => VendorMissRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class VendorMissRecord {
  final String? vCompanyName;
  final String? vGSTIN;
  final String? vMobileNumber;
  final String? vAlternateNumber;
  final String? vOwnerName;
  final String? vOwnerMobileNumber;
  final String? vOwnerAlternateNumber;
  final String? vRepresentativeName;
  final String? vRepresentativeNumber;
  final String? vRepresentativeAlternate;
  final String? reason;

  VendorMissRecord({
    this.vCompanyName,
    this.vGSTIN,
    this.vMobileNumber,
    this.vAlternateNumber,
    this.vOwnerName,
    this.vOwnerMobileNumber,
    this.vOwnerAlternateNumber,
    this.vRepresentativeName,
    this.vRepresentativeNumber,
    this.vRepresentativeAlternate,
    this.reason,
  });

  factory VendorMissRecord.fromJson(Map<String, dynamic> json) {
    return VendorMissRecord(
      vCompanyName: json['vCompanyName'] ?? '',
      vGSTIN: json['vGSTIN'] ?? '',
      vMobileNumber: json['vMobileNumber'] ?? '',
      vAlternateNumber: json['vAlternateNumber'] ?? '',
      vOwnerName: json['vOwnerName'] ?? '',
      vOwnerMobileNumber: json['vOwnerMobileNumber'] ?? '',
      vOwnerAlternateNumber: json['vOwnerAlternateNumber'] ?? '',
      vRepresentativeName: json['vRepresentativeName'] ?? '',
      vRepresentativeNumber: json['vRepresentativeNumber'] ?? '',
      vRepresentativeAlternate: json['vRepresentativeAlternate'] ?? '',
      reason: json['reason'] ?? '',
    );
  }
}
