import 'package:flutter/material.dart';
import 'package:indogrip/features/chalan/data/model/challan_details_model.dart';
import 'package:indogrip/features/chalan/presentation/bloc/challan_bloc.dart';
import 'package:indogrip/features/chalan/presentation/page/bill/bill_formate.dart';

abstract class BillFormatBuilder extends State<BillFormate> {
  late final ChallanBloc challanBloc;
  final unitPriceController = TextEditingController();
  final remarkController = TextEditingController();
  final chalanDateController = TextEditingController();
  String? unitPrice;
  String? remark;
  String? displayQuantity;

  TextStyle _testTextStyle = TextStyle(
    // fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  @override
  void initState() {
    super.initState();
    challanBloc = ChallanBloc();
    challanBloc.add(FetchChallanDetailsInBillEvent(orderKey: widget.orderKey));
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
    // unitPriceController.text = record!.first.orderProduct!.first.unitPrice
    // .toString();
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
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('Actual Quantity'),
              ),
              Padding(padding: EdgeInsets.all(8), child: Text('Display Price')),
              Padding(padding: EdgeInsets.all(8), child: Text('Price')),
              Padding(padding: EdgeInsets.all(8), child: Text('Remark')),
              Padding(padding: EdgeInsets.all(8), child: Text('Action')),
            ],
          ),
          ...List<TableRow>.generate(
            record!.first.orderProduct!.length,
            (index) => TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('${index + 1}'),
                ),
                Padding(padding: EdgeInsets.all(8), child: Text('')),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    record.first.orderProduct![index].productInformation
                        .toString(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    record.first.orderProduct![index].hsnCode.toString(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 15),
                    height: 30,
                    child: Center(
                      child: TextFormField(
                        initialValue: record
                            .first
                            .orderProduct![index]
                            .unitPrice
                            .toString(),
                        onChanged: (value) {
                          setState(() {
                            unitPrice = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusColor: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 15),
                    height: 30,
                    child: Center(
                      child: TextFormField(
                        initialValue: '',
                        onChanged: (value) {
                          setState(() {
                            displayQuantity = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusColor: Colors.blueAccent,
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
                  child: Text(
                    record.first.orderProduct![index].quantity.toString(),
                  ),
                ),
                Padding(padding: EdgeInsets.all(8), child: Text('')),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    record.first.orderProduct![index].productPrice.toString(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 15),
                    height: 30,
                    child: Center(
                      child: TextFormField(
                        initialValue: '',
                        onChanged: (value) {
                          setState(() {
                            remark = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusColor: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle verify action
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
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color?>((
                                    Set<MaterialState> states,
                                  ) {
                                    if (states.contains(
                                      MaterialState.hovered,
                                    )) {
                                      return Colors.green.shade700;
                                    }
                                    if (states.contains(
                                      MaterialState.pressed,
                                    )) {
                                      return Colors.green.shade800;
                                    }
                                    return null;
                                  }),
                            ),
                        child: Text('Verify', style: TextStyle(fontSize: 10)),
                      ),
                      SizedBox(height: 4),
                      ElevatedButton(
                        onPressed: () {
                          showReturnReasonDialog(context);
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
          ),
        ],
      ),
    );
  }

  void showReturnReasonDialog(BuildContext context) {
    TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.4,
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
            content: TextField(
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
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  String reason = reasonController.text.trim();
                  if (reason.isNotEmpty) {
                    // Handle the reason, e.g., send to server or update state
                    print('Return reason: $reason');
                    // You can add logic here to process the reason
                    Navigator.of(context).pop();
                  } else {
                    // Show error if reason is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a reason'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Submit'),
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
