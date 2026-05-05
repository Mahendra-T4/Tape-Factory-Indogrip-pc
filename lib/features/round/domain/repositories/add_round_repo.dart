import 'dart:async';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/features/global/data/model/success_reponse.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/view_jumbo_roll_model.dart';
import 'package:indogrip/features/round/data/models/add_batch_model.dart';
import 'package:indogrip/features/round/data/models/add_batch_param.dart';
import 'package:indogrip/features/round/data/models/add_round_param_model.dart';
import 'package:indogrip/features/round/data/models/batch_details_model.dart';
import 'package:indogrip/features/round/data/models/change_jumbo_status_model.dart';
import 'package:indogrip/features/round/data/models/core_list_model.dart';
import 'package:indogrip/features/round/data/models/edit_round_success_model.dart';
import 'package:indogrip/features/round/data/models/jumbo_info_model.dart';
import 'package:indogrip/features/round/data/models/master_roll_size_entity.dart';
import 'package:indogrip/features/round/data/models/show_model.dart';
import 'package:indogrip/features/round/data/models/view_round_modeld.dart';
import 'package:indogrip/features/round/domain/repositories/add_round_mathod_repo.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:retry/retry.dart';

class AddRoundRepository implements AddRoundMethodRepository {
  // final Dio _dioClient = Dio();
  @override
  Future<SuccessResponse> addRound({required AddRoundParam apiParam}) async {
    SuccessResponse successResponse = SuccessResponse();

    try {
      final formData = FormData.fromMap({
        'activity': apiParam.activity,
        'jumboRoll': apiParam.jumboRoll.join(','),
        'rollSize': apiParam.rollSize,
        'rollCore': apiParam.rollCore,
        'round': apiParam.round,
        'damagePieces': apiParam.damagePieces,
        'wastagePercentage': apiParam.wastagePercentage,
        'conversionRate': apiParam.conversionRate,
        'meters': apiParam.meters,
        'cartonType': apiParam.cartonType,
        'userKey': HiveService.getUserId(),
      });
      final response = await retry(
        () => DioService.dioPostApiCall(data: formData).timeout(
          const Duration(seconds: 30),
          onTimeout: () => throw TimeoutException('Request timed out'),
        ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        successResponse = SuccessResponse.fromJson(response.data);
        developer.log(name: 'Add Round Api Fields', formData.fields.toString());
        developer.log(name: 'Add Round Response', response.data.toString());
      }
    } on DioException catch (error) {
      developer.log(name: 'Add Round Error', error.toString());
    } catch (e) {
      developer.log(name: 'Add Round Error', e.toString());
    }
    return successResponse;
  }

  @override
  Future<CoreListModel> fetchCoreList() async {
    CoreListModel coreListModel = CoreListModel();

    try {
      final Response response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'view-master-core',
                'userKey': HiveService.getUserId(),
              }),
            ).timeout(
              const Duration(seconds: 30),
              onTimeout: () => throw TimeoutException('Request timed out'),
            ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        coreListModel = CoreListModel.fromJson(response.data);

        developer.log(
          name: 'CoreList Response',
          coreListModel.message.toString(),
        );
      } else {
        return CoreListModel()..message = 'Failed to Load Data From Server';
      }
    } catch (e) {
      developer.log(name: 'CoreList Fetching Error', e.toString());
    }
    return coreListModel;
  }

  @override
  Future<MasterRollSizeEntity> masterRollSize() async {
    MasterRollSizeEntity rollSize = MasterRollSizeEntity();
    try {
      final Response response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'view-master-roll-size',
                'userKey': HiveService.getUserId(),
              }),
            ).timeout(
              const Duration(seconds: 30),
              onTimeout: () => throw TimeoutException('Request timed out'),
            ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        rollSize = MasterRollSizeEntity.fromJson(response.data);

        developer.log(
          name: 'Master roll Size Response',
          rollSize.message.toString(),
        );
      } else {
        developer.log(
          name: 'Master roll Size Failed',
          'Failed to Load Data From Server',
        );
      }
    } catch (e) {
      developer.log(name: 'MasterRoll Size Fetching Error', e.toString());
    }
    return rollSize;
  }

  @override
  Future<ViewJumboRollModel> masterJumboRoll() async {
    ViewJumboRollModel mJumboRollModel = ViewJumboRollModel();
    try {
      final Response response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'view-jumbo-roll',
                'userKey': HiveService.getUserId(),
                'available': '1',
              }),
            ).timeout(
              const Duration(seconds: 30),
              onTimeout: () => throw TimeoutException('Request timed out'),
            ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        mJumboRollModel = ViewJumboRollModel.fromJson(response.data);

        developer.log(
          name: 'MasterJumboRoll Size Response',
          mJumboRollModel.message.toString(),
        );
      } else {
        return ViewJumboRollModel()
          ..message = 'Failed to Load Data From Server';
      }
    } catch (e) {
      developer.log(name: 'MasterJumboRoll Size Fetching Error', e.toString());
    }
    return mJumboRollModel;
  }

  @override
  Future<ViewRoundModel> viewRoundRecords({
    required ViewRecordApiParam param,
  }) async {
    ViewRoundModel viewRoundModel = ViewRoundModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'view-round',
                'userKey': HiveService.getUserId(),
                'keyword': param.keyword ?? '',
                'filterBy': param.filterBy ?? '',
                'sortBy': param.sortBy ?? '',
                'orderBy': param.orderBy ?? '',
                'pageNo': param.pageNo ?? 1,
                'cutMMMeterID': param.cutMMMeterID,
                'micID': param.micID,
                'baseID': param.baseID,
                'fromDate': param.fromDate ?? '',
                'toDate': param.toDate ?? '',
                'tapeLength': param.tapeLength,
              }),
            ).timeout(
              const Duration(seconds: 30),
              onTimeout: () => throw TimeoutException('Request timed out'),
            ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        viewRoundModel = ViewRoundModel.fromJson(response.data);
        developer.log(
          name: 'View Round Response',
          viewRoundModel.message.toString(),
        );
      } else {
        developer.log(
          name: 'View Round Failed',
          'Failed to Load Data From Server',
        );
        return ViewRoundModel()..message = 'Failed to Load Data From Server';
      }
    } catch (e) {
      developer.log(name: 'View Round Error', e.toString());
    }
    return viewRoundModel;
  }

  @override
  Future<EditRoundResponse> editRoundRecords({
    required AddRoundParam apiParam,
  }) async {
    EditRoundResponse successResponse = EditRoundResponse();

    try {
      final formData = FormData.fromMap({
        'activity': 'add-round',
        'rollSize': apiParam.rollSize,
        'rollCore': apiParam.rollCore,
        'round': apiParam.round,
        'damagePieces': apiParam.damagePieces,
        'wastagePercentage': apiParam.wastagePercentage,
        'conversionRate': apiParam.conversionRate,
        'meters': apiParam.meters,
        'cartonType': apiParam.cartonType,
        'jumboRoll': apiParam.jumboRoll,
        'rKey': apiParam.rKey,
        'userKey': HiveService.getUserId(),
      });
      final response = await retry(
        () => DioService.dioPostApiCall(data: formData).timeout(
          const Duration(seconds: 30),
          onTimeout: () => throw TimeoutException('Request timed out'),
        ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        successResponse = EditRoundResponse.fromJson(response.data);
        developer.log(formData.fields.toString(), name: 'Edit Round Request');
        developer.log(name: 'Edit Round Response', response.data.toString());
      }
    } on DioException catch (error) {
      developer.log(name: 'Edit Round Error', error.toString());
    } catch (e) {
      developer.log(name: 'Edit Round Error', e.toString());
    }
    return successResponse;
  }

  @override
  Future<ShowModel> showLengthWidth() async {
    ShowModel showModel = ShowModel();

    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'view-master-show-for',
                'userKey': HiveService.getUserId(),
              }),
            ).timeout(
              const Duration(seconds: 30),
              onTimeout: () => throw TimeoutException('Request timed out'),
            ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        showModel = ShowModel.fromJson(response.data);
        developer.log(
          name: 'Show Length Width Response',
          showModel.message.toString(),
        );
      } else {
        developer.log(
          name: 'Show Length Width Failed',
          'Failed to Load Data From Server',
        );
      }
    } catch (e) {
      developer.log(name: 'Show Length Width Error', e.toString());
    }

    return showModel;
  }

  @override
  Future<AddBatchModel> addBatch({required AddBatchParam apiParam}) async {
    AddBatchModel addBatchModel = AddBatchModel();
    try {
      final formData = FormData.fromMap({
        'activity': 'batch-information',
        'userKey': HiveService.getUserId(),
        'roundKey': apiParam.roundKey,
        'showFor': apiParam.showFor,
        'displayMic': apiParam.displayMic,
        'displayValue': apiParam.displayValue,
        'batchMRP': apiParam.batchMRP,
        'batchOperator': apiParam.batchOperator,
        'displayMFG': apiParam.displayMFG,
        'batchPackedBy': apiParam.batchPackedBy,

        'rKey': apiParam.rKey,
        'remark': apiParam.remark,
      });
      final response = await retry(
        () => DioService.dioPostApiCall(data: formData).timeout(
          const Duration(seconds: 30),
          onTimeout: () => throw TimeoutException('Request timed out'),
        ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        addBatchModel = AddBatchModel.fromJson(response.data);
        developer.log(
          name: 'Add Batch Response',
          addBatchModel.message.toString(),
        );
        developer.log(name: 'Add Batch Response', response.data.toString());
        developer.log(name: 'Add Batch FormData', formData.fields.toString());
      } else {
        developer.log(
          name: 'Add Batch Failed',
          'Failed to Load Data From Server',
        );
      }
    } catch (e) {
      developer.log(name: 'Add Batch Error', e.toString());
    }
    return addBatchModel;
  }

  @override
  Future<BatchDetailsModel> fetchBatchDetails(String rKey) async {
    BatchDetailsModel batchDetailsModel = BatchDetailsModel();
    try {
      final response = await retry(
        () =>
            DioService.dioPostApiCall(
              data: FormData.fromMap({
                'activity': 'round-details',
                'userKey': HiveService.getUserId(),
                'roundKey': rKey,
              }),
            ).timeout(
              const Duration(seconds: 30),
              onTimeout: () => throw TimeoutException('Request timed out'),
            ),
        retryIf: (e) => e is TimeoutException || e is DioException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 1),
      );

      if (response.statusCode == 200) {
        batchDetailsModel = BatchDetailsModel.fromJson(response.data);
        developer.log(
          name: 'Fetch Batch Details Api',
          response.data.toString(),
        );
        developer.log(
          name: 'Fetch Batch Details Response',
          batchDetailsModel.message.toString(),
        );
      } else {
        developer.log(
          name: 'Fetch Batch Details Failed',
          'Failed to Load Data From Server',
        );
      }
    } catch (e) {
      developer.log(name: 'Fetch Batch Details Error', e.toString());
    }
    return batchDetailsModel;
  }

  @override
  Future<List<Map<String, dynamic>>> loadRoundJsonData(
    ViewRecordApiParam param,
  ) async {
    try {
      final response = await DioService.dioPostApiCall(
        data: FormData.fromMap({
          'activity': 'view-round',
          'userKey': HiveService.getUserId(),
          'keyword': param.keyword ?? '',
          'filterBy': param.filterBy ?? '',
          'sortBy': param.sortBy ?? '',
          'orderBy': param.orderBy ?? '',
          'pageNo': param.pageNo ?? 1,
          'cutMMMeterID': param.cutMMMeterID,
          'micID': param.micID,
          'baseID': param.baseID,
          'fromDate': param.fromDate ?? '',
          'toDate': param.toDate ?? '',
          'tapeLength': param.tapeLength,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;

        final roundList = jsonData is Map && jsonData['record'] is List
            ? (jsonData['record'] as List)
                  .where((item) => item is Map)
                  .map((element) => Map<String, dynamic>.from(element as Map))
                  .toList()
            : <Map<String, dynamic>>[];

        return roundList;
      } else {
        developer.log(
          name: 'Load Round Json Data Failed',
          'Failed to Load Data From Server',
        );
        throw Exception('Failed to Load Data From Server');
      }
    } catch (e) {
      developer.log(name: 'Load Round Json Data Error', e.toString());
      throw Exception('Error loading round JSON data: $e');
    }
  }

  @override
  Future<JumboInfoModel> loadJubmoInformations({
    required String jumboID,
  }) async {
    JumboInfoModel jumboInfoModel = JumboInfoModel();

    try {
      final response = await DioService.dioPostApiCall(
        data: FormData.fromMap({
          'activity': 'jumbo-information',
          'userKey': HiveService.getUserId(),
          'jumboID': jumboID,
        }),
      );

      if (response.statusCode == 200) {
        jumboInfoModel = JumboInfoModel.fromJson(response.data);
        developer.log(
          name: 'Fetch Jumbo Information Response',
          jumboInfoModel.message.toString(),
        );
        developer.log(
          name: 'Fetch Jumbo Information Raw Data',
          response.data.toString(),
        );
      } else {
        developer.log(
          name: 'Fetch Jumbo Information Failed',
          'Failed to Load Data From Server',
        );
      }
    } catch (e) {
      developer.log(name: 'Fetch Jumbo Information Error', e.toString());
    } finally {
      return jumboInfoModel;
    }
  }

  @override
  Future<ChangeJumboStatusModel> changeJumboStatus({
    required String rKey,
    required String rStatus,
  }) async {
    ChangeJumboStatusModel model = ChangeJumboStatusModel();

    try {
      final response = await DioService.dioPostApiCall(
        data: FormData.fromMap({
          'activity': 'change-status',
          'userKey': HiveService.getUserId(),
          'rPanel': 'view-jumbo-roll',
          'rKey': rKey,
          'rStatus': rStatus,
        }),
      );

      if (response.statusCode == 200) {
        model = ChangeJumboStatusModel.fromJson(response.data);
        developer.log(
          name: 'Change Jumbo Status Response',
          model.message.toString(),
        );
        developer.log(
          name: 'Change Jumbo Status Raw Data',
          response.data.toString(),
        );
      } else {
        developer.log(
          name: 'Change Jumbo Status Failed',
          'Failed to Load Data From Server',
        );
      }
    } catch (e) {
      developer.log(name: 'Change Jumbo Status Error', e.toString());
    } finally {
      return model;
    }
  }
}
