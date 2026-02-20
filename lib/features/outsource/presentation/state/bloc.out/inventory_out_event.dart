part of 'inventory_out_bloc.dart';

@immutable
sealed class InventoryOutEvent {}

final class ViewTapInventoryFetchingEvent extends InventoryOutEvent {
  final ViewRecordApiParam param;

  ViewTapInventoryFetchingEvent({required this.param});
}

final class ViewStretchFilmFetchingEvent extends InventoryOutEvent {}

final class ViewTapeInventoryStickerDetailsEvent extends InventoryOutEvent {
  final String inventoryKey;

  ViewTapeInventoryStickerDetailsEvent({required this.inventoryKey});
}

final class ViewStretchFilmInventoryFetchingEvent extends InventoryOutEvent {
  final ViewRecordApiParam param;

  ViewStretchFilmInventoryFetchingEvent({required this.param});
}

final class ViewStretchFilmStickerDetailsEvent extends InventoryOutEvent {
  final String inventoryKey;

  ViewStretchFilmStickerDetailsEvent({required this.inventoryKey});
}

final class LoadStretchFilmStickerInfoDetailsEvent extends InventoryOutEvent {
  final String batchKey;

  LoadStretchFilmStickerInfoDetailsEvent({required this.batchKey});
}
