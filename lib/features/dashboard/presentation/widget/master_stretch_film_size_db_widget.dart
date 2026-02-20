import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/features/outsource/presentation/state/bloc.master/master_in_bloc.dart';

class MasterStretchFilmWidgetDB extends StatefulWidget {
  const MasterStretchFilmWidgetDB({super.key});

  @override
  State<MasterStretchFilmWidgetDB> createState() =>
      _MasterStretchFilmWidgetState();
}

class _MasterStretchFilmWidgetState extends State<MasterStretchFilmWidgetDB> {
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
          return Container(
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
                      'Stretch Film Sizes',
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
                          data.record![index].stretchFilmSize.toString(),
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
        } else if (state is MasterInStretchFilmErrorStatus) {
          return SizedBox.shrink();
        }
        return SizedBox.shrink();
      },
    );
  }
}
