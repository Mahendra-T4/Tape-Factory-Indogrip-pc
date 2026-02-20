part of 'client_bloc.dart';

@immutable
sealed class ClientState {}

final class ClientInitialStatus extends ClientState {}

final class ClientLoadingStatus extends ClientState {}

final class AddClientOnRecordSuccessStatus extends ClientState {
  final SuccessResponse successResponse;

  AddClientOnRecordSuccessStatus({required this.successResponse});
}

final class AddClientOnRecordFailureStatus extends ClientState {
  final String errorMessage;

  AddClientOnRecordFailureStatus({required this.errorMessage});
}

final class ViewClientRecordsLoadedSuccessStatus extends ClientState {
  final ViewClientModel viewClientModel;

  ViewClientRecordsLoadedSuccessStatus({required this.viewClientModel});
}

final class ViewClientRecordsErrorStatus extends ClientState {
  final String errorMessage;

  ViewClientRecordsErrorStatus({required this.errorMessage});
}

final class UpdateClientDetailsOnRecordSuccessStatus extends ClientState {
  final EditClientResponse successResponse;

  UpdateClientDetailsOnRecordSuccessStatus({required this.successResponse});
}

final class UpdateClientDetailsOnRecordFailureStatus extends ClientState {
  final String errorMessage;

  UpdateClientDetailsOnRecordFailureStatus({required this.errorMessage});
}

final class UploadClientCSVFileSuccessStatus extends ClientState {
  final SuccessResponse successResponse;

  UploadClientCSVFileSuccessStatus({required this.successResponse});
}

final class UploadClientCSVFileFailureStatus extends ClientState {
  final String errorMessage;

  UploadClientCSVFileFailureStatus({required this.errorMessage});
}
