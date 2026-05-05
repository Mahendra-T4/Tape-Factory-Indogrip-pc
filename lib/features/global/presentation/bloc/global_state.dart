part of 'global_bloc.dart';

@immutable
sealed class GlobalState {}

final class GlobalInitial extends GlobalState {}

final class GlobalLoadingStatus extends GlobalState {}

final class GlobalLoadingStatus2 extends GlobalState {}

final class GlobalLoadingStatus3 extends GlobalState {}

final class GlobalChangeUserStatusSuccessStatus extends GlobalState {
  final ChangeStatusEntity changeStatusEntity;

  GlobalChangeUserStatusSuccessStatus({required this.changeStatusEntity});
}

final class GlobalChangeUserStatusErrorStatus extends GlobalState {
  final String message;

  GlobalChangeUserStatusErrorStatus({required this.message});
}

//! delete single record states

final class GlobalDeleteRecordSuccessStatus extends GlobalState {
  final DeleteRecordEntity deleteRecordEntity;

  GlobalDeleteRecordSuccessStatus({required this.deleteRecordEntity});
}

final class GlobalDeleteRecordErrorStatus extends GlobalState {
  final String message;

  GlobalDeleteRecordErrorStatus({required this.message});
}

//! delete multiple records states

final class GlobalDeleteMultipleRecordsSuccessStatus extends GlobalState {
  final DeleteRecordEntity deleteRecordEntity;

  GlobalDeleteMultipleRecordsSuccessStatus({required this.deleteRecordEntity});
}

final class GlobalDeleteMultipleRecordsErrorStatus extends GlobalState {
  final String message;

  GlobalDeleteMultipleRecordsErrorStatus({required this.message});
}

final class GlobalUploadCsvFileSuccessStatus extends GlobalState {
  final SuccessResponse successResponse;

  GlobalUploadCsvFileSuccessStatus({required this.successResponse});
}

final class GlobalUploadCsvFileErrorStatus extends GlobalState {
  final String message;

  GlobalUploadCsvFileErrorStatus({required this.message});
}

final class GlobalRoundRecordUploadCsvFileSuccessStatus extends GlobalState {
  final UploadRoundRecordModel successResponse;

  GlobalRoundRecordUploadCsvFileSuccessStatus({required this.successResponse});
}

final class GlobalRoundRecordUploadCsvFileErrorStatus extends GlobalState {
  final String message;

  GlobalRoundRecordUploadCsvFileErrorStatus({required this.message});
}

final class GlobalMasterMicronSuccessStatus extends GlobalState {
  final ViewMicronModel micronModel;

  GlobalMasterMicronSuccessStatus({required this.micronModel});
}

final class GlobalMasterMicronErrorStatus extends GlobalState {
  final String message;

  GlobalMasterMicronErrorStatus({required this.message});
}

final class FetchMasterStockStatusSuccessStatus extends GlobalState {
  final StockStatusModel model;

  FetchMasterStockStatusSuccessStatus({required this.model});
}

final class FetchMasterStockStatusFailedStatus extends GlobalState {
  final String message;

  FetchMasterStockStatusFailedStatus({required this.message});
}

final class LoadNotificationsSuccessStatus extends GlobalState {
  final NotificationModel notifications;

  LoadNotificationsSuccessStatus({required this.notifications});
}

final class LoadNotificationsErrorStatus extends GlobalState {
  final String message;

  LoadNotificationsErrorStatus({required this.message});
}

final class ReadUnReadNotificationMasterStatusSuccessStatus
    extends GlobalState {
  final ReadUnReadMasterStatusModel model;

  ReadUnReadNotificationMasterStatusSuccessStatus({required this.model});
}

final class ReadUnReadNotificationMasterStatusErrorStatus extends GlobalState {
  final String message;

  ReadUnReadNotificationMasterStatusErrorStatus({required this.message});
}

final class UpdateDefaultSettingSuccessStatus extends GlobalState {
  final UpdateDefaultSetting model;

  UpdateDefaultSettingSuccessStatus({required this.model});
}

final class UpdateDefaultSettingErrorStatus extends GlobalState {
  final String message;

  UpdateDefaultSettingErrorStatus({required this.message});
}

final class FetchUserSettingsSuccessStatus extends GlobalState {
  final SettingModel model;

  FetchUserSettingsSuccessStatus({required this.model});
}

final class FetchUserSettingsErrorStatus extends GlobalState {
  final String message;

  FetchUserSettingsErrorStatus({required this.message});
}

final class ChallanProductVerifySuccessState extends GlobalState {
  final ChallanProductVerifyModel model;

  ChallanProductVerifySuccessState({required this.model});
}

final class ChallanProductVerifyFailureState extends GlobalState {
  final String errorMessage;

  ChallanProductVerifyFailureState({required this.errorMessage});
}

final class UnVerifyProductSuccessState extends GlobalState {
  final SuccessResponse model;

  UnVerifyProductSuccessState({required this.model});
}

final class UnVerifyProductFailureState extends GlobalState {
  final String errorMessage;

  UnVerifyProductFailureState({required this.errorMessage});
}

final class ReturnChallanProductSuccessState extends GlobalState {
  final SuccessResponse model;

  ReturnChallanProductSuccessState({required this.model});
}

final class ReturnChallanProductFailureState extends GlobalState {
  final String errorMessage;

  ReturnChallanProductFailureState({required this.errorMessage});
}

final class AddChallanInfoSuccessState extends GlobalState {
  final SuccessResponse model;

  AddChallanInfoSuccessState({required this.model});
}

final class AddChallanInfoFailureState extends GlobalState {
  final String errorMessage;

  AddChallanInfoFailureState({required this.errorMessage});
}

final class ChallanRoundDetailsLoadedSuccessStatus extends GlobalState {
  final RoundDetails dataModel;

  ChallanRoundDetailsLoadedSuccessStatus({required this.dataModel});
}

final class ChallanRoundDetailsLoadedFailureStatus extends GlobalState {
  final String errorMessage;

  ChallanRoundDetailsLoadedFailureStatus({required this.errorMessage});
}

final class SubmitRoundScannedDataSuccessStatus extends GlobalState {
  final SubmitBatchModel model;

  SubmitRoundScannedDataSuccessStatus({required this.model});
}

final class SubmitRoundScannedDataFailureStatus extends GlobalState {
  final String errorMessage;

  SubmitRoundScannedDataFailureStatus({required this.errorMessage});
}
