part of 'wastage_bloc.dart';

@immutable
sealed class WastageState {}

final class WastageInitialStatus extends WastageState {}

final class WastageLoadingStatus extends WastageState {}

final class AddWastageONRecordsSuccessStatus extends WastageState {
  final SuccessResponse successResponse;
  AddWastageONRecordsSuccessStatus(this.successResponse);
}

final class AddWastageONRecordsFailureStatus extends WastageState {
  final String message;
  AddWastageONRecordsFailureStatus(this.message);
}

final class ViewWastageFromRecordsSuccessStatus extends WastageState {
  final ViewWastageModel viewWastageModel;
  ViewWastageFromRecordsSuccessStatus(this.viewWastageModel);
}

final class ViewWastageFromRecordsFailureStatus extends WastageState {
  final String message;
  ViewWastageFromRecordsFailureStatus(this.message);
}

final class UpdateWastageOnRecordSuccessStatus extends WastageState {
  final EditWastageResponse successResponse;
  UpdateWastageOnRecordSuccessStatus(this.successResponse);
}

final class UpdateWastageOnRecordFailureStatus extends WastageState {
  final String message;
  UpdateWastageOnRecordFailureStatus(this.message);
}
