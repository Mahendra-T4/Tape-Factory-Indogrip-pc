class ViewStaffModel {
  int? status;
  String? message;
  List<StaffRecords>? record;
  int? pageQty;

  ViewStaffModel({this.status, this.message, this.record, this.pageQty});

  ViewStaffModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['record'] != null) {
      record = <StaffRecords>[];
      json['record'].forEach((v) {
        record!.add(new StaffRecords.fromJson(v));
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

class StaffRecords {
  int? SNo;
  String? uFirstName;
  String? uLastName;
  String? uEmail;
  String? uMobileNumber;
  String? uAlternateNumber;
  String? uPersonalEmail;
  int? uRole;
  String? uRoleText;
  String? uAccessPanel;
  String? uAssignedPanel;
  String? rKey;
  int? rStatus;

  StaffRecords({
    this.SNo,
    this.uFirstName,
    this.uLastName,
    this.uEmail,
    this.uMobileNumber,
    this.uAlternateNumber,
    this.uPersonalEmail,
    this.uRole,
    this.uRoleText,
    this.uAccessPanel,
    this.uAssignedPanel,
    this.rKey,
    this.rStatus,
  });

  StaffRecords.fromJson(Map<String, dynamic> json) {
    SNo = json['SNo'];
    uFirstName = json['uFirstName'];
    uLastName = json['uLastName'];
    uEmail = json['uEmail'];
    uMobileNumber = json['uMobileNumber'];
    uAlternateNumber = json['uAlternateNumber'];
    uPersonalEmail = json['uPersonalEmail'];
    uRole = json['uRole'];
    uRoleText = json['uRoleText'];
    uAccessPanel = json['uAccessPanel'];
    uAssignedPanel = json['uAssignedPanel'];
    rKey = json['rKey'];
    rStatus = json['rStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SNo'] = this.SNo;
    data['uFirstName'] = this.uFirstName;
    data['uLastName'] = this.uLastName;
    data['uEmail'] = this.uEmail;
    data['uMobileNumber'] = this.uMobileNumber;
    data['uAlternateNumber'] = this.uAlternateNumber;
    data['uPersonalEmail'] = this.uPersonalEmail;
    data['uRole'] = this.uRole;
    data['uRoleText'] = this.uRoleText;
    data['uAccessPanel'] = this.uAccessPanel;
    data['uAssignedPanel'] = this.uAssignedPanel;
    data['rKey'] = this.rKey;
    data['rStatus'] = this.rStatus;
    return data;
  }
}
