// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SettingModel {
  final int? status;
  final List<SettingRecord>? record;
  final String? message;

  SettingModel({this.status, this.record, this.message});

  factory SettingModel.fromRawJson(String str) =>
      SettingModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
    status: json["status"],
    record: json["record"] == null
        ? []
        : List<SettingRecord>.from(
            json["record"]!.map((x) => SettingRecord.fromJson(x)),
          ),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "record": record == null
        ? []
        : List<dynamic>.from(record!.map((x) => x.toJson())),
    "message": message,
  };
}

class SettingRecord {
  final int? amountPerKG;
  final int? wastagePercentage;
  final int? conversionRate;

  SettingRecord({
    this.amountPerKG,
    this.wastagePercentage,
    this.conversionRate,
  });

  factory SettingRecord.fromRawJson(String str) =>
      SettingRecord.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SettingRecord.fromJson(Map<String, dynamic> json) => SettingRecord(
    amountPerKG: json["amountPerKG"],
    wastagePercentage: json["wastagePercentage"],
    conversionRate: json["conversionRate"],
  );

  Map<String, dynamic> toJson() => {
    "amountPerKG": amountPerKG,
    "wastagePercentage": wastagePercentage,
    "conversionRate": conversionRate,
  };
}
