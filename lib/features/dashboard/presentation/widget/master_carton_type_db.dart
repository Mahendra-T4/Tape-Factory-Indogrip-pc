import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indogrip/features/carton/data/models/master_carton_type_model.dart';
import 'package:indogrip/features/carton/domain/repositories/carton_repo.dart';
import 'package:indogrip/features/carton/presentation/bloc/carton_bloc.dart';

final masterCartonTypeProvider = FutureProvider<CartonTypeModel>(
  (ref) => CartonRepository.masterCartonType(),
);

class MasterCartonTypeDropDownDB extends StatefulWidget {
  const MasterCartonTypeDropDownDB({Key? key}) : super(key: key);

  @override
  State<MasterCartonTypeDropDownDB> createState() =>
      _MasterCartonTypeDropDownDBState();
}

class _MasterCartonTypeDropDownDBState
    extends State<MasterCartonTypeDropDownDB> {
  late final CartonBloc _cartonBloc;

  @override
  void initState() {
    super.initState();
    _cartonBloc = CartonBloc();
    _cartonBloc.add(FetchMasterCartonTypeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _cartonBloc,

      builder: (context, state) {
        switch (state.runtimeType) {
          case CartonLoadingStatus:
            return const Center(child: CircularProgressIndicator());
          case FetchMasterCartonTypeSuccessStatus:
            final carton =
                (state as FetchMasterCartonTypeSuccessStatus).cartonTypeModel;
            return carton.status != 1
                ? Center(child: Text(carton.message.toString()))
                : Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9B59B6).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Carton Type',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF9B59B6),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Carton Stock',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF9B59B6),
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Carton Code',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF9B59B6),
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: carton.record?.length ?? 0,
                        itemBuilder: (context, index) {
                          final item = carton.record![index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: index.isEven
                                  ? const Color(0xFF9B59B6).withOpacity(0.03)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey[200]!,
                                width: 0.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.mCartonName.toString(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2C3E50),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    item.cartonStock.toString(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2C3E50),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    item.mCartonCode.toString(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2C3E50),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );

          case FetchViewCartonRecordFailureStatus:
            final errorState = state as FetchViewCartonRecordFailureStatus;
            return Center(child: Text('Error: ${errorState.errorMessage}'));

          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
