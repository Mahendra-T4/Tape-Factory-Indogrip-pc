import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/outsource/data/model/stretchfilm_sticker_model.dart';
import 'package:indogrip/features/outsource/data/model/tap_sticker_info_model.dart';
import 'package:indogrip/features/outsource/data/model/upload_file_param.dart';
import 'package:indogrip/features/outsource/data/model/upload_stretch_record_model.dart';
import 'package:indogrip/features/outsource/data/model/upload_tap_miss_record_model.dart';
import 'package:indogrip/features/outsource/data/model/view_stretchfilm_model.dart';
import 'package:indogrip/features/outsource/data/model/view_tap_in_model.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';

abstract class InventoryOutRepository {
  Future<ViewTapInventoryModel> loadTapInventoryData({
    required ViewRecordApiParam param,
  });

  Future<ViewStretchFilmModel> loadStretchFilmInventoryData({
    required ViewRecordApiParam param,
  });

  Future<TapeStickerInfoModel> loadTapeStickerDetails(String inventoryKey);

  Future<StretchFilmStickerModel> loadStretchFilmStickerDetails(
    String inventoryKey,
  );

  Future<UploadTapRecordModel> uploadCSVFileInventoryIN(UploadFileParam param);

  Future<UploadStretchRecordModel> uploadStretchCSVFileInventoryIN(
    UploadFileParam param,
  );
}
