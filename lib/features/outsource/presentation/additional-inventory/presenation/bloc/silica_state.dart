part of 'silica_bloc.dart';

sealed class SilicaState extends Equatable {
  const SilicaState();

  @override
  List<Object> get props => [];
}

final class SilicaInitial extends SilicaState {}

final class SilicaLoading extends SilicaState {}

final class AddSilicaRecordsFailedState extends SilicaState {
  final String message;

  const AddSilicaRecordsFailedState({required this.message});

  @override
  List<Object> get props => [message];
}
