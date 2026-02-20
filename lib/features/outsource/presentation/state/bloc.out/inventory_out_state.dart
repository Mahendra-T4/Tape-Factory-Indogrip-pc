part of 'inventory_out_bloc.dart';

@immutable
sealed class InventoryOutState {}

final class InventoryOutInitial extends InventoryOutState {}

final class InventoryOutLoadingStatus extends InventoryOutState {}

final class InventoryOutTapLoadedSuccessStatus extends InventoryOutState {
  final ViewTapInventoryModel model;

  InventoryOutTapLoadedSuccessStatus({required this.model});
}

final class InventoryOutTapFailedStatus extends InventoryOutState {
  final String errorMessage;

  InventoryOutTapFailedStatus({required this.errorMessage});
}

final class InventoryOutTapeStickerDetailsLoadedSuccessStatus
    extends InventoryOutState {
  final TapeStickerInfoModel model;

  InventoryOutTapeStickerDetailsLoadedSuccessStatus({required this.model});
}

final class InventoryOutTapeStickerDetailsFailedStatus
    extends InventoryOutState {
  final String errorMessage;

  InventoryOutTapeStickerDetailsFailedStatus({required this.errorMessage});
}

final class InventoryOutStretchFilmLoadedSuccessStatus
    extends InventoryOutState {
  final ViewStretchFilmModel model;

  InventoryOutStretchFilmLoadedSuccessStatus({required this.model});
}

final class InventoryOutStretchFilmFailedStatus extends InventoryOutState {
  final String errorMessage;

  InventoryOutStretchFilmFailedStatus({required this.errorMessage});
}

final class InventoryOutStretchFilmStickerDetailsLoadedSuccessStatus
    extends InventoryOutState {
  final StretchFilmBatchInfoModel model;

  InventoryOutStretchFilmStickerDetailsLoadedSuccessStatus({
    required this.model,
  });
}

final class InventoryOutStretchFilmStickerDetailsFailedStatus
    extends InventoryOutState {
  final String errorMessage;

  InventoryOutStretchFilmStickerDetailsFailedStatus({
    required this.errorMessage,
  });
}

final class StretchFilmStickerDataLoadedSuccessStatus
    extends InventoryOutState {
  final StretchFilmStickerModel model;

  StretchFilmStickerDataLoadedSuccessStatus({required this.model});
}

final class StretchFilmStickerDataFailedErrorStatus extends InventoryOutState {
  final String message;

  StretchFilmStickerDataFailedErrorStatus({required this.message});
}
