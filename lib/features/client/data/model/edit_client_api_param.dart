class EditClientApiParam {
  final String activity = 'add-client';
  final String cConsigneeName;
  final String? cAlternateNumber;
  final String cGSTIN;
  final String cOwnerName;
  final String cOwnerMobileNumber;
  final String? cOwnerAlterMobileNumber;
  final String cPurchaseManagerName;
  final String cPurchaseManagerNumber;
  final String? cPurchaseManagerAlterNumber;
  final String rKey;
  final String uPassword;
  final String uConfirmPassword;
  final String cMobileNumber;
  final String? cUnitOne;
  final String? cUnitTwo;
  final String? cUnitThree;
  final String? cUnitFour;
  final String? cUnitFive;

  EditClientApiParam({
    this.cOwnerAlterMobileNumber,
    this.cAlternateNumber,
    this.cPurchaseManagerAlterNumber,
    required this.cConsigneeName,

    required this.cGSTIN,
    required this.cOwnerName,
    required this.cOwnerMobileNumber,
    required this.cPurchaseManagerName,
    required this.cPurchaseManagerNumber,
    required this.rKey,
    required this.uPassword,
    required this.uConfirmPassword,
    required this.cMobileNumber,
    this.cUnitOne,
    this.cUnitTwo,
    this.cUnitThree,
    this.cUnitFour,
    this.cUnitFive,
  });
}
