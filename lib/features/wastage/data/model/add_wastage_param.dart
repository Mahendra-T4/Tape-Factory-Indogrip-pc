class AddWastageParam {
  final String activity = 'add-wastage';

  final String wastageDate;
  final String wastageClient;
  final String billNumber;
  final String width;
  final String price_kg;
  final String remark;

  AddWastageParam({
    required this.wastageDate,
    required this.wastageClient,
    required this.billNumber,
    required this.width,
    required this.price_kg,
    required this.remark,
  });
}
