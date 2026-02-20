import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/features/outsource/presentation/state/bloc.master/master_in_bloc.dart';

class MasterProductTypeWidgetDB extends StatefulWidget {
  const MasterProductTypeWidgetDB({super.key});

  @override
  State<MasterProductTypeWidgetDB> createState() =>
      _MasterStretchFilmWidgetState();
}

class _MasterStretchFilmWidgetState extends State<MasterProductTypeWidgetDB> {
  late final MasterInBloc masterInBloc;
  @override
  void initState() {
    masterInBloc = MasterInBloc();
    masterInBloc.add(LoadMasterInProductTypeEvent());
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
        } else if (state is MasterInProductTypeLoadedStatus) {
          final data = state.model;
          return data.status != 1
              ? Center(child: Text(data.message.toString()))
              : Container(
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
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.production_quantity_limits_sharp,
                              color: Colors.green,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Product Types',
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
                                data.record![index].productTypeName.toString(),
                                Colors.green.withOpacity(.6),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
        } else if (state is MasterInProductTypeErrorStatus) {
          return SizedBox.shrink();
        }
        return SizedBox.shrink();
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
