import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:indogrip/features/dashboard/data/model/show_static_model.dart';
import 'package:indogrip/features/dashboard/data/repositories/home_repo.dart';
import 'package:meta/meta.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepository repository = HomeRepository();
  HomeBloc() : super(HomeInitial()) {
    on<FetchDashboardStaticsEvent>(fetchDashboardStaticsEvent);
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
}
