import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:indogrip/features/chalan/data/model/challan_product_verify_model.dart';
import 'package:indogrip/features/chalan/data/model/challaninfo_param.dart';
import 'package:indogrip/features/chalan/data/model/return_product.dart';
import 'package:indogrip/features/chalan/data/model/round_details_model.dart';
import 'package:indogrip/features/chalan/data/model/submit_batch_model.dart';
import 'package:indogrip/features/chalan/data/model/verify_challan_product_param.dart';
import 'package:indogrip/features/chalan/domain/repositories/chalan_repo.dart';
import 'package:indogrip/features/global/data/model/change_status_model.dart';
import 'package:indogrip/features/global/data/model/change_status_param.dart';
import 'package:indogrip/features/global/data/model/delete_record_model.dart';
import 'package:indogrip/features/global/data/model/profit_loss_modeld.dart';
import 'package:indogrip/features/global/data/model/setting_model.dart';
import 'package:indogrip/features/global/data/model/stock_status_model.dart';
import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/global/data/model/update_default_setting_model.dart';
import 'package:indogrip/features/global/domain/repositories/global_repo.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/view_micron_modeld.dart';
import 'package:indogrip/features/notifications/model/notification_model.dart';
import 'package:indogrip/features/notifications/model/notification_status_model.dart';
import 'package:indogrip/features/notifications/repository/notification_repo.dart';
import 'package:indogrip/features/outsource/data/model/upload_file_param.dart';
import 'package:indogrip/features/round/data/models/upload_round_record_model.dart';
import 'package:meta/meta.dart';

