part of 'staff_bloc.dart';

@immutable
sealed class StaffEvent {}

final class AddStaffOnRecordEvent extends StaffEvent {
  final AddStaffParam addStaffParam;

  AddStaffOnRecordEvent({required this.addStaffParam});
}

final class ViewStaffRecordsFetchingEvent extends StaffEvent {
  final ViewRecordApiParam viewStaffApiParam;

  ViewStaffRecordsFetchingEvent({required this.viewStaffApiParam});
}

final class UpdateStaffDetailsEvent extends StaffEvent {
  final EditStaffApiParam editStaffApiParam;

  UpdateStaffDetailsEvent({required this.editStaffApiParam});
}

final class LoadMasterUserStatusEvent extends StaffEvent {}

final class LoadUserMasterRollEvent extends StaffEvent {}

final class LoadAccessPanelEvent extends StaffEvent {}
