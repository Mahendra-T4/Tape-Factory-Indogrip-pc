import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indogrip/features/global/data/model/change_status_model.dart';
import 'package:indogrip/features/global/data/model/change_status_param.dart';
import 'package:indogrip/features/global/data/model/delete_record_model.dart';
import 'package:indogrip/features/global/data/model/profit_loss_modeld.dart';
import 'package:indogrip/features/global/data/model/setting_model.dart';
import 'package:indogrip/features/global/data/model/stock_status_model.dart';
import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/global/data/model/udpate_status_model.dart';
import 'package:indogrip/features/global/data/model/update_default_setting_model.dart';
import 'package:indogrip/features/global/data/model/ustatus_param.dart';
import 'package:indogrip/features/global/data/model/view_master_user_status_model.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/outsource/data/model/upload_file_param.dart';
import 'package:indogrip/features/round/data/models/upload_round_record_model.dart';

final settingProvider = FutureProvider<SettingModel>((ref) {
  return GlobalManagerRepository().fetchSettings();
});

abstract class GlobalRepository {
  Future<ChangeStatusEntity> changeUserStatus({
    required ChangeStaffParam param,
  });

  Future<DeleteRecordEntity> deleteRecord({
    required String rKey,
    required String rPanel,
  });

  Future<DeleteRecordEntity> deleteMultipleRecords({
    required List<String> rKeys,
    required String rPanel,
  });

  Future<UserStatusModel> masterUserStatus();

  Future<SuccessResponse> uploadCsvFile({required UploadFileParam param});

  Future<UploadRoundRecordModel> uploadRoundRecordCsvFile({
    required UploadFileParam param,
  });

  Future<SettingModel> fetchSettings();

  Future<UpdateStatusModel> updateUserStatus(
    BuildContext context, {
    required UStatus param,
  });

  Future<StockStatusModel> stockStatus();

  Future<UpdateDefaultSetting> updateDefaultSetting({
    required String conversionRate,
    required String wastagePercentage,
    required String amountPerKG,
  });

  Future<ProfitAndLossModel> profitAndLossGetter({
    required String toDate,
    required String fromDate,
    required String productType,
  });
}
