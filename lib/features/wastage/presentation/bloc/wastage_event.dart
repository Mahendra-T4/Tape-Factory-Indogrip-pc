part of 'wastage_bloc.dart';

@immutable
sealed class WastageEvent {}

final class AddWastageONRecordEvent extends WastageEvent {
  final AddWastageParam addWastageParam;

  AddWastageONRecordEvent({required this.addWastageParam});
}

final class ViewWastageFromRecords extends WastageEvent {
  final ViewRecordApiParam param;

  ViewWastageFromRecords({required this.param});
}

final class UpdateWastageOnRecordEvent extends WastageEvent {
  final EditWastageApiParam editWastageApiParam;

  UpdateWastageOnRecordEvent({required this.editWastageApiParam});
}
