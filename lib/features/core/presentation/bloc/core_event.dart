part of 'core_bloc.dart';


sealed class CoreEvent {}

final class AddCoreOnRecordEvent extends CoreEvent {
  final CoreApiParams apiParams;

  AddCoreOnRecordEvent({required this.apiParams});
}


final class ViewCoreRecordEvent extends CoreEvent {
  final ViewRecordApiParam param;

  ViewCoreRecordEvent({required this.param});
}


final class EditCoreOnRecordEvent extends CoreEvent {
  final CoreApiParams apiParams;

  EditCoreOnRecordEvent({required this.apiParams});
}
