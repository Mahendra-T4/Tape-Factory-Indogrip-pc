import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/features/outsource/presentation/state/bloc.master/master_in_bloc.dart';

class MasterProductTypeWidget extends StatefulWidget {
  const MasterProductTypeWidget({super.key, this.value, this.onChanged});
  final String? value;
  final void Function(String?)? onChanged;

  @override
  State<MasterProductTypeWidget> createState() =>
      _MasterStretchFilmWidgetState();
}

class _MasterStretchFilmWidgetState extends State<MasterProductTypeWidget> {
  late final MasterInBloc masterInBloc;
  @override
  void initState() {
    masterInBloc = MasterInBloc();
    masterInBloc.add(LoadMasterInProductTypeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: masterInBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is MasterInLoadingStatus) {
          return Center(child: CircularProgressIndicator());
        } else if (state is MasterInProductTypeLoadedStatus) {
          final data = state.model;
          return data.status != 1
              ? Center(child: Text(data.message.toString()))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldlabelText('Product Type'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      hint: Text('Select Product Type'),
                      value:
                          widget.value != null &&
                              (data.record!.any(
                                (r) => r.productID.toString() == widget.value,
                              ))
                          ? widget.value
                          : null,
                      items:
                          data.record
                              ?.map(
                                (record) => DropdownMenuItem(
                                  value: record.productID.toString(),
                                  child: Text(
                                    record.productTypeName.toString(),
                                  ),
                                ),
                              )
                              .toList() ??
                          [],
                      onChanged: widget.onChanged,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) =>
                          value == null ? 'Please select product type' : null,
                    ),
                  ],
                );
        } else if (state is MasterInProductTypeErrorStatus) {
          return SizedBox.shrink();
        }
        return SizedBox.shrink();
      },
    );
  }
}
