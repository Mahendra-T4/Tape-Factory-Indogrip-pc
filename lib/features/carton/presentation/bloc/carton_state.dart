part of 'carton_bloc.dart';

@immutable
sealed class CartonState {}

final class CartonInitialStatus extends CartonState {}

final class CartonLoadingStatus extends CartonState {}

final class AddCartonOnRecordSuccessStatus extends CartonState {
  final AddCartonEntity addCartonEntity;

  AddCartonOnRecordSuccessStatus({required this.addCartonEntity});
}

final class AddCartonOnRecordFailureStatus extends CartonState {
  final String errorMessage;

  AddCartonOnRecordFailureStatus({required this.errorMessage});
}

final class FetchViewCartonRecordSuccessStatus extends CartonState {
  final ViewCartonModel viewCartonModel;

  FetchViewCartonRecordSuccessStatus({required this.viewCartonModel});
}

final class FetchViewCartonRecordFailureStatus extends CartonState {
  final String errorMessage;

  FetchViewCartonRecordFailureStatus({required this.errorMessage});
}

final class EditCartonOnRecordSuccessStatus extends CartonState {
  final EditClientResponse successResponse;

  EditCartonOnRecordSuccessStatus({required this.successResponse});
}

final class EditCartonOnRecordFailureStatus extends CartonState {
  final String errorMessage;

  EditCartonOnRecordFailureStatus({required this.errorMessage});
}

final class FetchMasterCartonTypeSuccessStatus extends CartonState {
  final CartonTypeModel cartonTypeModel;

  FetchMasterCartonTypeSuccessStatus({required this.cartonTypeModel});
}

final class FetchMasterCartonTypeFailureStatus extends CartonState {
  final String errorMessage;

  FetchMasterCartonTypeFailureStatus({required this.errorMessage});
}
