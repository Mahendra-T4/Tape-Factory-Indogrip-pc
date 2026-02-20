import 'package:indogrip/features/client/data/model/view_staff_api_param.dart';
import 'package:indogrip/features/staff/data/models/access_panel_model.dart';
import 'package:indogrip/features/staff/data/models/master_roll_model.dart';

abstract class StaffMethodProviderRepo {
  Future<void> updateStaffDetails({required EditStaffApiParam param});

  Future<MasterRoll> fetchUserRolls();

  Future<AccessPanel> fetchAccessPanels();
}
