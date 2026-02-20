class ReadUnReadMasterStatusModel {
  int? status;
  List<Record>? record;
  String? message;

  ReadUnReadMasterStatusModel({this.status, this.record, this.message});

  ReadUnReadMasterStatusModel.fromJson(Map<String, dynamic> json) {
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
  int? readUnreadID;
  String? readUnreadName;

  Record({this.readUnreadID, this.readUnreadName});

  Record.fromJson(Map<String, dynamic> json) {
    readUnreadID = json['readUnreadID'];
    readUnreadName = json['readUnreadName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['readUnreadID'] = this.readUnreadID;
    data['readUnreadName'] = this.readUnreadName;
    return data;
  }
}
