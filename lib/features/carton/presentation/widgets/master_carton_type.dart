import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/features/carton/data/models/master_carton_type_model.dart';
import 'package:indogrip/features/carton/domain/repositories/carton_repo.dart';
import 'package:indogrip/features/carton/presentation/bloc/carton_bloc.dart';


final masterCartonTypeProvider = FutureProvider<CartonTypeModel>(
  (ref) => CartonRepository.masterCartonType(),
);

class MasterCartonTypeDropDown extends StatefulWidget {
  final String? selectCartonType;
  final Function(String?) onChanged;

  const MasterCartonTypeDropDown({
    Key? key,
    required this.selectCartonType,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<MasterCartonTypeDropDown> createState() =>
      _MasterCartonTypeDropDownState();
}

class _MasterCartonTypeDropDownState extends State<MasterCartonTypeDropDown> {
  late final CartonBloc _cartonBloc;

  @override
  void initState() {
    super.initState();
    _cartonBloc = CartonBloc();
    _cartonBloc.add(FetchMasterCartonTypeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Carton Type*",
          style: TextStyle(
            color: Color(0xFF3D475C),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        BlocBuilder(
          bloc: _cartonBloc,

          builder: (context, state) {
            switch (state.runtimeType) {
              case CartonLoadingStatus:
                return const Center(child: CircularProgressIndicator());
              case FetchMasterCartonTypeSuccessStatus:
                final carton = (state as FetchMasterCartonTypeSuccessStatus)
                    .cartonTypeModel;
                return carton.status != 1
                    ? Center(child: Text(carton.message.toString()))
                    : Container(
                        height: 68,
                       
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        
                        ),
                        child: DropdownButtonFormField<String>(
                          hint: Text('Select Carton Type'),
                          value:
                              widget.selectCartonType != null &&
                                  (carton.record?.any(
                                        (r) =>
                                            r.mCartonId.toString() ==
                                            widget.selectCartonType,
                                      ) ??
                                      false)
                              ? widget.selectCartonType
                              : null,
                          items:
                              carton.record
                                  ?.map(
                                    (record) => DropdownMenuItem(
                                      value: record.mCartonId.toString(),
                                      child: Text(record.mCartonName ?? ''),
                                    ),
                                  )
                                  .toList() ??
                              [],
                          onChanged: widget.onChanged,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Color(0xFF2D8FCF),
                                width: 1.5,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                          ),
                          isExpanded: true,
                          style: TextStyle(
                            color: ColourPalette.textFieldLabelColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          validator: (value) => value == null
                              ? 'Please Select Carton Type'
                              : null,
                        ),
                      );
              case FetchViewCartonRecordFailureStatus:
                final errorState = state as FetchViewCartonRecordFailureStatus;
                return Center(child: Text('Error: ${errorState.errorMessage}'));

              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
