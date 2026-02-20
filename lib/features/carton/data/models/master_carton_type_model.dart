class CartonTypeModel {
  int? status;
  List<CartonRecord>? record;
  String? message;

  CartonTypeModel({this.status, this.record, this.message});

  CartonTypeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['record'] != null) {
      record = <CartonRecord>[];
      json['record'].forEach((v) {
        record!.add(new CartonRecord.fromJson(v));
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

class CartonRecord {
  int? mCartonId;
  String? mCartonName;
  String? mCartonCode;
  dynamic cartonStock;

  CartonRecord({this.mCartonId, this.mCartonName, this.mCartonCode});

  CartonRecord.fromJson(Map<String, dynamic> json) {
    mCartonId = json['mCartonId'];
    mCartonName = json['mCartonName'];
    mCartonCode = json['mCartonCode'];
    cartonStock = json['cartonStock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mCartonId'] = this.mCartonId;
    data['mCartonName'] = this.mCartonName;
    data['mCartonCode'] = this.mCartonCode;
    data['cartonStock'] = this.cartonStock;
    return data;
  }
}
