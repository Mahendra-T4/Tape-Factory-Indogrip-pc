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
  OrderInformation? orderInformation;
  AdditionalInfo? additionalInfo;
  String? rKey;
  int? rStatus;

  ChallanRecord({
    this.dateTime,
    this.clientInformation,
    this.staffInformation,
    this.orderProduct,
    this.orderInformation,
    this.additionalInfo,
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
    orderInformation = json['orderInformation'] != null
        ? new OrderInformation.fromJson(json['orderInformation'])
        : null;
    additionalInfo = json['additionalInfo'] != null
        ? new AdditionalInfo.fromJson(json['additionalInfo'])
        : null;
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
    if (this.orderInformation != null) {
      data['orderInformation'] = this.orderInformation!.toJson();
    }
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo!.toJson();
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
  String? cMobileNumber;
  String? cAlternateNumber;
  String? cGSTIN;

  ClientInformation({
    this.cCode,
    this.cConsigneeName,
    this.unitName,
    this.cMobileNumber,
    this.cAlternateNumber,
    this.cGSTIN,
  });

  ClientInformation.fromJson(Map<String, dynamic> json) {
    cCode = json['cCode'];
    cConsigneeName = json['cConsigneeName'];
    unitName = json['unitName'];
    cMobileNumber = json['cMobileNumber'];
    cAlternateNumber = json['cAlternateNumber'];
    cGSTIN = json['cGSTIN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cCode'] = this.cCode;
    data['cConsigneeName'] = this.cConsigneeName;
    data['unitName'] = this.unitName;
    data['cMobileNumber'] = this.cMobileNumber;
    data['cAlternateNumber'] = this.cAlternateNumber;
    data['cGSTIN'] = this.cGSTIN;
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
  int? sNo;
  VendortInformation? vendortInformation;
  String? displayInformation;
  String? productInformation;
  int? hsnCode;
  dynamic unitPrice;
  int? quantity;
  int? displayQty;
  dynamic productPrice;
  dynamic displayPrice;
  String? prRemarks;
  String? returnQty;
  String? returnReason;
  String? returnDate;
  String? manageName;
  String? prManager;
  String? productKey;
  int? productStatus;
  String? productStatusText;

  OrderProduct({
    this.sNo,
    this.vendortInformation,
    this.displayInformation,
    this.productInformation,
    this.hsnCode,
    this.unitPrice,
    this.quantity,
    this.displayQty,
    this.productPrice,
    this.displayPrice,
    this.prRemarks,
    this.returnQty,
    this.returnReason,
    this.returnDate,
    this.manageName,
    this.prManager,
    this.productKey,
    this.productStatus,
    this.productStatusText,
  });

  OrderProduct.fromJson(Map<String, dynamic> json) {
    sNo = json['sNo'];
    vendortInformation = json['vendortInformation'] != null
        ? new VendortInformation.fromJson(json['vendortInformation'])
        : null;
    displayInformation = json['displayInformation'];
    productInformation = json['productInformation'];
    hsnCode = json['hsnCode'];
    unitPrice = json['unitPrice'];
    quantity = json['quantity'];
    displayQty = json['displayQty'];
    productPrice = json['productPrice'];
    displayPrice = json['displayPrice'];
    prRemarks = json['prRemarks'];
    returnQty = json['returnQty'];
    returnReason = json['returnReason'];
    returnDate = json['returnDate'];
    manageName = json['manageName'];
    prManager = json['prManager'];
    productKey = json['productKey'];
    productStatus = json['productStatus'];
    productStatusText = json['productStatusText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sNo'] = this.sNo;
    if (this.vendortInformation != null) {
      data['vendortInformation'] = this.vendortInformation!.toJson();
    }
    data['displayInformation'] = this.displayInformation;
    data['productInformation'] = this.productInformation;
    data['hsnCode'] = this.hsnCode;
    data['unitPrice'] = this.unitPrice;
    data['quantity'] = this.quantity;
    data['displayQty'] = this.displayQty;
    data['productPrice'] = this.productPrice;
    data['displayPrice'] = this.displayPrice;
    data['prRemarks'] = this.prRemarks;
    data['returnQty'] = this.returnQty;
    data['returnReason'] = this.returnReason;
    data['returnDate'] = this.returnDate;
    data['manageName'] = this.manageName;
    data['prManager'] = this.prManager;
    data['productKey'] = this.productKey;
    data['productStatus'] = this.productStatus;
    data['productStatusText'] = this.productStatusText;
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

class OrderInformation {
  String? oDate;
  String? oTime;
  String? challanRemark;
  String? manualChallanNumber;
  String? manualChallanDate;

  OrderInformation({
    this.oDate,
    this.oTime,
    this.challanRemark,
    this.manualChallanNumber,
    this.manualChallanDate,
  });

  OrderInformation.fromJson(Map<String, dynamic> json) {
    oDate = json['oDate'];
    oTime = json['oTime'];
    challanRemark = json['challanRemark'];
    manualChallanNumber = json['manualChallanNumber'];
    manualChallanDate = json['manualChallanDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oDate'] = this.oDate;
    data['oTime'] = this.oTime;
    data['challanRemark'] = this.challanRemark;
    data['manualChallanNumber'] = this.manualChallanNumber;
    data['manualChallanDate'] = this.manualChallanDate;
    return data;
  }
}

class AdditionalInfo {
  String? gSTIN;
  String? mobileNumber;
  String? whatsApp;
  String? manufactureOf;
  String? wholesaler;
  String? mainLogo;
  String? secondaryLogo;
  String? termHeading;
  String? companyName;
  List<String>? termList;

  AdditionalInfo({
    this.gSTIN,
    this.mobileNumber,
    this.whatsApp,
    this.manufactureOf,
    this.wholesaler,
    this.mainLogo,
    this.secondaryLogo,
    this.termHeading,
    this.companyName,
    this.termList,
  });

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    gSTIN = json['GSTIN'];
    mobileNumber = json['mobileNumber'];
    whatsApp = json['WhatsApp'];
    manufactureOf = json['manufactureOf'];
    wholesaler = json['Wholesaler'];
    mainLogo = json['mainLogo'];
    secondaryLogo = json['secondaryLogo'];
    termHeading = json['termHeading'];
    companyName = json['CompanyName'];
    termList = json['termList'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GSTIN'] = this.gSTIN;
    data['mobileNumber'] = this.mobileNumber;
    data['WhatsApp'] = this.whatsApp;
    data['manufactureOf'] = this.manufactureOf;
    data['Wholesaler'] = this.wholesaler;
    data['mainLogo'] = this.mainLogo;
    data['secondaryLogo'] = this.secondaryLogo;
    data['termHeading'] = this.termHeading;
    data['CompanyName'] = this.companyName;
    data['termList'] = this.termList;
    return data;
  }
}
