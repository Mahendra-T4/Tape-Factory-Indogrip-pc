class ViewWastageModel {
  int? status;
  String? message;
  List<WastageRecord>? record;
  int? pageQty;
  String? pageText;

  ViewWastageModel({this.status, this.message, this.record, this.pageQty});

  ViewWastageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['record'] != null) {
      record = <WastageRecord>[];
      json['record'].forEach((v) {
        record!.add(new WastageRecord.fromJson(v));
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

class WastageRecord {
  int? sNo;
  String? consigneeName;
  String? wastageClient;
  String? wastageDate;
  String? wastageDateText;
  int? billNumber;
  dynamic weight;
  dynamic pricePerKG;
  dynamic price;
  String? remark;
  String? rKey;
  dynamic rStatus;

  WastageRecord({
    this.sNo,
    this.consigneeName,
    this.wastageClient,
    this.wastageDate,
    this.wastageDateText,
    this.billNumber,
    this.weight,
    this.pricePerKG,
    this.price,
    this.remark,
    this.rKey,
    this.rStatus,
  });

  WastageRecord.fromJson(Map<String, dynamic> json) {
    sNo = json['SNo'];
    consigneeName = json['consigneeName'];
    wastageClient = json['wastageClient'];
    wastageDate = json['wastageDate'];
    wastageDateText = json['wastageDateText'];
    billNumber = json['billNumber'];
    weight = json['weight'];
    pricePerKG = json['pricePerKG'];
    price = json['price'];
    remark = json['remark'];
    rKey = json['rKey'];
    rStatus = json['rStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SNo'] = this.sNo;
    data['consigneeName'] = this.consigneeName;
    data['wastageClient'] = this.wastageClient;
    data['wastageDate'] = this.wastageDate;
    data['wastageDateText'] = this.wastageDateText;
    data['billNumber'] = this.billNumber;
    data['weight'] = this.weight;
    data['pricePerKG'] = this.pricePerKG;
    data['price'] = this.price;
    data['remark'] = this.remark;
    data['rKey'] = this.rKey;
    data['rStatus'] = this.rStatus;
    return data;
  }
}
