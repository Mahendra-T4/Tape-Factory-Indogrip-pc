import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';

class ReadUnreadMasterStatusWidget extends StatefulWidget {
  ReadUnreadMasterStatusWidget({
    super.key,
    required this.onChanged,
    this.initialStatus,
  });
  final void Function(String?) onChanged;
  String? initialStatus;

  @override
  State<ReadUnreadMasterStatusWidget> createState() =>
      _ReadUnreadMasterStatusWidgetState();
}

class _ReadUnreadMasterStatusWidgetState
    extends State<ReadUnreadMasterStatusWidget> {
  late final GlobalBloc _globalBloc;

  @override
  void initState() {
    super.initState();
    _globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    _globalBloc.add(ReadUnReadNotificationMasterStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _globalBloc,
      listener: (context, state) {
        if (state is ReadUnReadNotificationMasterStatusErrorStatus) {
          ToastService.instance.showError(context, state.message.toString());
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case GlobalLoadingStatus:
            return Center(child: CircularProgressIndicator());
          case ReadUnReadNotificationMasterStatusSuccessStatus:
            final status =
                (state as ReadUnReadNotificationMasterStatusSuccessStatus)
                    .model;
            return Container(
              height: 37,
              // margin: const EdgeInsets.symmetric(horizontal: 2),
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
              child: DropdownButtonFormField(
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF2D8FCF),
                  size: 24,
                ),
                value:
                    widget.initialStatus != null &&
                        status.record!.any(
                          (item) =>
                              item.readUnreadID.toString() ==
                              widget.initialStatus,
                        )
                    ? widget.initialStatus
                    : null,
                isExpanded: true,
                style: TextStyle(
                  color: ColourPalette.textFieldLabelColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                items: status.record!
                    .map(
                      (element) => DropdownMenuItem<String>(
                        value: element.readUnreadID.toString(),
                        child: Text(
                          element.readUnreadName.toString(),
                          style: TextStyle(
                            color: ColourPalette.textFieldLabelColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                    .toList(),
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
                hint: Text(
                  '-Select Status-',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
                onChanged: widget.onChanged,
                dropdownColor: Colors.white,
                elevation: 3,
              ),
            );
          case FetchMasterStockStatusFailedStatus:
            return SizedBox.shrink();
          default:
            return SizedBox.shrink();
        }
      },
    );
  }
}
