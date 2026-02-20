import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:indogrip/features/wastage/data/model/add_wastage_param.dart';
import 'package:indogrip/features/wastage/data/model/edit_wastage_api_param.dart';
import 'package:indogrip/features/wastage/data/model/edit_wastage_success_model.dart';
import 'package:indogrip/features/wastage/data/model/view_wastage_model.dart';
import 'package:indogrip/features/wastage/domain/repositories/add_wastage_main_repo.dart';
import 'package:meta/meta.dart';

part 'wastage_event.dart';
part 'wastage_state.dart';

class WastageBloc extends Bloc<WastageEvent, WastageState> {
  final AddWastageRepository addWastageRepository;
  WastageBloc({required this.addWastageRepository})
    : super(WastageInitialStatus()) {
    on<AddWastageONRecordEvent>(_addWastageONRecordEvent);
    on<ViewWastageFromRecords>(_viewWastageFromRecords);
    on<UpdateWastageOnRecordEvent>(_updateWastageOnRecordEvent);
  }

  FutureOr<void> _addWastageONRecordEvent(
    AddWastageONRecordEvent event,
    Emitter<WastageState> emit,
  ) async {
    emit(WastageLoadingStatus());
    try {
      final SuccessResponse successResponse = await addWastageRepository
          .addWastage(event.addWastageParam);
      emit(AddWastageONRecordsSuccessStatus(successResponse));
    } catch (e) {
      emit(AddWastageONRecordsFailureStatus(e.toString()));
    }
  }

  FutureOr<void> _viewWastageFromRecords(
    ViewWastageFromRecords event,
    Emitter<WastageState> emit,
  ) async {
    emit(WastageLoadingStatus());
    try {
      final ViewWastageModel viewWastageModel = await addWastageRepository
          .viewWastage(param: event.param);
      emit(ViewWastageFromRecordsSuccessStatus(viewWastageModel));
    } catch (e) {
      emit(ViewWastageFromRecordsFailureStatus(e.toString()));
    }
  }

  FutureOr<void> _updateWastageOnRecordEvent(
    UpdateWastageOnRecordEvent event,
    Emitter<WastageState> emit,
  ) async {
    emit(WastageLoadingStatus());
    try {
      final EditWastageResponse successResponse = await addWastageRepository
          .editWastage(apiParam: event.editWastageApiParam);
      emit(UpdateWastageOnRecordSuccessStatus(successResponse));
    } catch (e) {
      emit(UpdateWastageOnRecordFailureStatus(e.toString()));
    }
  }
}
