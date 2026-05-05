part of 'round_bloc.dart';

@immutable
sealed class RoundState {}

final class RoundInitialStatus extends RoundState {}

final class RoundLoadingStatus extends RoundState {}

final class AddRoundLoadedSuccessStatus extends RoundState {
  final SuccessResponse successResponse;

  AddRoundLoadedSuccessStatus({required this.successResponse});
}

final class AddRoundFailedToAddStatus extends RoundState {
  final String error;

  AddRoundFailedToAddStatus({required this.error});
}

final class ViewRoundRecordsLoadedSuccessStatus extends RoundState {
  final ViewRoundModel viewRoundModel;

  ViewRoundRecordsLoadedSuccessStatus({required this.viewRoundModel});
}

final class ViewRoundRecordsErrorStatus extends RoundState {
  final String errorMessage;

  ViewRoundRecordsErrorStatus({required this.errorMessage});
}

final class UpdateRoundRecordsSuccessStatus extends RoundState {
  final EditRoundResponse successResponse;

  UpdateRoundRecordsSuccessStatus({required this.successResponse});
}

final class UpdateRoundRecordsFailureStatus extends RoundState {
  final String errorMessage;

  UpdateRoundRecordsFailureStatus({required this.errorMessage});
}

final class AddBatchLoadedSuccessStatus extends RoundState {
  final AddBatchModel addBatchModel;

  AddBatchLoadedSuccessStatus({required this.addBatchModel});
}

final class AddBatchFailedToAddStatus extends RoundState {
  final String error;

  AddBatchFailedToAddStatus({required this.error});
}

final class ShowForGetterLoadedSuccessStatus extends RoundState {
  final ShowModel model;

  ShowForGetterLoadedSuccessStatus({required this.model});
}

final class ShowForGetterErrorFailedStatus extends RoundState {
  final String error;

  ShowForGetterErrorFailedStatus({required this.error});
}

class MasterRollSizeLoadedSuccessStatus extends RoundState {
  final MasterRollSizeEntity model;

  MasterRollSizeLoadedSuccessStatus({required this.model});
}

class MasterRollSizeErrorFailedStatus extends RoundState {
  final String error;

  MasterRollSizeErrorFailedStatus({required this.error});
}

class RoundDetailsLoadedSuccessStatus extends RoundState {
  final BatchDetailsModel model;

  RoundDetailsLoadedSuccessStatus({required this.model});
}

class RoundDetailsErrorFailedStatus extends RoundState {
  final String error;

  RoundDetailsErrorFailedStatus({required this.error});
}

class FetchJumboInformationsLoadedSuccessStatus extends RoundState {
  final JumboInfoModel model;

  FetchJumboInformationsLoadedSuccessStatus({required this.model});
}

class FetchJumboInformationsErrorFailedStatus extends RoundState {
  final String error;

  FetchJumboInformationsErrorFailedStatus({required this.error});
}
