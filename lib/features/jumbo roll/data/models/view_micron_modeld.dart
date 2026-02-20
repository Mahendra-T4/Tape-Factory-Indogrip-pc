class ViewMicronModel {
  int? status;
  List<Record>? record;
  String? message;

  ViewMicronModel({this.status, this.record, this.message});

  ViewMicronModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['record'] != null) {
      record = <Record>[];
      json['record'].forEach((v) {
        record!.add(new Record.fromJson(v));
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

class Record {
  int? mMicId;
  String? mMicName;

  Record({this.mMicId, this.mMicName});

  Record.fromJson(Map<String, dynamic> json) {
    mMicId = json['mMicId'];
    mMicName = json['mMicName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mMicId'] = this.mMicId;
    data['mMicName'] = this.mMicName;
    return data;
  }
}