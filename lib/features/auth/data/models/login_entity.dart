class UserLoginEntity {
  int? status;
  String? message;
  Record? record;

  UserLoginEntity({this.status, this.message, this.record});

  UserLoginEntity.fromJson(Map<String, dynamic> json) {
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
  String? userFirstName;
  String? userLastName;
  String? userEmailID;
  String? userMobileNumber;
  String? userAlternateNumber;
  String? userPersonalEmailID;
  int? userRole;
  String? userAssignedPanels;
  String? userImage;
  String? userKey;

  Record({
    this.userFirstName,
    this.userLastName,
    this.userEmailID,
    this.userMobileNumber,
    this.userAlternateNumber,
    this.userPersonalEmailID,
    this.userRole,
    this.userAssignedPanels,
    this.userImage,
    this.userKey,
  });

  Record.fromJson(Map<String, dynamic> json) {
    userFirstName = json['userFirstName'];
    userLastName = json['userLastName'];
    userEmailID = json['userEmailID'];
    userMobileNumber = json['userMobileNumber'];
    userAlternateNumber = json['userAlternateNumber'];
    userPersonalEmailID = json['userPersonalEmailID'];
    userRole = json['userRole'];
    userAssignedPanels = json['userAssignedPanels'];
    userImage = json['userImage'];
    userKey = json['userKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userFirstName'] = this.userFirstName;
    data['userLastName'] = this.userLastName;
    data['userEmailID'] = this.userEmailID;
    data['userMobileNumber'] = this.userMobileNumber;
    data['userAlternateNumber'] = this.userAlternateNumber;
    data['userPersonalEmailID'] = this.userPersonalEmailID;
    data['userRole'] = this.userRole;
    data['userAssignedPanels'] = this.userAssignedPanels;
    data['userImage'] = this.userImage;
    data['userKey'] = this.userKey;
    return data;
  }
}
