// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer' as developer;
import 'package:bloc/bloc.dart';
import 'package:indogrip/features/round/data/models/add_batch_model.dart';
import 'package:indogrip/features/round/data/models/add_batch_param.dart';
import 'package:indogrip/features/round/data/models/batch_details_model.dart';
import 'package:indogrip/features/round/data/models/edit_round_success_model.dart';
import 'package:indogrip/features/round/data/models/master_roll_size_entity.dart';
import 'package:indogrip/features/round/data/models/show_model.dart';
import 'package:indogrip/features/round/data/models/view_round_modeld.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:meta/meta.dart';
import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/round/data/models/add_round_param_model.dart';
import 'package:indogrip/features/round/domain/repositories/add_round_repo.dart';

part 'round_event.dart';
part 'round_state.dart';

class RoundBloc extends Bloc<RoundEvent, RoundState> {
  final AddRoundRepository addRoundRepository;
  RoundBloc({required this.addRoundRepository}) : super(RoundInitialStatus()) {
    on<AddRoundONRecordEvent>(_addRoundONRecordEvent);
    on<ViewRoundRecordsFetchingEvent>(_viewRoundRecordsFetchingEvent);
    on<UpdateRoundRecordsEvent>(_updateRoundRecordsEvent);
    on<AddBatchOnRecordEvent>(_addBatchOnRecordEvent);
    on<FetchShowForGetterEvent>(_fetchShowForGetterEvent);
    on<FetchMasterRollSizeEvent>(_fetchMasterRollSizeEvent);
    on<FetchRoundDetailsEvent>(_fetchRoundDetailsEvent);
  }

  FutureOr<void> _addRoundONRecordEvent(
    AddRoundONRecordEvent event,
    Emitter<RoundState> emit,
  ) async {
    emit(RoundLoadingStatus());
    try {
      final addRound = await addRoundRepository.addRound(
        apiParam: event.addRoundParam,
      );
      emit(AddRoundLoadedSuccessStatus(successResponse: addRound));
    } catch (e) {
      developer.log(name: 'Add Round Response', e.toString());
      emit(AddRoundFailedToAddStatus(error: e.toString()));
    }
  }

  FutureOr<void> _viewRoundRecordsFetchingEvent(
    ViewRoundRecordsFetchingEvent event,
    Emitter<RoundState> emit,
  ) async {
    emit(RoundLoadingStatus());
    try {
      final viewRoundModel = await addRoundRepository.viewRoundRecords(
        param: event.param,
      );
      emit(ViewRoundRecordsLoadedSuccessStatus(viewRoundModel: viewRoundModel));
    } catch (e) {
      developer.log(name: 'View Round Event Error', e.toString());
      emit(ViewRoundRecordsErrorStatus(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _updateRoundRecordsEvent(
    UpdateRoundRecordsEvent event,
    Emitter<RoundState> emit,
  ) async {
    emit(RoundLoadingStatus());
    try {
      final successResponse = await addRoundRepository.editRoundRecords(
        apiParam: event.addRoundParam,
      );
      emit(UpdateRoundRecordsSuccessStatus(successResponse: successResponse));
    } catch (e) {
      developer.log(name: 'Update Round Event Error', e.toString());
      emit(UpdateRoundRecordsFailureStatus(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _addBatchOnRecordEvent(
    AddBatchOnRecordEvent event,
    Emitter<RoundState> emit,
  ) async {
    emit(RoundLoadingStatus());
    try {
      final addBatchModel = await addRoundRepository.addBatch(
        apiParam: event.apiParam,
      );
      emit(AddBatchLoadedSuccessStatus(addBatchModel: addBatchModel));
    } catch (e) {
      developer.log(name: 'Add Batch Event Error', e.toString());
      emit(AddBatchFailedToAddStatus(error: e.toString()));
    }
  }

  FutureOr<void> _fetchShowForGetterEvent(
    FetchShowForGetterEvent event,
    Emitter<RoundState> emit,
  ) async {
    emit(RoundLoadingStatus());
    try {
      final model = await AddRoundRepository().showLengthWidth();
      emit(ShowForGetterLoadedSuccessStatus(model: model));
    } catch (e) {
      emit(ShowForGetterErrorFailedStatus(error: e.toString()));
    }
  }

  FutureOr<void> _fetchMasterRollSizeEvent(
    FetchMasterRollSizeEvent event,
    Emitter<RoundState> emit,
  ) async {
    emit(RoundLoadingStatus());
    try {
      final model = await AddRoundRepository().masterRollSize();
      emit(MasterRollSizeLoadedSuccessStatus(model: model));
    } catch (e) {
      emit(MasterRollSizeErrorFailedStatus(error: e.toString()));
    }
  }

  FutureOr<void> _fetchRoundDetailsEvent(
    FetchRoundDetailsEvent event,
    Emitter<RoundState> emit,
  ) async {
    emit(RoundLoadingStatus());
    try {
      final model = await AddRoundRepository().fetchBatchDetails(event.rKey);
      emit(RoundDetailsLoadedSuccessStatus(model: model));
    } catch (e) {
      emit(RoundDetailsErrorFailedStatus(error: e.toString()));
    }
  }
}
