class ViewJumboRollModel {
  int? status;
  String? message;
  List<JumboRollRecord>? record;
  int? pageQty;

  ViewJumboRollModel({this.status, this.message, this.record, this.pageQty});

  ViewJumboRollModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['record'] != null) {
      record = <JumboRollRecord>[];
      json['record'].forEach((v) {
        record!.add(new JumboRollRecord.fromJson(v));
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

class JumboRollRecord {
  int? sNo;
  int? jumboID;
  String? jumboCode;
  String? jumboDate;
  String? jBillDate;
  String? jBillNumber;
  String? jRollNumber;
  int? jBase;
  String? baseLabel;
  int? jMic;
  String? micLabel;
  dynamic jLength;
  dynamic availableLength;
  dynamic consumeLength;
  dynamic jWeight;
  int? jwidthID;
  dynamic jWidth;
  dynamic jSquareMeter;
  dynamic amountPerKG;
  dynamic rollCost;
  String? jRemark;
  String? rKey;
  int? rStatus;
  String? jumboStatusLabel;
  VendorInfo? vendorInfo;

  JumboRollRecord({
    this.sNo,
    this.jumboID,
    this.jumboCode,
    this.jumboDate,
    this.jBillDate,
    this.jBillNumber,
    this.jRollNumber,
    this.jBase,
    this.baseLabel,
    this.jMic,
    this.micLabel,
    this.jLength,
    this.availableLength,
    this.consumeLength,
    this.jWeight,
    this.jwidthID,
    this.jWidth,
    this.jSquareMeter,
    this.amountPerKG,
    this.rollCost,
    this.jRemark,
    this.rKey,
    this.rStatus,
    this.jumboStatusLabel,
    this.vendorInfo,
  });

  JumboRollRecord.fromJson(Map<String, dynamic> json) {
    sNo = json['SNo'];
    jumboID = json['jumboID'];
    jumboCode = json['jumboCode'];
    jumboDate = json['jumboDate'];
    jBillDate = json['jBillDate'];
    jBillNumber = json['jBillNumber'];
    jRollNumber = json['jRollNumber'];
    jBase = json['jBase'];
    baseLabel = json['baseLabel'];
    jMic = json['jMic'];
    micLabel = json['micLabel'];
    jLength = json['jLength'];
    availableLength = json['availableLength'];
    consumeLength = json['consumeLength'];
    jWeight = json['jWeight'];
    jwidthID = json['jwidthID'];
    jWidth = json['jWidth'];
    jSquareMeter = json['jSquareMeter'];
    amountPerKG = json['amountPerKG'];
    rollCost = json['rollCost'];
    jRemark = json['jRemark'];
    rKey = json['rKey'];
    rStatus = json['rStatus'];
    jumboStatusLabel = json['jumboStatusLabel'];
    vendorInfo = json['vendorInfo'] != null
        ? new VendorInfo.fromJson(json['vendorInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SNo'] = this.sNo;
    data['jumboID'] = this.jumboID;
    data['jumboCode'] = this.jumboCode;
    data['jumboDate'] = this.jumboDate;
    data['jBillDate'] = this.jBillDate;
    data['jBillNumber'] = this.jBillNumber;
    data['jRollNumber'] = this.jRollNumber;
    data['jBase'] = this.jBase;
    data['baseLabel'] = this.baseLabel;
    data['jMic'] = this.jMic;
    data['micLabel'] = this.micLabel;
    data['jLength'] = this.jLength;
    data['availableLength'] = this.availableLength;
    data['consumeLength'] = this.consumeLength;
    data['jWeight'] = this.jWeight;
    data['jwidthID'] = this.jwidthID;
    data['jWidth'] = this.jWidth;
    data['jSquareMeter'] = this.jSquareMeter;
    data['amountPerKG'] = this.amountPerKG;
    data['rollCost'] = this.rollCost;
    data['jRemark'] = this.jRemark;
    data['rKey'] = this.rKey;
    data['rStatus'] = this.rStatus;
    if (this.vendorInfo != null) {
      data['vendorInfo'] = this.vendorInfo!.toJson();
    }
    return data;
  }
}

class VendorInfo {
  String? vendorCode;
  String? companyName;
  String? vendorKey;

  VendorInfo({this.vendorCode, this.companyName, this.vendorKey});

  VendorInfo.fromJson(Map<String, dynamic> json) {
    vendorCode = json['vendorCode'];
    companyName = json['companyName'];
    vendorKey = json['vendorKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vendorCode'] = this.vendorCode;
    data['companyName'] = this.companyName;
    data['vendorKey'] = this.vendorKey;
    return data;
  }
}
