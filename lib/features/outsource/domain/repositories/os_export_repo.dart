import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';

abstract class OutSourceExportMasterRepository {
  Future<List<Map<String, dynamic>>> exportToExcel(ViewRecordApiParam param);

  Future<List<Map<String, dynamic>>> exportStretchExcel(
    ViewRecordApiParam param,
  );
}
