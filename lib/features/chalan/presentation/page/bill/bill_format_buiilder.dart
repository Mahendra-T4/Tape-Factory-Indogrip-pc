import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:indogrip/Assets/assets.dart';
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
  bool _isProcessingBarcode = false; // Track barcode processing state

  final TextEditingController addScannedBarcodeController =
      TextEditingController();
  final FocusNode barcodeFocusNode = FocusNode();

  final TextEditingController challanRemarkController = TextEditingController();
  final TextEditingController challanNoController = TextEditingController();
  // final TextEditingController challanDateController = TextEditingController();

  TextStyle _testTextStyle = TextStyle(
    // fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  String _safeValue(dynamic value, {String defaultValue = 'N/A'}) {
    if (value == null) return defaultValue;
    if (value is String) return value.isEmpty ? defaultValue : value;
    if (value is int || value is double) return value.toString();
    return value.toString();
  }

  @override
  void initState() {
    super.initState();
    challanBloc = ChallanBloc();
    globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    challanBloc.add(FetchChallanDetailsInBillEvent(orderKey: widget.orderKey));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      barcodeFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
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
    unitPriceController.dispose();
    remarkController.dispose();
    chalanDateController.dispose();
    addScannedBarcodeController.dispose();
    barcodeFocusNode.dispose();
    challanRemarkController.dispose();
    challanNoController.dispose();
    challanBloc.close();
    globalBloc.close();
    super.dispose();
  }

  Widget buildModernAddButton() {
    return BlocConsumer<GlobalBloc, GlobalState>(
      bloc: globalBloc,
      listenWhen: (previous, current) =>
          current is ChallanRoundDetailsLoadedSuccessStatus ||
          current is ChallanRoundDetailsLoadedFailureStatus,
      listener: (context, state) {
        if (state is ChallanRoundDetailsLoadedSuccessStatus) {
          final roundDetails = state.dataModel;
          if (roundDetails.status == 1) {
            ToastService.instance.showSuccess(
              context,
              roundDetails.message.toString(),
            );
            showRoundDetailsPopDialogBox(roundDetails.record!);
          } else {
            ToastService.instance.showError(
              context,
              roundDetails.message?.toString() ??
                  'Failed to fetch round details',
            );
          }
        } else if (state is ChallanRoundDetailsLoadedFailureStatus) {
          ToastService.instance.showError(context, state.errorMessage);
        }
      },
      builder: (BuildContext context, GlobalState state) {
        print('DEBUG: GlobalBloc state = ${state.runtimeType}'); // Debug print
        final isLoading = state is GlobalLoadingStatus;

        return SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: isLoading || addScannedBarcodeController.text.isEmpty
                ? null
                : () {
                    if (addScannedBarcodeController.text.isNotEmpty) {
                      globalBloc.add(
                        FetchRoundDetailsEvent(
                          batchCode: addScannedBarcodeController.text,
                        ),
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: kButtonColor,
              disabledBackgroundColor: const Color(0xFFBFDBFE),
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white,
              elevation: isLoading ? 2 : 4,
              shadowColor: const Color(0xFF2D8FCF).withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Submit Batch Code',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
          ),
        );
      },
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

  Widget buildAddChallanInfoWidget(challanKey) => BlocConsumer(
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
    required String clientName,
    required String clientPhone,
    required String gstin,
  }) => Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('M/s. $clientName'),
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
    if (rowUnitPriceControllers.length < products.length) {
      for (var i = rowUnitPriceControllers.length; i < products.length; i++) {
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
                        BlocListener(
                          bloc: globalBloc,
                          listener: (context, state) {
                            if (state is GlobalDeleteRecordSuccessStatus) {
                              if (state.deleteRecordEntity.status == 1) {
                                ToastService.instance.showSuccess(
                                  context,
                                  state.deleteRecordEntity.message.toString(),
                                );
                                challanBloc.add(
                                  FetchChallanDetailsInBillEvent(
                                    orderKey: widget.orderKey,
                                  ),
                                );
                              } else {
                                ToastService.instance.showError(
                                  context,
                                  state.deleteRecordEntity.message.toString(),
                                );
                              }
                            } else if (state is GlobalDeleteRecordErrorStatus) {
                              ToastService.instance.showError(
                                context,
                                state.message.toString(),
                              );
                            }
                          },
                          child: SizedBox(
                            width: double.infinity,
                            height: 25,
                            child: ElevatedButton(
                              onPressed: () {
                                DeleteConfirmationAlert.show(
                                  context,
                                  title: 'Delete Record',
                                  message:
                                      'Are Your to Delete This client Record',
                                  itemName: products[index].hsnCode.toString(),

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

  void showRoundDetailsPopDialogBox(RoundDetailsRecord record) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Round Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade600,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // _buildQtyField,
                    // Tape Information Card
                    _buildInfoCard('Tape Information', [
                      if (record.productType == 1) ...[
                        _buildDetailItem(
                          'Cut MM Meter',
                          _safeValue(record.cutMMMeter),
                        ),
                        _buildDetailItem(
                          'Pieces Per Carton',
                          _safeValue(record.piecesPerCarton),
                        ),
                        _buildDetailItem(
                          'Tape Length',
                          _safeValue(record.tapeLength),
                        ),
                      ],
                      if (record.productType == 2) ...[
                        _buildDetailItem('Size', _safeValue(record.size)),
                        _buildDetailItem(
                          'Stretch Weight',
                          _safeValue(record.stretchWeight),
                        ),
                        _buildDetailItem(
                          'Operation',
                          _safeValue(record.operation),
                        ),
                      ],
                      _buildDetailItem('Base', _safeValue(record.baseLabel)),
                      _buildDetailItem('Mic', _safeValue(record.micLabel)),
                    ]),
                    const SizedBox(height: 16),

                    // Base Information Card
                    // _buildInfoCard('Base Information', [
                    //   _buildDetailItem('Unit', widget.submitData.unitName),

                    // ]),
                    const SizedBox(height: 16),

                    // Mic Information Card
                    // _buildInfoCard('Mic Information', [
                    //   _buildDetailItem('Mic ID', _safeValue(record?.micID)),

                    // ]),
                    // const SizedBox(height: 16),

                    // Display Information Card
                    _buildInfoCard('Information', [
                      // _buildDetailItem(
                      //   'Show For',
                      //   _safeValue(record?.showFor),
                      // ),
                      // _buildDetailItem(
                      //   'Show Label',
                      //   _safeValue(record?.showLabel),
                      // ),
                      _buildDetailItem(
                        'Batch Code',
                        _safeValue(record.batchCode),
                      ),
                      _buildDetailItem('MFG', _safeValue(record.displayMFG)),

                      _buildDetailItem(
                        'Batch Remark',
                        _safeValue(record.batchRemark),
                      ),
                    ]),

                    // const SizedBox(height: 16),

                    // // Remarks Card
                    // _buildInfoCard('Remarks', []),
                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.3),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                GoRouter.of(context).pop();
                              },
                              icon: Icon(Icons.refresh_rounded, size: 20),
                              label: Text(
                                'Rescan',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange.shade600,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF2D7FD9).withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 3,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final data = RoundDataModel(
                                  productType: record.productType,
                                  size: record.size.toString(),
                                  stretchWeigh: record.stretchWeight.toString(),
                                  operation: record.operation.toString(),
                                  unitName: '',
                                  unitIndex: '',
                                  // quantity: quantityController.text,
                                  rKey: widget.orderKey.toString(),
                                  baseID: record.baseID.toString(),
                                  piecesPerCarton: record.piecesPerCarton
                                      .toString(),
                                  cutMMMeter: record.cutMMMeter.toString(),
                                  micID: record.micID.toString(),
                                  micLabel: record.micLabel.toString(),
                                  showFor: record.showFor?.toString() ?? '',
                                  tapeLength:
                                      record.tapeLength?.toString() ?? '',
                                  batchRemark:
                                      record.batchRemark?.toString() ?? '',
                                  baseLabel: record.baseLabel?.toString() ?? '',
                                  displayMFG:
                                      record.displayMFG?.toString() ?? '',
                                  displayMFGLabel:
                                      record.displayMFGLabel?.toString() ?? '',
                                  tapeWeight:
                                      record.tapeWeight?.toString() ?? '',
                                  showForLabel: '',
                                  batchID: addScannedBarcodeController.text,
                                  batchCode: record.batchCode?.toString() ?? '',
                                  quantity: '1',
                                );

                                // Save to Hive box
                                final box = Hive.box<RoundDataModel>(
                                  RoundDBHive.roundBox,
                                );
                                await box.add(data);

                                if (mounted) {
                                  ToastService.instance.showSuccess(
                                    context,
                                    'Round details saved successfully!',
                                  );
                                  GoRouter.of(context).pop();
                                }
                              },
                              icon: Icon(Icons.check_circle_rounded, size: 20),
                              label: Text(
                                'Submit',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2D7FD9),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close', style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 25,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Color(0xFF2D7FD9).withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.95),
              Colors.white.withOpacity(0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D7FD9),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2D7FD9).withOpacity(0.12),
                  Color(0xFF2D7FD9).withOpacity(0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Color(0xFF2D7FD9).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey.shade900,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
