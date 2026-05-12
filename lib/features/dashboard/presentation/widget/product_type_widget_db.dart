import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/features/outsource/data/model/master_product_type_model.dart';
import 'package:indogrip/features/outsource/presentation/state/bloc.master/master_in_bloc.dart';

class MasterProductTypeDBWidget extends StatefulWidget {
  const MasterProductTypeDBWidget({super.key, this.value, this.onChanged});
  final String? value;
  final void Function(String?)? onChanged;

  @override
  State<MasterProductTypeDBWidget> createState() =>
      _MasterProductTypeDBWidgetState();
}

class _MasterProductTypeDBWidgetState extends State<MasterProductTypeDBWidget> {
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
          List<ProductRecord> record = List.from(data.record!);
          record.insert(0, ProductRecord(productID: 0, productTypeName: 'All'));

          return data.status != 1
              ? Center(child: Text(data.message.toString()))
              : Container(
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
                    hint: Text(
                      'Select Product Type',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12.5,
                      ),
                    ),
                    value:
                        widget.value != null &&
                            (data.record!.any(
                              (r) => r.productID.toString() == widget.value,
                            ))
                        ? widget.value
                        : null,
                    items: record
                        .map(
                          (record) => DropdownMenuItem(
                            value: record.productID.toString(),
                            child: Text(record.productTypeName.toString()),
                          ),
                        )
                        .toList(),
                    onChanged: widget.onChanged,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Color(0xFF2D8FCF),
                          width: 1.5,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    isExpanded: true,
                    style: TextStyle(
                      color: ColourPalette.textFieldLabelColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    validator: (value) =>
                        value == null ? 'Please select product type' : null,
                  ),
                );
        } else if (state is MasterInProductTypeErrorStatus) {
          return SizedBox.shrink();
        }
        return SizedBox.shrink();
      },
    );
  }
}
