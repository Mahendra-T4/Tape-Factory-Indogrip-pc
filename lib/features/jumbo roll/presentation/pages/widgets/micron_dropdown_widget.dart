// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/bloc/jumbo_roll_bloc.dart';

class MicronDropdownWidget extends StatefulWidget {
  final InputDecoration? decoration;
  final double? size;
  final String? value;
  final bool isFilter;
  final void Function(String?) onChanged;
  final void Function(String?)? onLabelChanged;

  MicronDropdownWidget({
    Key? key,
    this.value,
    this.decoration,
    this.size,
    this.isFilter = false,
    required this.onChanged,
    this.onLabelChanged,
  }) : super(key: key);

  @override
  State<MicronDropdownWidget> createState() => _MicronDropdownWidgetState();
}

class _MicronDropdownWidgetState extends State<MicronDropdownWidget> {
  late final JumboRollBloc _jumboRollBloc;
  @override
  void initState() {
    super.initState();
    _jumboRollBloc = JumboRollBloc();
    _jumboRollBloc.add(LoadMasterJumboMicronEvent());
  }

  @override
  Widget build(BuildContext context) {
    // final micronProvider = ref.watch(masterMicProvider);
    return BlocBuilder(
      bloc: _jumboRollBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case JumboRollLoadingStatus:
            return const Center(child: CircularProgressIndicator());
          case MasterJumboMicronLoadedSuccessState:
            final data = (state as MasterJumboMicronLoadedSuccessState).model;
            return data.status != 1
                ? Center(child: Text(data.message ?? 'Refresh to load data'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldlabelText('Mic'),
                      const SizedBox(height: 8),
                      Container(
                        height: widget.size ?? 51,

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
                        child: DropdownButtonFormField<String>(
                          hint: Text('Select Mic'),
                          value:
                              widget.value != null &&
                                  (data.record?.any(
                                        (r) =>
                                            r.mMicId.toString() == widget.value,
                                      ) ??
                                      false)
                              ? widget.value
                              : null,
                          items:
                              data.record
                                  ?.map(
                                    (record) => DropdownMenuItem(
                                      value: record.mMicId.toString(),
                                      child: Text(record.mMicName ?? ''),
                                    ),
                                  )
                                  .toList() ??
                              [],
                          style: widget.isFilter
                              ? TextStyle(
                                  color: ColourPalette.textFieldLabelColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                )
                              : null,
                          onChanged: (value) {
                            final selectedRecord = data.record?.firstWhere(
                              (r) => r.mMicId.toString() == value,
                              orElse: () => data.record!.first,
                            );

                            widget.onLabelChanged?.call(
                              selectedRecord?.mMicName,
                            );
                            widget.onChanged.call(value);
                          },
                          decoration: widget.isFilter
                              ? InputDecoration(
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
                                )
                              : widget.decoration ??
                                    InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                          validator: (value) =>
                              value == null ? 'Please select Mic' : null,
                        ),
                      ),
                    ],
                  );
          case MasterJumboMicronLoadedFailureState:
            final errorState = state as MasterJumboMicronLoadedFailureState;
            return Center(
              child: Text(
                errorState.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
