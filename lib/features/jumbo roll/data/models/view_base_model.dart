class ViewBaseModel {
  int? status;
  List<BaseRecord>? record;
  String? message;

  ViewBaseModel({this.status, this.record, this.message});

  ViewBaseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['record'] != null) {
      record = <BaseRecord>[];
      json['record'].forEach((v) {
        record!.add(new BaseRecord.fromJson(v));
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

class BaseRecord {
  int? mBaseId;
  String? mBaseName;

  BaseRecord({this.mBaseId, this.mBaseName});

  BaseRecord.fromJson(Map<String, dynamic> json) {
    mBaseId = json['mBaseId'];
    mBaseName = json['mBaseName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mBaseId'] = this.mBaseId;
    data['mBaseName'] = this.mBaseName;
    return data;
  }
}
