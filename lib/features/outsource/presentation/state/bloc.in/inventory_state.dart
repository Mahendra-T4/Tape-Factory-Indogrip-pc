part of 'inventory_bloc.dart';

@immutable
sealed class InventoryState {}

final class InventoryInitial extends InventoryState {}

final class InventoryLoadingStatus extends InventoryState {}

final class InventoryInRecordAddedSuccessStatus extends InventoryState {
  final SuccessResponse response;

  InventoryInRecordAddedSuccessStatus({required this.response});
}

final class InventoryInRecordAddErrorStatus extends InventoryState {
  final String message;

  InventoryInRecordAddErrorStatus({required this.message});
}

final class InventoryInUploadCSVFileSuccessStatus extends InventoryState {
  final SuccessResponse response;

  InventoryInUploadCSVFileSuccessStatus({required this.response});
}

final class InventoryInUploadCSVFileFailedErrorStatus extends InventoryState {
  final String message;

  InventoryInUploadCSVFileFailedErrorStatus({required this.message});
}
