import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/bloc/jumbo_roll_bloc.dart';

class MicronDashboard extends StatefulWidget {
  const MicronDashboard({super.key});

  @override
  State<MicronDashboard> createState() => _MicronDashboardState();
}

class _MicronDashboardState extends State<MicronDashboard> {
  late final JumboRollBloc _jumboRollBloc;
  @override
  void initState() {
    super.initState();
    _jumboRollBloc = JumboRollBloc();
    _jumboRollBloc.add(LoadMasterJumboMicronEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _jumboRollBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case JumboRollLoadingStatus:
            return const Center(child: CircularProgressIndicator());
          case MasterJumboMicronLoadedSuccessState:
            final data = (state as MasterJumboMicronLoadedSuccessState).model;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9B59B6).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Sr. NO.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF9B59B6),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Micron',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF9B59B6),
                              letterSpacing: 0.5,
                            ),
                          ),
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
                        // mainAxisAlignment: Mai,
                        children: [
                          Expanded(
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                item.mMicName.toString(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          case MasterJumboMicronLoadedFailureState:
            final message =
                (state as MasterJumboMicronLoadedFailureState).errorMessage;
            return Center(child: Text('Error: $message'));
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
