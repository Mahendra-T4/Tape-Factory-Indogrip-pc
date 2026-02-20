import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:indogrip/features/outsource/data/model/stretchfilm_sticker_model.dart';
import 'package:indogrip/features/outsource/data/model/tap_sticker_info_model.dart';
import 'package:indogrip/features/outsource/data/model/view_stretchfilm_model.dart';
import 'package:indogrip/features/outsource/data/model/view_tap_in_model.dart';
import 'package:indogrip/features/outsource/data/repositories/in_out_manager_repo.dart';
import 'package:indogrip/features/outsource/domain/repositories/in_out_repo.dart';
import 'package:indogrip/features/outsource/presentation/outsource-out/panels/strach%20film/model/stretch_batch_info_model.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:meta/meta.dart';

part 'inventory_out_event.dart';
part 'inventory_out_state.dart';

class InventoryOutBloc extends Bloc<InventoryOutEvent, InventoryOutState> {
  final InventoryOutRepository repository = InventoryOutManagerRepository();
  InventoryOutBloc() : super(InventoryOutInitial()) {
    on<ViewTapInventoryFetchingEvent>(_viewTapInventoryFetchingEvent);
    on<ViewStretchFilmInventoryFetchingEvent>(
      viewStretchFilmInventoryFetchingEvent,
    );
    on<ViewTapeInventoryStickerDetailsEvent>(
      _viewTapeInventoryStickerDetailsEvent,
    );
    on<ViewStretchFilmStickerDetailsEvent>(viewStretchFilmStickerDetailsEvent);
    on<LoadStretchFilmStickerInfoDetailsEvent>(
      loadStretchFilmStickerInfoDetailsEvent,
    );
  }

  FutureOr<void> _viewTapInventoryFetchingEvent(
    ViewTapInventoryFetchingEvent event,
    Emitter<InventoryOutState> emit,
  ) async {
    emit(InventoryOutLoadingStatus());
    try {
      final model = await repository.loadTapInventoryData(param: event.param);
      emit(InventoryOutTapLoadedSuccessStatus(model: model));
    } catch (e) {
      emit(InventoryOutTapFailedStatus(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _viewTapeInventoryStickerDetailsEvent(
    ViewTapeInventoryStickerDetailsEvent event,
    Emitter<InventoryOutState> emit,
  ) async {
    emit(InventoryOutLoadingStatus());
    try {
      final model = await repository.loadTapeStickerDetails(event.inventoryKey);
      emit(InventoryOutTapeStickerDetailsLoadedSuccessStatus(model: model));
    } catch (e) {
      emit(
        InventoryOutTapeStickerDetailsFailedStatus(errorMessage: e.toString()),
      );
    }
  }

  FutureOr<void> viewStretchFilmInventoryFetchingEvent(
    ViewStretchFilmInventoryFetchingEvent event,
    Emitter<InventoryOutState> emit,
  ) async {
    emit(InventoryOutLoadingStatus());
    try {
      final model = await repository.loadStretchFilmInventoryData(
        param: event.param,
      );
      emit(InventoryOutStretchFilmLoadedSuccessStatus(model: model));
    } catch (e) {
      emit(InventoryOutStretchFilmFailedStatus(errorMessage: e.toString()));
    }
  }

  FutureOr<void> viewStretchFilmStickerDetailsEvent(
    ViewStretchFilmStickerDetailsEvent event,
    Emitter<InventoryOutState> emit,
  ) async {
    emit(InventoryOutLoadingStatus());
    try {
      final model = await repository.loadStretchFilmStickerDetails(
        event.inventoryKey,
      );
      emit(StretchFilmStickerDataLoadedSuccessStatus(model: model));
    } catch (e) {
      emit(StretchFilmStickerDataFailedErrorStatus(message: e.toString()));
    }
  }

  FutureOr<void> loadStretchFilmStickerInfoDetailsEvent(
    LoadStretchFilmStickerInfoDetailsEvent event,
    Emitter<InventoryOutState> emit,
  ) async {
    emit(InventoryOutLoadingStatus());
    try {
      final model = await repository.loadStretchFilmStickerDetails(
        event.batchKey,
      );
      emit(StretchFilmStickerDataLoadedSuccessStatus(model: model));
    } catch (e) {
      // print(e);
      emit(StretchFilmStickerDataFailedErrorStatus(message: e.toString()));
    }
  }
}
