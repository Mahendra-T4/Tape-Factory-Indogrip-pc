part of 'vendor_bloc.dart';

@immutable
sealed class VendorState {}

final class VendorInitialStatus extends VendorState {}

final class VendorLoadingStatus extends VendorState {}

final class AddVendorOnRecordSuccessStatus extends VendorState {
  final EditVendorResponse successResponse;

  AddVendorOnRecordSuccessStatus({required this.successResponse});
}

final class AddVendorOnRecordFailureStatus extends VendorState {
  final String errorMessage;

  AddVendorOnRecordFailureStatus({required this.errorMessage});
}

final class ViewVendorRecordsLoadedSuccessStatus extends VendorState {
  final ViewVendorModel viewVendorModel;

  ViewVendorRecordsLoadedSuccessStatus({required this.viewVendorModel});
}

final class ViewVendorRecordsErrorStatus extends VendorState {
  final String errorMessage;

  ViewVendorRecordsErrorStatus({required this.errorMessage});
}

final class UpdateVendorOnRecordSuccessStatus extends VendorState {
  final SuccessResponse successResponse;

  UpdateVendorOnRecordSuccessStatus({required this.successResponse});
}

final class UpdateVendorOnRecordFailureStatus extends VendorState {
  final String errorMessage;

  UpdateVendorOnRecordFailureStatus({required this.errorMessage});
}

final class UploadVendorCSVFileSuccessStatus extends VendorState {
  final UploadVendorResponse successResponse;

  UploadVendorCSVFileSuccessStatus({required this.successResponse});
}

final class UploadVendorCSVFileFailureStatus extends VendorState {
  final String errorMessage;

  UploadVendorCSVFileFailureStatus({required this.errorMessage});
}
