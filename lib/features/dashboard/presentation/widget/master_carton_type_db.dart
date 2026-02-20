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
                : Container(
                    constraints: BoxConstraints(maxHeight: 450),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Container(
                      height: 420,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    7,
                                    35,
                                    254,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.add_box,
                                  color: Color.fromARGB(255, 7, 35, 254),
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Carton Type',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFF9B59B6).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Carton Type',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF9B59B6),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Carton Stock',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF9B59B6),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Carton Code',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF9B59B6),
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.cartonTypeModel.record!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: index.isEven
                                      ? const Color.fromARGB(
                                          255,
                                          7,
                                          35,
                                          254,
                                        ).withOpacity(0.03)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        state
                                            .cartonTypeModel
                                            .record![index]
                                            .mCartonName
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF2C3E50),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        state
                                            .cartonTypeModel
                                            .record![index]
                                            .cartonStock
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF2C3E50),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        state
                                            .cartonTypeModel
                                            .record![index]
                                            .mCartonCode
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF2C3E50),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
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
