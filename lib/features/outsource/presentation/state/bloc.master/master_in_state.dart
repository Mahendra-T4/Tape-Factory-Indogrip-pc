part of 'master_in_bloc.dart';

@immutable
sealed class MasterInState {}

final class MasterInInitial extends MasterInState {}

final class MasterInLoadingStatus extends MasterInState {}

final class MasterInStretchFilmLoadedStatus extends MasterInState {
  final MasterStretchFilmModel model;

  MasterInStretchFilmLoadedStatus({required this.model});
}

final class MasterInStretchFilmErrorStatus extends MasterInState {
  final String errorMessage;

  MasterInStretchFilmErrorStatus({required this.errorMessage});
}


final class MasterInProductTypeLoadedStatus extends MasterInState {
  final MasterProductTypeModel model;

  MasterInProductTypeLoadedStatus({required this.model});
}


final class MasterInProductTypeErrorStatus extends MasterInState {
  final String errorMessage;

  MasterInProductTypeErrorStatus({required this.errorMessage});
}
