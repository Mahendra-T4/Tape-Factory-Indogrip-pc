// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:indogrip/core/utils/widgets/text_field.dart';

import 'package:indogrip/features/jumbo%20roll/data/models/view_width_model.dart';
import 'package:indogrip/features/jumbo%20roll/demain/repositories/master_repo.dart';

final masterWidthProvider = FutureProvider<ViewWidthModel>(
  (ref) => MasterRepository.viewMasterWidth(),
);

class EWidthDropdownWidget extends ConsumerWidget {
  final String? value;
  final String? rKey;
  final void Function(String?) onChanged;
  const EWidthDropdownWidget({
    Key? key,
    this.value,
    required this.onChanged,
    this.rKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widthProvider = ref.watch(masterWidthProvider);
    return widthProvider.when(
      data: (data) => data.status != 1
          ? Center(child: Text(data.message ?? 'Refresh to load data'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldlabelText('Width'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: value == null
                      ? null
                      : data.record
                            ?.where(
                              (record) => record.mWidthName.toString() == value,
                            )
                            .firstOrNull
                            ?.mWidthId
                            ?.toString(),
                  items:
                      data.record
                          ?.map(
                            (record) => DropdownMenuItem(
                              value: record.mWidthId.toString(),
                              child: Text(record.mWidthName.toString()),
                            ),
                          )
                          .toList() ??
                      [],
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) =>
                      value == null ? 'Please select Width' : null,
                ),
              ],
            ),
      error: (error, stackTrace) {
        return Text('Error: $error', style: TextStyle(color: Colors.red));
      },
      loading: () {
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
