import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indogrip/features/round/data/models/show_model.dart';
import 'package:indogrip/features/round/domain/repositories/add_round_repo.dart';
import 'package:indogrip/features/round/presentation/bloc/round_bloc.dart';

final showProvider = FutureProvider<ShowModel>((ref) {
  return AddRoundRepository().showLengthWidth();
});

class ShowWidget extends StatefulWidget {
  final String? value;
  final Function(String?) onChanged;

  const ShowWidget({Key? key, required this.value, required this.onChanged})
    : super(key: key);

  @override
  State<ShowWidget> createState() => _ShowWidgetState();
}

class _ShowWidgetState extends State<ShowWidget> {
  late final RoundBloc roundBloc;
  @override
  void initState() {
    super.initState();
    roundBloc = RoundBloc(addRoundRepository: AddRoundRepository());
    roundBloc.add(FetchShowForGetterEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(10),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Show',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),

          showForDropdownWidget,
        ],
      ),
    );
  }

  Widget get showForDropdownWidget => BlocBuilder(
    bloc: roundBloc,
    builder: (context, state) {
      switch (state.runtimeType) {
        case const (RoundLoadingStatus):
          return Center(child: CircularProgressIndicator());
        case const (ShowForGetterLoadedSuccessStatus):
          final data = (state as ShowForGetterLoadedSuccessStatus).model;
          return data.status == 1
              ? Container(
                  // margin: const EdgeInsets.only(top: 10),
                  child: DropdownButtonFormField<String>(
                    value:
                        widget.value != null &&
                            (data.record!.any(
                              (r) => r.showForID.toString() == widget.value,
                            ))
                        ? widget.value
                        : null,
                    items: data.record!
                        .map(
                          (record) => DropdownMenuItem(
                            value: record.showForID.toString(),
                            child: Text(record.showForLabel.toString()),
                          ),
                        )
                        .toList(),

                    onChanged: widget.onChanged,
                    hint: Text('-Select Panel-'),
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) =>
                        value == null ? 'Please select City' : null,
                  ),
                )
              : Text(
                  data.message ?? 'No response from server',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.red.shade700,
                  ),
                );
        case const (ShowForGetterErrorFailedStatus):
          return SizedBox.shrink();
        default:
          return SizedBox.shrink();
      }
    },
  );
}
