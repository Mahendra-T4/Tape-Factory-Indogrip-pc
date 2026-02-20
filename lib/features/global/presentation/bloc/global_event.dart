part of 'global_bloc.dart';

@immutable
sealed class GlobalEvent {}

final class GlobalChangeUserStatusEvent extends GlobalEvent {
  final ChangeStaffParam param;

  GlobalChangeUserStatusEvent({required this.param});
}

final class GlobalDeleteRecordEvent extends GlobalEvent {
  final String rKey;
  final String rPanel;

  GlobalDeleteRecordEvent({required this.rKey, required this.rPanel});
}

final class GlobalDeleteMultipleRecordsEvent extends GlobalEvent {
  final List<String> rKeys;
  final String rPanel;

  GlobalDeleteMultipleRecordsEvent({required this.rKeys, required this.rPanel});
}

final class GlobalUploadCsvFileEvent extends GlobalEvent {
  final UploadFileParam param;

  GlobalUploadCsvFileEvent({required this.param});
}

final class GlobalMasterMicronEvent extends GlobalEvent {}

final class FetchMasterStockStatusEvent extends GlobalEvent {}

final class ReadUnReadNotificationsEvent extends GlobalEvent {
  final String notificationKey;

  ReadUnReadNotificationsEvent({required this.notificationKey});
}

final class LoadNotificationsEvent extends GlobalEvent {
  final int filterBy;

  LoadNotificationsEvent({required this.filterBy});
}

final class ReadUnReadNotificationMasterStatusEvent extends GlobalEvent {}

final class UpdateDefaultSettingEvent extends GlobalEvent {
  final String conversionRate;
  final String wastagePercentage;
  final String amountPerKG;

  UpdateDefaultSettingEvent({
    required this.conversionRate,
    required this.wastagePercentage,
    required this.amountPerKG,
  });
}

final class FetchUserSettingsEvent extends GlobalEvent {}
