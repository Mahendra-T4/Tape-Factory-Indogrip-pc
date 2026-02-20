part of 'jumbo_roll_bloc.dart';

sealed class JumboRollState {}

final class JumboRollInitialStatus extends JumboRollState {}

final class JumboRollLoadingStatus extends JumboRollState {}

final class AddJumboRollOnRecordSuccessStatus extends JumboRollState {
  final JumboRoleEntity jumboRoleEntity;

  AddJumboRollOnRecordSuccessStatus({required this.jumboRoleEntity});
}

final class AddJumboRollOnRecordFailureStatus extends JumboRollState {
  final String errorMessage;

  AddJumboRollOnRecordFailureStatus({required this.errorMessage});
}

final class FetchViewJumboRollRecordSuccessStatus extends JumboRollState {
  final ViewJumboRollModel viewJumboRollModel;

  FetchViewJumboRollRecordSuccessStatus({required this.viewJumboRollModel});
}

final class FetchViewJumboRollRecordFailureStatus extends JumboRollState {
  final String errorMessage;

  FetchViewJumboRollRecordFailureStatus({required this.errorMessage});
}

final class UpdateJumboRollRecordSuccessStatus extends JumboRollState {
  final EditJumboRollResponse successResponse;

  UpdateJumboRollRecordSuccessStatus({required this.successResponse});
}

final class UpdateJumboRollFailedStatus extends JumboRollState {
  final String errorMessage;

  UpdateJumboRollFailedStatus({required this.errorMessage});
}

final class MasterJumboWidthLoadedSuccessState extends JumboRollState {
  final ViewWidthModel model;

  MasterJumboWidthLoadedSuccessState({required this.model});
}

final class MasterJumboWidthLoadedFailureState extends JumboRollState {
  final String errorMessage;

  MasterJumboWidthLoadedFailureState({required this.errorMessage});
}

final class MasterJumboBaseLoadedSuccessState extends JumboRollState {
  final ViewBaseModel model;

  MasterJumboBaseLoadedSuccessState({required this.model});
}

final class MasterJumboBaseLoadedFailureState extends JumboRollState {
  final String errorMessage;

  MasterJumboBaseLoadedFailureState({required this.errorMessage});
}

final class MasterJumboMicronLoadedSuccessState extends JumboRollState {
  final ViewMicronModel model;

  MasterJumboMicronLoadedSuccessState({required this.model});
}

final class MasterJumboMicronLoadedFailureState extends JumboRollState {
  final String errorMessage;

  MasterJumboMicronLoadedFailureState({required this.errorMessage});
}

final class UploadJumboCSVFileSuccessState extends JumboRollState {
  final JumboUploadFileResponseModel successResponse;

  UploadJumboCSVFileSuccessState({required this.successResponse});
}

final class UploadJumboCSVFileFailureState extends JumboRollState {
  final String errorMessage;

  UploadJumboCSVFileFailureState({required this.errorMessage});
}
