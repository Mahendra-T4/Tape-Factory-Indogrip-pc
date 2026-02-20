import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:indogrip/features/carton/data/models/add_carton_api_param.dart';
import 'package:indogrip/features/core/data/models/add_core_entity.dart';
import 'package:indogrip/features/core/data/models/core_api_param_entity.dart';
import 'package:indogrip/features/core/data/models/edit_core_response_model.dart';
import 'package:indogrip/features/core/data/models/view_core_model.dart';
import 'package:indogrip/features/core/domain/repositories/core_repo.dart';
import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:meta/meta.dart';

part 'core_event.dart';
part 'core_state.dart';

class CoreBloc extends Bloc<CoreEvent, CoreState> {
  CoreBloc() : super(CoreInitialStatus()) {
    on<AddCoreOnRecordEvent>(_addCoreOnRecordEvent);
    on<ViewCoreRecordEvent>(_viewCoreRecordEvent);
    on<EditCoreOnRecordEvent>(_editCoreOnRecordEvent);
  }

  FutureOr<void> _addCoreOnRecordEvent(
    AddCoreOnRecordEvent event,
    Emitter<CoreState> emit,
  ) async {
    emit(CoreLoadingStatus());
    try {
      final addCarton = await CoreRepository.addCore(
        apiParams: event.apiParams,
      );
      emit(AddCoreOnRecordSuccessStatus(addCoreEntity: addCarton));
    } catch (e) {
      emit(AddCoreOnRecordFailureStatus(errorMessage: e.toString()));
      log(name: 'Add Carton Event Error: ', e.toString());
    }
  }

  FutureOr<void> _viewCoreRecordEvent(
    ViewCoreRecordEvent event,
    Emitter<CoreState> emit,
  ) async {
    emit(CoreLoadingStatus());
    try {
      final viewCoreData = await CoreRepository.fetchViewCoreData(param: event.param);
      emit(FetchViewCoreRecordSuccessStatus(viewCoreModel: viewCoreData));
    } catch (e) {
      emit(FetchViewCoreRecordFailureStatus(errorMessage: e.toString()));
      log(name: 'View Core Event Error: ', e.toString());
    }
  }

  FutureOr<void> _editCoreOnRecordEvent(
    EditCoreOnRecordEvent event,
    Emitter<CoreState> emit,
  ) async {
    emit(CoreLoadingStatus());
    try {
      final successResponse = await CoreRepository.editCore(
        apiParams: event.apiParams,
      );
      emit(EditCoreOnRecordSuccessStatus(successResponse: successResponse));
    } catch (e) {
      emit(EditCoreOnRecordFailureStatus(errorMessage: e.toString()));
      log(name: 'Edit Core Event Error: ', e.toString());
    }
  }
}
