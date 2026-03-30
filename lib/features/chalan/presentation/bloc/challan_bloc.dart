import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:indogrip/features/chalan/data/model/chalanlist_model.dart';
import 'package:indogrip/features/chalan/data/model/challan_details_model.dart';
import 'package:indogrip/features/chalan/data/model/challan_product_verify_model.dart';
import 'package:indogrip/features/chalan/data/model/verify_challan_product_param.dart';
import 'package:indogrip/features/chalan/domain/repositories/chalan_repo.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:meta/meta.dart';

part 'challan_event.dart';
part 'challan_state.dart';

class ChallanBloc extends Bloc<ChallanEvent, ChallanState> {
  ChallanBloc() : super(ChallanInitial()) {
    on<FetchChallanRecordsEvent>(fetchChallanRecordsEvent);
    on<FetchChallanDetailsInBillEvent>(fetchChallanDetailsInBillEvent);
  }

  FutureOr<void> fetchChallanRecordsEvent(
    FetchChallanRecordsEvent event,
    Emitter<ChallanState> emit,
  ) async {
    emit(ChallanLoadingState());

    try {
      final model = await ChallanRepository.fetchChalanRecords(
        param: event.param,
      );
      emit(ChallanRecordLoadedSuccessState(model: model));
    } catch (e) {
      emit(ChallanRecordLoadedFailureState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> fetchChallanDetailsInBillEvent(
    FetchChallanDetailsInBillEvent event,
    Emitter<ChallanState> emit,
  ) async {
    emit(ChallanLoadingState());

    try {
      final model = await ChallanRepository.fetchChallanDetails(
        orderKey: event.orderKey,
      );
      emit(ChallanDetailsLoadedSuccessState(model: model));
    } catch (e) {
      emit(ChallanDetailsLoadedFailureState(errorMessage: e.toString()));
    }
  }
}
