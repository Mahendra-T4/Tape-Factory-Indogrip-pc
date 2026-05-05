class StretchStockModel {
  int? status;
  dynamic availableCarton;
  dynamic totalNetWeight;
  dynamic totalGrossWeight;
  String? message;

  StretchStockModel({
    this.status,
    this.availableCarton,
    this.totalNetWeight,
    this.totalGrossWeight,
    this.message,
  });

  StretchStockModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    availableCarton = json['availableCarton'] ?? '0';
    totalNetWeight = json['totalNetWeight'] ?? '0';
    totalGrossWeight = json['totalGrossWeight'] ?? '0';
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['availableCarton'] = this.availableCarton;
    data['totalNetWeight'] = this.totalNetWeight;
    data['totalGrossWeight'] = this.totalGrossWeight;
    data['message'] = this.message;
    return data;
  }
}
