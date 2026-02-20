class UserStatusModel {
  int? status;
  List<Record>? record;
  String? message;

  UserStatusModel({this.status, this.record, this.message});

  UserStatusModel.fromJson(Map<String, dynamic> json) {
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
  int? mID;
  String? mActiveStatus;

  Record({this.mID, this.mActiveStatus});

  Record.fromJson(Map<String, dynamic> json) {
    mID = json['mID'];
    mActiveStatus = json['mActiveStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mID'] = this.mID;
    data['mActiveStatus'] = this.mActiveStatus;
    return data;
  }
}
