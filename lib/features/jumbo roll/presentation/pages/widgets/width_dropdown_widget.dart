// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/bloc/jumbo_roll_bloc.dart';

class WidthDropdownWidget extends StatefulWidget {
  final String? value;
  final bool isFilter;
  final double? size;
  final void Function(String?) onChanged;
  const WidthDropdownWidget({
    Key? key,
    this.value,
    this.size,
    required this.onChanged,
    this.isFilter = false,
  }) : super(key: key);

  @override
  State<WidthDropdownWidget> createState() => _WidthDropdownWidgetState();
}

class _WidthDropdownWidgetState extends State<WidthDropdownWidget> {
  late final JumboRollBloc _jumboRollBloc;
  @override
  void initState() {
    super.initState();
    _jumboRollBloc = JumboRollBloc();
    _jumboRollBloc.add(LoadMasterJumboWidthEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _jumboRollBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case JumboRollLoadingStatus:
            return const Center(child: CircularProgressIndicator());
          case MasterJumboWidthLoadedSuccessState:
            final data = (state as MasterJumboWidthLoadedSuccessState).model;
            return data.status != 1
                ? Center(child: Text(data.message ?? 'Refresh to load data'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldlabelText('Width'),
                      const SizedBox(height: 8),
                      Container(
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
                        child: DropdownButtonFormField<String>(
                          hint: Text('Select Width'),
                          value: widget.value,
                          items:
                              data.record
                                  ?.map(
                                    (record) => DropdownMenuItem(
                                      value: record.mWidthId
                                          .toString(), // Use width name as value instead of ID
                                      child: Text(record.mWidthName.toString()),
                                    ),
                                  )
                                  .toList() ??
                              [],
                          onChanged: widget.onChanged,
                          style: widget.isFilter
                              ? TextStyle(
                                  color: ColourPalette.textFieldLabelColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                )
                              : null,
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
                              : InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                          validator: (value) =>
                              value == null ? 'Please select Width' : null,
                        ),
                      ),
                    ],
                  );
          case MasterJumboWidthLoadedFailureState:
            final error =
                (state as MasterJumboWidthLoadedFailureState).errorMessage;
            return Text('Error: $error', style: TextStyle(color: Colors.red));
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