part 'global_event.dart';
part 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  final GlobalRepository globalRepository;
  GlobalBloc({required this.globalRepository}) : super(GlobalInitial()) {
    on<GlobalChangeUserStatusEvent>(_globalChangeUserStatusEvent);
    on<GlobalDeleteRecordEvent>(globalDeleteRecordEvent);
    on<GlobalDeleteMultipleRecordsEvent>(globalDeleteMultipleRecordsEvent);
    on<GlobalUploadCsvFileEvent>(globalUploadCsvFileEvent);
    on<FetchMasterStockStatusEvent>(fetchMasterStockStatusEvent);
    on<LoadNotificationsEvent>(loadNotificationsEvent);
    on<ReadUnReadNotificationMasterStatusEvent>(
      readUnReadNotificationMasterStatusEvent,
    );
    on<GlobalRoundRecordUploadCsvFileEvent>(
      globalRoundRecordUploadCsvFileEvent,
    );
    on<UpdateDefaultSettingEvent>(updateDefaultSettingEvent);
    on<FetchUserSettingsEvent>(fetchUserSettingsEvent);
    on<VerifyChallanProductEvent>(verifyChallanProductEvent);
    on<UnVerifyProductEvent>(unVerifyProductEvent);
    on<ReturnChallanProductEvent>(returnChallanProductEvent);
    on<AddChallanInfoEvent>(addChallanInfoEvent);
    on<FetchRoundDetailsEvent>(_fetchRoundDetailsEvent);
    on<SubmitRoundScannedDataEvent>(_submitRoundScannedDataEvent);
    on<ProfitAndLossGetterEvent>(_profitAndLossGetterEvent);
  }

  FutureOr<void> _globalChangeUserStatusEvent(
    GlobalChangeUserStatusEvent event,
    Emitter<GlobalState> emit,
  ) async {
    emit(GlobalLoadingStatus());
    try {
      final changeStatusEntity = await globalRepository.changeUserStatus(
        param: event.param,
      );
      emit(
        GlobalChangeUserStatusSuccessStatus(
          changeStatusEntity: changeStatusEntity,
        ),
      );
    } catch (e) {
      emit(GlobalChangeUserStatusErrorStatus(message: e.toString()));
    }
  }

  FutureOr<void> globalDeleteRecordEvent(
    GlobalDeleteRecordEvent event,
    Emitter<GlobalState> emit,
  ) async {
    emit(GlobalLoadingStatus());
    try {
      final deleteRecordEntity = await globalRepository.deleteRecord(
        rKey: event.rKey,
        rPanel: event.rPanel,
      );
      emit(
        GlobalDeleteRecordSuccessStatus(deleteRecordEntity: deleteRecordEntity),
      );
    } catch (e) {
      emit(GlobalDeleteRecordErrorStatus(message: e.toString()));
    }
  }

  FutureOr<void> globalDeleteMultipleRecordsEvent(
    GlobalDeleteMultipleRecordsEvent event,
    Emitter<GlobalState> emit,
  ) async {
    emit(GlobalLoadingStatus());
    try {
      final deleteRecordEntity = await globalRepository.deleteMultipleRecords(
        rKeys: event.rKeys,
        rPanel: event.rPanel,
      );
      emit(
        GlobalDeleteMultipleRecordsSuccessStatus(
          deleteRecordEntity: deleteRecordEntity,
        ),
      );
    } catch (e) {
      emit(GlobalDeleteMultipleRecordsErrorStatus(message: e.toString()));
    }
  }

  FutureOr<void> globalUploadCsvFileEvent(
    GlobalUploadCsvFileEvent event,
    Emitter<GlobalState> emit,
  ) async {
    emit(GlobalLoadingStatus());
    try {
      final successResponse = await globalRepository.uploadCsvFile(
        param: event.param,
      );
      emit(GlobalUploadCsvFileSuccessStatus(successResponse: successResponse));
    } catch (e) {
      emit(GlobalUploadCsvFileErrorStatus(message: e.toString()));
    }
  }

  FutureOr<void> fetchMasterStockStatusEvent(
    FetchMasterStockStatusEvent event,
    Emitter<GlobalState> emit,
  ) async {
    emit(GlobalLoadingStatus());
    try {
      final model = await globalRepository.stockStatus();
      emit(FetchMasterStockStatusSuccessStatus(model: model));
    } catch (e) {
      emit(FetchMasterStockStatusFailedStatus(message: e.toString()));
    }
  }

  FutureOr<void> loadNotificationsEvent(
    LoadNotificationsEvent event,
    Emitter<GlobalState> emit,
  ) async {
    emit(GlobalLoadingStatus());
    try {
      final notifications = await NotificationRepository.fetchNotifications();
      emit(LoadNotificationsSuccessStatus(notifications: notifications));
    } catch (e) {
      emit(LoadNotificationsErrorStatus(message: e.toString()));
    }
  }

  FutureOr<void> readUnReadNotificationMasterStatusEvent(
    ReadUnReadNotificationMasterStatusEvent event,
    Emitter<GlobalState> emit,
  ) async {
    emit(GlobalLoadingStatus());
    try {
      final model = await NotificationRepository.readUnreadMasterStatus();
      emit(ReadUnReadNotificationMasterStatusSuccessStatus(model: model));
    } catch (e) {
      emit(
        ReadUnReadNotificationMasterStatusErrorStatus(message: e.toString()),
      );
    }
  }

  FutureOr<void> updateDefaultSettingEvent(
    UpdateDefaultSettingEvent event,
    Emitter<GlobalState> emit,
  ) async {
    emit(GlobalLoadingStatus());
    try {
      final model = await globalRepository.updateDefaultSetting(
        conversionRate: event.conversionRate,
        wastagePercentage: event.wastagePercentage,
        amountPerKG: event.amountPerKG,
      );
      emit(UpdateDefaultSettingSuccessStatus(model: model));
    } catch (e) {
      emit(UpdateDefaultSettingErrorStatus(message: e.toString()));
    }
  }

  FutureOr<void> fetchUserSettingsEvent(
    FetchUserSettingsEvent event,
    Emitter<GlobalState> emit,
  ) async {
    emit(GlobalLoadingStatus());
    try {
      final model = await globalRepository.fetchSettings();
      emit(FetchUserSettingsSuccessStatus(model: model));
    } catch (e) {
      emit(FetchUserSettingsErrorStatus(message: e.toString()));
    }
  }

  FutureOr<void> globalRoundRecordUploadCsvFileEvent(
    GlobalRoundRecordUploadCsvFileEvent event,
    Emitter<GlobalState> emit,
  ) async {
    emit(GlobalLoadingStatus());
    try {
      final response = await globalRepository.uploadRoundRecordCsvFile(
        param: event.param,
      );
      emit(
        GlobalRoundRecordUploadCsvFileSuccessStatus(successResponse: response),
      );
    } catch (e) {
      emit(GlobalRoundRecordUploadCsvFileErrorStatus(message: e.toString()));
    }
  }

  FutureOr<void> verifyChallanProductEvent(
    VerifyChallanProductEvent event,
    Emitter<GlobalState> emit,
  ) async {
    emit(GlobalLoadingStatus());

    try {
      final model = await ChallanRepository.verifyChallanProduct(
        param: event.param,
      );
      emit(ChallanProductVerifySuccessState(model: model));
    } catch (e) {
      emit(ChallanProductVerifyFailureState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> unVerifyProductEvent(
    UnVerifyProductEvent event,
    Emitter<GlobalState> emit,
  ) async {
    emit(GlobalLoadingStatus2());

    try {
      final model = await ChallanRepository.unverifyProduct(
        productKey: event.productKey,
      );
      emit(UnVerifyProductSuccessState(model: model));
    } catch (e) {
      emit(UnVerifyProductFailureState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> returnChallanProductEvent(
    ReturnChallanProductEvent event,
    Emitter<GlobalState> emit,
  ) async {
    emit(GlobalLoadingStatus3());

    try {
      final model = await ChallanRepository.returnProduct(param: event.param);
      emit(ReturnChallanProductSuccessState(model: model));
    } catch (e) {
      emit(ReturnChallanProductFailureState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> addChallanInfoEvent(
    AddChallanInfoEvent event,
    Emitter<GlobalState> emit,
  ) async {
    emit(GlobalLoadingStatus3());
    try {
      final model = await ChallanRepository.challanInfo(data: event.param);
      emit(AddChallanInfoSuccessState(model: model));
    } catch (e) {
      emit(AddChallanInfoFailureState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _fetchRoundDetailsEvent(
    FetchRoundDetailsEvent event,
    Emitter<GlobalState> emit,
  ) async {
    emit(GlobalLoadingStatus());
    try {
      final RoundDetails dataModel = await ChallanRepository.fetchRoundDetails(
        batchCode: event.batchCode,
      );
      emit(ChallanRoundDetailsLoadedSuccessStatus(dataModel: dataModel));
    } catch (e) {
      emit(ChallanRoundDetailsLoadedFailureStatus(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _submitRoundScannedDataEvent(
    SubmitRoundScannedDataEvent event,
    Emitter<GlobalState> emit,
  ) async {
    emit(GlobalLoadingStatus());
    try {
      final batchCodes = await ChallanRepository.submitBatchInfo(
        event.batchCodes,
        event.batchQty,
        event.unitIndex,
        event.clientKey,
      );
      emit(SubmitRoundScannedDataSuccessStatus(model: batchCodes));
    } catch (e) {
      emit(SubmitRoundScannedDataFailureStatus(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _profitAndLossGetterEvent(
    ProfitAndLossGetterEvent event,
    Emitter<GlobalState> emit,
  ) async {
    emit(GlobalLoadingStatus());
    try {
      final model = await globalRepository.profitAndLossGetter(
        toDate: event.toDate,
        fromDate: event.fromDate,
        productType: event.productType,
      );
      emit(ProfitAndLossGetterSuccessStatus(model: model));
    } catch (e) {
      emit(ProfitAndLossGetterFailureStatus(errorMessage: e.toString()));
    }
  }
}
