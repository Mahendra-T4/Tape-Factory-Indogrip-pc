// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/features/carton/presentation/bloc/carton_bloc.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';

class MasterCarton extends StatefulWidget {
  final void Function(String?)? onChanged;
  final InputDecoration? decoration;
  final TextEditingController controller;
  final String selectedCarton;

  const MasterCarton({
    Key? key,
    this.decoration,
    required this.onChanged,
    required this.controller,
    required this.selectedCarton,
  }) : super(key: key);

  @override
  State<MasterCarton> createState() => _MasterJumboRollState();
}

class _MasterJumboRollState extends State<MasterCarton> {
  late CartonBloc cartonBloc;
  late TextEditingController searchController;
  List<dynamic> filteredRecords = [];
  bool showResults = false;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    cartonBloc = CartonBloc();
    cartonBloc.add(
      ViewCartonRecordEvent(
        param: ViewRecordApiParam(
          keyword: searchController.text,
          filterBy: '',
          orderBy: '',
          pageNo: '',
          sortBy: '500',
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterRecords(List<dynamic> records, String query) {
    if (query.isEmpty) {
      setState(() {
        filteredRecords = records;
        showResults = true;
      });
      return;
    }

    filteredRecords = records.where((record) {
      final searchText = query.toLowerCase();
      return (record.jRollNumber?.toString().toLowerCase().contains(
                searchText,
              ) ??
              false) ||
          (record.baseLabel?.toString().toLowerCase().contains(searchText) ??
              false) ||
          (record.micLabel?.toString().toLowerCase().contains(searchText) ??
              false) ||
          (record.jLength?.toString().toLowerCase().contains(searchText) ??
              false);
    }).toList();

    setState(() {
      showResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: cartonBloc,
      builder: (context, state) {
        if (state is CartonLoadingStatus) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is FetchViewCartonRecordSuccessStatus) {
          final data = state.viewCartonModel;
          return data.status != 1
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    const Text(
                      "Selected Carton*",
                      style: TextStyle(
                        color: Color(0xFF3D475C),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      height: 40,
                      // margin: const EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey.shade700),
                      ),
                      child: Center(
                        child: Text(data.message ?? 'Refresh to load data'),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Selected Carton*",
                      style: TextStyle(
                        color: Color(0xFF3D475C),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search TextField
                          TextField(
                            controller: searchController,
                            onTap: () {
                              if (searchController.text.isEmpty) {
                                setState(() {
                                  filteredRecords = data.record!;

                                  showResults = !showResults;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              hintText: "Search Carton....",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                  color: Color(0xFF9499A1),
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Color(0xFF2D8FCF),
                              ),
                              suffixIcon: searchController.text.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        searchController.clear();
                                        setState(() {
                                          filteredRecords = data.record!;
                                          showResults = true;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: Color(0xFF9499A1),
                                      ),
                                    )
                                  : null,
                            ),
                            onChanged: (value) {
                              filterRecords(data.record!, value);
                              setState(() {});
                            },
                          ),
                          // Results List
                          if (showResults && filteredRecords.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              constraints: const BoxConstraints(maxHeight: 300),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: filteredRecords.length,
                                itemBuilder: (context, index) {
                                  final record = filteredRecords[index];
                                  return InkWell(
                                    onTap: () {
                                      searchController.text =
                                          '${record.jRollNumber} , ${record.baseLabel} , ${record.micLabel} , ${record.jLength}(${record.availableLength})';
                                      widget.onChanged?.call(
                                        record.rKey.toString(),
                                      );
                                      setState(() {
                                        showResults = false;
                                        filteredRecords = [];
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${record.cartonTypeText}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF3D475C),
                                            ),
                                          ),
                                          if (index <
                                              filteredRecords.length - 1)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                              ),
                                              child: Divider(
                                                height: 1,
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          // No Results Message
                          if (showResults &&
                              filteredRecords.isEmpty &&
                              searchController.text.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                'No matching Carton found',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
        } else if (state is FetchViewCartonRecordFailureStatus) {
          return Center(child: Text(state.errorMessage.toString()));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
