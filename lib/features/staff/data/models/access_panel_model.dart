class AccessPanel {
  int? status;
  List<Record>? record;
  String? message;

  AccessPanel({this.status, this.record, this.message});

  AccessPanel.fromJson(Map<String, dynamic> json) {
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
  int? mPanelId;
  String? mPanelName;
  String? mPanelSlug;

  Record({this.mPanelId, this.mPanelName, this.mPanelSlug});

  Record.fromJson(Map<String, dynamic> json) {
    mPanelId = json['mPanelId'];
    mPanelName = json['mPanelName'];
    mPanelSlug = json['mPanelSlug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mPanelId'] = this.mPanelId;
    data['mPanelName'] = this.mPanelName;
    data['mPanelSlug'] = this.mPanelSlug;
    return data;
  }
}
