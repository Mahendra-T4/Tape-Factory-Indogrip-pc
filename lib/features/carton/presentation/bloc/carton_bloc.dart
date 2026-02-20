import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:indogrip/features/carton/data/models/add_carton_api_param.dart';
import 'package:indogrip/features/carton/data/models/add_carton_entity.dart';
import 'package:indogrip/features/carton/data/models/master_carton_type_model.dart';
import 'package:indogrip/features/carton/data/models/view_carton_model.dart';
import 'package:indogrip/features/carton/data/models/view_client_succ_model.dart';
import 'package:indogrip/features/carton/domain/repositories/carton_repo.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:meta/meta.dart';

part 'carton_event.dart';
part 'carton_state.dart';

class CartonBloc extends Bloc<CartonEvent, CartonState> {
  CartonBloc() : super(CartonInitialStatus()) {
    on<AddCartonOnRecordEvent>(_addCartonOnRecordEvent);
    on<ViewCartonRecordEvent>(_viewCartonRecordEvent);
    on<EditCartonOnRecordEvent>(_editCartonOnRecordEvent);
    on<FetchMasterCartonTypeEvent>(_fetchMasterCartonTypeEvent);
  }

  FutureOr<void> _addCartonOnRecordEvent(
    AddCartonOnRecordEvent event,
    Emitter<CartonState> emit,
  ) async {
    emit(CartonLoadingStatus());
    try {
      final addCarton = await CartonRepository.addCarton(
        apiParams: event.apiParams,
      );
      emit(AddCartonOnRecordSuccessStatus(addCartonEntity: addCarton));
    } catch (e) {
      emit(AddCartonOnRecordFailureStatus(errorMessage: e.toString()));
      developer.log(name: 'Add Carton Event Error: ', e.toString());
    }
  }

  FutureOr<void> _viewCartonRecordEvent(
    ViewCartonRecordEvent event,
    Emitter<CartonState> emit,
  ) async {
    emit(CartonLoadingStatus());
    try {
      final viewCartonData = await CartonRepository.fetchViewCartonData(
        param: event.param,
      );
      emit(FetchViewCartonRecordSuccessStatus(viewCartonModel: viewCartonData));
    } catch (e) {
      emit(FetchViewCartonRecordFailureStatus(errorMessage: e.toString()));
      developer.log(name: 'View Carton Event Error: ', e.toString());
    }
  }

  FutureOr<void> _editCartonOnRecordEvent(
    EditCartonOnRecordEvent event,
    Emitter<CartonState> emit,
  ) async {
    emit(CartonLoadingStatus());
    try {
      final successResponse = await CartonRepository.editCarton(
        apiParams: event.apiParams,
      );
      emit(EditCartonOnRecordSuccessStatus(successResponse: successResponse));
    } catch (e) {
      emit(EditCartonOnRecordFailureStatus(errorMessage: e.toString()));
      developer.log(name: 'Edit Carton Event Error: ', e.toString());
    }
  }

  FutureOr<void> _fetchMasterCartonTypeEvent(
    FetchMasterCartonTypeEvent event,
    Emitter<CartonState> emit,
  ) async {
    emit(CartonLoadingStatus());
    try {
      final cartonTypeModel = await CartonRepository.masterCartonType();
      emit(
        FetchMasterCartonTypeSuccessStatus(cartonTypeModel: cartonTypeModel),
      );
    } catch (e) {
      emit(FetchMasterCartonTypeFailureStatus(errorMessage: e.toString()));
      developer.log(
        name: 'Fetch Master Carton Type Event Error: ',
        e.toString(),
      );
    }
  }
}
