class MasterProductTypeModel {
  int? status;
  List<Record>? record;
  String? message;

  MasterProductTypeModel({this.status, this.record, this.message});

  MasterProductTypeModel.fromJson(Map<String, dynamic> json) {
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
  int? productID;
  String? productTypeName;

  Record({this.productID, this.productTypeName});

  Record.fromJson(Map<String, dynamic> json) {
    productID = json['productID'];
    productTypeName = json['productTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productID'] = this.productID;
    data['productTypeName'] = this.productTypeName;
    return data;
  }
}
