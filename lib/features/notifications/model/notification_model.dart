class NotificationModel {
  int? status;
  String? message;
  List<Record>? record;
  int? pageQty;

  NotificationModel({this.status, this.message, this.record, this.pageQty});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['record'] != null) {
      record = <Record>[];
      json['record'].forEach((v) {
        record!.add(new Record.fromJson(v));
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

class Record {
  int? sNo;
  String? notificationMsg;
  String? notificationDate;
  String? notificationAction;
  int? notificationPanel;
  int? notificationStatus;
  String? notificationKey;

  Record(
      {this.sNo,
      this.notificationMsg,
      this.notificationDate,
      this.notificationAction,
      this.notificationPanel,
      this.notificationStatus,
      this.notificationKey});

  Record.fromJson(Map<String, dynamic> json) {
    sNo = json['SNo'];
    notificationMsg = json['notificationMsg'];
    notificationDate = json['notificationDate'];
    notificationAction = json['notificationAction'];
    notificationPanel = json['notificationPanel'];
    notificationStatus = json['notificationStatus'];
    notificationKey = json['notificationKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SNo'] = this.sNo;
    data['notificationMsg'] = this.notificationMsg;
    data['notificationDate'] = this.notificationDate;
    data['notificationAction'] = this.notificationAction;
    data['notificationPanel'] = this.notificationPanel;
    data['notificationStatus'] = this.notificationStatus;
    data['notificationKey'] = this.notificationKey;
    return data;
  }
}