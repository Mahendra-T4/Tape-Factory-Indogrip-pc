import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/custom_textfield.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/chalan/data/model/challan_details_model.dart';
import 'package:indogrip/features/chalan/presentation/bloc/challan_bloc.dart';
import 'package:indogrip/features/chalan/presentation/page/bill/bill_format_buiilder.dart';
import 'package:indogrip/features/chalan/presentation/page/scanned-carton/scanned_carton.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/refresh_button.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;

class BillFormate extends StatefulWidget {
  const BillFormate({super.key, required this.orderKey});
  final String orderKey;
  static const String routeName = '/bill-format';

  @override
  State<BillFormate> createState() => _BillFormateState();
}

class _BillFormateState extends BillFormatBuilder {
  final GlobalKey<ScaffoldState> statekey = GlobalKey<ScaffoldState>();
  // final GlobalKey _key = GlobalKey();

  final pw.TextStyle _pwTestTextStyle = pw.TextStyle(
    // fontSize: 14,
    fontWeight: pw.FontWeight.bold,
  );

  pw.TextStyle get _billTextStyle => pw.TextStyle(fontSize: 7);

  Future<Uint8List> _loadImageBytes(String imagePath) async {
    if (imagePath.startsWith('http')) {
      // Load from network
      final response = await http.get(Uri.parse(imagePath));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load network image: ${response.statusCode}');
      }
    } else {
      // Load from local assets
      return (await rootBundle.load(imagePath)).buffer.asUint8List();
    }
  }

  void _printBill(List<ChallanRecord>? data, bool isDisplay) async {
    final tapeLogoBytes = await _loadImageBytes(
      data!.first.additionalInfo!.mainLogo!,
    );
    final tapeLogo = pw.MemoryImage(tapeLogoBytes);

    final indogripLogoBytes = await _loadImageBytes(
      data.first.additionalInfo!.secondaryLogo!,
    );
    final indogripLogo = pw.MemoryImage(indogripLogoBytes);
    final List<String> termList = data.first.additionalInfo?.termList ?? [];

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        final pdf = pw.Document();
        pdf.addPage(
          pw.MultiPage(
            pageFormat: format,

            build: (pw.Context context) {
              return [
                pw.Container(
                  padding: pw.EdgeInsets.all(8),
                  margin: pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    color: PdfColor(0.97, 0.93, 0.89),
                    border: pw.Border.all(
                      color: PdfColor(1, 0.34, 0.13),
                      width: 1,
                    ),
                    // borderRadius: pw.BorderRadius.circular(12),
                  ),
                  child: pw.Column(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      // topHeaderRow
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'GSTIN: ${data.first.additionalInfo!.gSTIN ?? ''}',
                            style: pw.TextStyle(fontSize: 12),
                          ),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text(
                                'CALL : ${data.first.additionalInfo!.mobileNumber ?? ''}',
                                style: pw.TextStyle(fontSize: 12),
                              ),
                              pw.Text(
                                'WhatsApp: ${data.first.additionalInfo!.whatsApp ?? ''}',
                                style: pw.TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      // logoRowNo2
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Image(tapeLogo, width: 80, height: 35),
                          pw.Image(indogripLogo, width: 80, height: 35),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      // businessInfoWidget
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Text(
                                  data.first.additionalInfo!.manufactureOf ??
                                      '',
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Text(
                                  data.first.additionalInfo!.wholesaler ?? '',
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      // Divider
                      pw.Divider(thickness: 2, color: PdfColor(1, 0.34, 0.13)),
                      pw.SizedBox(height: 8),
                      // Row with details
                      pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'M/s. ${clientName ?? data.first.clientInformation!.cConsigneeName}',
                                  style: pw.TextStyle(fontSize: 9),
                                ),

                                pw.SizedBox(height: 3),
                                pw.Text(
                                  'Contact No.: ${data.first.clientInformation!.cMobileNumber ?? ''}',
                                  style: pw.TextStyle(fontSize: 8),
                                ),
                                pw.SizedBox(height: 3),
                                pw.Text(
                                  'Party\'s GSTIN: ${data.first.clientInformation!.cGSTIN ?? ''}',
                                  style: pw.TextStyle(fontSize: 8),
                                ),
                              ],
                            ),
                          ),
                          pw.Container(
                            width: 2,
                            height: 50,
                            color: PdfColor(1, 0.34, 0.13),
                          ),
                          pw.SizedBox(width: 5),
                          pw.Expanded(
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              // border: pw.TableBorder.all(),
                              children: [
                                pw.Text(
                                  'ChallanNo.: ${data.first.orderInformation!.challanNumber ?? ''}',
                                  style: pw.TextStyle(fontSize: 8),
                                ),
                                pw.SizedBox(height: 3),
                                pw.Text(
                                  'DT.: ${data.first.orderInformation!.dateTime ?? ''}',
                                  style: pw.TextStyle(fontSize: 8),
                                ),
                                pw.SizedBox(height: 3),
                              ],
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      // dataTableWidget - Professional Table
                      pw.Table(
                        border: pw.TableBorder.all(),
                        defaultColumnWidth: const pw.FlexColumnWidth(),
                        columnWidths: {
                          1: const pw.FlexColumnWidth(2.3),
                          if (!isDisplay) 2: const pw.FlexColumnWidth(2.3),
                        },
                        children: [
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.all(4),
                                child: pw.Center(
                                  child: pw.Text(
                                    'S.NO.',
                                    style: _billTextStyle,
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(4),
                                child: pw.Center(
                                  child: pw.Text(
                                    'Material',
                                    style: _billTextStyle,
                                  ),
                                ),
                              ),
                              if (!isDisplay)
                                pw.Padding(
                                  padding: pw.EdgeInsets.all(4),
                                  child: pw.Center(
                                    child: pw.Text(
                                      'Material',
                                      style: _billTextStyle,
                                    ),
                                  ),
                                ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(4),
                                child: pw.Center(
                                  child: pw.Text(
                                    'HSN Code',
                                    style: _billTextStyle,
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(4),
                                child: pw.Center(
                                  child: pw.Text(
                                    'Unit Price',
                                    style: _billTextStyle,
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(4),
                                child: pw.Center(
                                  child: pw.Text(
                                    'Quantity',
                                    style: _billTextStyle,
                                  ),
                                ),
                              ),
                              if (!isDisplay)
                                pw.Padding(
                                  padding: pw.EdgeInsets.all(4),
                                  child: pw.Center(
                                    child: pw.Text(
                                      'Quantity',
                                      style: _billTextStyle,
                                    ),
                                  ),
                                ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(4),
                                child: pw.Center(
                                  child: pw.Text(
                                    'Price',
                                    style: _billTextStyle,
                                  ),
                                ),
                              ),
                              if (!isDisplay)
                                pw.Padding(
                                  padding: pw.EdgeInsets.all(4),
                                  child: pw.Center(
                                    child: pw.Text(
                                      'Price',
                                      style: _billTextStyle,
                                    ),
                                  ),
                                ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(4),
                                child: pw.Center(
                                  child: pw.Text(
                                    'Remark',
                                    style: _billTextStyle,
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(4),
                                child: pw.Center(
                                  child: pw.Text(
                                    'Return Date',
                                    style: _billTextStyle,
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(4),
                                child: pw.Center(
                                  child: pw.Text(
                                    'Return Qty',
                                    style: _billTextStyle,
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(4),
                                child: pw.Center(
                                  child: pw.Text(
                                    'Return Reason',
                                    style: _billTextStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ...List<pw.TableRow>.generate(
                            data.first.orderProduct!.length,
                            (index) {
                              final product = data.first.orderProduct![index];
                              return pw.TableRow(
                                children: [
                                  pw.Padding(
                                    padding: pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      '${index + 1}',
                                      style: _billTextStyle,
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      product.displayInformation ?? '',
                                      style: _billTextStyle,
                                    ),
                                  ),
                                  if (!isDisplay)
                                    pw.Padding(
                                      padding: pw.EdgeInsets.all(4),
                                      child: pw.Text(
                                        product.productInformation ?? '',
                                        style: _billTextStyle,
                                      ),
                                    ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      product.hsnCode?.toString() ?? '',
                                      style: _billTextStyle,
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      product.unitPrice?.toString() ?? '',
                                      style: _billTextStyle,
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      product.displayQty?.toString() ?? '',
                                      style: _billTextStyle,
                                    ),
                                  ),
                                  if (!isDisplay)
                                    pw.Padding(
                                      padding: pw.EdgeInsets.all(4),
                                      child: pw.Text(
                                        product.quantity?.toString() ?? '',
                                        style: _billTextStyle,
                                      ),
                                    ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      product.displayPrice?.toString() ?? '',
                                      style: _billTextStyle,
                                    ),
                                  ),
                                  if (!isDisplay)
                                    pw.Padding(
                                      padding: pw.EdgeInsets.all(4),
                                      child: pw.Text(
                                        product.productPrice?.toString() ?? '',
                                        style: _billTextStyle,
                                      ),
                                    ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      product.prRemarks ?? '',
                                      style: _billTextStyle,
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      product.returnDate ?? '',
                                      style: _billTextStyle,
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      product.returnQty?.toString() ?? '',
                                      style: _billTextStyle,
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      product.returnReason ?? '',
                                      style: _billTextStyle,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      // bottomDetailsWidget
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                data.first.additionalInfo?.termHeading ?? '',
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                data.first.additionalInfo?.companyName ?? '',
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          pw.SizedBox(height: 8),

                          ...termList.map(
                            (term) =>
                                pw.Text(term, style: pw.TextStyle(fontSize: 7)),
                          ),

                          pw.SizedBox(height: 20),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'Receiver\'s Signature',
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                'Authorised Signature',
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),
        );
        return pdf.save();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return StreamBuilder(
      stream: InternetConnectionService().connectionStream,
      initialData: true, // Assume connected initially
      builder: (context, snapshot) {
        // Handle error state
        if (snapshot.hasError) {
          return const NoInternetConnection();
        }

        // Handle disconnected state
        if (snapshot.data == false) {
          return const NoInternetConnection();
        }

        // Handle loading state
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          key: statekey,
          appBar: !Responsive.isDesktop(context)
              ? MobileAppBar(context, statekey, 'Challan Bill')
              : DesktopAppBar(context, statekey, 'Challan Bill', true),
          drawer: !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : null,
          body: BlocListener<GlobalBloc, GlobalState>(
            bloc: globalBloc,
            listener: (context, state) {
              print(
                'DEBUG: BlocListener received state = ${state.runtimeType}',
              );
              if (state is GlobalDeleteRecordSuccessStatus) {
                print(
                  'DEBUG: Delete success status received: ${state.deleteRecordEntity.status}',
                );
                if (state.deleteRecordEntity.status == 1) {
                  ToastService.instance.showSuccess(
                    context,
                    state.deleteRecordEntity.message.toString(),
                  );
                  print('DEBUG: Adding FetchChallanDetailsInBillEvent');
                  challanBloc.add(
                    FetchChallanDetailsInBillEvent(orderKey: widget.orderKey),
                  );
                } else {
                  ToastService.instance.showError(
                    context,
                    state.deleteRecordEntity.message.toString(),
                  );
                }
              }
            },
            child: BlocConsumer(
              bloc: challanBloc,
              listener: (context, state) {
                if (state is ChallanDetailsLoadedSuccessState) {
                  if (state.model.status == 1) {
                    ToastService.instance.showSuccess(
                      context,
                      state.model.message.toString(),
                    );
                    final newRemark =
                        state
                            .model
                            .record
                            ?.first
                            .orderInformation
                            ?.challanRemark ??
                        '';
                    final newChallanNo =
                        state
                            .model
                            .record
                            ?.first
                            .orderInformation
                            ?.manualChallanNumber ??
                        '';
                    final newChallanDate =
                        state
                            .model
                            .record
                            ?.first
                            .orderInformation
                            ?.manualChallanDate ??
                        '';
                    final newClientKey =
                        state
                            .model
                            .record
                            ?.first
                            .clientInformation
                            ?.clientKey ??
                        '';
                    final newClientUnitName =
                        state.model.record?.first.clientInformation?.unitName ??
                        '';

                    // Update state variables with setState to trigger rebuild
                    setState(() {
                      if (selectedClientKey != newClientKey) {
                        selectedClientKey = newClientKey;
                      }
                      if (clientUnitName != newClientUnitName) {
                        clientUnitName = newClientUnitName;
                      }
                    });

                    // Only update if values actually changed to prevent rebuild loops
                    if (remarkController.text != newRemark) {
                      remarkController.text = newRemark;
                    }
                    if (challanNoController.text != newChallanNo) {
                      challanNoController.text = newChallanNo;
                    }
                    if (chalanDateController.text != newChallanDate) {
                      chalanDateController.text = newChallanDate;
                    }
                  } else {
                    ToastService.instance.showError(
                      context,
                      state.model.message.toString(),
                    );
                  }
                }
              },

              builder: (context, state) {
                switch (state.runtimeType) {
                  case ChallanLoadingState:
                    return const Center(child: CircularProgressIndicator());
                  case ChallanDetailsLoadedSuccessState:
                    final data = (state as ChallanDetailsLoadedSuccessState)
                        .model
                        .record;
                    final totalCartons = data?.first.orderProduct?.fold(
                      0,
                      (int sum, product) => sum + (product.quantity ?? 0),
                    );
                    return state.model.status != 1
                        ? Center(
                            child: Text(
                              state.model.message ?? 'try again please',
                            ),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                SizedBox(height: 25),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                  ),
                                  child: Row(
                                    spacing: 16,
                                    children: [
                                      Expanded(child: SizedBox()),
                                      // Expanded(child: SizedBox()),
                                      // Expanded(child: verifyButton),
                                      Expanded(
                                        child: CustomButton(
                                          label: 'Print Display',
                                          onPressed: () =>
                                              _printBill(data, false),
                                        ),
                                      ),
                                      Expanded(
                                        child: CustomButton(
                                          label: 'Print Display Challan',
                                          onPressed: () =>
                                              _printBill(data, true),
                                        ),
                                      ),

                                      Expanded(
                                        child: CustomButton(
                                          label: 'View Scanned Cartons',
                                          onPressed: () => context.pushNamed(
                                            ScannedCarton.routeName,
                                            extra: ScannedData(
                                              rKey: widget.orderKey,
                                              clientKey: selectedClientKey!,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 25),

                                Center(
                                  child: Container(
                                    width: size.width / .9,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      // height: size.height,  // Removed to prevent layout issues
                                      padding: const EdgeInsets.all(12),
                                      color: Color(0xfff7ede2).withAlpha(128),

                                      child: Container(
                                        // margin: const EdgeInsets.symmetric(vertical: 12),
                                        padding: const EdgeInsets.all(12),
                                        // height: size.height * 3,
                                        width: size.width / 3,

                                        decoration: BoxDecoration(
                                          color: Color(
                                            0xfff7ede2,
                                          ).withAlpha(128),
                                          border: Border.all(
                                            color: Colors.deepOrangeAccent,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          // color: Colors.white,
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            spacing: 15,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              topHeaderRow(
                                                gstinNo: data!
                                                    .first
                                                    .additionalInfo!
                                                    .gSTIN
                                                    .toString(),
                                                callNo: data
                                                    .first
                                                    .additionalInfo!
                                                    .mobileNumber
                                                    .toString(),
                                                whatsAppNo: data
                                                    .first
                                                    .additionalInfo!
                                                    .whatsApp
                                                    .toString(),
                                              ),
                                              logoRowNo2(
                                                data
                                                    .first
                                                    .additionalInfo!
                                                    .mainLogo
                                                    .toString(),
                                                data
                                                    .first
                                                    .additionalInfo!
                                                    .secondaryLogo
                                                    .toString(),
                                              ),
                                              businessInfoWidget(
                                                manufactureOf:
                                                    state
                                                        .model
                                                        .record
                                                        ?.first
                                                        .additionalInfo
                                                        ?.manufactureOf ??
                                                    '',
                                                wholesaler:
                                                    state
                                                        .model
                                                        .record
                                                        ?.first
                                                        .additionalInfo
                                                        ?.wholesaler ??
                                                    '',
                                              ),

                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      MediaQuery.sizeOf(
                                                        context,
                                                      ).width *
                                                      0.025,
                                                ),
                                                child: Divider(
                                                  height: 2,

                                                  thickness: 3,
                                                  color:
                                                      Colors.deepOrangeAccent,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: leftSideDetailsFillContainer(
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedClientKey =
                                                              value;
                                                          clientUnitName = state
                                                              .model
                                                              .record
                                                              ?.first
                                                              .clientInformation
                                                              ?.unitName;
                                                        });
                                                      },
                                                      clientKey:
                                                          data
                                                              .first
                                                              .clientInformation
                                                              ?.clientKey ??
                                                          '',

                                                      clientPhone:
                                                          data
                                                              .first
                                                              .clientInformation
                                                              ?.cMobileNumber ??
                                                          '',
                                                      gstin:
                                                          data
                                                              .first
                                                              .clientInformation
                                                              ?.cGSTIN ??
                                                          '',
                                                      // orderKey: widget.orderKey
                                                      //     .toString(),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 3,
                                                    height: 90,
                                                    color:
                                                        Colors.deepOrangeAccent,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    child:
                                                        rightSideDetailsFillContainer(
                                                          challanNo: data
                                                              .first
                                                              .orderInformation!
                                                              .challanNumber
                                                              .toString(),
                                                          challanDate: data
                                                              .first
                                                              .orderInformation!
                                                              .dateTime
                                                              .toString(),

                                                          // orderNo: '',
                                                          // orderDate: '',
                                                        ),
                                                  ),
                                                ],
                                              ),

                                              dataTableWidget(
                                                state.model.record,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(child: SizedBox()),
                                                  Expanded(child: SizedBox()),
                                                  Expanded(child: SizedBox()),
                                                  Expanded(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      margin:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 12,
                                                            // horizontal: 12,
                                                          ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 12,
                                                            horizontal: 20,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                          color: Colors
                                                              .deepOrangeAccent,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),

                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Total Cartons: ',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            totalCartons
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .deepOrangeAccent,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                spacing: 10,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Remark'),
                                                  CustomTextField(
                                                    controller:
                                                        remarkController,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                spacing: 16,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      spacing: 10,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text('Challan Number'),
                                                        CustomTextField(
                                                          controller:
                                                              challanNoController,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: buildDateField(
                                                      'Challan Date',
                                                      chalanDateController,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                spacing: 16,
                                                children: [
                                                  Expanded(child: SizedBox()),
                                                  Expanded(child: SizedBox()),
                                                  Expanded(child: SizedBox()),
                                                  Expanded(
                                                    child:
                                                        buildAddChallanInfoWidget(
                                                          state
                                                              .model
                                                              .record
                                                              ?.first
                                                              .rKey,
                                                          state
                                                              .model
                                                              .record
                                                              ?.first
                                                              .clientInformation
                                                              ?.clientKey
                                                              .toString(),
                                                          state
                                                              .model
                                                              .record
                                                              ?.first
                                                              .clientInformation
                                                              ?.unitName
                                                              .toString(),
                                                        ),
                                                  ),
                                                ],
                                              ),

                                              bottomDetailsWidget(
                                                termHeading:
                                                    state
                                                        .model
                                                        .record
                                                        ?.first
                                                        .additionalInfo
                                                        ?.termHeading ??
                                                    '',
                                                termHeading2:
                                                    state
                                                        .model
                                                        .record
                                                        ?.first
                                                        .additionalInfo
                                                        ?.companyName ??
                                                    '',
                                                termList:
                                                    state
                                                        .model
                                                        .record
                                                        ?.first
                                                        .additionalInfo
                                                        ?.termList ??
                                                    [],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // SizedBox(height: 30),
                                SizedBox(height: 50),
                              ],
                            ),
                          );
                  case ChallanDetailsLoadedFailureState:
                    final errorState =
                        state as ChallanDetailsLoadedFailureState;
                    return Center(
                      child: Text('Error: ${errorState.errorMessage}'),
                    );
                  default:
                    return const Center(child: Text('Unexpected state'));
                }
              },
            ),
          ),
          floatingActionButton: SizedBox(
            width: MediaQuery.sizeOf(context).width * .15,
            height: 35,
            child: RefreshButton(
              onPressed: () {
                challanBloc.add(
                  FetchChallanDetailsInBillEvent(orderKey: widget.orderKey),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldlabelText(label),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: TextFormField(
              controller: controller,
              readOnly: true,
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  setState(() {
                    controller.text = DateFormat(
                      'yyyy-MM-dd',
                    ).format(selectedDate);
                  });
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF9499A1)),
                  borderRadius: BorderRadius.circular(5),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                suffixIcon: const Icon(
                  Icons.calendar_month,
                  color: Color(0xFF2D8FCF),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select $label';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
