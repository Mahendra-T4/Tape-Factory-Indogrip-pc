class UpdateStatusModel {
  int? status;
  Record? record;
  int? newStatus;
  String? message;

  UpdateStatusModel({this.status, this.record, this.newStatus, this.message});

  UpdateStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    record =
        json['record'] != null ? new Record.fromJson(json['record']) : null;
    newStatus = json['newStatus'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.record != null) {
      data['record'] = this.record!.toJson();
    }
    data['newStatus'] = this.newStatus;
    data['message'] = this.message;
    return data;
  }
}

class Record {
  int? lcUid;
  String? lcUfirstname;
  String? lcUlastname;
  String? lcUemail;
  String? lcUmobilenumber;
  String? lcUalternatenumber;
  String? lcUpassword;
  String? lcUsearchkeyword;
  int? lcUotp;
  int? lcUotpverified;
  int? lcUrole;
  String? lcUaassignedpanel;
  String? lcUblockreason;
  String? lcUrecoverkey;
  String? lcUencryptkey;
  String? lcUcreatedon;
  int? lcUstatus;

  Record({
    this.lcUid,
    this.lcUfirstname,
    this.lcUlastname,
    this.lcUemail,
    this.lcUmobilenumber,
    this.lcUalternatenumber,
    this.lcUpassword,
    this.lcUsearchkeyword,
    this.lcUotp,
    this.lcUotpverified,
    this.lcUrole,
    this.lcUaassignedpanel,
    this.lcUblockreason,
    this.lcUrecoverkey,
    this.lcUencryptkey,
    this.lcUcreatedon,
    this.lcUstatus,
  });

  Record.fromJson(Map<String, dynamic> json) {
    lcUid = json['lc_uid'];
    lcUfirstname = json['lc_ufirstname'];
    lcUlastname = json['lc_ulastname'];
    lcUemail = json['lc_uemail'];
    lcUmobilenumber = json['lc_umobilenumber'];
    lcUalternatenumber = json['lc_ualternatenumber'];
    lcUpassword = json['lc_upassword'];
    lcUsearchkeyword = json['lc_usearchkeyword'];
    lcUotp = json['lc_uotp'];
    lcUotpverified = json['lc_uotpverified'];
    lcUrole = json['lc_urole'];
    lcUaassignedpanel = json['lc_uaassignedpanel'];
    lcUblockreason = json['lc_ublockreason'];
    lcUrecoverkey = json['lc_urecoverkey'];
    lcUencryptkey = json['lc_uencryptkey'];
    lcUcreatedon = json['lc_ucreatedon'];
    lcUstatus = json['lc_ustatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lc_uid'] = this.lcUid;
    data['lc_ufirstname'] = this.lcUfirstname;
    data['lc_ulastname'] = this.lcUlastname;
    data['lc_uemail'] = this.lcUemail;
    data['lc_umobilenumber'] = this.lcUmobilenumber;
    data['lc_ualternatenumber'] = this.lcUalternatenumber;
    data['lc_upassword'] = this.lcUpassword;
    data['lc_usearchkeyword'] = this.lcUsearchkeyword;
    data['lc_uotp'] = this.lcUotp;
    data['lc_uotpverified'] = this.lcUotpverified;
    data['lc_urole'] = this.lcUrole;
    data['lc_uaassignedpanel'] = this.lcUaassignedpanel;
    data['lc_ublockreason'] = this.lcUblockreason;
    data['lc_urecoverkey'] = this.lcUrecoverkey;
    data['lc_uencryptkey'] = this.lcUencryptkey;
    data['lc_ucreatedon'] = this.lcUcreatedon;
    data['lc_ustatus'] = this.lcUstatus;
    return data;
  }
}
