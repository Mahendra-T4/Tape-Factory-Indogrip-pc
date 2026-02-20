part of 'staff_bloc.dart';

@immutable
sealed class StaffState {}

final class StaffInitialStatus extends StaffState {}

final class StaffLoadingStatus extends StaffState {}

final class StaffAddLoadedSuccessStatus extends StaffState {
  final AddStaffEntity addStaffEntity;

  StaffAddLoadedSuccessStatus({required this.addStaffEntity});
}

final class StaffAddLoadedFailureStatus extends StaffState {
  final String error;

  StaffAddLoadedFailureStatus({required this.error});
}

final class StaffViewLoadedSuccessStatus extends StaffState {
  final ViewStaffModel viewStaffModel;

  StaffViewLoadedSuccessStatus({required this.viewStaffModel});
}

final class StaffViewLoadedFailureStatus extends StaffState {
  final String error;

  StaffViewLoadedFailureStatus({required this.error});
}

final class UpdateStaffLoadedSuccessStatus extends StaffState {
  final EditStaffResponse successResponse;

  UpdateStaffLoadedSuccessStatus({required this.successResponse});
}

final class UpdateStaffLoadedFailureStatus extends StaffState {
  final String error;

  UpdateStaffLoadedFailureStatus({required this.error});
}

final class MasterUserStatusLoadedSuccessState extends StaffState {
  final ViewStaffMasterEntity viewStaffMasterEntity;

  MasterUserStatusLoadedSuccessState({required this.viewStaffMasterEntity});
}

final class MasterUserStatusLoadedFailureState extends StaffState {
  final String error;

  MasterUserStatusLoadedFailureState({required this.error});
}

final class MasterUserRollLoadedSuccessState extends StaffState {
  final MasterRoll masterRoll;

  MasterUserRollLoadedSuccessState({required this.masterRoll});
}

final class MasterUserRollLoadedFailureState extends StaffState {
  final String error;

  MasterUserRollLoadedFailureState({required this.error});
}


final class AccessPanelLoadedSuccessState extends StaffState {
  final AccessPanel accessPanel;

  AccessPanelLoadedSuccessState({required this.accessPanel});
}

final class AccessPanelLoadedFailureState extends StaffState {
  final String error;

  AccessPanelLoadedFailureState({required this.error});
}