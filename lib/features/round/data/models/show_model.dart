class ShowModel {
  int? status;
  List<Record>? record;
  String? message;

  ShowModel({this.status, this.record, this.message});

  ShowModel.fromJson(Map<String, dynamic> json) {
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
  int? showForID;
  String? showForLabel;

  Record({this.showForID, this.showForLabel});

  Record.fromJson(Map<String, dynamic> json) {
    showForID = json['showForID'];
    showForLabel = json['showForLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['showForID'] = this.showForID;
    data['showForLabel'] = this.showForLabel;
    return data;
  }
}
