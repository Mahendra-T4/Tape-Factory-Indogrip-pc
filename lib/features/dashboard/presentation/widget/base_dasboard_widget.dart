// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/view_base_model.dart';
import 'package:indogrip/features/jumbo%20roll/demain/repositories/master_repo.dart';

final masterBaseProvider = FutureProvider<ViewBaseModel>(
  (ref) => MasterRepository.viewMasterBase(),
);

class BaseDashboardWidget extends ConsumerWidget {
  const BaseDashboardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masterBasePro = ref.watch(masterBaseProvider);

    return masterBasePro.when(
      data: (data) => data.status != 1
          ? Center(
              child: Text(
                data.message ?? 'No response from server',
                style: const TextStyle(color: Color(0xFF3D475C), fontSize: 14),
              ),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9B59B6).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'SR.No.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF9B59B6),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Base Type',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF9B59B6),
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.record?.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = data.record![index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: index.isEven
                            ? const Color(0xFF9B59B6).withOpacity(0.03)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[200]!,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item.mBaseName.toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2C3E50),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
      error: (error, stackTrace) {
        ToastService.instance.showError(context, error.toString());
        return SizedBox.shrink();
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
