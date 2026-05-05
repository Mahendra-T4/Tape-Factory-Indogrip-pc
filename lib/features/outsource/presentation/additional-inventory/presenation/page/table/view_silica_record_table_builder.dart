import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/domain/repositories/global_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/data_filtration.dart';
import 'package:indogrip/features/global/presentation/widget/pagination_widget.dart';
import 'package:indogrip/features/global/presentation/widget/refresh_button.dart';
import 'package:indogrip/features/global/presentation/widget/search_fields.dart';
import 'package:indogrip/features/outsource/presentation/additional-inventory/data/source/silic_record_data_source.dart';
import 'package:indogrip/features/outsource/presentation/additional-inventory/presenation/page/table/view_silica_records.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

abstract class ViewSilicaRecordTableBuilder
    extends State<ViewSilicaRecordTablePanel> {
  late final GlobalBloc globalBloc;
  Key refreshKey = UniqueKey();

  String pageText = '';
  int? currentPage = 1;
  int? pageQty;

  List filterList = ["Newest", "Oldest"];
  List entryList = ["10", "25", "50", "100", "500"];
  var recordValue, filterValue, entryValue;

  clearFiltersOnRefresh() {
    searchController.clear();
    fromDateController.clear();
    toDateController.clear();
    setState(() {
      recordValue = null;
      filterValue = null;
      entryValue = null;
    });

    refreshKey = UniqueKey();

    // eventHandler();
  }

  @override
  void initState() {
    super.initState();
    globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
  }

  SilicaDataSource? silicaDataSource;
  List<DataGridRow> selectedRows = [];
  bool isMultipleSelection = false;
  bool isChecked = false;
  List<SilicaData> selectedItems = [];
  final TextEditingController searchController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  void handleSelectionChanged(List<SilicaData> items) {
    setState(() {
      selectedItems = items;
    });
  }

  final List<SilicaData> silicaData = [
    SilicaData(
      sNo: '1',
      vendorName: 'ABC Suppliers',
      billDate: '2024-01-15',
      billNumber: 'BL001',
      serialNumber: 'SN001',
      cost: 5000.00,
      transportPrice: 500.00,
      margin: 10.0,
      grossWeight: 250.0,
      remark: 'Good quality',
    ),
    SilicaData(
      sNo: '2',
      vendorName: 'XYZ Industries',
      billDate: '2024-01-16',
      billNumber: 'BL002',
      serialNumber: 'SN002',
      cost: 6000.00,
      transportPrice: 600.00,
      margin: 12.0,
      grossWeight: 280.0,
      remark: 'Fast delivery',
    ),
    SilicaData(
      sNo: '3',
      vendorName: 'Prime Materials',
      billDate: '2024-01-17',
      billNumber: 'BL003',
      serialNumber: 'SN003',
      cost: 4500.00,
      transportPrice: 450.00,
      margin: 8.5,
      grossWeight: 220.0,
      remark: 'Standard quality',
    ),
    SilicaData(
      sNo: '4',
      vendorName: 'Global Trade',
      billDate: '2024-01-18',
      billNumber: 'BL004',
      serialNumber: 'SN004',
      cost: 7000.00,
      transportPrice: 700.00,
      margin: 15.0,
      grossWeight: 320.0,
      remark: 'Premium grade',
    ),
    SilicaData(
      sNo: '5',
      vendorName: 'Tech Solutions',
      billDate: '2024-01-19',
      billNumber: 'BL005',
      serialNumber: 'SN005',
      cost: 5500.00,
      transportPrice: 550.00,
      margin: 11.0,
      grossWeight: 260.0,
      remark: 'Verified supplier',
    ),
    SilicaData(
      sNo: '6',
      vendorName: 'Quality Imports',
      billDate: '2024-01-20',
      billNumber: 'BL006',
      serialNumber: 'SN006',
      cost: 4800.00,
      transportPrice: 480.00,
      margin: 9.5,
      grossWeight: 240.0,
      remark: 'Excellent service',
    ),
    SilicaData(
      sNo: '7',
      vendorName: 'Standard Corp',
      billDate: '2024-01-21',
      billNumber: 'BL007',
      serialNumber: 'SN007',
      cost: 6500.00,
      transportPrice: 650.00,
      margin: 13.0,
      grossWeight: 300.0,
      remark: 'Reliable partner',
    ),
    SilicaData(
      sNo: '8',
      vendorName: 'Elite Supplies',
      billDate: '2024-01-22',
      billNumber: 'BL008',
      serialNumber: 'SN008',
      cost: 5200.00,
      transportPrice: 520.00,
      margin: 10.5,
      grossWeight: 270.0,
      remark: 'On time delivery',
    ),
    SilicaData(
      sNo: '9',
      vendorName: 'Metro Trading',
      billDate: '2024-01-23',
      billNumber: 'BL009',
      serialNumber: 'SN009',
      cost: 7200.00,
      transportPrice: 720.00,
      margin: 14.0,
      grossWeight: 330.0,
      remark: 'Bulk order',
    ),
    SilicaData(
      sNo: '10',
      vendorName: 'Universal Traders',
      billDate: '2024-01-24',
      billNumber: 'BL010',
      serialNumber: 'SN010',
      cost: 5800.00,
      transportPrice: 580.00,
      margin: 12.5,
      grossWeight: 290.0,
      remark: 'Regular supplier',
    ),
  ];

  Widget get silicaSearchFields => Column(
    children: [
      BlocListener<GlobalBloc, GlobalState>(
        bloc: globalBloc,
        listener: (context, state) {
          if (state is GlobalChangeUserStatusSuccessStatus) {
            // Handle status change success (for approved, rejected, blocked, etc.)
            if (state.changeStatusEntity.status == 1) {
              ToastService.instance.showSuccess(
                context,
                state.changeStatusEntity.message.toString(),
              );

              // Refresh list after status change
              // eventHandler();
            } else {
              ToastService.instance.showError(
                context,
                state.changeStatusEntity.message ?? 'try again later',
              );
            }
          } else if (state is GlobalChangeUserStatusErrorStatus) {
            ToastService.instance.showError(context, state.message);
          } else if (state is GlobalDeleteRecordSuccessStatus) {
            ToastService.instance.showSuccess(
              context,
              state.deleteRecordEntity.message.toString(),
            );
            // Refresh list after single delete
            // eventHandler();
          } else if (state is GlobalDeleteRecordErrorStatus) {
            ToastService.instance.showError(context, state.message.toString());
          } else if (state is GlobalDeleteMultipleRecordsSuccessStatus) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.deleteRecordEntity.message ?? 'Records deleted',
                ),
              ),
            );
            // Refresh list after bulk delete
            // eventHandler();
            // Clear selection
            setState(() {
              selectedRows.clear();
              selectedItems.clear();
              isMultipleSelection = false;
            });
          } else if (state is GlobalDeleteMultipleRecordsErrorStatus) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Column(
          children: [
            DateFiltration(
              fromDateController: fromDateController,
              toDateController: toDateController,
            ),
            searchFields,
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: refreshButton,
      ),
      SizedBox(height: 15),
      // if (isNotEmpty)
      _buildPaginationWidget,
    ],
  );

  Widget get refreshButton => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      SizedBox(
        width: MediaQuery.sizeOf(context).width * .15,
        height: 35,
        child: RefreshButton(
          onPressed: () {
            clearFiltersOnRefresh();
          },
        ),
      ),
    ],
  );

  //! tablet

  Widget get searchFields => SearchFields(
    key: refreshKey,
    isStatus: true,
    controller: searchController,
    onSearch: (keyword) {
      // eventHandler();
    },
    onChangedStatus: (status) {
      setState(() {
        recordValue = status;
      });
      // eventHandler();
    },
    onChangedOrder: (order) {
      setState(() {
        filterValue = order;
      });
      // eventHandler();
    },
    onChangedSort: (sortBy) {
      setState(() {
        entryValue = sortBy ?? 10;
      });
      // eventHandler();
    },
  );

  Widget get _buildPaginationWidget => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: TableBottomWidget(
      pageText: pageText,
      currentPage: currentPage,
      pageQty: pageQty,

      onPagePressed: (pageNumber) {
        setState(() {
          currentPage = pageNumber;
        });
        setState(() {
          final pageNumber = currentPage;
          // eventHandler();
        });

        // Page number button clicked
      },
      onFirstPressed: () {
        setState(() {
          currentPage = 1;
          // eventHandler();
        });
      },
      onPreviousPressed: () {
        if (currentPage != null && currentPage! >= 1) {
          setState(() {
            currentPage = currentPage! - 1;
            // eventHandler();
          });
        }
      },
      onNextPressed: () {
        if (currentPage != null &&
            pageQty != null &&
            currentPage! <= pageQty!) {
          setState(() {
            currentPage = currentPage! + 1;
            // eventHandler();
          });
        }
      },
      onLastPressed: () {
        setState(() {
          currentPage = pageQty;
          // eventHandler();
        });
      },
    ),
  );

  List<GridColumn> buildGridColumns() {
    return [
      GridColumn(
        columnName: Silica.srNo,
        width: 70,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Silica.srNo,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Silica.vendorName,
        width: 300,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Silica.vendorName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Silica.billDate,
        width: 180,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Silica.billDate,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Silica.billNumber,
        width: 180,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Silica.billNumber,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Silica.serialNumber,
        width: 180,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Silica.serialNumber,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Silica.transportPrice,
        width: 130,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Silica.transportPrice,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Silica.cost,
        width: 130,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Silica.cost,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Silica.margin,
        width: 130,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Silica.margin,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Silica.grossWeight,
        width: 120,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Silica.grossWeight,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: Silica.remark,
        width: 120,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            Silica.remark,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),

      GridColumn(
        columnName: 'actions',
        width: 140,
        label: Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: const Text(
            'Actions',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ];
  }
}
