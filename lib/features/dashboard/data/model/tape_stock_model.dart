class TapeStockModel {
  int? status;
  dynamic inventoryCarton;
  dynamic roundCarton;
  dynamic availableCarton;
  String? message;

  TapeStockModel({
    this.status,
    this.inventoryCarton,
    this.roundCarton,
    this.availableCarton,
    this.message,
  });

  TapeStockModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    inventoryCarton = json['inventoryCarton'] ?? '0';
    roundCarton = json['roundCarton'] ?? '0';
    availableCarton = json['availableCarton'] ?? '0';
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['inventoryCarton'] = this.inventoryCarton;
    data['roundCarton'] = this.roundCarton;
    data['availableCarton'] = this.availableCarton;
    data['message'] = this.message;
    return data;
  }
}
