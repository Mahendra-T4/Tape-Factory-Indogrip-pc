part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class FetchDashboardStaticsEvent extends HomeEvent {}

final class PredictCalculationEvent extends HomeEvent {
  final PredictCalParam param;

  PredictCalculationEvent({required this.param});
}

final class PredictCalculationByMicEvent extends HomeEvent {
  final PredictCalParam param;

  PredictCalculationByMicEvent({required this.param});
}

final class FetchCoreListEvent extends HomeEvent {}

final class LoadTapeStockRecordsEvent extends HomeEvent {
  final TapeStockEntity param;

  LoadTapeStockRecordsEvent({required this.param});
}
