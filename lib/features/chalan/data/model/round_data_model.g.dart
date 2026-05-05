// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoundDataModelAdapter extends TypeAdapter<RoundDataModel> {
  @override
  final int typeId = 0;

  @override
  RoundDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoundDataModel(
      rKey: fields[0] as String?,
      baseID: fields[1] as String?,
      piecesPerCarton: fields[2] as String?,
      cutMMMeter: fields[3] as String?,
      micID: fields[4] as String?,
      micLabel: fields[5] as String?,
      showFor: fields[6] as String?,
      tapeLength: fields[7] as String?,
      batchRemark: fields[8] as String?,
      baseLabel: fields[9] as String?,
      displayMFG: fields[10] as String?,
      displayMFGLabel: fields[11] as String?,
      tapeWeight: fields[12] as String?,
      showForLabel: fields[13] as String?,
      batchID: fields[14] as String?,
      quantity: fields[23] as String?,
      unitIndex: fields[24] as String?,
      unitName: fields[25] as String?,
      size: fields[27] as dynamic,
      stretchWeigh: fields[28] as dynamic,
      operation: fields[29] as String?,
      productType: fields[26] as int?,
      batchCode: fields[15] as String?,
      jumboCode: fields[16] as String?,
      displayMic: fields[17] as String?,
      length: fields[18] as String?,
      base: fields[19] as String?,
      roundCount: fields[20] as String?,
      batchOperator: fields[21] as String?,
      batchMRP: fields[22] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RoundDataModel obj) {
    writer
      ..writeByte(30)
      ..writeByte(0)
      ..write(obj.rKey)
      ..writeByte(1)
      ..write(obj.baseID)
      ..writeByte(2)
      ..write(obj.piecesPerCarton)
      ..writeByte(3)
      ..write(obj.cutMMMeter)
      ..writeByte(4)
      ..write(obj.micID)
      ..writeByte(5)
      ..write(obj.micLabel)
      ..writeByte(6)
      ..write(obj.showFor)
      ..writeByte(7)
      ..write(obj.tapeLength)
      ..writeByte(8)
      ..write(obj.batchRemark)
      ..writeByte(9)
      ..write(obj.baseLabel)
      ..writeByte(10)
      ..write(obj.displayMFG)
      ..writeByte(11)
      ..write(obj.displayMFGLabel)
      ..writeByte(12)
      ..write(obj.tapeWeight)
      ..writeByte(13)
      ..write(obj.showForLabel)
      ..writeByte(14)
      ..write(obj.batchID)
      ..writeByte(15)
      ..write(obj.batchCode)
      ..writeByte(16)
      ..write(obj.jumboCode)
      ..writeByte(17)
      ..write(obj.displayMic)
      ..writeByte(18)
      ..write(obj.length)
      ..writeByte(19)
      ..write(obj.base)
      ..writeByte(20)
      ..write(obj.roundCount)
      ..writeByte(21)
      ..write(obj.batchOperator)
      ..writeByte(22)
      ..write(obj.batchMRP)
      ..writeByte(23)
      ..write(obj.quantity)
      ..writeByte(24)
      ..write(obj.unitIndex)
      ..writeByte(25)
      ..write(obj.unitName)
      ..writeByte(26)
      ..write(obj.productType)
      ..writeByte(27)
      ..write(obj.size)
      ..writeByte(28)
      ..write(obj.stretchWeigh)
      ..writeByte(29)
      ..write(obj.operation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoundDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
