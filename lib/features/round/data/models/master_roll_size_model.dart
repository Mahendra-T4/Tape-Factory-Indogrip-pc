class MasterRollSizeModel {
  int? status;
  List<Record>? record;
  String? message;

  MasterRollSizeModel({this.status, this.record, this.message});

  MasterRollSizeModel.fromJson(Map<String, dynamic> json) {
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
  int? mRollSizeId;
  String? mRollSize;

  Record({this.mRollSizeId, this.mRollSize});

  Record.fromJson(Map<String, dynamic> json) {
    mRollSizeId = json['mRollSizeId'];
    mRollSize = json['mRollSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mRollSizeId'] = this.mRollSizeId;
    data['mRollSize'] = this.mRollSize;
    return data;
  }
}
