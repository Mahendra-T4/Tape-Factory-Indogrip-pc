part of 'round_bloc.dart';

@immutable
sealed class RoundEvent {}

final class AddRoundONRecordEvent extends RoundEvent {
  final AddRoundParam addRoundParam;

  AddRoundONRecordEvent({required this.addRoundParam});
}

final class ViewRoundRecordsFetchingEvent extends RoundEvent {
  final ViewRecordApiParam param;

  ViewRoundRecordsFetchingEvent({required this.param});
}

final class UpdateRoundRecordsEvent extends RoundEvent {
  final AddRoundParam addRoundParam;

  UpdateRoundRecordsEvent({required this.addRoundParam});
}

final class AddBatchOnRecordEvent extends RoundEvent {
  final AddBatchParam apiParam;

  AddBatchOnRecordEvent({required this.apiParam});
}

final class FetchShowForGetterEvent extends RoundEvent {}

final class FetchMasterRollSizeEvent extends RoundEvent {}

final class FetchRoundDetailsEvent extends RoundEvent {
  final String rKey;

  FetchRoundDetailsEvent({required this.rKey});
}

final class FetchJumboInformationsEvent extends RoundEvent {
  final String jumboID;

  FetchJumboInformationsEvent({required this.jumboID});
}
