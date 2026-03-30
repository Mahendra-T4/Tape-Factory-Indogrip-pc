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

final class GlobalRoundRecordUploadCsvFileEvent extends GlobalEvent {
  final UploadFileParam param;

  GlobalRoundRecordUploadCsvFileEvent({required this.param});
}

final class GlobalMasterMicronEvent extends GlobalEvent {}

final class FetchMasterStockStatusEvent extends GlobalEvent {}

final class ReadUnReadNotificationsEvent extends GlobalEvent {
  final String notificationKey;

  ReadUnReadNotificationsEvent({required this.notificationKey});
}

final class LoadNotificationsEvent extends GlobalEvent {}

final class LoadNotificationsMainEvent extends GlobalEvent {}

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

final class VerifyChallanProductEvent extends GlobalEvent {
  final VerifyProductParam param;

  VerifyChallanProductEvent({required this.param});
}

final class UnVerifyProductEvent extends GlobalEvent {
  final String productKey;

  UnVerifyProductEvent({required this.productKey});
}

final class ReturnChallanProductEvent extends GlobalEvent {
  final ReturnProduct param;

  ReturnChallanProductEvent({required this.param});
}
