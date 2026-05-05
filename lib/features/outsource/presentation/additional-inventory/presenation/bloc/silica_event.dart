part of 'silica_bloc.dart';

sealed class SilicaEvent extends Equatable {
  const SilicaEvent();

  @override
  List<Object> get props => [];
}

final class AddSilicaRecordsEvent extends SilicaEvent {
  final AddSilicaRequestEntity param;

  const AddSilicaRecordsEvent({required this.param});

  @override
  List<Object> get props => [param];
}
