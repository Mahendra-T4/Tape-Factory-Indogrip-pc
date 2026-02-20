// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:indogrip/features/vendor/presentation/bloc/vendor_bloc.dart';

// final masterVendorProvider =
//     FutureProvider.family<ViewVendorModel, ViewRecordApiParam>(
//       (ref, param) => ViewVendorRepository.viewVendorsRecords(param: param),
//     );

class VendorListWidget extends StatefulWidget {
  final String? value;
  final void Function(String?) onChanged;
  final bool isFilter;
  const VendorListWidget({
    Key? key,
    this.value,
    this.isFilter = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<VendorListWidget> createState() => _VendorListWidgetState();
}

class _VendorListWidgetState extends State<VendorListWidget> {
  late final VendorBloc _vendorBloc;

  @override
  void initState() {
    super.initState();
    _vendorBloc = VendorBloc();
    _vendorBloc.add(
      ViewVendorRecordsFetchingEvent(
        param: ViewRecordApiParam(
          filterBy: '1',
          // keyword: '',
          // orderBy: '',
          // pageNo: '',
          // sortBy: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _vendorBloc,
      builder: (context, state) {
        if (state is VendorLoadingStatus) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ViewVendorRecordsLoadedSuccessStatus) {
          final vendor = state.viewVendorModel.record;
          // final vendor = state.viewVendorModel.record?.map((e) {
          //   if (e.rStatus == 1) {
          //     return e;
          //   }
          // });
          return state.viewVendorModel.status != 1
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    TextFieldlabelText('Vendor*'),
                    Container(
                      // margin: const EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey.shade700),
                      ),
                      child: Center(
                        child: Text(
                          state.viewVendorModel.message ??
                              'No response from server',
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldlabelText('Vendor*'),
                    const SizedBox(height: 8),
                    Container(
                      height: widget.isFilter ? 37 : 51,
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
                        hint: Text('Select Vendor'),
                        style: widget.isFilter
                            ? TextStyle(
                                color: ColourPalette.textFieldLabelColor,
                                // fontSize: 13,
                                // fontWeight: FontWeight.w500,
                              )
                            : null,
                        value:
                            widget.value != null &&
                                (vendor?.any(
                                      (r) => r.rKey.toString() == widget.value,
                                    ) ??
                                    false)
                            ? widget.value
                            : null,
                        items:
                            vendor
                                ?.map(
                                  (record) => DropdownMenuItem(
                                    value: record.rKey.toString(),
                                    child: Text(
                                      record.vCompanyName ??
                                          'no active vendors',
                                    ),
                                  ),
                                )
                                .toList() ??
                            [],
                        onChanged: widget.onChanged,
                        isExpanded: true,
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
                            value == null ? 'Please select Vendor' : null,
                      ),
                    ),
                  ],
                );
        } else if (state is ViewVendorRecordsErrorStatus) {
          return SizedBox.shrink();
        }
        return SizedBox.shrink();
      },
    );
  }
}
