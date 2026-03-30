import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/outsource/data/model/inventory_in_param.dart';
import 'package:indogrip/features/outsource/data/model/upload_file_param.dart';
import 'package:indogrip/features/outsource/data/model/upload_stretch_record_model.dart';
import 'package:indogrip/features/outsource/data/model/upload_tap_miss_record_model.dart';
import 'package:indogrip/features/outsource/data/repositories/in_out_manager_repo.dart';
import 'package:indogrip/features/outsource/data/repositories/inventory_in_manager_repo.dart';
import 'package:indogrip/features/outsource/domain/repositories/in_out_repo.dart';
import 'package:indogrip/features/outsource/domain/repositories/inventory_in_repo.dart';
import 'package:indogrip/features/outsource/presentation/outside-in/models/add_batch_param.dart';
import 'package:meta/meta.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryInRepository repository = InventoryInManagerRepository();
  InventoryBloc() : super(InventoryInitial()) {
    on<AddInventoryInRecordEvent>(_addInventoryInRecordEvent);
    on<InsertBatchIntoRecordEvent>(insertBatchIntoRecordEvent);
    on<AddInventoryUploadCSVFileEvent>(addInventoryUploadCSVFileEvent);
    on<AddInventoryStretchUploadCSVFileEvent>(
      addInventoryStretchUploadCSVFileEvent,
    );
  }

  FutureOr<void> _addInventoryInRecordEvent(
    AddInventoryInRecordEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoadingStatus());
    try {
      final response = await repository.addInventoryInRecord(
        param: event.param,
      );
      emit(InventoryInRecordAddedSuccessStatus(response: response));
    } catch (e) {
      emit(InventoryInRecordAddErrorStatus(message: e.toString()));
    }
  }

  FutureOr<void> insertBatchIntoRecordEvent(
    InsertBatchIntoRecordEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoadingStatus());
    try {
      final model = await repository.insertBatchRecord(param: event.batchInfo);
      emit(InventoryInRecordAddedSuccessStatus(response: model));
    } catch (e) {
      emit(InventoryInRecordAddErrorStatus(message: e.toString()));
    }
  }

  FutureOr<void> addInventoryUploadCSVFileEvent(
    AddInventoryUploadCSVFileEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoadingStatus());
    try {
      final response = await InventoryOutManagerRepository()
          .uploadCSVFileInventoryIN(event.param);
      emit(InventoryInUploadCSVFileSuccessStatus(response: response));
    } catch (e) {
      emit(InventoryInUploadCSVFileFailedErrorStatus(message: e.toString()));
    }
  }

  FutureOr<void> addInventoryStretchUploadCSVFileEvent(
    AddInventoryStretchUploadCSVFileEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoadingStatus());
    try {
      final response = await InventoryOutManagerRepository()
          .uploadStretchCSVFileInventoryIN(event.param);
      emit(InventoryInStretchUploadCSVFileSuccessStatus(response: response));
    } catch (e) {
      emit(
        InventoryInStretchUploadCSVFileFailedErrorStatus(message: e.toString()),
      );
    }
  }
}
