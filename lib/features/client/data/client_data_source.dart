import 'package:flutter/material.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/utils/widgets/delete_alert.dart';
import 'package:indogrip/features/client/data/model/view_staff_modeld.dart';
import 'package:indogrip/features/global/presentation/widget/master_user_status.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ClientDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<ClientRecord> clientData = [];
  final BuildContext context;
  bool isAllChecked;
  final Function(bool) onStatusChanged;
  final Function(bool, int) onCheckboxChanged;
  final Function(ClientRecord, List<ClientUnitList> units) onEdit;
  final Function(ClientRecord) onDelete;
  final Function(ClientRecord) onProfile;
  final void Function(String?, ClientRecord) onChanged;

  ClientDataSource({
    required this.context,
    required this.clientData,
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
    dataGridRows = clientData.asMap().entries.map<DataGridRow>((entry) {
      // final index = entry.key;
      final data = entry.value;
      return DataGridRow(
        cells: [
          DataGridCell<String>(columnName: 'Sr No', value: data.sNo.toString()),
          DataGridCell<String>(
            columnName: 'Client Code',
            value: data.cCode.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Consignee Name',
            value: data.cConsigneeName.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Mobile Number',
            value: data.cMobileNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'GSTIN',
            value: data.cGSTIN.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Owner Name',
            value: data.cOwnerName.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Owner Mobile',
            value: data.cOwnerMobileNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Owner Alternate Mobile',
            value: data.cOwnerAlternateNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Purchase Manager',
            value: data.cPurchaseManagerName.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Manager Mobile',
            value: data.cPurchaseManagerNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Manager Alternate Mobile',
            value: data.cPurchaseManagerAlternateNumber.toString(),
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

          DataGridCell<Widget>(
            columnName: 'actions',
            value: _buildActionButtons(data, data.unitList ?? []),
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
        // If the DataGridCell holds a Widget (for example the Status dropdown
        // or action buttons), render it directly. Otherwise fall back to text.
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

  Widget _buildActionButtons(ClientRecord client, List<ClientUnitList> unit) {
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
                onPressed: () => onEdit(client, unit),
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
                  message: 'Are Your to Delete This client Record',
                  itemName: '${client.cConsigneeName}',

                  onConfirm: () {
                    onDelete(client);
                  },
                  rPanel: 'view-client',
                  item: clientData,
                  index: clientData.indexOf(client),
                  rKey: client.rKey.toString(),
                );
              },
            ),
          // SizedBox(
          //   width: 35,
          //   child: DeleteRecordButton(
          //     rKey: client.rKey.toString(),
          //     rPanel: 'view-client',
          //     item: clientData,
          //     index: clientData.indexOf(client),
          //     onPressed: () => onDelete(client),
          //   ),
          // ),
          SizedBox(
            width: 35,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.person, size: 18),
              onPressed: () => onProfile(client),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
