import 'package:indogrip/features/outsource/data/model/stretch_film_model.dart';

class StretchFilmStates {
  final bool isLoading;
  final MasterStretchFilmModel? masterStretchFilmModel;
  final String? errorMessage;

  StretchFilmStates({
    required this.isLoading,
    this.masterStretchFilmModel,
    this.errorMessage,
  });

  StretchFilmStates copyWith({
    bool? isLoading,
    MasterStretchFilmModel? masterStretchFilmModel,
    String? errorMessage,
  }) {
    return StretchFilmStates(
      isLoading: isLoading ?? this.isLoading,
      masterStretchFilmModel:
          masterStretchFilmModel ?? this.masterStretchFilmModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
