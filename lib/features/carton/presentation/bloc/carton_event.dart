part of 'carton_bloc.dart';

sealed class CartonEvent {}

final class AddCartonOnRecordEvent extends CartonEvent {
  final CartonApiParams apiParams;

  AddCartonOnRecordEvent({required this.apiParams});
}

final class ViewCartonRecordEvent extends CartonEvent {
  final ViewRecordApiParam param;

  ViewCartonRecordEvent({required this.param});
}

final class EditCartonOnRecordEvent extends CartonEvent {
  final CartonApiParams apiParams;

  EditCartonOnRecordEvent({required this.apiParams});
}


class FetchMasterCartonTypeEvent extends CartonEvent {}

