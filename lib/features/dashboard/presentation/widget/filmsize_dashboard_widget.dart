import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/features/outsource/presentation/state/bloc.master/master_in_bloc.dart';

class MasterStretchFilmDashboardWidget extends StatefulWidget {
  const MasterStretchFilmDashboardWidget({super.key});

  @override
  State<MasterStretchFilmDashboardWidget> createState() =>
      _MasterStretchFilmDashboardWidgetState();
}

class _MasterStretchFilmDashboardWidgetState
    extends State<MasterStretchFilmDashboardWidget> {
  late final MasterInBloc masterInBloc;
  @override
  void initState() {
    masterInBloc = MasterInBloc();
    masterInBloc.add(LoadMasterInStretchFilmEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: masterInBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is MasterInLoadingStatus) {
          return Center(child: CircularProgressIndicator());
        } else if (state is MasterInStretchFilmLoadedStatus) {
          final data = state.model;
          return Column(
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
                        'Film Size',
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
                      border: Border.all(color: Colors.grey[200]!, width: 0.5),
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
                            item.stretchFilmSize.toString(),
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
        } else if (state is MasterInStretchFilmErrorStatus) {
          return SizedBox.shrink();
        }
        return SizedBox.shrink();
      },
    );
  }
}
