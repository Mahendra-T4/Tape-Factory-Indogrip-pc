import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:indogrip/features/client/data/model/view_staff_api_param.dart';
import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/staff/data/models/access_panel_model.dart';
import 'package:indogrip/features/staff/data/models/add_staff_model.dart';
import 'package:indogrip/features/staff/data/models/add_staff_param.dart';
import 'package:indogrip/features/staff/data/models/edit_staff_success_model.dart';
import 'package:indogrip/features/staff/data/models/master_roll_model.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:indogrip/features/staff/data/models/view_staff_master_model.dart';
import 'package:indogrip/features/staff/data/models/view_staff_model.dart';
import 'package:indogrip/features/staff/domain/repositories/staff_curd_repo.dart';
import 'package:indogrip/features/staff/domain/repositories/staff_repo.dart';
import 'package:meta/meta.dart';

part 'staff_event.dart';
part 'staff_state.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  StaffBloc() : super(StaffInitialStatus()) {
    on<AddStaffOnRecordEvent>(_addStaffOnRecordEvent);
    on<ViewStaffRecordsFetchingEvent>(_viewStaffRecordsFetchingEvent);
    on<UpdateStaffDetailsEvent>(_updateStaffDetailsEvent);
    on<LoadMasterUserStatusEvent>(loadMasterUserStatusEvent);
    on<LoadUserMasterRollEvent>(_loadUserMasterRollEvent);
    on<LoadAccessPanelEvent>(_loadAccessPanelEvent);
  }

  FutureOr<void> _addStaffOnRecordEvent(
    AddStaffOnRecordEvent event,
    Emitter<StaffState> emit,
  ) async {
    emit(StaffLoadingStatus());
    try {
      final addStaff = await StaffRepository.addStaff(
        param: event.addStaffParam,
      );

      emit(StaffAddLoadedSuccessStatus(addStaffEntity: addStaff));
    } catch (e) {
      developer.log(name: 'Add Staff Bloc Error', e.toString());
      emit(StaffAddLoadedFailureStatus(error: e.toString()));
    }
  }

  FutureOr<void> _viewStaffRecordsFetchingEvent(
    ViewStaffRecordsFetchingEvent event,
    Emitter<StaffState> emit,
  ) async {
    emit(StaffLoadingStatus());
    try {
      final viewStaff = await StaffRepository.viewStaff(
        param: event.viewStaffApiParam,
      );

      emit(StaffViewLoadedSuccessStatus(viewStaffModel: viewStaff));
    } catch (e) {
      developer.log(name: 'View Staff Bloc Error', e.toString());
      emit(StaffViewLoadedFailureStatus(error: e.toString()));
    }
  }

  FutureOr<void> _updateStaffDetailsEvent(
    UpdateStaffDetailsEvent event,
    Emitter<StaffState> emit,
  ) async {
    emit(StaffLoadingStatus());
    try {
      final successResponse = await StaffCURDRepository().updateStaffDetails(
        param: event.editStaffApiParam,
      );

      emit(UpdateStaffLoadedSuccessStatus(successResponse: successResponse));
    } catch (e) {
      developer.log(name: 'Update Staff Bloc Error', e.toString());
      emit(UpdateStaffLoadedFailureStatus(error: e.toString()));
    }
  }

  FutureOr<void> loadMasterUserStatusEvent(
    LoadMasterUserStatusEvent event,
    Emitter<StaffState> emit,
  ) async {
    emit(StaffLoadingStatus());
    try {
      final viewStaffMasterEntity = await StaffRepository.viewStaffMasterList();

      emit(
        MasterUserStatusLoadedSuccessState(
          viewStaffMasterEntity: viewStaffMasterEntity,
        ),
      );
    } catch (e) {
      developer.log(name: 'Load Master User Status Bloc Error', e.toString());
      emit(MasterUserStatusLoadedFailureState(error: e.toString()));
    }
  }

  FutureOr<void> _loadUserMasterRollEvent(
    LoadUserMasterRollEvent event,
    Emitter<StaffState> emit,
  ) async {
    emit(StaffLoadingStatus());
    try {
      final masterRoll = await StaffCURDRepository().fetchUserRolls();

      emit(MasterUserRollLoadedSuccessState(masterRoll: masterRoll));
    } catch (e) {
      developer.log(name: 'Load User Master Roll Bloc Error', e.toString());
      emit(MasterUserRollLoadedFailureState(error: e.toString()));
    }
  }

  FutureOr<void> _loadAccessPanelEvent(
    LoadAccessPanelEvent event,
    Emitter<StaffState> emit,
  ) async {
    emit(StaffLoadingStatus());
    try {
      final accessPanel = await StaffCURDRepository().fetchAccessPanels();

      emit(AccessPanelLoadedSuccessState(accessPanel: accessPanel));
    } catch (e) {
      developer.log(name: 'Load Access Panel Bloc Error', e.toString());
      emit(AccessPanelLoadedFailureState(error: e.toString()));
    }
  }
}
