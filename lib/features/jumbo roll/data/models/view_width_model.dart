class ViewWidthModel {
  int? status;
  List<Record>? record;
  String? message;

  ViewWidthModel({this.status, this.record, this.message});

  ViewWidthModel.fromJson(Map<String, dynamic> json) {
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
  int? mWidthId;
  int? mWidthName;
  dynamic availableLength;
  int? jumboCount;

  Record({
    this.mWidthId,
    this.mWidthName,
    this.availableLength,
    this.jumboCount,
  });

  Record.fromJson(Map<String, dynamic> json) {
    mWidthId = json['mWidthId'];
    mWidthName = json['mWidthName'];
    availableLength = json['availableLength'];
    jumboCount = json['jumboCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mWidthId'] = this.mWidthId;
    data['mWidthName'] = this.mWidthName;
    data['availableLength'] = this.availableLength;
    data['jumboCount'] = this.jumboCount;
    return data;
  }
}
