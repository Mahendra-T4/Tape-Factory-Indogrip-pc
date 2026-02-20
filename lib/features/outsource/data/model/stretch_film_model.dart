class MasterStretchFilmModel {
  int? status;
  List<Record>? record;
  String? message;

  MasterStretchFilmModel({this.status, this.record, this.message});

  MasterStretchFilmModel.fromJson(Map<String, dynamic> json) {
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
  int? stretchFilmSize;

  Record({this.mID, this.stretchFilmSize});

  Record.fromJson(Map<String, dynamic> json) {
    mID = json['mID'];
    stretchFilmSize = json['stretchFilmSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mID'] = this.mID;
    data['stretchFilmSize'] = this.stretchFilmSize;
    return data;
  }
}