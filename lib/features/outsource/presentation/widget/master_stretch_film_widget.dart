import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/features/outsource/presentation/state/bloc.master/master_in_bloc.dart';

class MasterStretchFilmWidget extends StatefulWidget {
  const MasterStretchFilmWidget({
    super.key,
    this.value,
    this.onChanged,
    this.isFilter = false,
    this.size,
  });
  final String? value;
  final bool isFilter;
  final double? size;
  final void Function(String?)? onChanged;

  @override
  State<MasterStretchFilmWidget> createState() =>
      _MasterStretchFilmWidgetState();
}

class _MasterStretchFilmWidgetState extends State<MasterStretchFilmWidget> {
  late final MasterInBloc masterInBloc;
  @override
  void initState() {
    masterInBloc = MasterInBloc();
    masterInBloc.add(LoadMasterInStretchFilmEvent());
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
        } else if (state is MasterInStretchFilmLoadedStatus) {
          final data = state.model;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldlabelText('Film Size'),
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
                  hint: Text('Select StretchFilm'),
                  value:
                      widget.value != null &&
                          (data.record!.any(
                            (r) => r.mID.toString() == widget.value,
                          ))
                      ? widget.value
                      : null,
                  items:
                      data.record
                          ?.map(
                            (record) => DropdownMenuItem(
                              value: record.mID.toString(),
                              child: Text(record.stretchFilmSize.toString()),
                            ),
                          )
                          .toList() ??
                      [],
                  onChanged: widget.onChanged,
                  decoration: widget.isFilter
                      ? InputDecoration(
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
                        )
                      : InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                  isExpanded: true,
                  style: TextStyle(
                    color: ColourPalette.textFieldLabelColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) =>
                      value == null ? 'Please select stretch film' : null,
                ),
              ),
            ],
          );
        } else if (state is MasterInStretchFilmErrorStatus) {
          return SizedBox.shrink();
        }
        return SizedBox.shrink();
      },
    );
  }
}
