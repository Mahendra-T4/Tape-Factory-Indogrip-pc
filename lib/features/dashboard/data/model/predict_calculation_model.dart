class PredictCalculationModel {
  int? status;
  dynamic cartonRate;
  dynamic cartonWithMargin;
  String? message;

  PredictCalculationModel({
    this.status,
    this.cartonRate,
    this.cartonWithMargin,
    this.message,
  });

  PredictCalculationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    cartonRate = json['cartonRate'];
    cartonWithMargin = json['cartonWithMargin'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['cartonRate'] = this.cartonRate;
    data['cartonWithMargin'] = this.cartonWithMargin;
    data['message'] = this.message;
    return data;
  }
}
