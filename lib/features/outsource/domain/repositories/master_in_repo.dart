import 'package:indogrip/features/outsource/data/model/master_product_type_model.dart';
import 'package:indogrip/features/outsource/data/model/stretch_film_model.dart';

abstract class MasterInRepository {
  Future<MasterStretchFilmModel> loadMasterStretchFilmData();

  Future<MasterProductTypeModel>loadMasterProductTypeData();
}
