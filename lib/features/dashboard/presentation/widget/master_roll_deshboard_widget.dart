import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/staff/presentation/bloc/staff_bloc.dart';

class MasterRollWidget extends StatefulWidget {
  const MasterRollWidget({super.key});

  @override
  State<MasterRollWidget> createState() => _MasterRollWidgetState();
}

class _MasterRollWidgetState extends State<MasterRollWidget> {
  late final StaffBloc _staffBloc;
  @override
  void initState() {
    super.initState();
    _staffBloc = StaffBloc();
    _staffBloc.add(LoadUserMasterRollEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _staffBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case StaffLoadingStatus:
            return const Center(child: CircularProgressIndicator());
          case MasterUserRollLoadedSuccessState:
            final masterRollState = state as MasterUserRollLoadedSuccessState;
            final data = masterRollState.masterRoll;
            return data.status == 1
                ? Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    // width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.deepPurpleAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.deepPurpleAccent,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Roll',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            itemCount: data.record?.length ?? 0,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: buildCoreTypeRow(
                                  data.record![index].mUserRoleName ?? '',
                                  Colors.deepPurpleAccent.withOpacity(.6),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 23),
                      child: Text(
                        data.message ?? 'No response from server',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
          case MasterUserRollLoadedFailureState:
            final errorState = state as MasterUserRollLoadedFailureState;
            ToastService.instance.showError(context, errorState.error);
            return const SizedBox.shrink();
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget buildCoreTypeRow(String value, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
