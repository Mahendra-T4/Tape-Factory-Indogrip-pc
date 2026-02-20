import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:indogrip/features/carton/data/models/view_client_succ_model.dart';
import 'package:indogrip/features/client/data/model/add_client_param.dart';
import 'package:indogrip/features/client/data/model/edit_client_api_param.dart';
import 'package:indogrip/features/client/data/model/view_staff_modeld.dart';
import 'package:indogrip/features/client/domain/repositories/add_client_repo.dart';
import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/jumbo_uploadfile_response_model.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:meta/meta.dart';

part 'client_event.dart';
part 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  ClientBloc() : super(ClientInitialStatus()) {
    on<AddClientOnRecordEvent>(_addClientOnRecordEvent);
    on<ViewClientRecordsFetchingEvent>(_viewClientRecordsFetchingEvent);
    on<UpdateClientDetailsOnRecordEvent>(_updateClientDetailsOnRecordEvent);
    on<UploadClientCSVFileEvent>(uploadClientCSVFileEvent);
  }

  FutureOr<void> _addClientOnRecordEvent(
    AddClientOnRecordEvent event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoadingStatus());
    try {
      final successResponse = await AddClientRepository.addClientOnRecord(
        param: event.apiParams,
      );
      emit(AddClientOnRecordSuccessStatus(successResponse: successResponse));
    } catch (e) {
      emit(AddClientOnRecordFailureStatus(errorMessage: e.toString()));
      developer.log('Error adding client: $e', name: 'Add Client Event');
    }
  }

  FutureOr<void> _viewClientRecordsFetchingEvent(
    ViewClientRecordsFetchingEvent event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoadingStatus());
    try {
      final viewClientModel = await AddClientRepository.viewStaffRecords(
        param: event.viewClientApiParam,
      );
      emit(
        ViewClientRecordsLoadedSuccessStatus(viewClientModel: viewClientModel),
      );
    } catch (e) {
      emit(ViewClientRecordsErrorStatus(errorMessage: e.toString()));
      developer.log(
        'Error fetching staff records: $e',
        name: 'View Staff Event',
      );
    }
  }

  FutureOr<void> _updateClientDetailsOnRecordEvent(
    UpdateClientDetailsOnRecordEvent event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoadingStatus());
    try {
      final successResponse = await AddClientRepository.updateClientRecord(
        param: event.apiParams,
      );
      emit(
        UpdateClientDetailsOnRecordSuccessStatus(
          successResponse: successResponse,
        ),
      );
    } catch (e) {
      emit(
        UpdateClientDetailsOnRecordFailureStatus(errorMessage: e.toString()),
      );
      developer.log(e.toString(), name: 'Update Client Event');
    }
  }

  FutureOr<void> uploadClientCSVFileEvent(
    UploadClientCSVFileEvent event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoadingStatus());
    try {
      final successResponse = await AddClientRepository.uploadClientCSVFile(
        activity: event.activity,
        csvFile: event.csvFile,
      );
      emit(UploadClientCSVFileSuccessStatus(successResponse: successResponse));
    } catch (e) {
      emit(UploadClientCSVFileFailureStatus(errorMessage: e.toString()));
      developer.log(e.toString(), name: 'Upload Client CSV File Event');
    }
  }
}
