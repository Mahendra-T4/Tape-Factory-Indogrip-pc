class BatchDetailsModel {
  int? status;
  String? message;
  Record? record;

  BatchDetailsModel({this.status, this.message, this.record});

  BatchDetailsModel.fromJson(Map<String, dynamic> json) {
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
  JumboInformation? jumboInformation;
  RoundInformation? roundInformation;
  BatchInformation? batchInformation;

  Record({this.jumboInformation, this.roundInformation, this.batchInformation});

  Record.fromJson(Map<String, dynamic> json) {
    jumboInformation = json['jumboInformation'] != null
        ? new JumboInformation.fromJson(json['jumboInformation'])
        : null;
    roundInformation = json['roundInformation'] != null
        ? new RoundInformation.fromJson(json['roundInformation'])
        : null;
    batchInformation = json['batchInformation'] != null
        ? new BatchInformation.fromJson(json['batchInformation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.jumboInformation != null) {
      data['jumboInformation'] = this.jumboInformation!.toJson();
    }
    if (this.roundInformation != null) {
      data['roundInformation'] = this.roundInformation!.toJson();
    }
    if (this.batchInformation != null) {
      data['batchInformation'] = this.batchInformation!.toJson();
    }
    return data;
  }
}

class JumboInformation {
  String? jumboCode;
  String? jumboDate;
  String? billDate;
  String? billNumber;
  String? rollNumber;
  dynamic baseID;
  String? baseLabel;
  dynamic micID;
  String? micLabel;
  dynamic length;
  dynamic netWeight;
  dynamic widthID;
  dynamic width;
  dynamic totalSquareMtr;
  dynamic amountPerKG;
  dynamic rollCost;
  String? remark;
  VendorInfo? vendorInfo;

  JumboInformation({
    this.jumboCode,
    this.jumboDate,
    this.billDate,
    this.billNumber,
    this.rollNumber,
    this.baseID,
    this.baseLabel,
    this.micID,
    this.micLabel,
    this.length,
    this.netWeight,
    this.widthID,
    this.width,
    this.totalSquareMtr,
    this.amountPerKG,
    this.rollCost,
    this.remark,
    this.vendorInfo,
  });

  JumboInformation.fromJson(Map<String, dynamic> json) {
    jumboCode = json['jumboCode'];
    jumboDate = json['jumboDate'];
    billDate = json['billDate'];
    billNumber = json['billNumber'];
    rollNumber = json['rollNumber'];
    baseID = json['baseID'];
    baseLabel = json['baseLabel'];
    micID = json['micID'];
    micLabel = json['micLabel'];
    length = json['length'];
    netWeight = json['netWeight'];
    widthID = json['widthID'];
    width = json['width'];
    totalSquareMtr = json['totalSquareMtr'];
    amountPerKG = json['amountPerKG'];
    rollCost = json['rollCost'];
    remark = json['remark'];
    vendorInfo = json['vendorInfo'] != null
        ? new VendorInfo.fromJson(json['vendorInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jumboCode'] = this.jumboCode;
    data['jumboDate'] = this.jumboDate;
    data['billDate'] = this.billDate;
    data['billNumber'] = this.billNumber;
    data['rollNumber'] = this.rollNumber;
    data['baseID'] = this.baseID;
    data['baseLabel'] = this.baseLabel;
    data['micID'] = this.micID;
    data['micLabel'] = this.micLabel;
    data['length'] = this.length;
    data['netWeight'] = this.netWeight;
    data['widthID'] = this.widthID;
    data['width'] = this.width;
    data['totalSquareMtr'] = this.totalSquareMtr;
    data['amountPerKG'] = this.amountPerKG;
    data['rollCost'] = this.rollCost;
    data['remark'] = this.remark;
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

class RoundInformation {
  String? roundDateText;
  dynamic cutMMMeter;
  dynamic roundCount;
  dynamic tapeLength;
  dynamic damagePieces;
  dynamic wastagePercentage;
  dynamic wastageOnCarton;
  dynamic conversionRate;
  dynamic usedLength;
  dynamic piecesPerCarton;
  dynamic usedSquareMeter;
  dynamic totalSquareMtr;
  dynamic ratePerSquareMeter;
  dynamic singleTapeSquareMeter;
  dynamic cartonMaterialCost;
  dynamic cartonRate;
  dynamic marginWithTenPercentage;
  dynamic marginWithTwelvePercentage;
  dynamic marginWithFifteenPercentage;
  String? rKey;
  int? rStatus;
  RoundAdditionalInformation? roundAdditionalInformation;

  RoundInformation({
    this.roundDateText,
    this.cutMMMeter,
    this.roundCount,
    this.tapeLength,
    this.damagePieces,
    this.wastagePercentage,
    this.wastageOnCarton,
    this.conversionRate,
    this.usedLength,
    this.piecesPerCarton,
    this.usedSquareMeter,
    this.totalSquareMtr,
    this.ratePerSquareMeter,
    this.singleTapeSquareMeter,
    this.cartonMaterialCost,
    this.cartonRate,
    this.marginWithTenPercentage,
    this.marginWithTwelvePercentage,
    this.marginWithFifteenPercentage,
    this.rKey,
    this.rStatus,
    this.roundAdditionalInformation,
  });

  RoundInformation.fromJson(Map<String, dynamic> json) {
    roundDateText = json['roundDateText'];
    cutMMMeter = json['cutMMMeter'];
    roundCount = json['roundCount'];
    tapeLength = json['tapeLength'];
    damagePieces = json['damagePieces'];
    wastagePercentage = json['wastagePercentage'];
    wastageOnCarton = json['wastageOnCarton'];
    conversionRate = json['conversionRate'];
    usedLength = json['usedLength'];
    piecesPerCarton = json['piecesPerCarton'];
    usedSquareMeter = json['usedSquareMeter'];
    totalSquareMtr = json['totalSquareMtr'];
    ratePerSquareMeter = json['ratePerSquareMeter'];
    singleTapeSquareMeter = json['singleTapeSquareMeter'];
    cartonMaterialCost = json['cartonMaterialCost'];
    cartonRate = json['cartonRate'];
    marginWithTenPercentage = json['marginWithTenPercentage'];
    marginWithTwelvePercentage = json['marginWithTwelvePercentage'];
    marginWithFifteenPercentage = json['marginWithFifteenPercentage'];
    rKey = json['rKey'];
    rStatus = json['rStatus'];
    roundAdditionalInformation = json['roundAdditionalInformation'] != null
        ? new RoundAdditionalInformation.fromJson(
            json['roundAdditionalInformation'],
          )
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roundDateText'] = this.roundDateText;
    data['cutMMMeter'] = this.cutMMMeter;
    data['roundCount'] = this.roundCount;
    data['tapeLength'] = this.tapeLength;
    data['damagePieces'] = this.damagePieces;
    data['wastagePercentage'] = this.wastagePercentage;
    data['wastageOnCarton'] = this.wastageOnCarton;
    data['conversionRate'] = this.conversionRate;
    data['usedLength'] = this.usedLength;
    data['piecesPerCarton'] = this.piecesPerCarton;
    data['usedSquareMeter'] = this.usedSquareMeter;
    data['totalSquareMtr'] = this.totalSquareMtr;
    data['ratePerSquareMeter'] = this.ratePerSquareMeter;
    data['singleTapeSquareMeter'] = this.singleTapeSquareMeter;
    data['cartonMaterialCost'] = this.cartonMaterialCost;
    data['cartonRate'] = this.cartonRate;
    data['marginWithTenPercentage'] = this.marginWithTenPercentage;
    data['marginWithTwelvePercentage'] = this.marginWithTwelvePercentage;
    data['marginWithFifteenPercentage'] = this.marginWithFifteenPercentage;
    data['rKey'] = this.rKey;
    data['rStatus'] = this.rStatus;
    if (this.roundAdditionalInformation != null) {
      data['roundAdditionalInformation'] = this.roundAdditionalInformation!
          .toJson();
    }
    return data;
  }
}

class RoundAdditionalInformation {
  dynamic perPieceRate;
  dynamic totalPiecesPerSingleRound;
  dynamic piecesWithDamagePieces;
  dynamic totalPiecesPerRound;
  dynamic totalCarton;
  dynamic piecesInCarton;
  dynamic remainingPieces;
  dynamic cartonType;
  dynamic usedCore;
  dynamic currentConsumedLength;

  RoundAdditionalInformation({
    this.perPieceRate,
    this.totalPiecesPerSingleRound,
    this.piecesWithDamagePieces,
    this.totalPiecesPerRound,
    this.totalCarton,
    this.piecesInCarton,
    this.remainingPieces,
    this.cartonType,
    this.usedCore,
    this.currentConsumedLength,
  });

  RoundAdditionalInformation.fromJson(Map<String, dynamic> json) {
    perPieceRate = json['perPieceRate'];
    totalPiecesPerSingleRound = json['totalPiecesPerSingleRound'];
    piecesWithDamagePieces = json['piecesWithDamagePieces'];
    totalPiecesPerRound = json['totalPiecesPerRound'];
    totalCarton = json['totalCarton'];
    piecesInCarton = json['piecesInCarton'];
    remainingPieces = json['remainingPieces'];
    cartonType = json['cartonType'];
    usedCore = json['usedCore'];
    currentConsumedLength = json['currentConsumedLength'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['perPieceRate'] = this.perPieceRate;
    data['totalPiecesPerSingleRound'] = this.totalPiecesPerSingleRound;
    data['piecesWithDamagePieces'] = this.piecesWithDamagePieces;
    data['totalPiecesPerRound'] = this.totalPiecesPerRound;
    data['totalCarton'] = this.totalCarton;
    data['piecesInCarton'] = this.piecesInCarton;
    data['remainingPieces'] = this.remainingPieces;
    data['cartonType'] = this.cartonType;
    data['usedCore'] = this.usedCore;
    data['currentConsumedLength'] = this.currentConsumedLength;
    return data;
  }
}

class BatchInformation {
  dynamic batchID;
  String? batchCode;
  String? batchDateText;
  dynamic showFor;
  String? showLabel;
  dynamic displayMic;
  dynamic displayValue;
  String? batchRemark;
  dynamic batchMRP;
  String? batchOperator;
  String? batchPackedBy;
  String? batchKey;
  String? displayMFG;
  String? displayMFGLabel;

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
    this.batchOperator,
    this.batchPackedBy,
    this.displayMFG,
    this.batchKey,
    this.displayMFGLabel,
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
    batchOperator = json['batchOperator'];
    batchPackedBy = json['batchPackedBy'];
    displayMFG = json['displayMFG'];
    batchKey = json['batchKey'];
    displayMFGLabel = json['displayMFGLabel'];
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
    data['batchOperator'] = this.batchOperator;
    data['batchPackedBy'] = this.batchPackedBy;
    data['displayMFG'] = this.displayMFG;
    data['batchKey'] = this.batchKey;
    data['displayMFGLabel'] = this.displayMFGLabel;
    return data;
  }
}
