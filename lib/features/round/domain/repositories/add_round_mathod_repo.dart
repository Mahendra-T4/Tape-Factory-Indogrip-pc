import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/view_jumbo_roll_model.dart';
import 'package:indogrip/features/round/data/models/add_batch_model.dart';
import 'package:indogrip/features/round/data/models/add_batch_param.dart';
import 'package:indogrip/features/round/data/models/add_round_param_model.dart';
import 'package:indogrip/features/round/data/models/batch_details_model.dart';
import 'package:indogrip/features/round/data/models/change_jumbo_status_model.dart';
import 'package:indogrip/features/round/data/models/core_list_model.dart';
import 'package:indogrip/features/round/data/models/edit_round_success_model.dart';
import 'package:indogrip/features/round/data/models/jumbo_info_model.dart';
import 'package:indogrip/features/round/data/models/master_roll_size_entity.dart';
import 'package:indogrip/features/round/data/models/show_model.dart';
import 'package:indogrip/features/round/data/models/view_round_modeld.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';

abstract class AddRoundMethodRepository {
  Future<SuccessResponse> addRound({required AddRoundParam apiParam});

  Future<CoreListModel> fetchCoreList();

  Future<MasterRollSizeEntity> masterRollSize();

  Future<ViewJumboRollModel> masterJumboRoll();

  Future<ViewRoundModel> viewRoundRecords({required ViewRecordApiParam param});

  Future<EditRoundResponse> editRoundRecords({required AddRoundParam apiParam});

  Future<ShowModel> showLengthWidth();

  Future<AddBatchModel> addBatch({required AddBatchParam apiParam});

  Future<BatchDetailsModel> fetchBatchDetails(String rKey);

  Future<List<Map<String, dynamic>>> loadRoundJsonData(
    ViewRecordApiParam param,
  );

  Future<JumboInfoModel> loadJubmoInformations({required String jumboID});

  Future<ChangeJumboStatusModel> changeJumboStatus({
    required String rKey,
    required String rStatus,
  });
}
