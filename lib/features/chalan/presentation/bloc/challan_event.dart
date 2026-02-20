part of 'challan_bloc.dart';

@immutable
sealed class ChallanEvent {}


final class FetchChallanRecordsEvent extends ChallanEvent {
  final ViewRecordApiParam param;

  FetchChallanRecordsEvent({required this.param});
}

final class FetchChallanDetailsInBillEvent extends ChallanEvent {
  final String orderKey;

  FetchChallanDetailsInBillEvent({required this.orderKey});
}
