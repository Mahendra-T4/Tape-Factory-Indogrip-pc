part of 'core_bloc.dart';

@immutable
sealed class CoreState {}

final class CoreInitialStatus extends CoreState {}

final class CoreLoadingStatus extends CoreState {}

final class AddCoreOnRecordSuccessStatus extends CoreState {
  final AddCoreEntity addCoreEntity;

  AddCoreOnRecordSuccessStatus({required this.addCoreEntity});
}

final class AddCoreOnRecordFailureStatus extends CoreState {
  final String errorMessage;

  AddCoreOnRecordFailureStatus({required this.errorMessage});
}

final class FetchViewCoreRecordSuccessStatus extends CoreState {
  final ViewCoreModel viewCoreModel;

  FetchViewCoreRecordSuccessStatus({required this.viewCoreModel});
}

final class FetchViewCoreRecordFailureStatus extends CoreState {
  final String errorMessage;

  FetchViewCoreRecordFailureStatus({required this.errorMessage});
}

final class EditCoreOnRecordSuccessStatus extends CoreState {
  final EditCoreResponse successResponse;

  EditCoreOnRecordSuccessStatus({required this.successResponse});
}

final class EditCoreOnRecordFailureStatus extends CoreState {
  final String errorMessage;

  EditCoreOnRecordFailureStatus({required this.errorMessage});
}
