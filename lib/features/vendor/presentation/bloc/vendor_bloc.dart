import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:indogrip/features/client/data/model/add_client_param.dart';
import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:indogrip/features/vendor/data/models/edit_vendor_api_param.dart';
import 'package:indogrip/features/vendor/data/models/edit_vendor_success_model.dart';
import 'package:indogrip/features/vendor/data/models/view_vendor_model.dart';
import 'package:indogrip/features/vendor/domain/repositories/add_vendor_repo.dart';
import 'package:indogrip/features/vendor/domain/repositories/view_vendor_repo.dart';
import 'package:meta/meta.dart';

part 'vendor_event.dart';
part 'vendor_state.dart';

class VendorBloc extends Bloc<VendorEvent, VendorState> {
  VendorBloc() : super(VendorInitialStatus()) {
    on<AddVendorOnRecordEvent>(_addVendorOnRecordEvent);
    on<ViewVendorRecordsFetchingEvent>(_viewVendorRecordsFetchingEvent);
    on<EditVendorOnRecordEvent>(_editVendorOnRecordEvent);
  }

  FutureOr<void> _addVendorOnRecordEvent(
    AddVendorOnRecordEvent event,
    Emitter<VendorState> emit,
  ) async {
    emit(VendorLoadingStatus());
    try {
      final successResponse = await AddVendorRepository.addClientOnRecord(
        param: event.apiParams,
      );
      emit(AddVendorOnRecordSuccessStatus(successResponse: successResponse));
    } catch (e) {
      emit(AddVendorOnRecordFailureStatus(errorMessage: e.toString()));
      developer.log('Error adding client: $e', name: 'Add Client Event');
    }
  }

  FutureOr<void> _viewVendorRecordsFetchingEvent(
    ViewVendorRecordsFetchingEvent event,
    Emitter<VendorState> emit,
  ) async {
    emit(VendorLoadingStatus());
    try {
      final viewVendorModel = await ViewVendorRepository.viewVendorsRecords(
        param: event.param,
      );
      emit(
        ViewVendorRecordsLoadedSuccessStatus(viewVendorModel: viewVendorModel),
      );
    } catch (e) {
      emit(ViewVendorRecordsErrorStatus(errorMessage: e.toString()));
      developer.log(
        'Error viewing vendor records: $e',
        name: 'View Vendor Event',
      );
    }
  }

  FutureOr<void> _editVendorOnRecordEvent(
    EditVendorOnRecordEvent event,
    Emitter<VendorState> emit,
  ) async {
    emit(VendorLoadingStatus());
    try {
      final successResponse = await ViewVendorRepository.editVendor(
        apiParam: event.apiParams,
      );
      emit(UpdateVendorOnRecordSuccessStatus(successResponse: successResponse));
    } catch (e) {
      emit(UpdateVendorOnRecordFailureStatus(errorMessage: e.toString()));
      developer.log(e.toString(), name: 'Edit Vendor Event');
    }
  }
}
