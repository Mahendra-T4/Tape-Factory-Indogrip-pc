import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:indogrip/core/database/init_box.dart';
import 'package:indogrip/core/database/round_db_hive.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/custom_date_picker.dart';
import 'package:indogrip/core/utils/widgets/delete_alert.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/chalan/data/model/challan_details_model.dart';
import 'package:indogrip/features/chalan/data/model/challaninfo_param.dart';
import 'package:indogrip/features/chalan/data/model/return_product.dart';
import 'package:indogrip/features/chalan/data/model/round_data_model.dart';
import 'package:indogrip/features/chalan/data/model/round_details_model.dart';
import 'package:indogrip/features/chalan/data/model/verify_challan_product_param.dart';
import 'package:indogrip/features/chalan/presentation/bloc/challan_bloc.dart';
import 'package:indogrip/features/chalan/presentation/page/bill/bill_formate.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/round/data/models/view_round_modeld.dart';
import 'package:indogrip/features/wastage/presentation/widgets/client_list_dropdown.dart';
import 'package:indogrip/features/wastage/presentation/widgets/client_searchable_dropdown.dart';

abstract class BillFormatBuilder extends State<BillFormate> {
  late final ChallanBloc challanBloc;
  late final GlobalBloc globalBloc;
  final unitPriceController = TextEditingController();
  final remarkController = TextEditingController();
  final chalanDateController = TextEditingController();
  final List<TextEditingController> rowUnitPriceControllers = [];
  final List<TextEditingController> rowDisplayQuantityControllers = [];
  final List<TextEditingController> rowRemarkControllers = [];
  final List<TextEditingController> actualQtyControllers = [];
  final List<FocusNode> rowUnitPriceFocusNodes = [];
  final List<FocusNode> rowDisplayQuantityFocusNodes = [];
  final List<FocusNode> rowRemarkFocusNodes = [];
  final List<FocusNode> actualQtyFocusNodes = [];
  final List<double> rowDisplayPrices = [];

  String? selectedClientKey;
  String? clientUnitName;
  String? clientName;
  int? _scannedItemCount;

  updateScannedItemCount(int count) {
    setState(() {
      _scannedItemCount = count;
    });
  }

  final TextEditingController challanRemarkController = TextEditingController();
  final TextEditingController challanNoController = TextEditingController();
  // final TextEditingController challanDateController = TextEditingController();

  TextStyle _testTextStyle = TextStyle(
    // fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  void _clearControllers() {
    // Dispose focus nodes
    for (final focusNode in rowUnitPriceFocusNodes) {
      focusNode.dispose();
    }
    for (final focusNode in rowDisplayQuantityFocusNodes) {
      focusNode.dispose();
    }
    for (final focusNode in rowRemarkFocusNodes) {
      focusNode.dispose();
    }
    for (final focusNode in actualQtyFocusNodes) {
      focusNode.dispose();
    }

    // Dispose controllers
    for (final controller in rowUnitPriceControllers) {
      controller.dispose();
    }
    for (final controller in rowDisplayQuantityControllers) {
      controller.dispose();
    }
    for (final controller in rowRemarkControllers) {
      controller.dispose();
    }
    for (final controller in actualQtyControllers) {
      controller.dispose();
    }

    // Clear lists
    rowUnitPriceFocusNodes.clear();
    rowDisplayQuantityFocusNodes.clear();
    rowRemarkFocusNodes.clear();
    actualQtyFocusNodes.clear();
    rowUnitPriceControllers.clear();
    rowDisplayQuantityControllers.clear();
    rowRemarkControllers.clear();
    actualQtyControllers.clear();
    rowDisplayPrices.clear();
  }

  @override
  void initState() {
    super.initState();
    challanBloc = ChallanBloc();
    globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    challanBloc.add(FetchChallanDetailsInBillEvent(orderKey: widget.orderKey));
  }

