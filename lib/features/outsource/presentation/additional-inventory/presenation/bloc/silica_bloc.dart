import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:indogrip/features/outsource/presentation/additional-inventory/domain/entities/add_silica_entitie.dart';

part 'silica_event.dart';
part 'silica_state.dart';

class SilicaBloc extends Bloc<SilicaEvent, SilicaState> {
  SilicaBloc() : super(SilicaInitial()) {
    on<SilicaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
