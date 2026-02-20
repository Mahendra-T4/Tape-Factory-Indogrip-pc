part of 'inventory_bloc.dart';

@immutable
sealed class InventoryEvent {}

final class AddInventoryInRecordEvent extends InventoryEvent {
  final InventoryInParam param;

  AddInventoryInRecordEvent({required this.param});
}

final class InsertBatchIntoRecordEvent extends InventoryEvent {
  final InsertBatch batchInfo;

  InsertBatchIntoRecordEvent({required this.batchInfo});
}

final class AddInventoryUploadCSVFileEvent extends InventoryEvent {
  final UploadFileParam param;

  AddInventoryUploadCSVFileEvent({required this.param});
}

final class AddInventoryStretchUploadCSVFileEvent extends InventoryEvent {
  final UploadFileParam param;

  AddInventoryStretchUploadCSVFileEvent({required this.param});
}
