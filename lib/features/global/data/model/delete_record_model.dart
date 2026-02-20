class DeleteRecordEntity {
  int? status;
  String? message;
  Record? record;

  DeleteRecordEntity({this.status, this.message, this.record});

  DeleteRecordEntity.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    record = json['record'] != null
        ? new Record.fromJson(json['record'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.record != null) {
      data['record'] = this.record!.toJson();
    }
    return data;
  }
}

class Record {
  int? tfUid;
  String? tfUfirstname;
  String? tfUlastname;
  String? tfUemail;
  String? tfUmobilenumber;
  String? tfUpassword;
  int? tfUrole;
  String? tfUaassignedpanel;
  String? tfUsearchkeyword;
  String? tfUblockreason;
  String? tfUrecoverkey;
  String? tfUencryptkey;
  String? tfUcreatedon;
  int? tfUstatus;

  Record({
    this.tfUid,
    this.tfUfirstname,
    this.tfUlastname,
    this.tfUemail,
    this.tfUmobilenumber,
    this.tfUpassword,
    this.tfUrole,
    this.tfUaassignedpanel,
    this.tfUsearchkeyword,
    this.tfUblockreason,
    this.tfUrecoverkey,
    this.tfUencryptkey,
    this.tfUcreatedon,
    this.tfUstatus,
  });

  Record.fromJson(Map<String, dynamic> json) {
    tfUid = json['tf_uid'];
    tfUfirstname = json['tf_ufirstname'];
    tfUlastname = json['tf_ulastname'];
    tfUemail = json['tf_uemail'];
    tfUmobilenumber = json['tf_umobilenumber'];
    tfUpassword = json['tf_upassword'];
    tfUrole = json['tf_urole'];
    tfUaassignedpanel = json['tf_uaassignedpanel'];
    tfUsearchkeyword = json['tf_usearchkeyword'];
    tfUblockreason = json['tf_ublockreason'];
    tfUrecoverkey = json['tf_urecoverkey'];
    tfUencryptkey = json['tf_uencryptkey'];
    tfUcreatedon = json['tf_ucreatedon'];
    tfUstatus = json['tf_ustatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tf_uid'] = this.tfUid;
    data['tf_ufirstname'] = this.tfUfirstname;
    data['tf_ulastname'] = this.tfUlastname;
    data['tf_uemail'] = this.tfUemail;
    data['tf_umobilenumber'] = this.tfUmobilenumber;
    data['tf_upassword'] = this.tfUpassword;
    data['tf_urole'] = this.tfUrole;
    data['tf_uaassignedpanel'] = this.tfUaassignedpanel;
    data['tf_usearchkeyword'] = this.tfUsearchkeyword;
    data['tf_ublockreason'] = this.tfUblockreason;
    data['tf_urecoverkey'] = this.tfUrecoverkey;
    data['tf_uencryptkey'] = this.tfUencryptkey;
    data['tf_ucreatedon'] = this.tfUcreatedon;
    data['tf_ustatus'] = this.tfUstatus;
    return data;
  }
}
