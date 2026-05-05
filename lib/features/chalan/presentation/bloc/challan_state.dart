part of 'challan_bloc.dart';

@immutable
sealed class ChallanState {}

final class ChallanInitial extends ChallanState {}

final class ChallanLoadingState extends ChallanState {}

final class ChallanLoadingState2 extends ChallanState {}

final class ChallanLoadingState3 extends ChallanState {}

final class ChallanRecordLoadedSuccessState extends ChallanState {
  final ChalanListModel model;

  ChallanRecordLoadedSuccessState({required this.model});
}

final class ChallanRecordLoadedFailureState extends ChallanState {
  final String errorMessage;

  ChallanRecordLoadedFailureState({required this.errorMessage});
}

final class ChallanDetailsLoadedSuccessState extends ChallanState {
  final ChallanDetailsModel model;

  ChallanDetailsLoadedSuccessState({required this.model});
}

final class ChallanDetailsLoadedFailureState extends ChallanState {
  final String errorMessage;

  ChallanDetailsLoadedFailureState({required this.errorMessage});
}
