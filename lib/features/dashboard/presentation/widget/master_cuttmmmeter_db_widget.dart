import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/features/round/domain/repositories/add_round_repo.dart';
import 'package:indogrip/features/round/presentation/bloc/round_bloc.dart';

// final masterRollSizeProvider = FutureProvider<MasterRollSizeEntity>(
//   (ref) => AddRoundRepository().masterRollSize(),
// );

class MasterRoleSizeDBSelector extends StatefulWidget {
  const MasterRoleSizeDBSelector({Key? key}) : super(key: key);

  @override
  State<MasterRoleSizeDBSelector> createState() =>
      _MasterRoleSizeSelectorState();
}

class _MasterRoleSizeSelectorState extends State<MasterRoleSizeDBSelector> {
  late final RoundBloc _roundBloc;
  @override
  void initState() {
    super.initState();
    _roundBloc = RoundBloc(addRoundRepository: AddRoundRepository());
    _roundBloc.add(FetchMasterRollSizeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _roundBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case RoundLoadingStatus:
            return const Center(child: CircularProgressIndicator());
          case MasterRollSizeLoadedSuccessStatus:
            final data = (state as MasterRollSizeLoadedSuccessStatus).model;
            return data.status == 1
                ? Column(
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
                                'CutMMMeter',
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
                                'CartonPerPiece',
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
                                    item.cutMmMeter.toString(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2C3E50),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    item.piecesPerCarton.toString(),
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
                  )
                : Center(
                    child: Text(
                      data.message ?? 'No response from server',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
          case MasterRollSizeErrorFailedStatus:
            return SizedBox.shrink();
          default:
            return SizedBox.shrink();
        }
      },
    );
  }
}
