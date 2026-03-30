class PredictCalculationModel {
  int? status;
  dynamic cartonRate;
  dynamic cartonWithMargin;
  dynamic perPieceRate;
  String? message;

  PredictCalculationModel({
    this.status,
    this.cartonRate,
    this.cartonWithMargin,
    this.perPieceRate,
    this.message,
  });

  PredictCalculationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    cartonRate = json['cartonRate'];
    cartonWithMargin = json['cartonWithMargin'];
    perPieceRate = json['perPieceRate'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['cartonRate'] = this.cartonRate;
    data['cartonWithMargin'] = this.cartonWithMargin;
    data['perPieceRate'] = this.perPieceRate;
    data['message'] = this.message;
    return data;
  }
}
