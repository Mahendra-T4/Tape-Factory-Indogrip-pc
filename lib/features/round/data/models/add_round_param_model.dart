class AddRoundParam {
  final String activity = 'add-round';
  final String jumboRoll;
  final String rollSize;
  final String rollCore;
  final String round;
  final String meters;
  final String damagePieces;
  final String wastagePercentage;
  final String conversionRate;
  final String cartonType;

  String? rKey;

  AddRoundParam({
    required this.damagePieces,
    required this.wastagePercentage,
    required this.conversionRate,
    required this.jumboRoll,
    required this.rollSize,
    required this.rollCore,
    required this.round,
    required this.meters,
    required this.cartonType,
   
    this.rKey,
  });
}
