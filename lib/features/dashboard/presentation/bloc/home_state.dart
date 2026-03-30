part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoadingStatus extends HomeState {}

final class HomeLoadingStatus2 extends HomeState {}

final class HomeDashboardStaticsSuccessStatus extends HomeState {
  final ShowStaticModel showStaticModel;

  HomeDashboardStaticsSuccessStatus({required this.showStaticModel});
}

final class HomeDashboardStaticsErrorStatus extends HomeState {
  final String message;

  HomeDashboardStaticsErrorStatus({required this.message});
}

final class PredictCalculationSuccessStatus extends HomeState {
  final PredictCalculationModel predictCalculationModel;

  PredictCalculationSuccessStatus({required this.predictCalculationModel});
}

final class PredictCalculationErrorStatus extends HomeState {
  final String message;

  PredictCalculationErrorStatus({required this.message});
}

final class PredictCalculationByMicSuccessStatus extends HomeState {
  final PredictCalculationModel predictCalculationModel;

  PredictCalculationByMicSuccessStatus({required this.predictCalculationModel});
}

final class PredictCalculationByMicErrorStatus extends HomeState {
  final String message;

  PredictCalculationByMicErrorStatus({required this.message});
}

final class CoreListSuccessStatus extends HomeState {
  final CoreListModel coreListModel;

  CoreListSuccessStatus({required this.coreListModel});
}

final class CoreListErrorStatus extends HomeState {
  final String message;

  CoreListErrorStatus({required this.message});
}
