import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:indogrip/features/wastage/data/model/add_wastage_param.dart';
import 'package:indogrip/features/wastage/data/model/edit_wastage_api_param.dart';
import 'package:indogrip/features/wastage/data/model/edit_wastage_success_model.dart';
import 'package:indogrip/features/wastage/data/model/view_wastage_model.dart';

abstract class WastageMathodProviderRepository{

  Future<SuccessResponse>addWastage(AddWastageParam addWastageParam);

  Future<ViewWastageModel> viewWastage({required ViewRecordApiParam param});

  Future<EditWastageResponse>editWastage({
    required EditWastageApiParam apiParam,
  });

}