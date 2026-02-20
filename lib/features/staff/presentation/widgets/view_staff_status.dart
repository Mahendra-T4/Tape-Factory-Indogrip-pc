import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/widgets/labal_text.dart';
import 'package:indogrip/features/staff/data/models/view_staff_master_model.dart';
import 'package:indogrip/features/staff/domain/repositories/staff_repo.dart';

final viewStaffStatus1Provider = FutureProvider<ViewStaffMasterEntity>((ref) {
  return StaffRepository.viewStaffMasterList();
});

class ViewStaffMasterStatus extends ConsumerWidget {
  ViewStaffMasterStatus({
    super.key,
    required this.value,
    required this.onChanged,
  });
  final String value;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(viewStaffStatus1Provider);
    return provider.when(
      data: (data) {
        return data.status == 1
            ? Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelText('Status'),
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
                      value:
                          value != '' &&
                              (data.record?.any(
                                    (r) => r.mID.toString() == value,
                                  ) ??
                                  false)
                          ? value
                          : null,
                      items:
                          data.record
                              ?.map(
                                (record) => DropdownMenuItem(
                                  value: record.mID.toString(),
                                  child: Text(record.userStatus ?? ''),
                                ),
                              )
                              .toList() ??
                          [],
                      onChanged: (newValue) => onChanged(newValue),
                      hint: Text('-Select Status-'),
                      isExpanded: true,
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

                      validator: (value) =>
                          value == null ? 'Please select Status' : null,
                    ),
                  ),
                ],
              )
            : Center(
                child: data.message == null
                    ? Text(data.message.toString())
                    : SizedBox(
                        height: 40,
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
                            ref.refresh(viewStaffStatus1Provider);
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
      error: (error, stackTrace) => SizedBox.shrink(),
      loading: () => Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
