import 'package:indogrip/features/dashboard/data/model/predict_cal_param.dart';
import 'package:indogrip/features/dashboard/data/model/predict_calculation_model.dart';
import 'package:indogrip/features/dashboard/data/model/show_static_model.dart';

abstract class HomeManagerRepository {
  Future<ShowStaticModel> showDashboardStatic();
  Future<PredictCalculationModel> predictCalculation({
    required PredictCalParam param,
  });
}
