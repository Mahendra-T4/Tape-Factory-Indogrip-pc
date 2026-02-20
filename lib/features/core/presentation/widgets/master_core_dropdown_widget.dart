import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/carton/data/models/master_carton_type_model.dart';
import 'package:indogrip/features/carton/domain/repositories/carton_repo.dart';
import 'package:indogrip/features/core/data/models/master_core_model.dart';
import 'package:indogrip/features/core/domain/repositories/core_repo.dart';

final masterCoreTypeProvider = FutureProvider<MasterCoreModel>(
  (ref) => CoreRepository.masterCoreType(),
);

class MasterCoreTypeDropDown extends ConsumerWidget {
  final String? selectCoreType;
  final Function(String?) onChanged;

  const MasterCoreTypeDropDown({
    Key? key,
    required this.selectCoreType,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masterCoreProvider = ref.watch(masterCoreTypeProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Core Type*",
          style: TextStyle(
            color: Color(0xFF3D475C),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        masterCoreProvider.when(
          data: (data) => data.status != 1
              ? Center(child: Text(data.message ?? 'No response from server'))
              : Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: DropdownButtonFormField<String>(
                    value: selectCoreType,
                    isExpanded: true,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Color(0xFF9499A1)),
                      ),
                    ),
                    hint: const Text("Select Core Type"),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a Core";
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
