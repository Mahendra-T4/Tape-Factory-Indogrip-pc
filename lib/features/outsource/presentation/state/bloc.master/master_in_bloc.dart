import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:indogrip/features/outsource/data/model/master_product_type_model.dart';
import 'package:indogrip/features/outsource/data/model/stretch_film_model.dart';
import 'package:indogrip/features/outsource/data/repositories/master_in_manager_repo.dart';
import 'package:meta/meta.dart';

part 'master_in_event.dart';
part 'master_in_state.dart';

class MasterInBloc extends Bloc<MasterInEvent, MasterInState> {
  final repository = MasterInManagerRepository();
  MasterInBloc() : super(MasterInInitial()) {
    on<LoadMasterInStretchFilmEvent>(_loadMasterInStretchFilmEvent);
    on<LoadMasterInProductTypeEvent>(_loadMasterInProductTypeEvent);
  }

  FutureOr<void> _loadMasterInStretchFilmEvent(
    LoadMasterInStretchFilmEvent event,
    Emitter<MasterInState> emit,
  ) async {
    emit(MasterInLoadingStatus());
    try {
      final result = await repository.loadMasterStretchFilmData();
      emit(MasterInStretchFilmLoadedStatus(model: result));
    } catch (e) {
      emit(MasterInStretchFilmErrorStatus(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _loadMasterInProductTypeEvent(
    LoadMasterInProductTypeEvent event,
    Emitter<MasterInState> emit,
  ) async {
    emit(MasterInLoadingStatus());
    try {
      final result = await repository.loadMasterProductTypeData();
      emit(MasterInProductTypeLoadedStatus(model: result));
    } catch (e) {
      emit(MasterInProductTypeErrorStatus(errorMessage: e.toString()));
    }
  }
}
