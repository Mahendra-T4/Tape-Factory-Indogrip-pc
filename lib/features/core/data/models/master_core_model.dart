class MasterCoreModel {
  int? status;
  List<CoreRecord>? record;
  String? message;

  MasterCoreModel({this.status, this.record, this.message});

  MasterCoreModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['record'] != null) {
      record = <CoreRecord>[];
      json['record'].forEach((v) {
        record!.add(new CoreRecord.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.record != null) {
      data['record'] = this.record!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class CoreRecord {
  int? mCoreId;
  String? mCoreName;

  CoreRecord({this.mCoreId, this.mCoreName});

  CoreRecord.fromJson(Map<String, dynamic> json) {
    mCoreId = json['mCoreId'];
    mCoreName = json['mCoreName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mCoreId'] = this.mCoreId;
    data['mCoreName'] = this.mCoreName;
    return data;
  }
}