import 'package:indogrip/features/dashboard/data/model/predict_cal_param.dart';
import 'package:indogrip/features/dashboard/data/model/predict_calculation_model.dart';
import 'package:indogrip/features/dashboard/data/model/show_static_model.dart';
import 'package:indogrip/features/dashboard/data/model/stretch_stock_model.dart';
import 'package:indogrip/features/dashboard/data/model/tape_stock_model.dart';
import 'package:indogrip/features/dashboard/domain/tape_stock_entity.dart';

abstract class HomeManagerRepository {
  Future<ShowStaticModel> showDashboardStatic();
  Future<PredictCalculationModel> predictCalculation({
    required PredictCalParam param,
  });

  Future<PredictCalculationModel> predictCalculationByMic({
    required PredictCalParam param,
  });

  Future<TapeStockModel> fetchTapeStock({required TapeStockEntity param});

  Future<StretchStockModel> fetchStretchStock({
    required String baseID,
    required String filmSizeID,
    required String coreID,
      required String micID,
  });
}
