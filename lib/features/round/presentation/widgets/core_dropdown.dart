import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/round/data/models/core_list_model.dart';
import 'package:indogrip/features/round/domain/repositories/add_round_repo.dart';

final coreListProvider = FutureProvider<CoreListModel>(
  (ref) => AddRoundRepository().fetchCoreList(),
);

class CoreDropdown extends ConsumerWidget {
  final String? selectedCore;
  final Function(String?) onChanged;
  final bool isFilter;
  final double? size;

  const CoreDropdown({
    Key? key,
    this.isFilter = false,
    this.size,
    required this.selectedCore,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masterRollSizePro = ref.watch(coreListProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Core*",
          style: TextStyle(
            color: Color(0xFF3D475C),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        masterRollSizePro.when(
          data: (data) => data.status != 1
              ? Center(
                  child: Text(
                    data.message ?? 'Refresh to load data',
                    style: const TextStyle(
                      color: Color(0xFF3D475C),
                      fontSize: 14,
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: size ?? 68,
                  decoration: isFilter
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
                    value:
                        selectedCore != null &&
                            (data.record?.any(
                                  (r) => r.mCoreId.toString() == selectedCore,
                                ) ??
                                false)
                        ? selectedCore
                        : null,
                    isExpanded: true,
                    decoration: isFilter
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
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Color(0xFF9499A1),
                              ),
                            ),
                          ),
                    hint: const Text("Select Core"),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFF2D8FCF),
                      size: 24,
                    ),
                    items: data.record!.map((role) {
                      return DropdownMenuItem<String>(
                        value: role.mCoreId.toString(), // Convert ID to String
                        child: Text(
                          role.mCoreName.toString(),
                          style: const TextStyle(
                            color: Color(0xFF3D475C),
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: onChanged,
                    style: isFilter
                        ? TextStyle(
                            color: ColourPalette.textFieldLabelColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          )
                        : null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a Size";
                      }
                      return null;
                    },
                  ),
                ),
          error: (error, stackTrace) {
            ToastService.instance.showError(context, error.toString());
            return SizedBox.shrink();
          },
          loading: () {
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}
