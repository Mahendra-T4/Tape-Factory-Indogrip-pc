class MasterRoll {
  int? status;
  List<Record>? record;
  String? message;

  MasterRoll({this.status, this.record, this.message});

  MasterRoll.fromJson(Map<String, dynamic> json) {
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
  int? mUserRoleId;
  String? mUserRoleName;

  Record({this.mUserRoleId, this.mUserRoleName});

  Record.fromJson(Map<String, dynamic> json) {
    mUserRoleId = json['mUserRoleId'];
    mUserRoleName = json['mUserRoleName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mUserRoleId'] = this.mUserRoleId;
    data['mUserRoleName'] = this.mUserRoleName;
    return data;
  }
}
