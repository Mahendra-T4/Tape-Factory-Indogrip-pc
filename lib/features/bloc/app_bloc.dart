import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:indogrip/features/dashboard/data/model/stretch_stock_model.dart';
import 'package:indogrip/features/dashboard/data/model/tape_stock_model.dart';
import 'package:indogrip/features/dashboard/data/repositories/home_repo.dart';
import 'package:indogrip/features/dashboard/domain/home_manager_repo.dart';
import 'package:indogrip/features/dashboard/domain/tape_stock_entity.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  HomeRepository repository = HomeRepository();
  AppBloc() : super(AppInitial()) {
    on<LoadTapeStockDataEvent>(loadTapeStockDataEvent);
    on<LoadStretchStockDataEvent>(loadStretchStockDataEvent);
  }

  FutureOr<void> loadTapeStockDataEvent(
    LoadTapeStockDataEvent event,
    Emitter<AppState> emit,
  ) async {
    emit(AppLoadingState());
    try {
      final model = await repository.fetchTapeStock(param: event.param);
      emit(LoadTapeStockDataSuccessAppState(model: model));
    } catch (e) {
      print(e);
      emit(LoadTapeStockDataErrorAppState(message: e.toString()));
    }
  }

  FutureOr<void> loadStretchStockDataEvent(
    LoadStretchStockDataEvent event,
    Emitter<AppState> emit,
  ) async {
    emit(AppStretchLoadingState());
    try {
      final model = await repository.fetchStretchStock(
        baseID: event.baseID,
        filmSizeID: event.filmSizeID,
        coreID: event.coreID,
        micID: event.micID
      );
      emit(LoadStretchStockDataSuccessAppState(model: model));
    } catch (e) {
      print(e);
      emit(LoadStretchStockDataErrorAppState(message: e.toString()));
    }
  }
}
