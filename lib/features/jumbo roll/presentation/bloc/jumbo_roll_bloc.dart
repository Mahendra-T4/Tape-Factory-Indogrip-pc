import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/edit_jumbo_roll_success_model.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/jumbo_api_params.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/jumbo_role_entity.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/jumbo_uploadfile_response_model.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/view_base_model.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/view_jumbo_roll_model.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/view_micron_modeld.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/view_width_model.dart';
import 'package:indogrip/features/jumbo%20roll/demain/repositories/jumbo_roll_repo.dart';
import 'package:indogrip/features/jumbo%20roll/demain/repositories/master_repo.dart';
import 'package:indogrip/features/outsource/data/model/upload_file_param.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';

part 'jumbo_roll_event.dart';
part 'jumbo_roll_state.dart';

class JumboRollBloc extends Bloc<JumboRollEvent, JumboRollState> {
  JumboRollBloc() : super(JumboRollInitialStatus()) {
    on<AddJumboRollOnRecordEvent>(_addJumboRollOnRecordEvent);
    on<FetchViewJumboRollRecordEvent>(_fetchViewJumboRollRecordEvent);
    on<UpdateJumboRollRecordsEvent>(_updateJumboRollRecordsEvent);
    on<LoadMasterJumboWidthEvent>(_loadMasterJumboWidthEvent);
    on<LoadMasterJumboBaseEvent>(_loadMasterJumboBaseEvent);
    on<LoadMasterJumboMicronEvent>(_loadMasterJumboMicronEvent);
    on<JumboFileUploadCsvFileEvent>(_jumboFileUploadCsvFileEvent);
  }

  FutureOr<void> _addJumboRollOnRecordEvent(
    AddJumboRollOnRecordEvent event,
    Emitter<JumboRollState> emit,
  ) async {
    emit(JumboRollLoadingStatus());
    try {
      final jumboRoleEntity = await JumboRollRepository.addJumboRoll(
        apiParams: event.apiParams,
      );
      emit(AddJumboRollOnRecordSuccessStatus(jumboRoleEntity: jumboRoleEntity));
    } catch (e) {
      emit(AddJumboRollOnRecordFailureStatus(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _fetchViewJumboRollRecordEvent(
    FetchViewJumboRollRecordEvent event,
    Emitter<JumboRollState> emit,
  ) async {
    emit(JumboRollLoadingStatus());
    try {
      final viewJumboRollModel =
          await JumboRollRepository.fetchJumboRollRecords(param: event.param);
      emit(
        FetchViewJumboRollRecordSuccessStatus(
          viewJumboRollModel: viewJumboRollModel,
        ),
      );
    } catch (e) {
      emit(FetchViewJumboRollRecordFailureStatus(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _updateJumboRollRecordsEvent(
    UpdateJumboRollRecordsEvent event,
    Emitter<JumboRollState> emit,
  ) async {
    emit(JumboRollLoadingStatus());
    try {
      final editJumboRoll = await JumboRollRepository.editJumboRoll(
        apiParams: event.apiParams,
      );
      emit(UpdateJumboRollRecordSuccessStatus(successResponse: editJumboRoll));
    } catch (e) {
      print(e);
      emit(UpdateJumboRollFailedStatus(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _loadMasterJumboWidthEvent(
    LoadMasterJumboWidthEvent event,
    Emitter<JumboRollState> emit,
  ) async {
    emit(JumboRollLoadingStatus());
    try {
      final model = await MasterRepository.viewMasterWidth();
      emit(MasterJumboWidthLoadedSuccessState(model: model));
    } catch (e) {
      emit(MasterJumboWidthLoadedFailureState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _loadMasterJumboBaseEvent(
    LoadMasterJumboBaseEvent event,
    Emitter<JumboRollState> emit,
  ) async {
    emit(JumboRollLoadingStatus());
    try {
      final model = await MasterRepository.viewMasterBase();
      emit(MasterJumboBaseLoadedSuccessState(model: model));
    } catch (e) {
      emit(MasterJumboBaseLoadedFailureState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _loadMasterJumboMicronEvent(
    LoadMasterJumboMicronEvent event,
    Emitter<JumboRollState> emit,
  ) async {
    emit(JumboRollLoadingStatus());
    try {
      final model = await MasterRepository.viewMasterMicron();
      emit(MasterJumboMicronLoadedSuccessState(model: model));
    } catch (e) {
      emit(MasterJumboMicronLoadedFailureState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _jumboFileUploadCsvFileEvent(
    JumboFileUploadCsvFileEvent event,
    Emitter<JumboRollState> emit,
  ) async {
    emit(JumboRollLoadingStatus());
    try {
      final successResponse = await JumboRollRepository.uploadJumboCsvFile(
        param: event.param,
      );
      emit(UploadJumboCSVFileSuccessState(successResponse: successResponse));
    } catch (e) {
      emit(UploadJumboCSVFileFailureState(errorMessage: e.toString()));
    }
  }
}
