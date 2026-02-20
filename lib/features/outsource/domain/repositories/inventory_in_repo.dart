import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/outsource/data/model/inventory_in_param.dart';
import 'package:indogrip/features/outsource/presentation/outside-in/models/add_batch_param.dart';

abstract class InventoryInRepository {
  Future<SuccessResponse> addInventoryInRecord({
    required InventoryInParam param,
  });

   Future<SuccessResponse> insertBatchRecord({
    required InsertBatch param,
  });

 
}
