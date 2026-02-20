import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/widgets/labal_text.dart';
import 'package:indogrip/features/global/data/model/view_master_user_status_model.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';

final masterUserStatusProvider = FutureProvider<UserStatusModel>(
  (ref) => GlobalManagerRepository().masterUserStatus(),
);

class MasterUserStatus extends ConsumerStatefulWidget {
  MasterUserStatus({
    super.key,
    this.initialStatus,
    this.isShowLabel = true,
    this.isCustomized = true,
    required this.onChanged,
  });
  final void Function(String?) onChanged;
  String? initialStatus;
  final bool isShowLabel;
  final bool isCustomized;

  @override
  ConsumerState<MasterUserStatus> createState() => _MasterUserStatusState();
}

class _MasterUserStatusState extends ConsumerState<MasterUserStatus> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(masterUserStatusProvider);
    return provider.when(
      data: (data) {
        return data.status == 1
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  if (widget.isShowLabel) LabelText('Status'),
                  Container(
                    height: 37,
                    // margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: widget.isCustomized
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
                    child: DropdownButtonFormField(
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF2D8FCF),
                        size: 24,
                      ),
                      value:
                          widget.initialStatus != null &&
                              data.record!.any(
                                (item) =>
                                    item.mID.toString() == widget.initialStatus,
                              )
                          ? widget.initialStatus
                          : null,
                      isExpanded: true,
                      style: TextStyle(
                        color: ColourPalette.textFieldLabelColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      items: data.record!
                          .map(
                            (element) => DropdownMenuItem<String>(
                              value: element.mID.toString(),
                              child: Text(
                                element.mActiveStatus.toString(),
                                style: TextStyle(
                                  color: ColourPalette.textFieldLabelColor,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      decoration: widget.isCustomized
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
                          : InputDecoration(border: InputBorder.none),
                      hint: Text(
                        '-Select Status-',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                      onChanged: widget.onChanged,
                      dropdownColor: Colors.white,
                      elevation: 3,
                    ),
                  ),
                ],
              )
            : Center(
                child: data.message == null
                    ? Text(data.message.toString())
                    : SizedBox(
                        height: 35,

                        child: ElevatedButton.icon(
                          style:
                              ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: kButtonColor,
                                minimumSize: Size(
                                  MediaQuery.sizeOf(context).width * .23,
                                  60,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ).copyWith(
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color?>((
                                      Set<MaterialState> states,
                                    ) {
                                      if (states.contains(
                                        MaterialState.focused,
                                      )) {
                                        return Colors.white.withOpacity(0.2);
                                      }
                                      return null;
                                    }),
                              ),
                          onPressed: () {
                            ref.refresh(masterUserStatusProvider);
                          },
                          label: Text(
                            'Refresh',
                            style: TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          icon: Icon(Icons.refresh, size: 25),
                        ),
                      ),
              );
      },
      error: (error, stackTrace) => Container(color: Colors.red),
      loading: () =>
          Center(child: CircularProgressIndicator.adaptive(strokeWidth: 3)),
    );
  }
}
