import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/custom_textfield.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/features/chalan/data/model/challan_details_model.dart';
import 'package:indogrip/features/chalan/presentation/bloc/challan_bloc.dart';
import 'package:indogrip/features/chalan/presentation/page/bill/bill_format_buiilder.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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

  void _printBill(List<ChallanRecord>? data) async {
    final logoImage = await rootBundle.load('assets/images/tap_factory.jpg');
    final logo = pw.MemoryImage(logoImage.buffer.asUint8List());

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        final pdf = pw.Document();
        pdf.addPage(
          pw.Page(
            pageFormat: format,
            build: (pw.Context context) {
              return pw.Container(
                padding: pw.EdgeInsets.all(12),
                margin: pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColor(0.97, 0.93, 0.89),
                  border: pw.Border.all(
                    color: PdfColor(1, 0.34, 0.13),
                    width: 1,
                  ),
                  // borderRadius: pw.BorderRadius.circular(12),
                ),
                child: pw.Column(
                  children: [
                    // topHeaderRow
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'GSTIN: 08AAYPS5383A2Z4',
                          style: pw.TextStyle(fontSize: 16),
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                              'CALL : +91 75979 18725',
                              style: pw.TextStyle(fontSize: 16),
                            ),
                            pw.Text(
                              'WhatsApp: +91 97996 45000',
                              style: pw.TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 15),
                    // logoRowNo2
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Image(logo, width: 120, height: 50),
                        pw.Image(logo, width: 120, height: 50),
                      ],
                    ),
                    pw.SizedBox(height: 15),
                    // businessInfoWidget
                    pw.Column(
                      children: [
                        pw.Row(
                          children: [
                            pw.Text(
                              'Manufacture of: ',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor(1, 0.34, 0.13),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                'Stretch Films, Bopp Packing Tapes, Self Adhesive Packing Tapes, Abro Tapes',
                              ),
                            ),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Text(
                              'Wholesaler: ',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor(1, 0.34, 0.13),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                'Silica Gel, Plastic Roll, LD, HD Packing Strips, Sutli',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 15),
                    // Divider
                    pw.Divider(thickness: 3, color: PdfColor(1, 0.34, 0.13)),
                    pw.SizedBox(height: 15),
                    // Row with details
                    pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'M/s. ${data!.first.clientInformation!.cConsigneeName ?? ''}',
                              ),
                              pw.SizedBox(height: 5),
                              pw.Text('________________________________'),
                              pw.SizedBox(height: 5),
                              pw.Text('Contact No.:______________________'),
                              pw.SizedBox(height: 5),
                              pw.Text('Party\'s GSTIN:_____________________'),
                            ],
                          ),
                        ),
                        pw.Container(
                          width: 3,
                          height: 60,
                          color: PdfColor(1, 0.34, 0.13),
                        ),
                        pw.SizedBox(width: 8),
                        pw.Expanded(
                          child: pw.Column(
                            // border: pw.TableBorder.all(),
                            children: [
                              pw.Text('ChallanNo.: ______________________'),
                              pw.SizedBox(height: 5),
                              pw.Text('DT._____________________________'),
                              pw.SizedBox(height: 5),
                              pw.Text('Order No.:_______________________'),
                              pw.SizedBox(height: 5),
                              pw.Text('DT._____________________________'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 15),
                    // dataTableWidget
                    pw.Table(
                      border: pw.TableBorder.all(),

                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.all(4),
                              child: pw.Center(child: pw.Text('S.NO.')),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(4),
                              child: pw.Center(
                                child: pw.Text('Display Material'),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(4),
                              child: pw.Center(
                                child: pw.Text('Actual Material'),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(4),
                              child: pw.Center(child: pw.Text('HSN Code')),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(4),
                              child: pw.Center(child: pw.Text('Unit Price')),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(4),
                              child: pw.Center(
                                child: pw.Text('Display Quantity'),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(4),
                              child: pw.Center(
                                child: pw.Text('Actual Quantity'),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(4),
                              child: pw.Center(child: pw.Text('Unit')),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(4),
                              child: pw.Center(child: pw.Text('Price')),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(4),
                              child: pw.Center(child: pw.Text('Display Price')),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(4),
                              child: pw.Center(child: pw.Text('Remark')),
                            ),
                          ],
                        ),
                        ...List<pw.TableRow>.generate(
                          data.first.orderProduct!.length,
                          (index) => pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.all(10),
                                child: pw.Text('${index + 1}'),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(10),
                                child: pw.Text(''),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(10),
                                child: pw.Text(
                                  data
                                          .first
                                          .orderProduct![index]
                                          .productInformation ??
                                      '',
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(10),
                                child: pw.Text(
                                  data.first.orderProduct![index].hsnCode
                                          ?.toString() ??
                                      '',
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(10),
                                child: pw.Text(
                                  data.first.orderProduct![index].unitPrice
                                          ?.toString() ??
                                      '',
                                ), // Unit, perhaps add if available
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(10),
                                child: pw.Text(
                                  '',
                                ), // Unit, perhaps add if available
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(10),
                                child: pw.Text(
                                  data.first.orderProduct![index].quantity
                                          ?.toString() ??
                                      '',
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(10),
                                child: pw.Text(''),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(10),
                                child: pw.Text(
                                  data.first.orderProduct![index].productPrice
                                          ?.toString() ??
                                      '',
                                ),
                              ),

                              pw.Padding(
                                padding: pw.EdgeInsets.all(10),
                                child: pw.Text(
                                  '',
                                ), // Unit, perhaps add if available
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 15),
                    // bottomDetailsWidget
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'All Orders & P.O. to Below Whatsapp on :  9799645000',
                              style: _pwTestTextStyle,
                            ),
                            pw.Text(
                              'For : The Tape Factory',
                              style: _pwTestTextStyle,
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 15),

                        pw.Text(
                          '1. This clarify that we have valid registration under GST & information is true & correct.',
                        ),
                        pw.Text('2. Good once sold will not be taken back.'),
                        pw.Text('3. Subject to Jodhpur Jurisdiction 5 E & Q E'),
                        pw.Text(
                          '4. Payment to be made on demand otherwise interest of 24% will be charged from the date of sales.',
                        ),
                        pw.SizedBox(height: 40),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Receiver\'s Signature',
                              style: _pwTestTextStyle,
                            ),
                            pw.Text(
                              'Authorised Signature',
                              style: _pwTestTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
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
          body: BlocConsumer(
            bloc: challanBloc,
            listener: (context, state) {},
            builder: (context, state) {
              switch (state.runtimeType) {
                case ChallanLoadingState:
                  return const Center(child: CircularProgressIndicator());
                case ChallanDetailsLoadedSuccessState:
                  final data =
                      (state as ChallanDetailsLoadedSuccessState).model.record;
                  // unitPriceController.text = data!
                  //     .first
                  //     .orderProduct!
                  //     .first
                  //     .unitPrice
                  //     .toString();
                  return state.model.status != 1
                      ? Center(child: Text(state.model.message.toString()))
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
                                    // Expanded(child: SizedBox()),
                                    Expanded(child: SizedBox()),
                                    Expanded(child: verifyButton),
                                    Expanded(
                                      child: CustomButton(
                                        label: 'Print Challan ',
                                        onPressed: () => _printBill(data),
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomButton(
                                        label: 'Print Challan',
                                        onPressed: () => _printBill(data),
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
                                        color: Color(0xfff7ede2).withAlpha(128),
                                        border: Border.all(
                                          color: Colors.deepOrangeAccent,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        // color: Colors.white,
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          spacing: 15,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            topHeaderRow,
                                            logoRowNo2,
                                            businessInfoWidget,

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
                                                color: Colors.deepOrangeAccent,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child:
                                                      leftSideDetailsFillContainer(
                                                        clientName: data!
                                                            .first
                                                            .clientInformation!
                                                            .cConsigneeName
                                                            .toString(),
                                                        clientPhone: '',
                                                        gstin: '',
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
                                                        challanNo: '',
                                                        challanDate: '',
                                                        orderNo: '',
                                                        orderDate: '',
                                                      ),
                                                ),
                                              ],
                                            ),
                                            dataTableWidget(state.model.record),
                                            Column(
                                              spacing: 10,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Remark'),
                                                CustomTextField(
                                                  controller: remarkController,
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
                                                            remarkController,
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

                                            bottomDetailsWidget,
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
                  final errorState = state as ChallanDetailsLoadedFailureState;
                  return Center(
                    child: Text('Error: ${errorState.errorMessage}'),
                  );
                default:
                  return const Center(child: Text('Unexpected state'));
              }
            },
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
