part of 'vendor_bloc.dart';

@immutable
sealed class VendorEvent {}

final class AddVendorOnRecordEvent extends VendorEvent {
  final ClientApiParams apiParams;

  AddVendorOnRecordEvent({required this.apiParams});
}

final class ViewVendorRecordsFetchingEvent extends VendorEvent {
  final ViewRecordApiParam param;

  ViewVendorRecordsFetchingEvent({required this.param});
}


final class EditVendorOnRecordEvent extends VendorEvent {
  final EditVendorApiParam apiParams;

  EditVendorOnRecordEvent({required this.apiParams});
}
