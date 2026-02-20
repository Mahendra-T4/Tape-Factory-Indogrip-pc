class InventoryInParam {
  final String? vendorKey;
  final String? date;
  final String? billNumber;
  final String? cartonPrice;
  final String? transportAmount;
  final String? productType;
  final String? quantity;
  final String? cutMMMeter;
  final String? base;
  final String? tapeLength;
  final String? stretchFilmSize;
  final String? core;
  final String? netWeight;
  final String? tapeWeight;
  final String? micron;
  final String? remarks;
  final String? grossWeight;
  final String? inventoryCode;
  final String? lessKGPrice;
  final String? rate;
  final String? margin;
  final String? rKey;

  InventoryInParam({
    required this.vendorKey,
    required this.date,
    required this.billNumber,
    required this.cartonPrice,
    required this.transportAmount,
    required this.productType,
    required this.cutMMMeter,
    required this.base,
    required this.tapeLength,
    required this.quantity,
    required this.stretchFilmSize,
    required this.grossWeight,
    required this.core,
    required this.micron,
    required this.netWeight,
    required this.tapeWeight,
    required this.remarks,
    this.inventoryCode,
    this.lessKGPrice,
    this.rate,
    this.margin,
    this.rKey,
  });
}
