class ViewRoundModel {
  int? status;
  String? message;
  List<RoundRecord>? record;
  int? pageQty;

  ViewRoundModel({this.status, this.message, this.record, this.pageQty});

  ViewRoundModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['record'] != null) {
      record = <RoundRecord>[];
      json['record'].forEach((v) {
        record!.add(new RoundRecord.fromJson(v));
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

class RoundRecord {
  int? sNo;
  String? rollNumber;
  String? jumboKey;
  dynamic width;
  String? base;
  String? mic;
  dynamic length;
  dynamic totalWeight;
  dynamic amountPerKG;
  dynamic rollSizeID;
  dynamic cutMMMeter;

  dynamic coreID;
  String? coreLabel;
  int? cartonType;
  dynamic roundCount;
  dynamic tapeLength;
  dynamic damagePieces;
  dynamic wastagePercentage;
  dynamic conversionRate;
  dynamic usedLength;
  dynamic piecesPerCarton;
  dynamic usedSquareMeter;
  dynamic rollCost;
  dynamic totalSquareMtr;
  dynamic ratePerSquareMeter;
  dynamic cartonMaterialCost;
  dynamic cartonRate;
  dynamic marginWithTenPercentage;
  dynamic marginWithTwelvePercentage;
  dynamic marginWithFifteenPercentage;
  int? totalCarton;
  BatchInformation? batchInformation;
  String? rKey;
  int? rStatus;
  String? roundStatusLabel;

  RoundRecord({
    this.sNo,
    this.rollNumber,
    this.jumboKey,
    this.width,
    this.base,
    this.mic,
    this.length,
    this.totalWeight,
    this.amountPerKG,
    this.rollSizeID,
    this.cutMMMeter,
    this.coreID,
    this.coreLabel,
    this.cartonType,
    this.roundCount,
    this.tapeLength,
    this.damagePieces,
    this.wastagePercentage,
    this.conversionRate,
    this.usedLength,
    this.piecesPerCarton,
    this.usedSquareMeter,
    this.rollCost,
    this.totalSquareMtr,
    this.ratePerSquareMeter,
    this.cartonMaterialCost,
    this.cartonRate,
    this.marginWithTenPercentage,
    this.marginWithTwelvePercentage,
    this.marginWithFifteenPercentage,
    this.totalCarton,
    this.batchInformation,
    this.rKey,

    this.rStatus,
    this.roundStatusLabel,
  });

  RoundRecord.fromJson(Map<String, dynamic> json) {
    sNo = json['sNo'];
    rollNumber = json['rollNumber'];
    jumboKey = json['jumboKey'];
    width = json['width'];
    base = json['base'];
    mic = json['mic'];
    length = json['length'];
    totalWeight = json['totalWeight'];
    amountPerKG = json['amountPerKG'];
    rollSizeID = json['rollSizeID'];
    cutMMMeter = json['cutMMMeter'];
    coreID = json['coreID'];
    coreLabel = json['coreLabel'];
    cartonType = json['cartonType'];
    roundCount = json['roundCount'];
    tapeLength = json['tapeLength'];
    damagePieces = json['damagePieces'];
    wastagePercentage = json['wastagePercentage'];
    conversionRate = json['conversionRate'];
    usedLength = json['usedLength'];
    piecesPerCarton = json['piecesPerCarton'];
    usedSquareMeter = json['usedSquareMeter'];
    rollCost = json['rollCost'];
    totalSquareMtr = json['totalSquareMtr'];
    ratePerSquareMeter = json['ratePerSquareMeter'];
    cartonMaterialCost = json['cartonMaterialCost'];
    cartonRate = json['cartonRate'];
    marginWithTenPercentage = json['marginWithTenPercentage'];
    marginWithTwelvePercentage = json['marginWithTwelvePercentage'];
    marginWithFifteenPercentage = json['marginWithFifteenPercentage'];
    totalCarton = json['totalCarton'];
    batchInformation = json['batchInformation'] != null
        ? new BatchInformation.fromJson(json['batchInformation'])
        : null;
    rKey = json['rKey'];
    cartonType = json['cartonType'];
    rStatus = json['rStatus'];
    roundStatusLabel = json['roundStatusLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sNo'] = this.sNo;
    data['rollNumber'] = this.rollNumber;
    data['jumboKey'] = this.jumboKey;
    data['width'] = this.width;
    data['base'] = this.base;
    data['mic'] = this.mic;
    data['length'] = this.length;
    data['totalWeight'] = this.totalWeight;
    data['amountPerKG'] = this.amountPerKG;
    data['rollSizeID'] = this.rollSizeID;
    data['cutMMMeter'] = this.cutMMMeter;
    data['coreID'] = this.coreID;
    data['coreLabel'] = this.coreLabel;
    data['cartonType'] = this.cartonType;
    data['roundCount'] = this.roundCount;
    data['tapeLength'] = this.tapeLength;
    data['damagePieces'] = this.damagePieces;
    data['wastagePercentage'] = this.wastagePercentage;
    data['conversionRate'] = this.conversionRate;
    data['usedLength'] = this.usedLength;
    data['piecesPerCarton'] = this.piecesPerCarton;
    data['usedSquareMeter'] = this.usedSquareMeter;
    data['rollCost'] = this.rollCost;
    data['totalSquareMtr'] = this.totalSquareMtr;
    data['ratePerSquareMeter'] = this.ratePerSquareMeter;
    data['cartonMaterialCost'] = this.cartonMaterialCost;
    data['cartonRate'] = this.cartonRate;
    data['marginWithTenPercentage'] = this.marginWithTenPercentage;
    data['marginWithTwelvePercentage'] = this.marginWithTwelvePercentage;
    data['marginWithFifteenPercentage'] = this.marginWithFifteenPercentage;
    data['totalCarton'] = this.totalCarton;

    if (this.batchInformation != null) {
      data['batchInformation'] = this.batchInformation!.toJson();
    }
    data['rKey'] = this.rKey;
    data['rStatus'] = this.rStatus;
    return data;
  }
}

class BatchInformation {
  dynamic batchID;
  dynamic batchType;
  String? batchCode;
  String? batchDateText;
  dynamic showFor;
  String? showLabel;
  dynamic displayMic;
  dynamic displayValue;
  String? batchRemark;
  String? batchMRP;
  String? batchOperator;
  String? batchPackedBy;
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
    this.batchRemark,
    this.batchMRP,
    this.batchOperator,
    this.batchPackedBy,
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
    batchRemark = json['batchRemark'];
    batchMRP = json['batchMRP'];
    batchOperator = json['batchOperator'];
    batchPackedBy = json['batchPackedBy'];
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
    data['batchRemark'] = this.batchRemark;
    data['batchMRP'] = this.batchMRP;
    data['batchOperator'] = this.batchOperator;
    data['batchPackedBy'] = this.batchPackedBy;
    data['batchKey'] = this.batchKey;
    return data;
  }
}
