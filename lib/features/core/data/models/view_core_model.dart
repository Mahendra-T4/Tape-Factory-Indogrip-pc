class ViewCoreModel {
  ViewCoreModel({this.status, this.message, this.record, this.pageQty});

  ViewCoreModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['record'] != null) {
      record = <CoreDataRecord>[];
      json['record'].forEach((v) {
        record!.add(new CoreDataRecord.fromJson(v));
      });
    }
    pageQty = json['pageQty'];
    pageText = json['pageText'];
  }

  String? message;
  int? pageQty;
  String? pageText;
  List<CoreDataRecord>? record;
  int? status;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.record != null) {
      data['record'] = this.record!.map((v) => v.toJson()).toList();
    }
    data['pageQty'] = this.pageQty;
    data['pageText'] = this.pageText;
    return data;
  }
}

class CoreDataRecord {
  CoreDataRecord({
    this.sNo,
    this.companyName,
    this.coreType,
    this.cartonType,
    this.coreTypeText,
    this.coreDateText,
    this.coreQuantity,
    this.coreBillNumber,
    this.rKey,
    this.rStatus,
  });

  CoreDataRecord.fromJson(Map<String, dynamic> json) {
    sNo = json['SNo'];
    companyName = json['companyName'];
    coreType = json['coreType'];
    cartonType = json['cartonType'];
    coreTypeText = json['coreTypeText'];
    coreDateText = json['coreDateText'];
    coreQuantity = json['coreQuantity'];
    coreBillNumber = json['coreBillNumber'];
    rKey = json['rKey'];
    rStatus = json['rStatus'];
  }

  int? cartonType;
  String? companyName;
  int? coreBillNumber;
  String? coreDateText;
  int? coreQuantity;
  int? coreType;
  String? coreTypeText;
  String? rKey;
  int? rStatus;
  int? sNo;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SNo'] = this.sNo;
    data['companyName'] = this.companyName;
    data['coreType'] = this.coreType;
    data['cartonType'] = this.cartonType;
    data['coreTypeText'] = this.coreTypeText;
    data['coreDateText'] = this.coreDateText;
    data['coreQuantity'] = this.coreQuantity;
    data['coreBillNumber'] = this.coreBillNumber;
    data['rKey'] = this.rKey;
    data['rStatus'] = this.rStatus;
    return data;
  }
}
