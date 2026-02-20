class StockStatusModel {
  int? status;
  List<Record>? record;
  String? message;

  StockStatusModel({this.status, this.record, this.message});

  StockStatusModel.fromJson(Map<String, dynamic> json) {
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
  int? stockID;
  String? stockLabel;

  Record({this.stockID, this.stockLabel});

  Record.fromJson(Map<String, dynamic> json) {
    stockID = json['stockID'];
    stockLabel = json['stockLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stockID'] = this.stockID;
    data['stockLabel'] = this.stockLabel;
    return data;
  }
}
