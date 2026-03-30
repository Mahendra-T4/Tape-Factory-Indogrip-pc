import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/utils/widgets/custom_date_picker.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/chalan/data/model/challan_details_model.dart';
import 'package:indogrip/features/chalan/data/model/return_product.dart';
import 'package:indogrip/features/chalan/data/model/verify_challan_product_param.dart';
import 'package:indogrip/features/chalan/presentation/bloc/challan_bloc.dart';
import 'package:indogrip/features/chalan/presentation/page/bill/bill_formate.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';

abstract class BillFormatBuilder extends State<BillFormate> {
  late final ChallanBloc challanBloc;
  late final GlobalBloc globalBloc;
  final unitPriceController = TextEditingController();
  final remarkController = TextEditingController();
  final chalanDateController = TextEditingController();
  final List<TextEditingController> rowUnitPriceControllers = [];
  final List<TextEditingController> rowDisplayQuantityControllers = [];
  final List<TextEditingController> rowRemarkControllers = [];
  final List<FocusNode> rowUnitPriceFocusNodes = [];
  final List<FocusNode> rowDisplayQuantityFocusNodes = [];
  final List<FocusNode> rowRemarkFocusNodes = [];
  final List<double> rowDisplayPrices = [];

  TextStyle _testTextStyle = TextStyle(
    // fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  @override
  void initState() {
    super.initState();
    challanBloc = ChallanBloc();
    globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    challanBloc.add(FetchChallanDetailsInBillEvent(orderKey: widget.orderKey));
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
    for (final controller in rowUnitPriceControllers) {
      controller.dispose();
    }
    for (final controller in rowDisplayQuantityControllers) {
      controller.dispose();
    }
    for (final controller in rowRemarkControllers) {
      controller.dispose();
    }
    unitPriceController.dispose();
    remarkController.dispose();
    chalanDateController.dispose();
    challanBloc.close();
    globalBloc.close();
    super.dispose();
  }

  Widget get topHeaderRow => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'GSTIN: 08AAYPS5383A2Z4',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'CALL : +91 75979 18725',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            'WhatsApp: +91 97996 45000',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ],
  );

  Widget get logoRowNo2 => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Image.asset('assets/images/tap_factory.jpg', height: 50, width: 150),
      Image.asset('assets/images/tap_factory.jpg', height: 50, width: 150),
    ],
  );

  Widget get businessInfoWidget => Column(
    spacing: 5,
    children: [
      Row(
        children: [
          Text(
            'Manufacture of: ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.deepOrangeAccent,
              // fontSize: 16.5,
            ),
          ),
          Expanded(
            child: Text(
              'Stretch Films, Bopp Packing Tapes, Self Adhesive Packing Tapes, Abro Tapes',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                // fontSize: 16,
              ),
            ),
          ),
        ],
      ),

      Row(
        children: [
          Text(
            'Wholesaler: ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.deepOrangeAccent,
              // fontSize: 16.5,
            ),
          ),
          Expanded(
            child: Text(
              'Silica Gel, Plastic Roll, LD, HD Packing Strips, Sutli',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                // fontSize: 16,
              ),
            ),
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
    required String orderNo,
    required String orderDate,
  }) => Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ChallanNo.: $challanNo'),
        Text('DT. $challanDate'),
        Text('Order No.: $orderNo'),
        Text('DT. $orderDate'),
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
        rowDisplayQuantityControllers.add(TextEditingController());
        rowRemarkControllers.add(TextEditingController());
        rowUnitPriceFocusNodes.add(FocusNode());
        rowDisplayQuantityFocusNodes.add(FocusNode());
        rowRemarkFocusNodes.add(FocusNode());
        rowDisplayPrices.add(0);
      }
    }

    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.9,
      child: Table(
        border: TableBorder.all(color: Colors.black, width: 1),
        columnWidths: {
          0: FixedColumnWidth(70),
          // 1: FlexColumnWidth(2),
          // 2: FlexColumnWidth(2),
          // 3: FixedColumnWidth(80),
          // 4: FixedColumnWidth(80),
          // 5: FixedColumnWidth(100),
          // 6: FixedColumnWidth(100),
          // 7: FixedColumnWidth(80),
          // 8: FlexColumnWidth(2),
          // 9: FixedColumnWidth(80),
        },
        children: [
          TableRow(
            children: [
              Padding(padding: EdgeInsets.all(8), child: Text('S.NO.')),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('Display Material'),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('Actual Material'),
              ),
              Padding(padding: EdgeInsets.all(8), child: Text('HSN Code')),
              Padding(padding: EdgeInsets.all(8), child: Text('Unit Price')),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('Display Quantity'),
              ),
              Padding(padding: EdgeInsets.all(8), child: Text('Quantity')),
              Padding(padding: EdgeInsets.all(8), child: Text('Display Price')),
              Padding(padding: EdgeInsets.all(8), child: Text('Price')),

              Padding(padding: EdgeInsets.all(8), child: Text('Remark')),
              Padding(padding: EdgeInsets.all(8), child: Text('Return Date')),
              Padding(padding: EdgeInsets.all(8), child: Text('Return Qty')),
              Padding(padding: EdgeInsets.all(8), child: Text('Return Reason')),

              Padding(padding: EdgeInsets.all(8), child: Text('Action')),
            ],
          ),
          ...List<TableRow>.generate(
            products.length,
            (index) => TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('${index + 1}'),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(products[index].displayInformation.toString()),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(products[index].productInformation.toString()),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(products[index].hsnCode.toString()),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      rowUnitPriceFocusNodes[index].requestFocus();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextFormField(
                        focusNode: rowUnitPriceFocusNodes[index],
                        controller: rowUnitPriceControllers[index],
                        textAlignVertical: TextAlignVertical.center,
                        maxLines: 5,
                        onChanged: (value) {
                          setState(() {
                            final unit = double.tryParse(value) ?? 0;
                            final qty =
                                double.tryParse(
                                  rowDisplayQuantityControllers[index].text,
                                ) ??
                                0;
                            rowDisplayPrices[index] = unit * qty;
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      rowDisplayQuantityFocusNodes[index].requestFocus();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextFormField(
                        focusNode: rowDisplayQuantityFocusNodes[index],
                        controller: rowDisplayQuantityControllers[index],
                        textAlignVertical: TextAlignVertical.center,
                        maxLines: 5,
                        onChanged: (value) {
                          setState(() {
                            final unit =
                                double.tryParse(
                                  rowUnitPriceControllers[index].text,
                                ) ??
                                0;
                            final qty = double.tryParse(value) ?? 0;
                            rowDisplayPrices[index] = unit * qty;
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.all(8),
                //   child: Text(
                //     record.first.orderProduct![index].quantity.toString(),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(products[index].quantity.toString()),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(rowDisplayPrices[index].toString()),
                ),

                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    ((double.tryParse(rowUnitPriceControllers[index].text) ??
                                0) *
                            (double.tryParse(
                                  products[index].quantity?.toString() ?? '',
                                ) ??
                                0))
                        .toString(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      rowRemarkFocusNodes[index].requestFocus();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextFormField(
                        focusNode: rowRemarkFocusNodes[index],
                        controller: rowRemarkControllers[index],
                        textAlignVertical: TextAlignVertical.center,
                        maxLines: 5,
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(products[index].returnDate ?? ''),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(products[index].returnQty?.toString() ?? ''),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(products[index].returnReason ?? ''),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      products[index].productStatus == 2
                          ? buildVerifyProductButton(
                              VerifyProductParam(
                                productKey: products[index].productKey
                                    .toString(),
                                unitPrice:
                                    rowUnitPriceControllers[index]
                                        .text
                                        .isNotEmpty
                                    ? rowUnitPriceControllers[index].text
                                    : products[index].unitPrice.toString(),
                                displayQty:
                                    rowDisplayQuantityControllers[index]
                                        .text
                                        .isNotEmpty
                                    ? rowDisplayQuantityControllers[index].text
                                    : products[index].quantity.toString(),
                                prRemarks: rowRemarkControllers[index].text,
                              ),
                            )
                          : buildUnVerifyProductButton(
                              products[index].productKey.toString(),
                            ),
                      SizedBox(height: 4),
                      ElevatedButton(
                        onPressed: () {
                          showReturnReasonDialog(
                            context,
                            products[index].productKey.toString(),
                          );
                          // context.pop();
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
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color?>((
                                    Set<MaterialState> states,
                                  ) {
                                    if (states.contains(
                                      MaterialState.hovered,
                                    )) {
                                      return Colors.red.shade700;
                                    }
                                    if (states.contains(
                                      MaterialState.pressed,
                                    )) {
                                      return Colors.red.shade800;
                                    }
                                    return null;
                                  }),
                            ),
                        child: Text('Return', style: TextStyle(fontSize: 10)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            growable: true,
          ),
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
      buildWhen: (previous, current) =>
          current is GlobalLoadingStatus ||
          current is ChallanProductVerifySuccessState ||
          current is ChallanProductVerifyFailureState,
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
      buildWhen: (previous, current) =>
          current is GlobalLoadingStatus3 ||
          current is ReturnChallanProductSuccessState ||
          current is ReturnChallanProductFailureState,
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

  Widget get bottomDetailsWidget => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'All Orders & P.O. to Below Whatsapp on :  9799645000',
            style: _testTextStyle,
          ),
          Text('For : The Tape Factory', style: _testTextStyle),
        ],
      ),
      SizedBox(height: 15),
      Text(
        '1.  This clerify that we have valid registration under GST & information is true & correct',
      ),
      Text('2.  Good once sold will not be taken back.'),
      Text(
        '3.  Payment to be made on demand otherwise interest of 24% will be charged from the date of sales.',
      ),
      Text('4.  Subject to Jodhpur Juisdiction 5 E & Q E'),
      Text(
        'This clerify that we have valid registration under GST & information is true & correct.',
      ),
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
