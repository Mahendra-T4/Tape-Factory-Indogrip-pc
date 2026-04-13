import 'package:flutter/material.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/utils/widgets/delete_alert.dart';
import 'package:indogrip/features/global/presentation/widget/delete_record_button.dart';
import 'package:indogrip/features/global/presentation/widget/master_user_status.dart';
import 'package:indogrip/features/staff/presentation/widgets/view_staff_master_dropdown.dart';
import 'package:indogrip/features/vendor/data/models/view_vendor_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Vendor {
  static final String srNo = 'Sr No';
  static final String companyName = 'Company Name';
  static final String mobileNumber = 'Mobile Number';
  static final String gstin = 'GSTIN';
  static final String ownerName = 'Owner Name';
  static final String ownerMobile = 'Owner Mobile';
  static final String vendorCode = 'Vendor Code';
  static final String representativeManager = 'Representative Manager';
  static final String representativeMobile = 'Representative Mobile';
}

class VendorDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<VendorRecord> vendorData = [];
  final BuildContext context;
  bool isAllChecked;
  final Function(bool) onStatusChanged;
  final Function(bool, int) onCheckboxChanged;
  final Function(VendorRecord) onEdit;
  final Function(VendorRecord) onDelete;
  final void Function(String?, VendorRecord) onChanged;
  final Function(VendorRecord) onProfile;

  VendorDataSource({
    required this.context,
    required this.vendorData,
    required this.isAllChecked,
    required this.onStatusChanged,
    required this.onCheckboxChanged,
    required this.onEdit,
    required this.onDelete,
    required this.onChanged,
    required this.onProfile,
  }) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = vendorData.asMap().entries.map<DataGridRow>((entry) {
      final data = entry.value;
      return DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: Vendor.srNo,
            value: data.sNo?.toString() ?? '',
          ),
          DataGridCell<String>(
            columnName: Vendor.vendorCode,
            value: data.vCode ?? '',
          ),
          DataGridCell<String>(
            columnName: Vendor.ownerName,
            value: data.vVendorName ?? '',
          ),
          DataGridCell<String>(
            columnName: Vendor.ownerMobile,
            value: data.vVendorMobileNumber ?? '',
          ),
          DataGridCell<String>(
            columnName: Vendor.companyName,
            value: data.vCompanyName ?? '',
          ),
          DataGridCell<String>(
            columnName: Vendor.mobileNumber,
            value: data.vCompanyMobileNumber ?? '',
          ),
          DataGridCell<String>(
            columnName: Vendor.gstin,
            value: data.vCompanyGSTIN ?? '',
          ),
          DataGridCell<String>(
            columnName: Vendor.representativeManager,
            value: data.vRepresentativeName ?? '',
          ),
          DataGridCell<String>(
            columnName: Vendor.representativeMobile,
            value: data.vRepresentativeNumber ?? '',
          ),
          DataGridCell<Widget>(
            columnName: 'Status',
            value: MasterUserStatus(
              isShowLabel: false,
              isCustomized: false,
              onChanged: (value) {
                onChanged.call(value, data);
              },
              initialStatus: data.rStatus
                  .toString(), //! status not show because of rStatus show 1 there is no status 1 in api
              // staff: staff,
            ),
          ),
          //  if (HiveService.getRole() != '2')
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
        // Render widget-valued cells (e.g., Status dropdown, action buttons)
        if (cell.value is Widget) {
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

  Widget _buildActionButtons(VendorRecord vendor) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 120),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (HiveService.getRole() != '2')
            SizedBox(
              width: 35,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () => onEdit(vendor),
                constraints: const BoxConstraints(),
              ),
            ),
          if (HiveService.getRole() != '2')
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
              onPressed: () {
                DeleteConfirmationAlert.show(
                  context,
                  title: 'Delete Record',
                  message: 'Are Your to Delete This vendor Record',
                  itemName: '${vendor.vVendorName} ',

                  onConfirm: () {
                    onDelete(vendor);
                  },
                  rPanel: 'view-vendor',
                  item: vendorData,
                  index: vendorData.indexOf(vendor),
                  rKey: vendor.rKey.toString(),
                );
              },
            ),
          // SizedBox(
          //   width: 35,
          //   child: DeleteRecordButton(
          //     rKey: vendor.rKey.toString(),
          //     rPanel: 'view-vendor',
          //     item: vendorData,
          //     index: vendorData.indexOf(vendor),
          //     onPressed: () => onDelete(vendor),
          //   ),
          // ),
          SizedBox(
            width: 35,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.person, size: 18),
              onPressed: () => onProfile(vendor),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
