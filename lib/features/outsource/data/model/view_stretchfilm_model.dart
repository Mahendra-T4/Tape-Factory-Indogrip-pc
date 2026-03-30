class ViewStretchFilmModel {
  int? status;
  String? message;
  List<StretchRecord>? record;
  int? pageQty;
  String? pageText;
  int? totalPieces;
  int? availableCarton;

  ViewStretchFilmModel({
    this.status,
    this.message,
    this.record,
    this.pageQty,
    this.totalPieces,
    this.availableCarton,
  });

  ViewStretchFilmModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['record'] != null) {
      record = <StretchRecord>[];
      json['record'].forEach((v) {
        record!.add(new StretchRecord.fromJson(v));
      });
    }
    pageQty = json['pageQty'];
    pageText = json['pageText'];
    totalPieces = json['totalPieces'];
    availableCarton = json['availableCarton'];
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
    data['totalPieces'] = this.totalPieces;
    data['availableCarton'] = this.availableCarton;
    return data;
  }
}

class StretchRecord {
  int? sNo;
  String? inventoryCode;
  String? recordDate;
  int? productTypeID;
  String? productTypeName;
  String? billDate;
  String? billNumber;
  dynamic cartonPrice;
  dynamic transportPrice;
  dynamic actualPrice;
  int? quantity;
  AdditionalInfo? additionalInfo;
  VendorInfo? vendorInfo;
  String? remark;
  String? rKey;
  int? rStatus;
  String? inventoryStatusLabel;
  BatchInformation? batchInformation;

  StretchRecord({
    this.sNo,
    this.inventoryCode,
    this.recordDate,
    this.productTypeID,
    this.productTypeName,
    this.billDate,
    this.billNumber,
    this.cartonPrice,
    this.transportPrice,
    this.actualPrice,
    this.quantity,
    this.additionalInfo,
    this.vendorInfo,
    this.remark,
    this.rKey,
    this.rStatus,
    this.inventoryStatusLabel,
    this.batchInformation,
  });

  StretchRecord.fromJson(Map<String, dynamic> json) {
    sNo = json['SNo'];
    inventoryCode = json['inventoryCode'];
    recordDate = json['recordDate'];
    productTypeID = json['productTypeID'];
    productTypeName = json['productTypeName'];
    billDate = json['billDate'];
    billNumber = json['billNumber'];
    cartonPrice = json['cartonPrice'];
    transportPrice = json['transportPrice'];
    actualPrice = json['actualPrice'];
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
    inventoryStatusLabel = json['inventoryStatusLabel'];
    batchInformation = json['batchInformation'] != null
        ? new BatchInformation.fromJson(json['batchInformation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SNo'] = this.sNo;
    data['inventoryCode'] = this.inventoryCode;
    data['recordDate'] = this.recordDate;
    data['productTypeID'] = this.productTypeID;
    data['productTypeName'] = this.productTypeName;
    data['billDate'] = this.billDate;
    data['billNumber'] = this.billNumber;
    data['cartonPrice'] = this.cartonPrice;
    data['transportPrice'] = this.transportPrice;
    data['actualPrice'] = this.actualPrice;
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
    data['inventoryStatusLabel'] = this.inventoryStatusLabel;
    if (this.batchInformation != null) {
      data['batchInformation'] = this.batchInformation!.toJson();
    }
    return data;
  }
}

class AdditionalInfo {
  int? stretchFilmSizeID;
  dynamic stretchFilmSize;
  int? coreID;
  String? coreLabel;
  dynamic netWeight;
  dynamic grossWeight;
  dynamic difference;
  dynamic lessWeight;
  dynamic actualWeight;
  int? micID;
  String? micLabel;
  int? baseID;
  String? baseLabel;
  String? coreCode;
  dynamic rate;
  dynamic perKGPrice;
  dynamic margin;

  AdditionalInfo({
    this.stretchFilmSizeID,
    this.stretchFilmSize,
    this.coreID,
    this.coreLabel,
    this.netWeight,
    this.grossWeight,
    this.difference,
    this.lessWeight,
    this.actualWeight,
    this.micID,
    this.micLabel,
    this.baseID,
    this.baseLabel,
    this.coreCode,
    this.rate,
    this.perKGPrice,
    this.margin,
  });

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    stretchFilmSizeID = json['stretchFilmSizeID'];
    stretchFilmSize = json['stretchFilmSize'];
    coreID = json['coreID'];
    coreLabel = json['coreLabel'];
    netWeight = json['netWeight'];
    grossWeight = json['grossWeight'];
    difference = json['difference'];
    lessWeight = json['lessWeight'];
    actualWeight = json['actualWeight'];
    micID = json['micID'];
    micLabel = json['micLabel'];
    baseID = json['baseID'];
    baseLabel = json['baseLabel'];
    coreCode = json['coreCode'];
    rate = json['rate'];
    perKGPrice = json['perKGPrice'];
    margin = json['margin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stretchFilmSizeID'] = this.stretchFilmSizeID;
    data['stretchFilmSize'] = this.stretchFilmSize;
    data['coreID'] = this.coreID;
    data['coreLabel'] = this.coreLabel;
    data['netWeight'] = this.netWeight;
    data['grossWeight'] = this.grossWeight;
    data['difference'] = this.difference;
    data['lessWeight'] = this.lessWeight;
    data['actualWeight'] = this.actualWeight;
    data['micID'] = this.micID;
    data['micLabel'] = this.micLabel;
    data['baseID'] = this.baseID;
    data['baseLabel'] = this.baseLabel;
    data['coreCode'] = this.coreCode;
    data['rate'] = this.rate;
    data['perKGPrice'] = this.perKGPrice;
    data['margin'] = this.margin;
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
  String? batchID;
  int? batchType;
  String? batchCode;
  String? batchDateText;
  String? showFor;
  String? showLabel;
  dynamic displayMic;
  dynamic displayValue;
  dynamic displayMFG;
  dynamic displayMFGLabel;
  String? batchRemark;
  dynamic batchMRP;
  String? batchKey;

  BatchInformation({
    this.batchID,
    this.batchType,
    this.batchCode,
    this.batchDateText,
    this.showFor,
    this.showLabel,
    this.displayMic,
    this.displayValue,
    this.displayMFG,
    this.displayMFGLabel,
    this.batchRemark,
    this.batchMRP,
    this.batchKey,
  });

  BatchInformation.fromJson(Map<String, dynamic> json) {
    batchID = json['batchID'];
    batchType = json['batchType'];
    batchCode = json['batchCode'];
    batchDateText = json['batchDateText'];
    showFor = json['showFor'];
    showLabel = json['showLabel'];
    displayMic = json['displayMic'];
    displayValue = json['displayValue'];
    displayMFG = json['displayMFG'];
    displayMFGLabel = json['displayMFGLabel'];
    batchRemark = json['batchRemark'];
    batchMRP = json['batchMRP'];
    batchKey = json['batchKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batchID'] = this.batchID;
    data['batchType'] = this.batchType;
    data['batchCode'] = this.batchCode;
    data['batchDateText'] = this.batchDateText;
    data['showFor'] = this.showFor;
    data['showLabel'] = this.showLabel;
    data['displayMic'] = this.displayMic;
    data['displayValue'] = this.displayValue;
    data['displayMFG'] = this.displayMFG;
    data['displayMFGLabel'] = this.displayMFGLabel;
    data['batchRemark'] = this.batchRemark;
    data['batchMRP'] = this.batchMRP;
    data['batchKey'] = this.batchKey;
    return data;
  }
}
