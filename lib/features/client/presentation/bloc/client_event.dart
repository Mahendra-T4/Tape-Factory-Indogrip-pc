part of 'client_bloc.dart';

@immutable
sealed class ClientEvent {}

final class AddClientOnRecordEvent extends ClientEvent {
  final ClientApiParams apiParams;

  AddClientOnRecordEvent({required this.apiParams});
}

final class ViewClientRecordsFetchingEvent extends ClientEvent {
  final ViewRecordApiParam viewClientApiParam;

  ViewClientRecordsFetchingEvent({required this.viewClientApiParam});
}

final class UpdateClientDetailsOnRecordEvent extends ClientEvent {
  final EditClientApiParam apiParams;

  UpdateClientDetailsOnRecordEvent({required this.apiParams});
}


final class LoadClientDataOnClientProfilePageEvent extends ClientEvent {
  final ClientRecord client;

  LoadClientDataOnClientProfilePageEvent({required this.client});
}

final class UploadClientCSVFileEvent extends ClientEvent {
  final String activity;
  final File csvFile;

  UploadClientCSVFileEvent({required this.activity, required this.csvFile});
}
