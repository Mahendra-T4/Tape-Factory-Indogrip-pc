class ChangeJumboStatusModel {
  int? status;
  Record? record;
  String? newStatus;
  String? message;

  ChangeJumboStatusModel({
    this.status,
    this.record,
    this.newStatus,
    this.message,
  });

  ChangeJumboStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    record = json['record'] != null
        ? new Record.fromJson(json['record'])
        : null;
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
  int? tfJid;
  String? tfJcode;
  String? tfJdate;
  String? tfJbilldate;
  String? tfJbillnumber;
  String? tfJrollnumber;
  double? tfJsquaremeter;
  int? tfJbase;
  int? tfJmic;
  int? tfJlength;
  int? tfJavailablelength;
  int? tfJconsumelength;
  int? tfJwidthid;
  double? tfJweight;
  int? tfJamountperkg;
  double? tfJrollcost;
  String? tfJremark;
  String? tfJvendor;
  String? tfJsearchkeyword;
  String? tfJmanager;
  String? tfJeditedby;
  String? tfJencryptkey;
  String? tfJcreatedon;
  int? tfJstatus;

  Record({
    this.tfJid,
    this.tfJcode,
    this.tfJdate,
    this.tfJbilldate,
    this.tfJbillnumber,
    this.tfJrollnumber,
    this.tfJsquaremeter,
    this.tfJbase,
    this.tfJmic,
    this.tfJlength,
    this.tfJavailablelength,
    this.tfJconsumelength,
    this.tfJwidthid,
    this.tfJweight,
    this.tfJamountperkg,
    this.tfJrollcost,
    this.tfJremark,
    this.tfJvendor,
    this.tfJsearchkeyword,
    this.tfJmanager,
    this.tfJeditedby,
    this.tfJencryptkey,
    this.tfJcreatedon,
    this.tfJstatus,
  });

  Record.fromJson(Map<String, dynamic> json) {
    tfJid = json['tf_jid'];
    tfJcode = json['tf_jcode'];
    tfJdate = json['tf_jdate'];
    tfJbilldate = json['tf_jbilldate'];
    tfJbillnumber = json['tf_jbillnumber'];
    tfJrollnumber = json['tf_jrollnumber'];
    tfJsquaremeter = json['tf_jsquaremeter'];
    tfJbase = json['tf_jbase'];
    tfJmic = json['tf_jmic'];
    tfJlength = json['tf_jlength'];
    tfJavailablelength = json['tf_javailablelength'];
    tfJconsumelength = json['tf_jconsumelength'];
    tfJwidthid = json['tf_jwidthid'];
    tfJweight = json['tf_jweight'];
    tfJamountperkg = json['tf_jamountperkg'];
    tfJrollcost = json['tf_jrollcost'];
    tfJremark = json['tf_jremark'];
    tfJvendor = json['tf_jvendor'];
    tfJsearchkeyword = json['tf_jsearchkeyword'];
    tfJmanager = json['tf_jmanager'];
    tfJeditedby = json['tf_jeditedby'];
    tfJencryptkey = json['tf_jencryptkey'];
    tfJcreatedon = json['tf_jcreatedon'];
    tfJstatus = json['tf_jstatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tf_jid'] = this.tfJid;
    data['tf_jcode'] = this.tfJcode;
    data['tf_jdate'] = this.tfJdate;
    data['tf_jbilldate'] = this.tfJbilldate;
    data['tf_jbillnumber'] = this.tfJbillnumber;
    data['tf_jrollnumber'] = this.tfJrollnumber;
    data['tf_jsquaremeter'] = this.tfJsquaremeter;
    data['tf_jbase'] = this.tfJbase;
    data['tf_jmic'] = this.tfJmic;
    data['tf_jlength'] = this.tfJlength;
    data['tf_javailablelength'] = this.tfJavailablelength;
    data['tf_jconsumelength'] = this.tfJconsumelength;
    data['tf_jwidthid'] = this.tfJwidthid;
    data['tf_jweight'] = this.tfJweight;
    data['tf_jamountperkg'] = this.tfJamountperkg;
    data['tf_jrollcost'] = this.tfJrollcost;
    data['tf_jremark'] = this.tfJremark;
    data['tf_jvendor'] = this.tfJvendor;
    data['tf_jsearchkeyword'] = this.tfJsearchkeyword;
    data['tf_jmanager'] = this.tfJmanager;
    data['tf_jeditedby'] = this.tfJeditedby;
    data['tf_jencryptkey'] = this.tfJencryptkey;
    data['tf_jcreatedon'] = this.tfJcreatedon;
    data['tf_jstatus'] = this.tfJstatus;
    return data;
  }
}
