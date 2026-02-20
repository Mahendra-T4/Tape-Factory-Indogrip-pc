class StretchFilmBatchInfoModel {
  int? status;
  String? message;
  Record? record;

  StretchFilmBatchInfoModel({this.status, this.message, this.record});

  StretchFilmBatchInfoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    record = json['record'] != null
        ? new Record.fromJson(json['record'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.record != null) {
      data['record'] = this.record!.toJson();
    }
    return data;
  }
}

class Record {
  InventoryInformation? inventoryInformation;
  BatchInformation? batchInformation;

  Record({this.inventoryInformation, this.batchInformation});

  Record.fromJson(Map<String, dynamic> json) {
    inventoryInformation = json['inventoryInformation'] != null
        ? new InventoryInformation.fromJson(json['inventoryInformation'])
        : null;
    batchInformation = json['batchInformation'] != null
        ? new BatchInformation.fromJson(json['batchInformation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.inventoryInformation != null) {
      data['inventoryInformation'] = this.inventoryInformation!.toJson();
    }
    if (this.batchInformation != null) {
      data['batchInformation'] = this.batchInformation!.toJson();
    }
    return data;
  }
}

class InventoryInformation {
  String? recordDate;
  int? productTypeID;
  String? productTypeName;
  String? billDate;
  String? billNumber;
  int? cartonPrice;
  int? transportPrice;
  int? quantity;
  AdditionalInfo? additionalInfo;
  List<VendorInfo>? vendorInfo;
  String? remark;
  String? rKey;
  int? rStatus;

  InventoryInformation({
    this.recordDate,
    this.productTypeID,
    this.productTypeName,
    this.billDate,
    this.billNumber,
    this.cartonPrice,
    this.transportPrice,
    this.quantity,
    this.additionalInfo,
    this.vendorInfo,
    this.remark,
    this.rKey,
    this.rStatus,
  });

  InventoryInformation.fromJson(Map<String, dynamic> json) {
    recordDate = json['recordDate'];
    productTypeID = json['productTypeID'];
    productTypeName = json['productTypeName'];
    billDate = json['billDate'];
    billNumber = json['billNumber'];
    cartonPrice = json['cartonPrice'];
    transportPrice = json['transportPrice'];
    quantity = json['quantity'];
    additionalInfo = json['additionalInfo'] != null
        ? new AdditionalInfo.fromJson(json['additionalInfo'])
        : null;
    if (json['vendorInfo'] != null &&
        json['vendorInfo'] is Map &&
        (json['vendorInfo'] as Map).isNotEmpty) {
      vendorInfo = [new VendorInfo.fromJson(json['vendorInfo'])];
    } else {
      // Default for empty array or null or empty map
      vendorInfo = [
        VendorInfo(companyName: 'N/A', vendorCode: '', vendorKey: ''),
      ];
    }
    remark = json['remark'];
    rKey = json['rKey'];
    rStatus = json['rStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recordDate'] = this.recordDate;
    data['productTypeID'] = this.productTypeID;
    data['productTypeName'] = this.productTypeName;
    data['billDate'] = this.billDate;
    data['billNumber'] = this.billNumber;
    data['cartonPrice'] = this.cartonPrice;
    data['transportPrice'] = this.transportPrice;
    data['quantity'] = this.quantity;
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo!.toJson();
    }
    if (this.vendorInfo != null) {
      data['vendorInfo'] = this.vendorInfo!.map((v) => v.toJson()).toList();
    }
    data['remark'] = this.remark;
    data['rKey'] = this.rKey;
    data['rStatus'] = this.rStatus;
    return data;
  }
}

class AdditionalInfo {
  int? cutMMMeterID;
  int? cutMMMeter;
  int? piecesPerCarton;
  int? baseID;
  String? baseLabel;
  String? tapeLength;
  String? tapeWeight;
  int? micID;
  String? micLabel;

  AdditionalInfo({
    this.cutMMMeterID,
    this.cutMMMeter,
    this.piecesPerCarton,
    this.baseID,
    this.baseLabel,
    this.tapeLength,
    this.tapeWeight,
    this.micID,
    this.micLabel,
  });

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    cutMMMeterID = json['cutMMMeterID'];
    cutMMMeter = json['cutMMMeter'];
    piecesPerCarton = json['piecesPerCarton'];
    baseID = json['baseID'];
    baseLabel = json['baseLabel'];
    tapeLength = json['tapeLength'];
    tapeWeight = json['tapeWeight'];
    micID = json['micID'];
    micLabel = json['micLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cutMMMeterID'] = this.cutMMMeterID;
    data['cutMMMeter'] = this.cutMMMeter;
    data['piecesPerCarton'] = this.piecesPerCarton;
    data['baseID'] = this.baseID;
    data['baseLabel'] = this.baseLabel;
    data['tapeLength'] = this.tapeLength;
    data['tapeWeight'] = this.tapeWeight;
    data['micID'] = this.micID;
    data['micLabel'] = this.micLabel;
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

class BatchInformation {
  int? batchID;
  String? batchCode;
  String? batchDateText;
  int? showFor;
  String? showLabel;
  int? displayMic;
  int? displayValue;
  String? batchRemark;
  String? batchMRP;
  String? batchKey;

  BatchInformation({
    this.batchID,
    this.batchCode,
    this.batchDateText,
    this.showFor,
    this.showLabel,
    this.displayMic,
    this.displayValue,
    this.batchRemark,
    this.batchMRP,
    this.batchKey,
  });

  BatchInformation.fromJson(Map<String, dynamic> json) {
    batchID = json['batchID'];
    batchCode = json['batchCode'];
    batchDateText = json['batchDateText'];
    showFor = json['showFor'];
    showLabel = json['showLabel'];
    displayMic = json['displayMic'];
    displayValue = json['displayValue'];
    batchRemark = json['batchRemark'];
    batchMRP = json['batchMRP'];
    batchKey = json['batchKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batchID'] = this.batchID;
    data['batchCode'] = this.batchCode;
    data['batchDateText'] = this.batchDateText;
    data['showFor'] = this.showFor;
    data['showLabel'] = this.showLabel;
    data['displayMic'] = this.displayMic;
    data['displayValue'] = this.displayValue;
    data['batchRemark'] = this.batchRemark;
    data['batchMRP'] = this.batchMRP;
    data['batchKey'] = this.batchKey;
    return data;
  }
}
