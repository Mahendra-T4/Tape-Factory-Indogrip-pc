class ClientApiParams {
  final String cConsigneeName;
  final String cMobileNumber;
  final String? cAlternateNumber;
  final String cGSTIN;
  final String cOwnerName;
  final String cOwnerMobileNumber;
  final String cOwnerAlternateNumber;
  final String cPurchaseManagerName;
  final String cPurchaseManagerNumber;
  final String cPurchaseManagerAlternateNumber;
  final String? cUnitOne;
  final String? cUnitTwo;
  final String? cUnitThree;
  final String? cUnitFour;
  final String? cUnitFive;

  ClientApiParams({
    required this.cConsigneeName,
    required this.cMobileNumber,
    this.cAlternateNumber,
    required this.cGSTIN,
    required this.cOwnerName,
    required this.cOwnerMobileNumber,
    required this.cOwnerAlternateNumber,
    required this.cPurchaseManagerName,
    required this.cPurchaseManagerNumber,
    required this.cPurchaseManagerAlternateNumber,
    this.cUnitOne,
    this.cUnitTwo,
    this.cUnitThree,
    this.cUnitFour,
    this.cUnitFive,
  });
}
