class ChalanListModel {
  int? status;
  String? message;
  List<ChalanRecord>? record;
  int? pageQty;

  ChalanListModel({this.status, this.message, this.record, this.pageQty});

  ChalanListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['record'] != null) {
      record = <ChalanRecord>[];
      json['record'].forEach((v) {
        record!.add(new ChalanRecord.fromJson(v));
      });
    }
    pageQty = json['pageQty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.record != null) {
      data['record'] = this.record!.map((v) => v.toJson()).toList();
    }
    data['pageQty'] = this.pageQty;
    return data;
  }
}

class ChalanRecord {
  int? sNo;
  String? challanNumber;
  String? dateTime;
  ClientInformation? clientInformation;
  StaffInformation? staffInformation;
  String? rKey;
  int? rStatus;

  ChalanRecord({
    this.sNo,
    this.challanNumber,
    this.dateTime,
    this.clientInformation,
    this.staffInformation,
    this.rKey,
    this.rStatus,
  });

  ChalanRecord.fromJson(Map<String, dynamic> json) {
    sNo = json['SNo'];
    challanNumber = json['challanNumber'];
    dateTime = json['dateTime'];
    clientInformation = json['clientInformation'] != null
        ? new ClientInformation.fromJson(json['clientInformation'])
        : null;
    staffInformation = json['staffInformation'] != null
        ? new StaffInformation.fromJson(json['staffInformation'])
        : null;
    rKey = json['rKey'];
    rStatus = json['rStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SNo'] = this.sNo;
    data['challanNumber'] = this.challanNumber;
    data['dateTime'] = this.dateTime;
    if (this.clientInformation != null) {
      data['clientInformation'] = this.clientInformation!.toJson();
    }
    if (this.staffInformation != null) {
      data['staffInformation'] = this.staffInformation!.toJson();
    }
    data['rKey'] = this.rKey;
    data['rStatus'] = this.rStatus;
    return data;
  }
}

class ClientInformation {
  String? cCode;
  String? cConsigneeName;
  String? unitName;

  ClientInformation({this.cCode, this.cConsigneeName, this.unitName});

  ClientInformation.fromJson(Map<String, dynamic> json) {
    cCode = json['cCode'];
    cConsigneeName = json['cConsigneeName'];
    unitName = json['unitName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cCode'] = this.cCode;
    data['cConsigneeName'] = this.cConsigneeName;
    data['unitName'] = this.unitName;
    return data;
  }
}

class StaffInformation {
  String? uFirstName;
  String? uLastName;

  StaffInformation({this.uFirstName, this.uLastName});

  StaffInformation.fromJson(Map<String, dynamic> json) {
    uFirstName = json['uFirstName'];
    uLastName = json['uLastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uFirstName'] = this.uFirstName;
    data['uLastName'] = this.uLastName;
    return data;
  }
}
