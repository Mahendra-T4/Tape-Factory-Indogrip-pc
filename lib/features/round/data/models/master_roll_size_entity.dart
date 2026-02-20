// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MasterRollSizeEntity {
  final int? status;
  final List<RollSizeRecord>? record;
  final String? message;

  MasterRollSizeEntity({this.status, this.record, this.message});

  factory MasterRollSizeEntity.fromRawJson(String str) =>
      MasterRollSizeEntity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MasterRollSizeEntity.fromJson(Map<String, dynamic> json) =>
      MasterRollSizeEntity(
        status: json["status"],
        record: json["record"] == null
            ? []
            : List<RollSizeRecord>.from(
                json["record"]!.map((x) => RollSizeRecord.fromJson(x)),
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

class RollSizeRecord {
  final int? mId;
  final int? cutMmMeter;
  final int? piecesPerCarton;

  RollSizeRecord({this.mId, this.cutMmMeter, this.piecesPerCarton});

  factory RollSizeRecord.fromRawJson(String str) =>
      RollSizeRecord.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RollSizeRecord.fromJson(Map<String, dynamic> json) => RollSizeRecord(
    mId: json["mID"],
    cutMmMeter: json["cutMMMeter"],
    piecesPerCarton: json["piecesPerCarton"],
  );

  Map<String, dynamic> toJson() => {
    "mID": mId,
    "cutMMMeter": cutMmMeter,
    "piecesPerCarton": piecesPerCarton,
  };
}
