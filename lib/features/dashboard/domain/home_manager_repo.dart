import 'package:indogrip/features/dashboard/data/model/show_static_model.dart';

abstract class HomeManagerRepository {
  Future<ShowStaticModel> showDashboardStatic();
}
