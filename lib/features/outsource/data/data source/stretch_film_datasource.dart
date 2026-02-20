import 'package:flutter/material.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/features/global/presentation/widget/master_user_status.dart';
import 'package:indogrip/features/outsource/data/model/view_stretchfilm_model.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class StretchFilm {
  static final String srNo = 'Sr No';
  static final String productType = 'Product Type';
  static final String date = 'Date';
  static final String vendorName = 'Vendor Name';
  static final String billDate = 'Bill Date';
  static final String cartonPrice = 'Carton Price';
  static final String transportPrice = 'Transport Price';
  static final String actualPrice = 'Actual Price';
  static final String totalPrice = 'Total Price';
  static final String filmSize = 'Film Size';
  static final String core = 'Core';
  static final String netWeight = 'Net Weight';
  static final String grossWeight = 'Gross Weight';
  static final String remark = 'Remark';

  static final String billNumber = 'Bill Number';

  static final String quantity = 'Quantity';

  static final String stretchFilmSize = 'Stretch Film Size';

  static final String vendorCode = 'Vendor Code';
  static final String companyName = 'Company Name';
  static final String inventoryCode = 'Serial Number';
  static final String inventoryStatusLabel = 'Inventory Status';
}

class StretchFilmDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<StretchRecord> stretchData = [];
  bool isAllChecked;
  final Function(bool) onStatusChanged;
  final Function(bool, int) onCheckboxChanged;
  final Function(StretchRecord) onEdit;
  final Function(StretchRecord) printLabel;
  // final Function() onDelete;
  // final Function() onProfile;
  final void Function(String?, StretchRecord) onChanged;

  StretchFilmDataSource({
    required this.stretchData,
    required this.isAllChecked,
    required this.onStatusChanged,
    required this.onCheckboxChanged,
    required this.onEdit,
    required this.printLabel,
    // required this.onProfile,
    required this.onChanged,
  }) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = stretchData.asMap().entries.map<DataGridRow>((entry) {
      final data = entry.value;
      // final index = entry.key;
      return DataGridRow(
        cells: [
          // 1. S. No.
          DataGridCell<String>(
            columnName: StretchFilm.srNo,
            value: data.sNo.toString(),
          ),
          // 2. Serial Number
          DataGridCell<String>(
            columnName: StretchFilm.inventoryCode,
            value: data.inventoryCode ?? '',
          ),
          // 3. Date
          DataGridCell<String>(
            columnName: StretchFilm.date,
            value: data.recordDate ?? '',
          ),
          // 4. Vendor Name
          DataGridCell<String>(
            columnName: StretchFilm.companyName,
            value: data.vendorInfo?.companyName ?? '',
          ),
          // 5. Bill Date
          DataGridCell<String>(
            columnName: StretchFilm.billDate,
            value: data.billDate ?? '',
          ),
          // 6. Bill Number
          DataGridCell<String>(
            columnName: StretchFilm.billNumber,
            value: data.billNumber ?? '',
          ),
          // 7. Gross Weight
          DataGridCell<String>(
            columnName: 'grossWeight',
            value: data.additionalInfo?.grossWeight?.toString() ?? '',
          ),
          // 8. Net Weight
          DataGridCell<String>(
            columnName: StretchFilm.netWeight,
            value: data.additionalInfo?.netWeight?.toString() ?? '',
          ),
          // 9. Difference
          DataGridCell<String>(
            columnName: 'difference',
            value: data.additionalInfo?.difference?.toString() ?? '',
          ),
          // 10. Less KG
          DataGridCell<String>(
            columnName: 'lessWeight',
            value: data.additionalInfo?.lessWeight?.toString() ?? '',
          ),
          // 11. Actual Weight
          DataGridCell<String>(
            columnName: 'actualWeight',
            value: data.additionalInfo?.actualWeight?.toString() ?? '',
          ),
          // 12. Film Size
          DataGridCell<String>(
            columnName: StretchFilm.filmSize,
            value: data.additionalInfo?.stretchFilmSize?.toString() ?? '',
          ),
          // 13. Core
          DataGridCell<String>(
            columnName: StretchFilm.core,
            value: data.additionalInfo?.coreLabel?.toString() ?? '',
          ),
          // 14. MIC
          DataGridCell<String>(
            columnName: 'mic',
            value: data.additionalInfo?.micLabel?.toString() ?? '',
          ),
          // 15. Base
          DataGridCell<String>(
            columnName: 'base',
            value: data.additionalInfo?.baseLabel?.toString() ?? '',
          ),
          // 16. Total Price (Carton Price)
          DataGridCell<String>(
            columnName: StretchFilm.cartonPrice,
            value: data.cartonPrice?.toString() ?? '',
          ),
          // 17. Transportation Price
          DataGridCell<String>(
            columnName: StretchFilm.transportPrice,
            value: data.transportPrice?.toString() ?? '',
          ),
          // 18. Actual Price
          DataGridCell<String>(
            columnName: StretchFilm.actualPrice,
            value: data.actualPrice?.toString() ?? '',
          ),
          // 19. Per KG Price
          DataGridCell<String>(
            columnName: 'perKGPrice',
            value: data.additionalInfo?.perKGPrice?.toString() ?? '',
          ),
          // 20. Margin
          DataGridCell<String>(
            columnName: 'margin',
            value: data.additionalInfo?.margin?.toString() ?? '',
          ),
          // 21. MRP
          // DataGridCell<String>(
          //   columnName: 'mrp',
          //   value: data.batchInformation?.batchMRP?.toString() ?? '',
          // ),
          // 22. Remarks
          DataGridCell<String>(
            columnName: StretchFilm.remark,
            value: data.remark ?? '',
          ),
          // 23. Inventory Status
          DataGridCell<String>(
            columnName: StretchFilm.inventoryStatusLabel,
            value: data.inventoryStatusLabel ?? '',
          ),
          // 23. Actions
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
    Color? rowBackgroundColor;
    try {
      final statusCell = row.getCells().firstWhere(
        (cell) => cell.columnName == StretchFilm.inventoryStatusLabel,
      );
      final statusText = statusCell.value?.toString().toLowerCase() ?? '';
      if (statusText.contains('out')) {
        rowBackgroundColor = Colors.red;
      } else if (statusText.contains('in')) {
        rowBackgroundColor = Colors.white;
      }
    } catch (e) {
      rowBackgroundColor = null;
    }

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == StretchFilm.inventoryStatusLabel) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            color: rowBackgroundColor,
            child: cell.value is Widget
                ? cell.value as Widget
                : Text(cell.value.toString(), overflow: TextOverflow.ellipsis),
          );
        }

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

  Widget _buildActionButtons(StretchRecord stretch) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 120),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (HiveService.getRole() != '2')
            SizedBox(
              width: 40,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () => onEdit(stretch),
                constraints: const BoxConstraints(),
              ),
            ),
          SizedBox(
            width: 40,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.label, size: 18),
              onPressed: () => printLabel(stretch),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
