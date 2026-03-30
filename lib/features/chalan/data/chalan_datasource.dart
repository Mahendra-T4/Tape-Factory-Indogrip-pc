import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:indogrip/Assets/assets.dart';
import 'package:indogrip/features/chalan/data/model/chalanlist_model.dart';
import 'package:indogrip/features/core/data/models/view_core_model.dart';

import 'package:indogrip/features/global/presentation/widget/master_user_status.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Chalan {
  static final String srNo = 'Sr No';
  static final String challanNumber = 'Chalan No';
  static final String dateTime = 'Date';
  static final String cCode = 'Client';
  static final String cConsigneeName = 'Consignee Name';
  static final String unitName = 'Unit Name';
  static final String name = 'Staff Name';

  // static final String billNo = 'Bill No';
  // static final String companyName = 'Company Name';
}

class ChalanDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<ChalanRecord> chalanData = [];
  bool isAllChecked;
  int? highlightedRowIndex;
  final Function(bool) onStatusChanged;
  final Function(bool, int) onCheckboxChanged;
  // final Function(ChalanRecord) onEdit;
  // final Function(ChalanRecord) onDelete;
  final Function(ChalanRecord) onProfile;
  final void Function(String?, ChalanRecord) onChanged;

  ChalanDataSource({
    required this.chalanData,
    required this.isAllChecked,
    this.highlightedRowIndex,
    required this.onStatusChanged,
    required this.onCheckboxChanged,
    // required this.onEdit,
    // required this.onDelete,
    required this.onProfile,
    required this.onChanged,
  }) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = chalanData.asMap().entries.map<DataGridRow>((entry) {
      final data = entry.value;
      // final index = entry.key;
      return DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: Chalan.srNo,
            value: data.sNo.toString(),
          ),
          DataGridCell<String>(
            columnName: Chalan.challanNumber,
            value: data.challanNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: Chalan.dateTime,
            value: data.dateTime.toString(),
          ),
          DataGridCell<String>(
            columnName: Chalan.cCode,
            value: data.clientInformation?.cCode.toString(),
          ),
          DataGridCell<String>(
            columnName: Chalan.cConsigneeName,
            value: data.clientInformation?.cConsigneeName.toString(),
          ),
          DataGridCell<String>(
            columnName: Chalan.unitName,
            value: data.clientInformation?.unitName.toString(),
          ),
          DataGridCell<String>(
            columnName: Chalan.name,
            value:
                '${data.staffInformation?.uFirstName} ${data.staffInformation?.uLastName}',
          ),

          // DataGridCell<String>(
          //   columnName: Chalan.cConsigneeName,
          //   value: data..toString(),
          // ),

          // DataGridCell<Widget>(
          //   columnName: 'Status',
          //   value: MasterUserStatus(
          //     isShowLabel: false,
          //     isCustomized: false,
          //     onChanged: (value) {
          //       onChanged.call(value, data);
          //     },
          //     initialStatus: data.rStatus?.toString() ?? '1',
          //   ),
          // ),
          DataGridCell<Widget>(
            columnName: 'actions',
            value: _buildActionButtons(data),
          ),
        ],
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final rowIndex = dataGridRows.indexOf(row);
    final isHighlighted = highlightedRowIndex == rowIndex;
    Color? rowBackgroundColor;

    if (isHighlighted) {
      rowBackgroundColor = Colors.deepPurple.withOpacity(0.2);
    }

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'actions') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            color: rowBackgroundColor,
            child: cell.value as Widget,
          );
        }
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: rowBackgroundColor,
          child: SelectableText(
            cell.value?.toString() ?? '',
            maxLines: 1,
            toolbarOptions: const ToolbarOptions(copy: true, selectAll: true),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(ChalanRecord chalan) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 120),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(
          //   width: 35,
          //   child: IconButton(
          //     padding: EdgeInsets.zero,
          //     icon: const Icon(Icons.edit, size: 18),
          //     onPressed: () => onEdit(core),
          //     constraints: const BoxConstraints(),
          //   ),
          // ),
          // SizedBox(
          //   width: 35,
          //   child: DeleteRecordButton(
          //     rKey: core.rKey.toString(),
          //     rPanel: 'view-core',
          //     item: coreData,
          //     index: coreData.indexOf(core),
          //     onPressed: () => onDelete(core),
          //   ),
          // ),
          SizedBox(
            width: 35,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: SvgPicture.asset(
                Assets.assetsImagesChalanInvoiceIcon,
                height: 22,
                width: 22,
              ),
              onPressed: () => onProfile(chalan),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
