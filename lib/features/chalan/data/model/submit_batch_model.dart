class SubmitBatchModel {
  int? status;
  dynamic totalRequest;
  dynamic missedRequest;
  dynamic acceptRequest;
  List<MissedRecord>? missedRecord;
  String? message;

  SubmitBatchModel({
    this.status,
    this.totalRequest,
    this.missedRequest,
    this.acceptRequest,
    this.missedRecord,
    this.message,
  });

  SubmitBatchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalRequest = json['totalRequest'];
    missedRequest = json['missedRequest'];
    acceptRequest = json['acceptRequest'];
    if (json['missedRecord'] != null) {
      missedRecord = <MissedRecord>[];
      json['missedRecord'].forEach((v) {
        missedRecord!.add(MissedRecord.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['totalRequest'] = totalRequest;
    data['missedRequest'] = missedRequest;
    data['acceptRequest'] = acceptRequest;
    if (missedRecord != null) {
      data['missedRecord'] = missedRecord!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class MissedRecord {
  dynamic batchID;
  dynamic batchQuantity;
  String? query;
  dynamic availableQuantity;
  String? reason;

  MissedRecord({
    this.batchID,
    this.batchQuantity,
    this.query,
    this.availableQuantity,
    this.reason,
  });

  MissedRecord.fromJson(Map<String, dynamic> json) {
    batchID = json['batchID'];
    batchQuantity = json['batchQuantity'];
    query = json['query'];
    availableQuantity = json['availableQuantity'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['batchID'] = batchID;
    data['batchQuantity'] = batchQuantity;
    data['query'] = query;
    data['availableQuantity'] = availableQuantity;
    data['reason'] = reason;
    return data;
  }
}
