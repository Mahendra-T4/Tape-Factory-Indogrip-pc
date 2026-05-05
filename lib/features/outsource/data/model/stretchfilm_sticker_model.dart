class StretchFilmStickerModel {
  int? status;
  String? message;
  Record? record;

  StretchFilmStickerModel({this.status, this.message, this.record});

  StretchFilmStickerModel.fromJson(Map<String, dynamic> json) {
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
  dynamic inventoryCode;
  String? recordDate;
  dynamic productTypeID;
  String? productTypeName;
  String? billDate;
  String? billNumber;
  dynamic cartonPrice;
  dynamic transportPrice;
  dynamic quantity;
  AdditionalInfo? additionalInfo;
  VendorInfo? vendorInfo;
  String? remark;
  String? rKey;
  int? rStatus;

  InventoryInformation({
    this.inventoryCode,
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
    inventoryCode = json['inventoryCode'] ?? '';
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
    vendorInfo = json['vendorInfo'] != null
        ? new VendorInfo.fromJson(json['vendorInfo'])
        : null;
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
      data['vendorInfo'] = this.vendorInfo!.toJson();
    }
    data['remark'] = this.remark;
    data['rKey'] = this.rKey;
    data['rStatus'] = this.rStatus;
    return data;
  }
}

class AdditionalInfo {
  dynamic stretchFilmSizeID;
  dynamic stretchFilmSize;
  dynamic coreID;
  String? coreLabel;
  dynamic netWeight;
  dynamic grossWeight;
  dynamic micID;
  String? micLabel;
  dynamic baseID;
  String? baseLabel;
  dynamic coreCode;

  AdditionalInfo({
    this.stretchFilmSizeID,
    this.stretchFilmSize,
    this.coreID,
    this.coreLabel,
    this.netWeight,
    this.grossWeight,
    this.micID,
    this.micLabel,
    this.baseID,
    this.baseLabel,
    this.coreCode,
  });

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    stretchFilmSizeID = json['stretchFilmSizeID'];
    stretchFilmSize = json['stretchFilmSize'];
    coreID = json['coreID'];
    coreLabel = json['coreLabel'];
    netWeight = json['netWeight'];
    grossWeight = json['grossWeight'];
    micID = json['micID'];
    micLabel = json['micLabel'];
    baseID = json['baseID'];
    baseLabel = json['baseLabel'];
    coreCode = json['coreCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stretchFilmSizeID'] = this.stretchFilmSizeID;
    data['stretchFilmSize'] = this.stretchFilmSize;
    data['coreID'] = this.coreID;
    data['coreLabel'] = this.coreLabel;
    data['netWeight'] = this.netWeight;
    data['grossWeight'] = this.grossWeight;
    data['micID'] = this.micID;
    data['micLabel'] = this.micLabel;
    data['baseID'] = this.baseID;
    data['baseLabel'] = this.baseLabel;
    data['coreCode'] = this.coreCode;
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
  dynamic batchID;
  dynamic batchScanCode;
  String? batchCode;
  String? batchDateText;
  dynamic showFor;
  String? showLabel;
  dynamic displayMic;
  String? displayValue;
  String? displayMFG;
  String? displayMFGLabel;
  String? batchRemark;
  dynamic batchType;
  String? batchMRP;
  String? batchKey;

  BatchInformation({
    this.batchID,
    this.batchScanCode,
    this.batchCode,
    this.batchDateText,
    this.showFor,
    this.showLabel,
    this.displayMic,
    this.displayValue,
    this.displayMFG,
    this.displayMFGLabel,
    this.batchRemark,
    this.batchType,
    this.batchMRP,
    this.batchKey,
  });

  BatchInformation.fromJson(Map<String, dynamic> json) {
    batchID = json['batchID'];
    batchScanCode = json['batchScanCode'];
    batchCode = json['batchCode'];
    batchDateText = json['batchDateText'];
    showFor = json['showFor'];
    showLabel = json['showLabel'];
    displayMic = json['displayMic'];
    displayValue = json['displayValue'];
    displayMFG = json['displayMFG'];
    displayMFGLabel = json['displayMFGLabel'];
    batchRemark = json['batchRemark'];
    batchType = json['batchType'];
    batchMRP = json['batchMRP'];
    batchKey = json['batchKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batchID'] = this.batchID;
    data['batchScanCode'] = this.batchScanCode;
    data['batchCode'] = this.batchCode;
    data['batchDateText'] = this.batchDateText;
    data['showFor'] = this.showFor;
    data['showLabel'] = this.showLabel;
    data['displayMic'] = this.displayMic;
    data['displayValue'] = this.displayValue;
    data['displayMFG'] = this.displayMFG;
    data['displayMFGLabel'] = this.displayMFGLabel;
    data['batchRemark'] = this.batchRemark;
    data['batchType'] = this.batchType;
    data['batchMRP'] = this.batchMRP;
    data['batchKey'] = this.batchKey;
    return data;
  }
}
