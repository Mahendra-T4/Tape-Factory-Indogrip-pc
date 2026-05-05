import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/features/round/domain/repositories/add_round_repo.dart';
import 'package:indogrip/features/round/presentation/bloc/round_bloc.dart';

class MasterRoleSizeSelector extends StatefulWidget {
  final String? selectedRole;
  final Function(String?) onChanged;
  final bool isFilter;
  final double? size;
  final bool isValidate;
  final void Function(String?)? onLabelChanged;

  MasterRoleSizeSelector({
    Key? key,
    this.selectedRole,
    required this.onChanged,
    this.isFilter = false,
    this.size,
    this.isValidate = true,
    this.onLabelChanged,
  }) : super(key: key);

  @override
  State<MasterRoleSizeSelector> createState() => _MasterRoleSizeSelectorState();
}

class _MasterRoleSizeSelectorState extends State<MasterRoleSizeSelector> {
  late final RoundBloc _roundBloc;
  @override
  void initState() {
    super.initState();
    _roundBloc = RoundBloc(addRoundRepository: AddRoundRepository());
    _roundBloc.add(FetchMasterRollSizeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Cut MM Meter*",
          style: TextStyle(
            color: Color(0xFF3D475C),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        BlocBuilder(
          bloc: _roundBloc,
          builder: (context, state) {
            switch (state.runtimeType) {
              case RoundLoadingStatus:
                return const Center(child: CircularProgressIndicator());
              case MasterRollSizeLoadedSuccessStatus:
                final data = (state as MasterRollSizeLoadedSuccessStatus).model;
                return data.status != 1
                    ? Container(
                        height: widget.size ?? 50,
                        decoration: widget.isFilter
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              )
                            : null,
                        child: Center(
                          child: Text(
                            data.message ?? 'Refresh to load data',
                            style: const TextStyle(
                              color: Color(0xFF3D475C),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: widget.size ?? 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropdownButtonFormField<String>(
                          value: widget.selectedRole,
                          isExpanded: true,
                          decoration: widget.isFilter
                              ? InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: Color(0xFF2D8FCF),
                                      width: 1.5,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                )
                              : InputDecoration(
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

                          hint: const Text("Select Size"),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF2D8FCF),
                            size: 24,
                          ),
                          items: data.record!.map((role) {
                            return DropdownMenuItem<String>(
                              value: role.mId
                                  .toString(), // Convert ID to String
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    role.cutMmMeter.toString(),
                                    style: const TextStyle(
                                      color: Color(0xFF3D475C),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    role.piecesPerCarton.toString(),
                                    style: const TextStyle(
                                      color: Color(0xFF3D475C),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          style: widget.isFilter
                              ? TextStyle(
                                  color: ColourPalette.textFieldLabelColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                )
                              : null,
                          onChanged: (value) {
                            final selectedRecord = data.record?.firstWhere(
                              (r) => r.mId.toString() == value,
                              orElse: () => data.record!.first,
                            );

                            widget.onLabelChanged?.call(
                              selectedRecord?.cutMmMeter.toString(),
                            );
                            widget.onChanged(value);
                          },
                          validator: widget.isValidate
                              ? (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please select a Size";
                                  }
                                  return null;
                                }
                              : null,
                        ),
                      );
              case MasterRollSizeErrorFailedStatus:
                return SizedBox.shrink();
              default:
                return SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