  @override
  void dispose() {
    _clearControllers();
    unitPriceController.dispose();
    remarkController.dispose();
    chalanDateController.dispose();

    challanRemarkController.dispose();
    challanNoController.dispose();
    challanBloc.close();
    globalBloc.close();
    super.dispose();
  }

  Widget itemCount() {
    final box = Boxes.roundData();

    final scannedData = box.values.toList().cast<RoundDataModel>();

    final clientData = scannedData.where(
      (item) => item.rKey == widget.orderKey,
    );

    _scannedItemCount = clientData.length;

    return Column(
      // spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scanned Cartons',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Container(
          width: 140,
          height: 40,
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blueGrey, width: 1.5),
          ),
          child: Text(
            _scannedItemCount.toString(),
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget topHeaderRow({
    required String gstinNo,
    required String callNo,
    required String whatsAppNo,
  }) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'GSTIN: $gstinNo',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'CALL : $callNo',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            'WhatsApp: $whatsAppNo',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ],
  );

  Widget buildAddChallanInfoWidget(challanKey, cKey, cUnitName) => BlocConsumer(
    bloc: globalBloc,
    listener: (context, state) {
      if (state is AddChallanInfoSuccessState) {
        if (state.model.status == 1) {
          ToastService.instance.showSuccess(
            context,
            state.model.message.toString(),
          );
          challanBloc.add(
            FetchChallanDetailsInBillEvent(orderKey: widget.orderKey),
          );
        } else {
          ToastService.instance.showError(
            context,
            state.model.message ?? 'failed to add challanInfo',
          );
        }
      } else if (state is AddChallanInfoFailureState) {
        ToastService.instance.showError(context, state.errorMessage);
      }
    },
    builder: (context, state) {
      if (state is GlobalLoadingStatus3) {
        return Center(child: CircularProgressIndicator());
      }
      return CustomButton(
        label: 'Submit',
        onPressed: () {
          globalBloc.add(
            AddChallanInfoEvent(
              param: ChallaninfoParam(
                challanRemark: remarkController.text,
                challanNumber: challanNoController.text,
                challanDate: chalanDateController.text,
                challanKey: challanKey,
                clientUnitName: cUnitName ?? clientUnitName,
                clientKey: cKey ?? selectedClientKey,
              ),
            ),
          );
        },
      );
    },
  );

  Widget logoRowNo2(theTapLogo, indogripLogo) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Image.network(theTapLogo, height: 120, width: 120),
      Image.network(indogripLogo, height: 120, width: 120),
    ],
  );

  Widget businessInfoWidget({
    required String manufactureOf,
    required String wholesaler,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 5,
    children: [
      Row(
        children: [
          Text(
            manufactureOf,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.deepOrangeAccent,

              // fontSize: 16.5,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),

      Row(
        children: [
          Text(
            wholesaler,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.deepOrangeAccent,
              // fontSize: 16.5,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    ],
  );

  Widget leftSideDetailsFillContainer({
    required String clientKey,
    required String clientPhone,
    required String gstin,
    required dynamic Function(String?) onChanged,
    // required String orderKey,
  }) => Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 10,
          children: [
            Expanded(
              flex: 2,
              child: ClientsListDropdown(
                isFilter: true,
                label: 'Client Name',
                value: selectedClientKey,
                onChanged: onChanged,
              ),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
        // Text('M/s. $clientName'),
        Text('________________________________'),
        Text('Contact No.: $clientPhone'),
        Text('Party\'s GSTIN: ${gstin}'),
      ],
    ),
  );

  Widget rightSideDetailsFillContainer({
    required String challanNo,
    required String challanDate,
    // required String orderNo,
    // required String orderDate,
  }) => Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ChallanNo.: $challanNo'),
        Text('DT. $challanDate'),
        // Text('Order No.: $orderNo'),
        // Text('DT. $orderDate'),
      ],
    ),
  );

  Widget dataTableWidget(List<ChallanRecord>? record) {
    final products = record?.expand((r) => r.orderProduct ?? []).toList() ?? [];

    // Only initialize controllers if product count changed or first time
    // Check both controller and focus node counts to ensure consistency
    if (rowUnitPriceControllers.length != products.length ||
        rowUnitPriceFocusNodes.length != products.length) {
      _clearControllers();

      for (var i = 0; i < products.length; i++) {
        rowUnitPriceControllers.add(
          TextEditingController(text: products[i].unitPrice?.toString() ?? '0'),
        );
        rowDisplayQuantityControllers.add(
          TextEditingController(
            text: products[i].displayQty?.toString() ?? '0',
          ),
        );
        rowRemarkControllers.add(
          TextEditingController(text: products[i].prRemarks ?? ''),
        );
        actualQtyControllers.add(
          TextEditingController(text: products[i].quantity?.toString() ?? '0'),
        );
        rowUnitPriceFocusNodes.add(FocusNode());
        rowDisplayQuantityFocusNodes.add(FocusNode());
        rowRemarkFocusNodes.add(FocusNode());
        actualQtyFocusNodes.add(FocusNode());

        // Initialize with proper API data
        final unitPrice =
            double.tryParse(products[i].unitPrice?.toString() ?? '0') ?? 0.0;
        final displayQty =
            double.tryParse(products[i].displayQty?.toString() ?? '0') ?? 0.0;
        rowDisplayPrices.add(unitPrice * displayQty);
      }
    } else {
      // Product count hasn't changed - preserve user input
      // Only update rowDisplayPrices based on current controller values
      for (var i = 0; i < products.length; i++) {
        final currentUnitPrice =
            double.tryParse(rowUnitPriceControllers[i].text) ??
            double.tryParse(products[i].unitPrice?.toString() ?? '0') ??
            0.0;
        final currentDisplayQty =
            double.tryParse(rowDisplayQuantityControllers[i].text) ??
            double.tryParse(products[i].displayQty?.toString() ?? '0') ??
            0.0;
        if (rowDisplayPrices.length <= i) {
          rowDisplayPrices.add(currentUnitPrice * currentDisplayQty);
        } else {
          rowDisplayPrices[i] = currentUnitPrice * currentDisplayQty;
        }
      }
    }
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.98,
      child: Table(
        border: TableBorder.all(color: Colors.black, width: 1.5),
        columnWidths: {
          0: FixedColumnWidth(50),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(1.2),
          3: FixedColumnWidth(80),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.grey[300]),
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    'S.NO.',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    'Material',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    'HSN',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    'Unit Price',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    'Display Qty',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    'Qty',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    'Dis. Price',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    'Total Price',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    'Remark',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    'Return Date',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    'Ret. Qty',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    'Ret. Reason',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    'Action',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
          ...List<TableRow>.generate(products.length, (index) {
            final product = products[index];
            final apiUnitPrice =
                double.tryParse(product.unitPrice?.toString() ?? '0') ?? 0.0;
            final apiDisplayQty =
                double.tryParse(product.displayQty?.toString() ?? '0') ?? 0.0;
            final apiActualQty =
                double.tryParse(product.quantity?.toString() ?? '0') ?? 0.0;
            final apiDisplayPrice =
                double.tryParse(product.displayPrice?.toString() ?? '0') ??
                (apiUnitPrice * apiDisplayQty);
            final apiTotalPrice =
                double.tryParse(product.productPrice?.toString() ?? '0') ??
                (apiUnitPrice * apiActualQty);

            // Get current values from controllers
            final currentUnitPrice =
                double.tryParse(rowUnitPriceControllers[index].text) ??
                apiUnitPrice;
            final currentDisplayQty =
                double.tryParse(rowDisplayQuantityControllers[index].text) ??
                apiDisplayQty;

            // Initialize rowDisplayPrices if needed
            if (rowDisplayPrices.length <= index) {
              rowDisplayPrices.add(currentUnitPrice * currentDisplayQty);
            }

            // Calculate prices based on current controller values
            final currentDisplayPrice =
                rowDisplayPrices.isNotEmpty && index < rowDisplayPrices.length
                ? rowDisplayPrices[index]
                : (currentUnitPrice * currentDisplayQty);
            final currentTotalPrice = currentUnitPrice * apiActualQty;

            return TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.all(6),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: Text(
                    product.displayInformation?.toString() ?? 'N/A',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: Center(
                    child: Text(
                      product.hsnCode?.toString() ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(3),
                  child: TextFormField(
                    controller: rowUnitPriceControllers[index],
                    focusNode: rowUnitPriceFocusNodes[index],
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        final unit = double.tryParse(value) ?? apiUnitPrice;
                        final qty =
                            double.tryParse(
                              rowDisplayQuantityControllers[index].text,
                            ) ??
                            apiDisplayQty;
                        rowDisplayPrices[index] = unit * qty;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      hintText: apiUnitPrice.toStringAsFixed(2),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(3),
                  child: TextFormField(
                    controller: rowDisplayQuantityControllers[index],
                    focusNode: rowDisplayQuantityFocusNodes[index],
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        final unit =
                            double.tryParse(
                              rowUnitPriceControllers[index].text,
                            ) ??
                            apiUnitPrice;
                        final qty = double.tryParse(value) ?? apiDisplayQty;
                        rowDisplayPrices[index] = unit * qty;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      hintText: apiDisplayQty.toStringAsFixed(2),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(3),
                  child: TextFormField(
                    controller: actualQtyControllers[index],
                    focusNode: actualQtyFocusNodes[index],
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    // onChanged: (value) {
                    //   setState(() {
                    //     final unit =
                    //         double.tryParse(
                    //           rowUnitPriceControllers[index].text,
                    //         ) ??
                    //         apiUnitPrice;
                    //     final qty = double.tryParse(value) ?? apiActualQty;
                    //     // Update total price based on actual quantity
                    //     rowDisplayPrices[index] = unit * qty;
                    //   });
                    // },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      hintText: apiActualQty.toStringAsFixed(2),
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.all(6),
                //   child: Center(
                //     child: Text(
                //       apiActualQty.toStringAsFixed(2),
                //       style: TextStyle(
                //         fontSize: 12,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: Center(
                    child: Text(
                      currentDisplayPrice.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: Center(
                    child: Text(
                      currentTotalPrice.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(3),
                  child: TextFormField(
                    controller: rowRemarkControllers[index],
                    focusNode: rowRemarkFocusNodes[index],
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: Center(
                    child: Text(
                      product.returnDate ?? 'N/A',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: Center(
                    child: Text(
                      product.returnQty?.toString() ?? '0',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: Text(
                    product.returnReason ?? '',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 25,
                          child: product.productStatus == 2
                              ? buildVerifyProductButton(
                                  VerifyProductParam(
                                    productKey: product.productKey.toString(),
                                    unitPrice:
                                        rowUnitPriceControllers[index]
                                            .text
                                            .isNotEmpty
                                        ? rowUnitPriceControllers[index].text
                                        : apiUnitPrice.toString(),
                                    displayQty:
                                        rowDisplayQuantityControllers[index]
                                            .text
                                            .isNotEmpty
                                        ? rowDisplayQuantityControllers[index]
                                              .text
                                        : apiDisplayQty.toString(),
                                    prRemarks: rowRemarkControllers[index].text,
                                    actualQty:
                                        actualQtyControllers[index]
                                            .text
                                            .isNotEmpty
                                        ? actualQtyControllers[index].text
                                        : apiActualQty.toString(),
                                  ),
                                )
                              : buildUnVerifyProductButton(
                                  product.productKey.toString(),
                                ),
                        ),
                        SizedBox(height: 4),
                        SizedBox(
                          width: double.infinity,
                          height: 25,
                          child: ElevatedButton(
                            onPressed: () {
                              showReturnReasonDialog(
                                context,
                                product.productKey.toString(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kButtonColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                            ),
                            child: Text(
                              'Return',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),

                        SizedBox(height: 4),
                        SizedBox(
                          width: double.infinity,
                          height: 25,
                          child: ElevatedButton(
                            onPressed: () {
                              DeleteConfirmationAlert.show(
                                context,
                                onDeleteSuccess: () {
                                  challanBloc.add(
                                    FetchChallanDetailsInBillEvent(
                                      orderKey: widget.orderKey,
                                    ),
                                  );
                                },
                                title: 'Delete Record',
                                message:
                                    'Are Your to Delete This client Record',
                                itemName: product.displayInformation.toString(),

                                onConfirm: () {
                                  globalBloc.add(
                                    GlobalDeleteRecordEvent(
                                      rKey: products[index].productKey
                                          .toString(),
                                      rPanel: 'challan-details',
                                    ),
                                  );
                                },
                                rPanel: 'challan-details',
                                item: products,
                                index: index,
                                rKey: products[index].productKey.toString(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                            ),
                            child: Text(
                              'Delete',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }, growable: true),
        ],
      ),
    );
  }

  Widget buildVerifyProductButton(VerifyProductParam data) {
    final buttonBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    return BlocConsumer(
      bloc: buttonBloc,
      listenWhen: (previous, current) =>
          current is ChallanProductVerifySuccessState ||
          current is ChallanProductVerifyFailureState,
      buildWhen: (previous, current) =>
          current is GlobalLoadingStatus ||
          current is ChallanProductVerifySuccessState ||
          current is ChallanProductVerifyFailureState,
      listener: (context, state) {
        if (state is ChallanProductVerifySuccessState) {
          if (state.model.status == 1) {
            ToastService.instance.showSuccess(
              context,
              state.model.message.toString(),
            );
            challanBloc.add(
              FetchChallanDetailsInBillEvent(orderKey: widget.orderKey),
            );
          } else {
            ToastService.instance.showError(
              context,
              state.model.message.toString(),
            );
          }
        } else if (state is ChallanProductVerifyFailureState) {
          ToastService.instance.showError(
            context,
            state.errorMessage.toString(),
          );
        }
      },

      builder: (context, state) {
        if (state is GlobalLoadingStatus) {
          return Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        return ElevatedButton(
          onPressed: () {
            buttonBloc.add(VerifyChallanProductEvent(param: data));
          },
          style:
              ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 0,
                minimumSize: Size(60, 30),
              ).copyWith(
                overlayColor: MaterialStateProperty.resolveWith<Color?>((
                  Set<MaterialState> states,
                ) {
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.green.shade700;
                  }
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.green.shade800;
                  }
                  return null;
                }),
              ),
          child: Text('Verify', style: TextStyle(fontSize: 10)),
        );
      },
    );
  }

  Widget buildUnVerifyProductButton(productKey) {
    final buttonBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    return BlocConsumer(
      bloc: buttonBloc,
      listenWhen: (previous, current) =>
          current is UnVerifyProductSuccessState ||
          current is UnVerifyProductFailureState,
      listener: (context, state) {
        if (state is UnVerifyProductSuccessState) {
          if (state.model.status == 1) {
            ToastService.instance.showSuccess(
              context,
              state.model.message.toString(),
            );
            challanBloc.add(
              FetchChallanDetailsInBillEvent(orderKey: widget.orderKey),
            );
          } else {
            ToastService.instance.showError(
              context,
              state.model.message.toString(),
            );
          }
        } else if (state is UnVerifyProductFailureState) {
          ToastService.instance.showError(
            context,
            state.errorMessage.toString(),
          );
        }
      },
      buildWhen: (previous, current) =>
          current is GlobalLoadingStatus2 ||
          current is UnVerifyProductSuccessState ||
          current is UnVerifyProductFailureState,
      builder: (context, state) {
        if (state is GlobalLoadingStatus2) {
          return Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        return ElevatedButton(
          onPressed: () {
            buttonBloc.add(UnVerifyProductEvent(productKey: productKey));
          },
          style:
              ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 0,
                minimumSize: Size(60, 30),
              ).copyWith(
                overlayColor: MaterialStateProperty.resolveWith<Color?>((
                  Set<MaterialState> states,
                ) {
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.red.shade700;
                  }
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.red.shade800;
                  }
                  return null;
                }),
              ),
          child: Icon(Icons.close, size: 16, color: Colors.white),
        );
      },
    );
  }

  Widget buildReturnProductButton({
    required String productKey,
    required TextEditingController returnQtyController,
    required TextEditingController returnReasonController,
    required TextEditingController returnDateController,
  }) {
    final buttonBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    return BlocConsumer(
      bloc: buttonBloc,
      listenWhen: (previous, current) =>
          current is ReturnChallanProductSuccessState ||
          current is ReturnChallanProductFailureState,
      buildWhen: (previous, current) =>
          current is GlobalLoadingStatus3 ||
          current is ReturnChallanProductSuccessState ||
          current is ReturnChallanProductFailureState,
      listener: (context, state) {
        if (state is ReturnChallanProductSuccessState) {
          if (state.model.status == 1) {
            ToastService.instance.showSuccess(
              context,
              state.model.message.toString(),
            );
            challanBloc.add(
              FetchChallanDetailsInBillEvent(orderKey: widget.orderKey),
            );
            context.pop();
          } else {
            ToastService.instance.showError(
              context,
              state.model.message.toString(),
            );
          }
        } else if (state is ReturnChallanProductFailureState) {
          ToastService.instance.showError(
            context,
            state.errorMessage.toString(),
          );
        }
      },

      builder: (context, state) {
        if (state is GlobalLoadingStatus3) {
          return Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        return ElevatedButton(
          onPressed: () {
            buttonBloc.add(
              ReturnChallanProductEvent(
                param: ReturnProduct(
                  productKey: productKey,
                  returnQty: returnQtyController.text,
                  returnReason: returnReasonController.text,
                  returnDate: returnDateController.text,
                ),
              ),
            );
          },
          style:
              ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 0,
                minimumSize: Size(60, 30),
              ).copyWith(
                overlayColor: MaterialStateProperty.resolveWith<Color?>((
                  Set<MaterialState> states,
                ) {
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.red.shade700;
                  }
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.red.shade800;
                  }
                  return null;
                }),
              ),
          child: Text('Return', style: TextStyle(fontSize: 10)),
        );
      },
    );
  }

  void showReturnReasonDialog(BuildContext context, productKey) {
    TextEditingController reasonController = TextEditingController();
    TextEditingController returnQtyController = TextEditingController();
    TextEditingController returnDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: 120,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              'Return Reason',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red.shade600,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                CustomDatePicker(
                  controller: returnDateController,
                  labelText: 'Return Date',
                ),
                TextField(
                  controller: returnQtyController,
                  decoration: InputDecoration(
                    hintText: 'Enter return quantity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red.shade600),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                TextField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    hintText: 'Enter reason for return',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red.shade600),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              buildReturnProductButton(
                productKey: productKey,
                returnQtyController: returnQtyController,
                returnReasonController: reasonController,
                returnDateController: returnDateController,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget bottomDetailsWidget({
    required String termHeading,
    required String termHeading2,
    required List<String> termList,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(termHeading, style: _testTextStyle),
          Text(termHeading2, style: _testTextStyle),
        ],
      ),
      SizedBox(height: 15),
      ...termList.map((term) => Text(term)),
      SizedBox(height: 40),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Receiver\'s Signature', style: _testTextStyle),
          Text('Authorised Signatur', style: _testTextStyle),
        ],
      ),
    ],
  );

  Widget get verifyButton => Container(
    margin: const EdgeInsets.only(top: 10),
    height: 38,
    child: ElevatedButton(
      onPressed: () {
        // Handle verify action
      },
      style:
          ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ).copyWith(
            overlayColor: MaterialStateProperty.resolveWith<Color?>((
              Set<MaterialState> states,
            ) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.green.shade700;
              }
              if (states.contains(MaterialState.pressed)) {
                return Colors.green.shade800;
              }
              return null;
            }),
          ),
      child: Text('Verify', style: TextStyle(fontSize: 17)),
    ),
  );
}
