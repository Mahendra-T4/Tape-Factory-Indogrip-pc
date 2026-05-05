import 'package:hive/hive.dart';
import 'package:indogrip/features/chalan/data/model/round_data_model.dart';
import 'package:path_provider/path_provider.dart';

class RoundDBHive {
  static const String roundBox = 'round_db_hive';

  static Future<void> initialize() async {
    var directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(RoundDataModelAdapter());
    await Hive.openBox<RoundDataModel>(roundBox);
  }
}
