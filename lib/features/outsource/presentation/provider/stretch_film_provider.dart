import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indogrip/features/outsource/data/repositories/master_in_manager_repo.dart';
import 'package:indogrip/features/outsource/domain/state/master_in_stretch_states.dart';

final stretchFilmProvider =
    StateNotifierProvider<StretchFilmNotifier, StretchFilmStates>(
      (ref) => StretchFilmNotifier(),
    );

class StretchFilmNotifier extends StateNotifier<StretchFilmStates> {
  final repository = MasterInManagerRepository();
  StretchFilmNotifier() : super(StretchFilmStates(isLoading: false));

  Future<void> loadMasterStretchFilmData() async {
    state = state.copyWith(isLoading: true);
    final result = await repository.loadMasterStretchFilmData();
    try {
      state = StretchFilmStates(
        isLoading: false,
        masterStretchFilmModel: result,
      );
    } catch (e) {
      state = StretchFilmStates(isLoading: false, errorMessage: e.toString());
    }
  }
}
