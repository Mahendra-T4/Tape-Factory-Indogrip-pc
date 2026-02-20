class MJumboRollModel {
  int? status;
  List<MJumboRollRecord>? record;
  String? message;

  MJumboRollModel({this.status, this.record, this.message});

  MJumboRollModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['record'] != null) {
      record = <MJumboRollRecord>[];
      json['record'].forEach((v) {
        record!.add(new MJumboRollRecord.fromJson(v));
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

class MJumboRollRecord {
  int? mJumboRollId;
  String? mJumboRollSize;

  MJumboRollRecord({this.mJumboRollId, this.mJumboRollSize});

  MJumboRollRecord.fromJson(Map<String, dynamic> json) {
    mJumboRollId = json['mJumboRollId'];
    mJumboRollSize = json['mJumboRollSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mJumboRollId'] = this.mJumboRollId;
    data['mJumboRollSize'] = this.mJumboRollSize;
    return data;
  }
}
