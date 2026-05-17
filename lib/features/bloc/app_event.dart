part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

final class LoadTapeStockDataEvent extends AppEvent {
  final TapeStockEntity param;

  LoadTapeStockDataEvent({required this.param});

  @override
  List<Object> get props => [param];
}

final class LoadStretchStockDataEvent extends AppEvent {
  final String baseID;
  final String filmSizeID;
  final String coreID;
  final String micID;

  LoadStretchStockDataEvent({
    required this.baseID,
    required this.filmSizeID,
    required this.coreID,
    required this.micID,
  });
  @override
  List<Object> get props => [baseID, filmSizeID, coreID, micID];
}
