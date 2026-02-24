import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/physics.dart';
import 'package:indogrip/features/dashboard/data/model/predict_cal_param.dart';
import 'package:indogrip/features/dashboard/data/model/predict_calculation_model.dart';
import 'package:indogrip/features/dashboard/data/model/show_static_model.dart';
import 'package:indogrip/features/dashboard/data/repositories/home_repo.dart';
import 'package:indogrip/features/round/data/models/core_list_model.dart';
import 'package:indogrip/features/round/domain/repositories/add_round_repo.dart';
import 'package:meta/meta.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepository repository = HomeRepository();
  HomeBloc() : super(HomeInitial()) {
    on<FetchDashboardStaticsEvent>(fetchDashboardStaticsEvent);
    on<PredictCalculationEvent>(predictCalculationEvent);
    on<FetchCoreListEvent>(fetchCoreListEvent);
  }

  FutureOr<void> fetchDashboardStaticsEvent(
    FetchDashboardStaticsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingStatus());
    try {
      final data = await repository.showDashboardStatic();
      emit(HomeDashboardStaticsSuccessStatus(showStaticModel: data));
    } catch (e) {
      emit(HomeDashboardStaticsErrorStatus(message: e.toString()));
    }
  }

  FutureOr<void> predictCalculationEvent(
    PredictCalculationEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingStatus());
    try {
      final data = await repository.predictCalculation(param: event.param);
      emit(PredictCalculationSuccessStatus(predictCalculationModel: data));
    } catch (e) {
      emit(PredictCalculationErrorStatus(message: e.toString()));
    }
  }

  FutureOr<void> fetchCoreListEvent(
    FetchCoreListEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingStatus());
    try {
      final data = await AddRoundRepository().fetchCoreList();
      emit(CoreListSuccessStatus(coreListModel: data));
    } catch (e) {
      emit(CoreListErrorStatus(message: e.toString()));
    }
  }
}
