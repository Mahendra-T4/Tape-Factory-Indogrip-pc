// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/bloc/jumbo_roll_bloc.dart';

class WidthDropdownDBWidget extends StatefulWidget {
  const WidthDropdownDBWidget({Key? key}) : super(key: key);

  @override
  State<WidthDropdownDBWidget> createState() => _WidthDropdownWidgetState();
}

class _WidthDropdownWidgetState extends State<WidthDropdownDBWidget> {
  late final JumboRollBloc _jumboRollBloc;
  @override
  void initState() {
    super.initState();
    _jumboRollBloc = JumboRollBloc();
    _jumboRollBloc.add(LoadMasterJumboWidthEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _jumboRollBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case JumboRollLoadingStatus:
            return const Center(child: CircularProgressIndicator());
          case MasterJumboWidthLoadedSuccessState:
            final data = (state as MasterJumboWidthLoadedSuccessState).model;
            return data.status != 1
                ? Center(child: Text(data.message ?? 'Refresh to load data'))
                : Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    width: 450,
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
                                color: Colors.brown.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.width_full,
                                color: Colors.brown,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Jumbo Width',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          height: 358,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFF9B59B6).withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Width',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF9B59B6),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Available Pieces',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF9B59B6),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: data.record?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: buildCoreTypeRow2(
                                        data.record![index].mWidthName
                                            .toString(),
                                        data.record![index].availableLength
                                            .toString(),
                                        Color(0xFF9B59B6),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
          case MasterJumboWidthLoadedFailureState:
            final error =
                (state as MasterJumboWidthLoadedFailureState).errorMessage;
            return Text('Error: $error', style: TextStyle(color: Colors.red));
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget buildCoreTypeRow(
    String width,
    String availablePeceas,
    String length,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            width,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            availablePeceas,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            length,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCoreTypeRow2(String width, String availablePeceas, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            width,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            availablePeceas,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
