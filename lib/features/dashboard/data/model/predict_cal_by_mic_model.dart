class PredictCalculationByMICModel {
  int? status;
  int? cartonRate;
  int? cartonWithMargin;
  int? piecesPerCarton;
  String? message;

  PredictCalculationByMICModel({
    this.status,
    this.cartonRate,
    this.cartonWithMargin,
    this.piecesPerCarton,
    this.message,
  });

  PredictCalculationByMICModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    cartonRate = json['cartonRate'];
    cartonWithMargin = json['cartonWithMargin'];
    piecesPerCarton = json['piecesPerCarton'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['cartonRate'] = this.cartonRate;
    data['cartonWithMargin'] = this.cartonWithMargin;
    data['piecesPerCarton'] = this.piecesPerCarton;
    data['message'] = this.message;
    return data;
  }
}
