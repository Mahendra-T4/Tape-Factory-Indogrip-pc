class ViewVendorModel {
  int? status;
  String? message;
  List<VendorRecord>? record;
  int? pageQty;

  ViewVendorModel({this.status, this.message, this.record, this.pageQty});

  ViewVendorModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['record'] != null) {
      record = <VendorRecord>[];
      json['record'].forEach((v) {
        record!.add(new VendorRecord.fromJson(v));
      });
    }
    pageQty = json['pageQty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.record != null) {
      data['record'] = this.record!.map((v) => v.toJson()).toList();
    }
    data['pageQty'] = this.pageQty;
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

  VendorRecord(
      {this.sNo,
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
      this.rStatus});

  VendorRecord.fromJson(Map<String, dynamic> json) {
    sNo = json['SNo'];
    vCode = json['vCode'];
    vCompanyName = json['vCompanyName'];
    vCompanyMobileNumber = json['vCompanyMobileNumber'];
    vAlternateNumber = json['vAlternateNumber'];
    vCompanyGSTIN = json['vCompanyGSTIN'];
    vVendorName = json['vVendorName'];
    vVendorMobileNumber = json['vVendorMobileNumber'];
    vVenderAlternateNumber = json['vVenderAlternateNumber'];
    vRepresentativeName = json['vRepresentativeName'];
    vRepresentativeNumber = json['vRepresentativeNumber'];
    vRAlternateNumber = json['vRAlternateNumber'];
    rKey = json['rKey'];
    rStatus = json['rStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SNo'] = this.sNo;
    data['vCode'] = this.vCode;
    data['vCompanyName'] = this.vCompanyName;
    data['vCompanyMobileNumber'] = this.vCompanyMobileNumber;
    data['vAlternateNumber'] = this.vAlternateNumber;
    data['vCompanyGSTIN'] = this.vCompanyGSTIN;
    data['vVendorName'] = this.vVendorName;
    data['vVendorMobileNumber'] = this.vVendorMobileNumber;
    data['vVenderAlternateNumber'] = this.vVenderAlternateNumber;
    data['vRepresentativeName'] = this.vRepresentativeName;
    data['vRepresentativeNumber'] = this.vRepresentativeNumber;
    data['vRAlternateNumber'] = this.vRAlternateNumber;
    data['rKey'] = this.rKey;
    data['rStatus'] = this.rStatus;
    return data;
  }
}