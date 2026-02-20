class AddBatchParam {
  final String roundKey;
  final String showFor;
  final String displayMic;
  final String displayValue;
  final String? remark;
  final String? batchMRP;
  final String? batchOperator;
  final String? batchPackedBy;
  final String? displayMFG;
  final String? rKey;

  AddBatchParam({
    required this.roundKey,
    required this.showFor,
    required this.displayMic,
    required this.displayValue,
    this.remark,
    this.batchMRP,
    this.batchOperator,
    this.batchPackedBy,
    this.displayMFG,
    this.rKey,
  });
}
