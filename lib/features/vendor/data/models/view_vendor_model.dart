class ViewVendorModel {
  int? status;
  String? message;
  List<VendorRecord>? record;
  int? pageQty;
  String? pageText;

  ViewVendorModel({
    this.status,
    this.message,
    this.record,
    this.pageQty,
    this.pageText,
  });

  ViewVendorModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['record'] != null) {
      record = <VendorRecord>[];
      json['record'].forEach((v) {
        record!.add(VendorRecord.fromJson(v));
      });
    }
    pageQty = json['pageQty'];
    pageText = json['pageText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (record != null) {
      data['record'] = record!.map((v) => v.toJson()).toList();
    }
    data['pageQty'] = pageQty;
    data['pageText'] = pageText;
    return data;
  }
}

class VendorRecord {
  int? sNo;
  String? vCode;
  String? vCompanyName;
  String? vCompanyMobileNumber;
  String? vAlternateNumber;
  String? vCompanyGSTIN;
  String? vVendorName;
  String? vVendorMobileNumber;
  String? vVenderAlternateNumber;
  String? vRepresentativeName;
  String? vRepresentativeNumber;
  String? vRAlternateNumber;
  String? rKey;
  int? rStatus;

  VendorRecord({
    this.sNo,
    this.vCode,
    this.vCompanyName,
    this.vCompanyMobileNumber,
    this.vAlternateNumber,
    this.vCompanyGSTIN,
    this.vVendorName,
    this.vVendorMobileNumber,
    this.vVenderAlternateNumber,
    this.vRepresentativeName,
    this.vRepresentativeNumber,
    this.vRAlternateNumber,
    this.rKey,
    this.rStatus,
  });

  VendorRecord.fromJson(Map<String, dynamic> json) {
    sNo = json['SNo'];
    vCode = json['vCode']?.toString();
    vCompanyName = json['vCompanyName']?.toString();
    vCompanyMobileNumber = json['vCompanyMobileNumber']?.toString();
    vAlternateNumber = json['vAlternateNumber']?.toString();
    vCompanyGSTIN = json['vCompanyGSTIN']?.toString();
    vVendorName = json['vVendorName']?.toString();
    vVendorMobileNumber = json['vVendorMobileNumber']?.toString();
    vVenderAlternateNumber = json['vVenderAlternateNumber']?.toString();
    vRepresentativeName = json['vRepresentativeName']?.toString();
    vRepresentativeNumber = json['vRepresentativeNumber']?.toString();
    vRAlternateNumber = json['vRAlternateNumber']?.toString();
    rKey = json['rKey']?.toString();
    rStatus = json['rStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SNo'] = sNo;
    data['vCode'] = vCode;
    data['vCompanyName'] = vCompanyName;
    data['vCompanyMobileNumber'] = vCompanyMobileNumber;
    data['vAlternateNumber'] = vAlternateNumber;
    data['vCompanyGSTIN'] = vCompanyGSTIN;
    data['vVendorName'] = vVendorName;
    data['vVendorMobileNumber'] = vVendorMobileNumber;
    data['vVenderAlternateNumber'] = vVenderAlternateNumber;
    data['vRepresentativeName'] = vRepresentativeName;
    data['vRepresentativeNumber'] = vRepresentativeNumber;
    data['vRAlternateNumber'] = vRAlternateNumber;
    data['rKey'] = rKey;
    data['rStatus'] = rStatus;
    return data;
  }
}
