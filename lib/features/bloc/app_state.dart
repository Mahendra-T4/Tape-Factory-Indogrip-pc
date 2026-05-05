part of 'app_bloc.dart';

sealed class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

final class AppInitial extends AppState {}

final class AppLoadingState extends AppState {}

final class AppStretchLoadingState extends AppState {}

final class LoadTapeStockDataSuccessAppState extends AppState {
  final TapeStockModel model;

  LoadTapeStockDataSuccessAppState({required this.model});

  @override
  List<Object> get props => [model];
}

final class LoadTapeStockDataErrorAppState extends AppState {
  final String message;

  LoadTapeStockDataErrorAppState({required this.message});

  @override
  List<Object> get props => [message];
}

final class LoadStretchStockDataSuccessAppState extends AppState {
  final StretchStockModel model;

  LoadStretchStockDataSuccessAppState({required this.model});

  @override
  List<Object> get props => [model];
}

final class LoadStretchStockDataErrorAppState extends AppState {
  final String message;

  LoadStretchStockDataErrorAppState({required this.message});

  @override
  List<Object> get props => [message];
}
