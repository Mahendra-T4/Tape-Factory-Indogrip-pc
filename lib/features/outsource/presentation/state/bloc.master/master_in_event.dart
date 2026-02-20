part of 'master_in_bloc.dart';

@immutable
sealed class MasterInEvent {}

final class LoadMasterInStretchFilmEvent extends MasterInEvent {}

final class LoadMasterInProductTypeEvent extends MasterInEvent {}
