class CoreListModel {
  int? status;
  List<Record>? record;
  String? message;

  CoreListModel({this.status, this.record, this.message});

  CoreListModel.fromJson(Map<String, dynamic> json) {
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
  int? mCoreId;
  String? mCoreName;
  String? mCoreCode;
  dynamic coreStock;

  Record({this.mCoreId, this.mCoreName, this.mCoreCode, this.coreStock});

  Record.fromJson(Map<String, dynamic> json) {
    mCoreId = json['mCoreId'];
    mCoreName = json['mCoreName'];
    mCoreCode = json['mCoreCode'];
    coreStock = json['coreStock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mCoreId'] = this.mCoreId;
    data['mCoreName'] = this.mCoreName;
    data['mCoreCode'] = this.mCoreCode;
    data['coreStock'] = this.coreStock;
    return data;
  }
}
