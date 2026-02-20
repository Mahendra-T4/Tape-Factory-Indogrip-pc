part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}


final class HomeLoadingStatus extends HomeState {}

final class HomeDashboardStaticsSuccessStatus extends HomeState {
  final ShowStaticModel showStaticModel;

  HomeDashboardStaticsSuccessStatus({required this.showStaticModel});
}

final class HomeDashboardStaticsErrorStatus extends HomeState {
  final String message;

  HomeDashboardStaticsErrorStatus({required this.message});
}
