import 'package:hive/hive.dart';
import 'package:indogrip/core/database/round_db_hive.dart';
import 'package:indogrip/features/chalan/data/model/round_data_model.dart';

class Boxes {
  static Box<RoundDataModel> roundData() =>
      Hive.box<RoundDataModel>(RoundDBHive.roundBox);
}
