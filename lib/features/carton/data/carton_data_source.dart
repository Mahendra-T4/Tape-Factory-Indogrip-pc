import 'package:flutter/material.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/features/carton/data/models/view_carton_model.dart';
import 'package:indogrip/features/global/presentation/widget/delete_record_button.dart';
import 'package:indogrip/features/global/presentation/widget/master_user_status.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Carton {
  static final String srNo = 'Sr No';
  static final String cartonType = 'Carton Type';
  static final String cartonTypeText = 'Carton Type Text';
  static final String date = 'Date';
  static final String quantity = 'Quantity';
  static final String billNo = 'Bill No';
  static final String companyName = 'Vendor Name';
}

class CartonDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<ViewCartonRecord> cartonData = [];
  bool isAllChecked;
  final Function(bool) onStatusChanged;
  final Function(bool, int) onCheckboxChanged;
  final Function(ViewCartonRecord) onEdit;
  final Function(ViewCartonRecord) onDelete;
  final Function(ViewCartonRecord) onProfile;
  final void Function(String?, ViewCartonRecord) onChanged;

  CartonDataSource({
    required this.cartonData,
    required this.isAllChecked,
    required this.onStatusChanged,
    required this.onCheckboxChanged,
    required this.onEdit,
    required this.onDelete,
    required this.onProfile,
    required this.onChanged,
  }) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = cartonData.asMap().entries.map<DataGridRow>((entry) {
      final data = entry.value;
      final index = entry.key;
      return DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: Carton.srNo,
            value: data.sNo.toString(),
          ),
          DataGridCell<String>(
            columnName: Carton.date,
            value: data.cartonDateText.toString(),
          ),
          DataGridCell<String>(
            columnName: Carton.billNo,
            value: data.cartonBillNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: Carton.companyName,
            value: data.companyName.toString(),
          ),

          // DataGridCell<String>(
          //   columnName: Carton.cartonType,
          //   value: data.cartonType.toString(),
          // ),
          DataGridCell<String>(
            columnName: Carton.cartonTypeText,
            value: data.cartonTypeText.toString(),
          ),

          DataGridCell<String>(
            columnName: Carton.quantity,
            value: data.cartonQuantity.toString(),
          ),

          // DataGridCell<Widget>(
          //   columnName: 'Status',
          //   value: MasterUserStatus(
          //     isShowLabel: false,
          //     isCustomized: false,
          //     onChanged: (value) {
          //       onChanged.call(value, data);
          //     },
          //     initialStatus: data.rStatus.toString(),
          //   ),
          // ),
          if (HiveService.getRole() != '2')
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
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'Status') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: cell.value as Widget,
          );
        }
        if (cell.columnName == 'actions') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: cell.value as Widget,
          );
        }
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SelectableText(
            cell.value?.toString() ?? '',
            maxLines: 1,
            toolbarOptions: const ToolbarOptions(copy: true, selectAll: true),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(ViewCartonRecord carton) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 120),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // if (HiveService.getRole() != '2')
          // if (HiveService.getRole() != '2')
          SizedBox(
            width: 35,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.edit, size: 18),
              onPressed: () => onEdit(carton),
              constraints: const BoxConstraints(),
            ),
          ),
          // SizedBox(
          //   width: 35,
          //   child: DeleteRecordButton(
          //     rKey: carton.rKey.toString(),
          //     rPanel: 'view-carton',
          //     item: cartonData,
          //     index: cartonData.indexOf(carton),
          //     onPressed: () => onDelete(carton),
          //   ),
          // ),
          // if (HiveService.getRole() != '2')

          // SizedBox(
          //   width: 35,
          //   child: IconButton(
          //     padding: EdgeInsets.zero,
          //     icon: const Icon(Icons.person, size: 18),
          //     onPressed: () => onProfile(carton),
          //     constraints: const BoxConstraints(),
          //   ),
          // ),
        ],
      ),
    );
  }
}
