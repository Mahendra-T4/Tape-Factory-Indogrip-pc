class ViewCartonModel {
  int? status;
  String? message;
  List<ViewCartonRecord>? record;
  int? pageQty;
  String? pageText;

  ViewCartonModel({this.status, this.message, this.record, this.pageQty});

  ViewCartonModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['record'] != null) {
      record = <ViewCartonRecord>[];
      json['record'].forEach((v) {
        record!.add(new ViewCartonRecord.fromJson(v));
      });
    }
    pageQty = json['pageQty'];
    pageText = json['pageText'];
  }

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

class ViewCartonRecord {
  int? sNo;
  String? companyName;
  int? cartonType;
  String? vendorKey;
  String? cartonTypeText;
  String? cartonDateText;
  int? cartonQuantity;
  int? cartonBillNumber;
  String? rKey;
  int? rStatus;

  ViewCartonRecord({
    this.sNo,
    this.companyName,
    this.cartonType,
    this.vendorKey,
    this.cartonTypeText,
    this.cartonDateText,
    this.cartonQuantity,
    this.cartonBillNumber,
    this.rKey,
    this.rStatus,
  });

  ViewCartonRecord.fromJson(Map<String, dynamic> json) {
    sNo = json['SNo'];
    companyName = json['companyName'];
    cartonType = json['cartonType'];
    vendorKey = json['vendorKey'];
    cartonTypeText = json['cartonTypeText'];
    cartonDateText = json['cartonDateText'];
    cartonQuantity = json['cartonQuantity'];
    cartonBillNumber = json['cartonBillNumber'];
    rKey = json['rKey'];
    rStatus = json['rStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SNo'] = this.sNo;
    data['companyName'] = this.companyName;
    data['cartonType'] = this.cartonType;
    data['vendorKey'] = this.vendorKey;
    data['cartonTypeText'] = this.cartonTypeText;
    data['cartonDateText'] = this.cartonDateText;
    data['cartonQuantity'] = this.cartonQuantity;
    data['cartonBillNumber'] = this.cartonBillNumber;
    data['rKey'] = this.rKey;
    data['rStatus'] = this.rStatus;
    return data;
  }
}
