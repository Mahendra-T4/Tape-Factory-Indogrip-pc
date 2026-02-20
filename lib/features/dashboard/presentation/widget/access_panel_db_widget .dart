// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/features/staff/presentation/bloc/staff_bloc.dart';

class AccessPanelDBWidget extends StatefulWidget {
  AccessPanelDBWidget({Key? key}) : super(key: key);

  @override
  State<AccessPanelDBWidget> createState() => _AccessPanelDBWidgetState();
}

class _AccessPanelDBWidgetState extends State<AccessPanelDBWidget> {
  late final StaffBloc _staffBloc;

  @override
  void initState() {
    super.initState();
    _staffBloc = StaffBloc();
    _staffBloc.add(LoadAccessPanelEvent());
    // _selectedSkills = List<String>.from(widget.selectedSkills);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _staffBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case StaffLoadingStatus:
            return const Center(child: CircularProgressIndicator());
          case AccessPanelLoadedSuccessState:
            final accessPanelState = state as AccessPanelLoadedSuccessState;
            final data = accessPanelState.accessPanel;
            return data.status == 1
                ? Container(
                    constraints: BoxConstraints(maxHeight: 450),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFF9B59B6).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.analytics_rounded,
                                color: Color(0xFF9B59B6),
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Access Panel',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10),
                        Container(
                          height: 350,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.record!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: index.isEven
                                      ? Color(0xFF9B59B6).withOpacity(0.03)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  data.record![index].mPanelName.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF2C3E50),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      data.message ?? 'No response from server',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
          case AccessPanelLoadedFailureState:
            final errorState = state as AccessPanelLoadedFailureState;
            return Center(
              child: Text(
                "Error loading access panel: ${errorState.error}",
                style: TextStyle(color: Colors.red),
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
