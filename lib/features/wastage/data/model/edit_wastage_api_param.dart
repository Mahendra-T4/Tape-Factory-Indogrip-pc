class EditWastageApiParam {
  final String activity = 'edit-wastage';
  final String wastageDate;
  final String wastageClient;
  final String billNumber;
  final String width;
  final String price_kg;
  final String remark;
  final String rKey;

  EditWastageApiParam({
    required this.wastageDate,
    required this.wastageClient,
    required this.billNumber,
    required this.width,
    required this.price_kg,
    required this.remark,
    required this.rKey,
  });
}
