// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/bloc/jumbo_roll_bloc.dart';


class BaseFilterDropdownWidget extends StatefulWidget {
  final String? value;
  final InputDecoration? decoration;
  final void Function(String?) onChanged;
  final double? size;
  const BaseFilterDropdownWidget({
    Key? key,
    this.value,
    this.decoration,
    this.size,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<BaseFilterDropdownWidget> createState() => _BaseDropdownWidgetState();
}

class _BaseDropdownWidgetState extends State<BaseFilterDropdownWidget> {
  late final JumboRollBloc _jumboRollBloc;

  @override
  void initState() {
    super.initState();
    _jumboRollBloc = JumboRollBloc();
    _jumboRollBloc.add(LoadMasterJumboBaseEvent());
  }

  @override
  Widget build(BuildContext context) {
    // final baseProvider = ref.watch(masterBaseProvider);
    return BlocBuilder(
      bloc: _jumboRollBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case JumboRollLoadingStatus:
            return const Center(child: CircularProgressIndicator());
          case MasterJumboBaseLoadedSuccessState:
            final data = (state as MasterJumboBaseLoadedSuccessState).model;
            return data.status != 1
                ? Center(child: Text(data.message ?? 'No response from server'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldlabelText('Base'),
                      const SizedBox(height: 8),
                      Container(
                        height: 37,
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
                          hint: Text('Select Base'),
                          value:
                              widget.value != null &&
                                  (data.record?.any(
                                        (r) =>
                                            r.mBaseId.toString() ==
                                            widget.value,
                                      ) ??
                                      false)
                              ? widget.value
                              : null,
                          items:
                              data.record
                                  ?.map(
                                    (record) => DropdownMenuItem(
                                      value: record.mBaseId.toString(),
                                      child: Text(record.mBaseName ?? ''),
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
                          validator: (value) =>
                              value == null ? 'Please select Base' : null,
                        ),
                      ),
                    ],
                  );
          case MasterJumboBaseLoadedFailureState:
            final errorMessage =
                (state as MasterJumboBaseLoadedFailureState).errorMessage;
            return Text(
              'Error: $errorMessage',
              style: TextStyle(color: Colors.red),
            );

          default:
            return const SizedBox();
        }
      },
    );
  }
}
