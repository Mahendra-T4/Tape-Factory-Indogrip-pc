class ChallanDetailsModel {
  int? status;
  String? message;
  List<ChallanRecord>? record;

  ChallanDetailsModel({this.status, this.message, this.record});

  ChallanDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['record'] != null) {
      record = <ChallanRecord>[];
      json['record'].forEach((v) {
        record!.add(new ChallanRecord.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.record != null) {
      data['record'] = this.record!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChallanRecord {
  String? dateTime;
  ClientInformation? clientInformation;
  StaffInformation? staffInformation;
  List<OrderProduct>? orderProduct;
  String? rKey;
  int? rStatus;

  ChallanRecord({
    this.dateTime,
    this.clientInformation,
    this.staffInformation,
    this.orderProduct,
    this.rKey,
    this.rStatus,
  });

  ChallanRecord.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    clientInformation = json['clientInformation'] != null
        ? new ClientInformation.fromJson(json['clientInformation'])
        : null;
    staffInformation = json['staffInformation'] != null
        ? new StaffInformation.fromJson(json['staffInformation'])
        : null;
    if (json['orderProduct'] != null) {
      orderProduct = <OrderProduct>[];
      json['orderProduct'].forEach((v) {
        orderProduct!.add(new OrderProduct.fromJson(v));
      });
    }
    rKey = json['rKey'];
    rStatus = json['rStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateTime'] = this.dateTime;
    if (this.clientInformation != null) {
      data['clientInformation'] = this.clientInformation!.toJson();
    }
    if (this.staffInformation != null) {
      data['staffInformation'] = this.staffInformation!.toJson();
    }
    if (this.orderProduct != null) {
      data['orderProduct'] = this.orderProduct!.map((v) => v.toJson()).toList();
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

class OrderProduct {
  VendortInformation? vendortInformation;
  String? productInformation;
  int? hsnCode;
  int? unitPrice;
  int? quantity;
  int? productPrice;
  String? productKey;

  OrderProduct({
    this.vendortInformation,
    this.productInformation,
    this.hsnCode,
    this.unitPrice,
    this.quantity,
    this.productPrice,
    this.productKey,
  });

  OrderProduct.fromJson(Map<String, dynamic> json) {
    vendortInformation = json['vendortInformation'] != null
        ? new VendortInformation.fromJson(json['vendortInformation'])
        : null;
    productInformation = json['productInformation'];
    hsnCode = json['hsnCode'];
    unitPrice = json['unitPrice'] ?? 0;
    quantity = json['quantity'] ?? 0;
    productPrice = json['productPrice'] ?? 0;
    productKey = json['productKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vendortInformation != null) {
      data['vendortInformation'] = this.vendortInformation!.toJson();
    }
    data['productInformation'] = this.productInformation;
    data['hsnCode'] = this.hsnCode;
    data['unitPrice'] = this.unitPrice;
    data['quantity'] = this.quantity;
    data['productPrice'] = this.productPrice;
    data['productKey'] = this.productKey;
    return data;
  }
}

class VendortInformation {
  String? vCode;
  String? vCompanyName;

  VendortInformation({this.vCode, this.vCompanyName});

  VendortInformation.fromJson(Map<String, dynamic> json) {
    vCode = json['vCode'];
    vCompanyName = json['vCompanyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vCode'] = this.vCode;
    data['vCompanyName'] = this.vCompanyName;
    return data;
  }
}
