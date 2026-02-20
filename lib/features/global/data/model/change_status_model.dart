class ChangeStatusEntity {
  String? status;
  Record? record;
  String? newStatus;
  String? message;

  ChangeStatusEntity({this.status, this.record, this.newStatus, this.message});

  ChangeStatusEntity.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    record = json['record'] != null
        ? new Record.fromJson(json['record'])
        : null;
    newStatus = json['newStatus']?.toString();
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
    tfUid = json['tf_uid'] is String
        ? int.tryParse(json['tf_uid'] as String)
        : json['tf_uid'];
    tfUfirstname = json['tf_ufirstname'];
    tfUlastname = json['tf_ulastname'];
    tfUemail = json['tf_uemail'];
    tfUmobilenumber = json['tf_umobilenumber'];
    tfUpassword = json['tf_upassword'];
    tfUrole = json['tf_urole'] is String
        ? int.tryParse(json['tf_urole'] as String)
        : json['tf_urole'];
    tfUaassignedpanel = json['tf_uaassignedpanel'];
    tfUsearchkeyword = json['tf_usearchkeyword'];
    tfUblockreason = json['tf_ublockreason'];
    tfUrecoverkey = json['tf_urecoverkey'];
    tfUencryptkey = json['tf_uencryptkey'];
    tfUcreatedon = json['tf_ucreatedon'];
    tfUstatus = json['tf_ustatus'] is String
        ? int.tryParse(json['tf_ustatus'] as String)
        : json['tf_ustatus'];
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
