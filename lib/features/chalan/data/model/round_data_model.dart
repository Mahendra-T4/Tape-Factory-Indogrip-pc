import 'package:hive_flutter/adapters.dart';

part 'round_data_model.g.dart';

@HiveType(typeId: 0)
class RoundDataModel extends HiveObject {
  @HiveField(0)
  final String? rKey;
  @HiveField(1)
  final String? baseID;
  @HiveField(2)
  final String? piecesPerCarton;
  @HiveField(3)
  final String? cutMMMeter;
  @HiveField(4)
  final String? micID;
  @HiveField(5)
  final String? micLabel;
  @HiveField(6)
  final String? showFor;
  @HiveField(7)
  final String? tapeLength;
  @HiveField(8)
  final String? batchRemark;
  @HiveField(9)
  final String? baseLabel;
  @HiveField(10)
  final String? displayMFG;
  @HiveField(11)
  final String? displayMFGLabel;
  @HiveField(12)
  final String? tapeWeight;
  @HiveField(13)
  final String? showForLabel;
  @HiveField(14)
  final String? batchID;
  @HiveField(15)
  final String? batchCode;
  @HiveField(16)
  final String? jumboCode;
  @HiveField(17)
  final String? displayMic;
  @HiveField(18)
  final String? length;
  @HiveField(19)
  final String? base;
  @HiveField(20)
  final String? roundCount;
  @HiveField(21)
  final String? batchOperator;
  @HiveField(22)
  final String? batchMRP;
  @HiveField(23)
  String? quantity;
  @HiveField(24)
  String? unitIndex;
  @HiveField(25)
  String? unitName;
  @HiveField(26)
  int? productType;
  @HiveField(27)
  dynamic size;
  @HiveField(28)
  dynamic stretchWeigh;
  @HiveField(29)
  String? operation;

  RoundDataModel({
    required this.rKey,
    required this.baseID,
    required this.piecesPerCarton,
    required this.cutMMMeter,
    required this.micID,
    required this.micLabel,
    required this.showFor,
    required this.tapeLength,
    required this.batchRemark,
    required this.baseLabel,
    required this.displayMFG,
    required this.displayMFGLabel,
    required this.tapeWeight,
    required this.showForLabel,
    required this.batchID,
    required this.quantity,
    required this.unitIndex,
    required this.unitName,
    this.size,
    this.stretchWeigh,
    this.operation,
    this.productType,
    this.batchCode,
    this.jumboCode,
    this.displayMic,
    this.length,
    this.base,
    this.roundCount,
    this.batchOperator,
    this.batchMRP,
  });
}
