// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/bloc/jumbo_roll_bloc.dart';

class BaseDBWidget extends StatefulWidget {
  BaseDBWidget({Key? key}) : super(key: key);

  @override
  State<BaseDBWidget> createState() => _BaseDBWidgetState();
}

class _BaseDBWidgetState extends State<BaseDBWidget> {
  late final JumboRollBloc _jumboRollBloc;

  @override
  void initState() {
    super.initState();
    _jumboRollBloc = JumboRollBloc();
    _jumboRollBloc.add(LoadMasterJumboBaseEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _jumboRollBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case JumboRollLoadingStatus:
            return const Center(child: CircularProgressIndicator());
          case MasterJumboBaseLoadedSuccessState:
            final data = (state as MasterJumboBaseLoadedSuccessState).model;
            return data.status != 1
                ? Center(child: Text(data.message ?? 'No response from server'))
                : Container(
                    constraints: BoxConstraints(maxHeight: 450),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          spreadRadius: 0,
                          blurRadius: 16,
                          offset: const Offset(0, 4),
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
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xFFA78BFA).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.analytics_rounded,
                                color: Color(0xFFA78BFA),
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Base',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1F2937),
                                letterSpacing: 0.2,
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
                                  data.record![index].mBaseName.toString(),
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
                  );
          case MasterJumboBaseLoadedFailureState:
            final errorMessage =
                (state as MasterJumboBaseLoadedFailureState).errorMessage;
            return Text(
              'Error: $errorMessage',
              style: TextStyle(color: Colors.red),
            );

          default:
            return const SizedBox();
        }
      },
    );
  }
}
