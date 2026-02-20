// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/bloc/jumbo_roll_bloc.dart';

class BaseDropdownWidget extends StatefulWidget {
  final String? value;
  final InputDecoration? decoration;
  final void Function(String?) onChanged;
  final double? size;
  const BaseDropdownWidget({
    Key? key,
    this.value,
    this.decoration,
    this.size,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<BaseDropdownWidget> createState() => _BaseDropdownWidgetState();
}

class _BaseDropdownWidgetState extends State<BaseDropdownWidget> {
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
                      SizedBox(
                        height: widget.size ?? 51,
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
                          decoration:
                              widget.decoration ??
                              InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
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
