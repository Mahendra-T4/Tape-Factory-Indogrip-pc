part of 'jumbo_roll_bloc.dart';

sealed class JumboRollEvent {}

final class AddJumboRollOnRecordEvent extends JumboRollEvent {
  final JumboRollApiParams apiParams;

  AddJumboRollOnRecordEvent({required this.apiParams});
}

final class FetchViewJumboRollRecordEvent extends JumboRollEvent {
  final ViewRecordApiParam param;

  FetchViewJumboRollRecordEvent({required this.param});
}

final class UpdateJumboRollRecordsEvent extends JumboRollEvent {
  final JumboRollApiParams apiParams;

  UpdateJumboRollRecordsEvent({required this.apiParams});
}

final class LoadMasterJumboWidthEvent extends JumboRollEvent {}

final class LoadMasterJumboBaseEvent extends JumboRollEvent {}

final class LoadMasterJumboMicronEvent extends JumboRollEvent {}

final class JumboFileUploadCsvFileEvent extends JumboRollEvent {
  final UploadFileParam param;

  JumboFileUploadCsvFileEvent({required this.param});
}

final class ChangeJumboStatusEvent extends JumboRollEvent {
  final String rKey;
  final String rStatus;

  ChangeJumboStatusEvent({required this.rKey, required this.rStatus});
}
