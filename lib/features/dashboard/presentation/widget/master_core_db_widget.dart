import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/dashboard/presentation/bloc/home_bloc.dart';
import 'package:indogrip/features/round/data/models/core_list_model.dart';
import 'package:indogrip/features/round/domain/repositories/add_round_repo.dart';

class CoreDropdownDB extends StatefulWidget {
  const CoreDropdownDB({Key? key}) : super(key: key);

  @override
  State<CoreDropdownDB> createState() => _CoreDropdownDBState();
}

class _CoreDropdownDBState extends State<CoreDropdownDB> {
  late final HomeBloc homeBloc;
  @override
  void initState() {
    super.initState();
    homeBloc = HomeBloc();
    homeBloc.add(FetchCoreListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: homeBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingStatus:
            return const Center(child: CircularProgressIndicator());
          case CoreListSuccessStatus:
            final data = (state as CoreListSuccessStatus).coreListModel;
            return data.status != 1
                ? Center(
                    child: Text(
                      data.message ?? 'No response from server',
                      style: const TextStyle(
                        color: Color(0xFF3D475C),
                        fontSize: 14,
                      ),
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
                                'Core Name',
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
                                'Core Stock',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF9B59B6),
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Core Code',
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
                                    item.mCoreName.toString(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2C3E50),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    item.coreStock.toString(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2C3E50),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    item.mCoreCode.toString(),
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
                  );
          case CoreListErrorStatus:
            final coreListState = (state as CoreListErrorStatus).message;

            return Center(
              child: Text(
                coreListState.toString(),
                style: const TextStyle(color: Color(0xFF3D475C), fontSize: 14),
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
