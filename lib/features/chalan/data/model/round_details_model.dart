class RoundDetails {
  int? status;
  RoundDetailsRecord? record;
  String? message;

  RoundDetails({this.status, this.record, this.message});

  RoundDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    record = json['record'] != null
        ? new RoundDetailsRecord.fromJson(json['record'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.record != null) {
      data['record'] = this.record!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class RoundDetailsRecord {
  dynamic cutMMMeter;
  dynamic piecesPerCarton;
  int? baseID;
  String? baseLabel;
  int? micID;
  String? micLabel;
  dynamic showFor;
  String? showLabel;
  dynamic tapeLength;
  dynamic tapeWeight;
  String? batchRemark;
  String? displayMFG;
  String? displayMFGLabel;
  dynamic batchCode;
  int? productType;
  dynamic size;
  dynamic stretchWeight;
  String? operation;

  RoundDetailsRecord({
    this.cutMMMeter,
    this.piecesPerCarton,
    this.baseID,
    this.baseLabel,
    this.micID,
    this.micLabel,
    this.showFor,
    this.showLabel,
    this.tapeLength,
    this.tapeWeight,
    this.batchRemark,
    this.displayMFG,
    this.displayMFGLabel,
    this.batchCode,
    this.productType,
    this.size,
    this.stretchWeight,
    this.operation,
  });

  RoundDetailsRecord.fromJson(Map<String, dynamic> json) {
    cutMMMeter = json['cutMMMeter'];
    piecesPerCarton = json['piecesPerCarton'];
    baseID = json['baseID'];
    baseLabel = json['baseLabel'];
    micID = json['micID'];
    micLabel = json['micLabel'];
    showFor = json['showFor'];
    showLabel = json['showLabel'];
    tapeLength = json['tapeLength'];
    tapeWeight = json['tapeWeight'];
    batchRemark = json['batchRemark'];
    displayMFG = json['displayMFG'];
    displayMFGLabel = json['displayMFGLabel'];
    batchCode = json['batchCode'];
    productType = json['productType'];
    size = json['size'];
    stretchWeight = json['stretchWeight'];
    operation = json['operation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cutMMMeter'] = this.cutMMMeter;
    data['piecesPerCarton'] = this.piecesPerCarton;
    data['baseID'] = this.baseID;
    data['baseLabel'] = this.baseLabel;
    data['micID'] = this.micID;
    data['micLabel'] = this.micLabel;
    data['showFor'] = this.showFor;
    data['showLabel'] = this.showLabel;
    data['tapeLength'] = this.tapeLength;
    data['tapeWeight'] = this.tapeWeight;
    data['batchRemark'] = this.batchRemark;
    data['displayMFG'] = this.displayMFG;
    data['displayMFGLabel'] = this.displayMFGLabel;
    data['batchCode'] = this.batchCode;
    return data;
  }
}
