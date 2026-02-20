// import 'dart:developer' as developer;
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:indogrip/Assets/assets.dart';
// import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
// import 'package:indogrip/core/service/connectivity/not_connected.dart';
// import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
// import 'package:indogrip/features/round/domain/repositories/add_round_repo.dart';
// import 'package:indogrip/features/round/presentation/bloc/round_bloc.dart';
// import 'package:printing/printing.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:flutter/services.dart';
// import 'package:indogrip/core/constants/sizes.dart';
// import 'package:indogrip/core/responsive/responsive.dart';
// import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
// import 'package:indogrip/core/utils/sidebar.dart';
// import 'package:indogrip/features/round/data/models/batch_details_model.dart';

// class PrintSticker extends StatefulWidget {
//   final String rKey;
//   const PrintSticker({super.key, required this.rKey});
//   static const String routeName = '/printSticker';

//   @override
//   State<PrintSticker> createState() => _PrintStickerState();
// }

// class _PrintStickerState extends State<PrintSticker> {
//   late final RoundBloc roundBloc;
//   final GlobalKey<ScaffoldState> _stateKey = GlobalKey<ScaffoldState>();
//   Set<int> selectedIndices = {};
//   bool isMultiSelect = false;
//   double _fontSize = 9.5;

//   void toggleItemSelection(int displayIndex) {
//     setState(() {
//       if (selectedIndices.contains(displayIndex)) {
//         selectedIndices.remove(displayIndex);
//       } else {
//         if (!isMultiSelect) {
//           selectedIndices.clear();
//         }
//         selectedIndices.add(displayIndex);
//       }
//     });
//   }

//   Future<void> printStickers(BatchDetailsModel batchDetailsModel) async {
//     if (selectedIndices.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select at least one sticker to print'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     try {
//       // Create PDF document
//       final pdf = pw.Document();

//       // Load images from assets
//       pw.ImageProvider? tapFactoryImage;
//       pw.ImageProvider? indogripStickerImage;

//       try {
//         final indogrip = await rootBundle.load(Assets.indogripSticker);
//         final tapFactory = await rootBundle.load(Assets.theTapFactoryLogo);

//         // Process tap factory logo (top)
//         final tapFactoryBytes = tapFactory.buffer.asUint8List();
//         try {
//           tapFactoryImage = pw.MemoryImage(tapFactoryBytes);
//         } catch (e) {
//           developer.log(name: 'Load Tap Factory Error', e.toString());
//         }

//         // Process indogrip sticker logo (bottom)
//         final indogripBytes = indogrip.buffer.asUint8List();
//         try {
//           indogripStickerImage = pw.MemoryImage(indogripBytes);
//         } catch (e) {
//           developer.log(name: 'Load Indogrip Sticker Error', e.toString());
//         }
//       } catch (e) {
//         developer.log(name: 'Load Images Error', e.toString());
//       }

//       // Add pages for each selected sticker from batchDetailsModel
//       for (var _ in selectedIndices) {
//         pdf.addPage(
//           pw.Page(
//             pageFormat: PdfPageFormat(
//               PdfPageFormat.inch * 4.9, // width = 4.9 inches
//               PdfPageFormat.inch * 3.4, // height = 3.4 inches
//               marginTop: PdfPageFormat.inch * 0.7,
//               marginRight: PdfPageFormat.inch * 0.15,
//               marginLeft: PdfPageFormat.inch * 0.15,
//             ),
//             build: (pw.Context context) {
//               return pw.Container(
//                 alignment: pw.Alignment.center,
//                 padding: pw.EdgeInsets.all(10),
//                 decoration: pw.BoxDecoration(
//                   border: pw.Border.all(color: PdfColors.black, width: 1.2),
//                   borderRadius: pw.BorderRadius.circular(4),
//                 ),
//                 child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.center,
//                   mainAxisAlignment: pw.MainAxisAlignment.center,
//                   children: [
//                     // Logo row
//                     pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         if (indogripStickerImage != null)
//                           pw.Image(
//                             indogripStickerImage,
//                             width: 100,
//                             height: 30,
//                             fit: pw.BoxFit.contain,
//                           ),
//                         if (tapFactoryImage != null)
//                           pw.Image(
//                             tapFactoryImage,
//                             width: 80,
//                             height: 30,
//                             fit: pw.BoxFit.contain,
//                           ),
//                       ],
//                     ),
//                     pw.SizedBox(height: 3),

//                     // Barcode
//                     pw.Align(
//                       alignment: pw.Alignment.center,
//                       child: pw.BarcodeWidget(
//                         data:
//                             '${batchDetailsModel.record!.batchInformation!.batchID}',
//                         barcode: pw.Barcode.code128(),
//                         textStyle: pw.TextStyle(
//                           fontSize: 9,
//                           fontWeight: pw.FontWeight.bold,
//                         ),
//                         width: PdfPageFormat.inch * 2.8,
//                         height: PdfPageFormat.inch * 0.6,
//                       ),
//                     ),
//                     pw.SizedBox(height: 5),

//                     // Jumbo Roll & Pieces/Carton
//                     pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.Text(
//                           'Jumbo Roll: ${batchDetailsModel.record!.jumboInformation!.rollNumber}',
//                           style: pw.TextStyle(
//                             fontSize: _fontSize,
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                         pw.Text(
//                           'Pieces/Carton: ${batchDetailsModel.record!.roundInformation!.piecesPerCarton}',
//                           style: pw.TextStyle(
//                             fontSize: _fontSize,
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     pw.SizedBox(height: 5),

//                     // Cut MM & Mic
//                     pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.Text(
//                           'Width: ${batchDetailsModel.record!.roundInformation!.cutMMMeter}',
//                           style: pw.TextStyle(
//                             fontSize: _fontSize,
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                         pw.Text(
//                           'Mic: ${batchDetailsModel.record!.batchInformation!.displayMic}',
//                           style: pw.TextStyle(
//                             fontSize: _fontSize,
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     pw.SizedBox(height: 5),

//                     // Length/Weight & Base
//                     pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.Text(
//                           '${batchDetailsModel.record!.batchInformation!.showLabel}: ${batchDetailsModel.record!.batchInformation!.displayValue}',
//                           style: pw.TextStyle(
//                             fontSize: _fontSize,
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                         pw.Text(
//                           'Base: ${batchDetailsModel.record!.jumboInformation!.baseLabel}',
//                           style: pw.TextStyle(
//                             fontSize: _fontSize,
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     pw.SizedBox(height: 5),

//                     // Round & Operator
//                     pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.Text(
//                           'MFG.: ${batchDetailsModel.record!.batchInformation!.displayMFGLabel}',
//                           style: pw.TextStyle(
//                             fontSize: _fontSize,
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                         pw.Text(
//                           'Operator: ${batchDetailsModel.record!.batchInformation!.batchOperator}',
//                           style: pw.TextStyle(
//                             fontSize: _fontSize,
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     pw.SizedBox(height: 5),

//                     // MRP & Packed By
//                     pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.Text(
//                           'MRP: ${batchDetailsModel.record!.batchInformation!.batchMRP}',
//                           style: pw.TextStyle(
//                             fontSize: _fontSize,
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                         pw.Text(
//                           'Packed By: ${batchDetailsModel.record!.batchInformation!.batchPackedBy}',
//                           style: pw.TextStyle(
//                             fontSize: _fontSize,
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     pw.SizedBox(height: 5),

//                     // Remark & Batch Code
//                     pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.Text(
//                           'Remark: ${batchDetailsModel.record!.batchInformation!.batchRemark}',
//                           style: pw.TextStyle(
//                             fontSize: _fontSize,
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                         pw.Text(
//                           'Batch Code: ${batchDetailsModel.record!.batchInformation!.batchCode}',
//                           style: pw.TextStyle(
//                             fontSize: _fontSize,
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       }

//       // Show printer picker and print
//       await Printing.layoutPdf(
//         onLayout: (format) {
//           return pdf.save();
//         },
//         name: 'Indogrip Round Stickers',
//         format: PdfPageFormat.a4,
//       );

//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Successfully sent ${selectedIndices.length} sticker(s) to printer',
//           ),
//           backgroundColor: Colors.green,
//         ),
//       );

//       // Clear selection after printing
//       setState(() {
//         selectedIndices.clear();
//       });
//     } catch (e) {
//       // Show error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error printing stickers: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     roundBloc = RoundBloc(addRoundRepository: AddRoundRepository())
//       ..add(FetchRoundDetailsEvent(rKey: widget.rKey));
//     // fetchBatchDetails();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: InternetConnectionService().connectionStream,
//       initialData: true, // Assume connected initially
//       builder: (context, snapshot) {
//         // Handle error state
//         if (snapshot.hasError) {
//           return const NoInternetConnection();
//         }

//         // Handle disconnected state
//         if (snapshot.data == false) {
//           return const NoInternetConnection();
//         }

//         // Handle loading state
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         return Scaffold(
//           backgroundColor: Colors.white,
//           key: _stateKey,
//           appBar: !Responsive.isDesktop(context)
//               ? MobileAppBar(context, _stateKey, 'Round Stickers')
//               : DesktopAppBar(context, _stateKey, 'Round Stickers', true),
//           drawer: !Responsive.isDesktop(context) ? SideMenuWidget() : null,

//           body: BlocConsumer(
//             bloc: roundBloc,
//             listener: (context, state) {},
//             builder: (context, state) {
//               switch (state.runtimeType) {
//                 case RoundLoadingStatus:
//                   return const Center(child: CircularProgressIndicator());
//                 case RoundDetailsLoadedSuccessStatus:
//                   final batchDetailsModel =
//                       (state as RoundDetailsLoadedSuccessStatus).model;
//                   return batchDetailsModel.status == 1
//                       ? Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: kDefaultHorizontalPadding,
//                                 vertical: 30,
//                               ),
//                               child: Row(
//                                 spacing: 16,
//                                 children: [
//                                   Expanded(
//                                     child: Row(
//                                       children: [
//                                         Text(
//                                           '${selectedIndices.length} item${selectedIndices.length != 1 ? 's' : ''} selected',
//                                           style: TextStyle(
//                                             color: Colors.grey.shade600,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   SizedBox(
//                                     width: 120,
//                                     child: ElevatedButton(
//                                       onPressed: () {
//                                         setState(() {
//                                           final totalItems =
//                                               batchDetailsModel
//                                                   .record
//                                                   ?.roundInformation
//                                                   ?.roundAdditionalInformation
//                                                   ?.totalCarton ??
//                                               0;

//                                           // Toggle: if all selected, deselect all; otherwise select all
//                                           if (selectedIndices.length ==
//                                               totalItems) {
//                                             // All items selected, so deselect all
//                                             selectedIndices.clear();
//                                           } else {
//                                             // Not all selected, so select all
//                                             selectedIndices.clear();
//                                             for (
//                                               int i = 0;
//                                               i < totalItems;
//                                               i++
//                                             ) {
//                                               selectedIndices.add(i);
//                                             }
//                                           }
//                                         });
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor:
//                                             selectedIndices.isNotEmpty
//                                             ? Colors.blue.shade700
//                                             : Colors.grey.shade200,
//                                         foregroundColor:
//                                             selectedIndices.isNotEmpty
//                                             ? Colors.white
//                                             : Colors.grey.shade700,
//                                         padding: const EdgeInsets.symmetric(
//                                           vertical: 16,
//                                         ),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             8,
//                                           ),
//                                         ),
//                                       ),
//                                       child: const Text('Select All'),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   SizedBox(
//                                     width: 120,
//                                     child: ElevatedButton(
//                                       onPressed: selectedIndices.isNotEmpty
//                                           ? () =>
//                                                 printStickers(batchDetailsModel)
//                                           : null,
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.blue.shade600,
//                                         foregroundColor: Colors.white,
//                                         padding: const EdgeInsets.symmetric(
//                                           vertical: 16,
//                                         ),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             8,
//                                           ),
//                                         ),
//                                       ),
//                                       child: const Text('Print'),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),

                            
//                           ],
//                         )
//                       : Center(
//                           child: Text(
//                             batchDetailsModel.message ?? 'Try Again',
//                             style: TextStyle(
//                               color: Colors.grey.shade600,
//                               fontSize: 16,
//                             ),
//                           ),
//                         );
//                 case RoundDetailsErrorFailedStatus:
//                   return Center(
//                     child: Text(
//                       'Error: ${(state as RoundDetailsErrorFailedStatus).error}',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                         fontSize: 16,
//                       ),
//                     ),
//                   );
//                 default:
//                   return const Center(child: Text('No State Found'));
//               }
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget stickersWidget(BatchDetailsModel batchDetailsModel) => Container(
//     padding: const EdgeInsets.all(24),
//     decoration: BoxDecoration(
//       gradient: LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: [Colors.blue.shade50.withOpacity(0.5), Colors.white],
//       ),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (Responsive.isDesktop(context)) ...[
//           Text(
//             'Print Sticker',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.blue.shade900,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Select a sticker size template',
//             style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//           ),
//           const SizedBox(height: 32),
//         ],

//         Expanded(
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               final crossAxisCount = 3;

//               return GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: crossAxisCount,
//                   mainAxisSpacing: 20,
//                   crossAxisSpacing: 20,
//                   childAspectRatio: 1.3,
//                 ),

//                 itemCount:
//                     batchDetailsModel
//                         .record
//                         ?.roundInformation
//                         ?.roundAdditionalInformation
//                         ?.totalCarton ??
//                     0,
//                 itemBuilder: (context, index) {
//                   final displayIndex = index + 1;
//                   final isSelected = selectedIndices.contains(index);

//                   return InkWell(
//                     onTap: () {
//                       toggleItemSelection(index);
//                     },
//                     borderRadius: BorderRadius.circular(12),
//                     child: Container(
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: isSelected
//                               ? Colors.blue.shade600
//                               : Colors.grey.shade300,
//                           width: isSelected ? 2.5 : 1.5,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: isSelected
//                                 ? Colors.blue.shade200.withOpacity(0.6)
//                                 : Colors.grey.shade200.withOpacity(0.4),
//                             blurRadius: 10,
//                             offset: const Offset(0, 4),
//                             spreadRadius: 1,
//                           ),
//                         ],
//                       ),
//                       child: Stack(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(12),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               spacing: 6,
//                               children: [
//                                 // Carton Title
//                                 Text(
//                                   'Carton $displayIndex',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.blue.shade900,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),

//                                 // Batch Code
//                                 Container(
//                                   alignment: Alignment.center,
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 8,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                       color: Colors.grey.shade300,
//                                     ),
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                   child: Text(
//                                     batchDetailsModel
//                                         .record!
//                                         .batchInformation!
//                                         .batchCode
//                                         .toString(),
//                                     style: const TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: 'Courier',
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),

//                                 // Details rows (matching PDF format)
//                                 Expanded(
//                                   child: SingleChildScrollView(
//                                     child: Column(
//                                       spacing: 4,
//                                       children: [
//                                         // Row 1: Jumbo Roll & Pieces/Carton
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             _detailText(
//                                               'Jumbo Roll: ${batchDetailsModel.record!.jumboInformation!.rollNumber}',
//                                             ),
//                                             _detailText(
//                                               'Pieces/Carton: ${batchDetailsModel.record!.roundInformation!.piecesPerCarton}',
//                                             ),
//                                           ],
//                                         ),

//                                         // Row 2: Width & Mic
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             _detailText(
//                                               'Width: ${batchDetailsModel.record!.roundInformation!.cutMMMeter}',
//                                             ),
//                                             _detailText(
//                                               'Mic: ${batchDetailsModel.record!.batchInformation!.displayMic}',
//                                             ),
//                                           ],
//                                         ),

//                                         // Row 3: Tape Length/Weight & Base
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             _detailText(
//                                               '${batchDetailsModel.record!.batchInformation!.showLabel}: ${batchDetailsModel.record!.batchInformation!.displayValue}',
//                                             ),
//                                             _detailText(
//                                               'Base: ${batchDetailsModel.record!.jumboInformation!.baseLabel}',
//                                             ),
//                                           ],
//                                         ),

//                                         // Row 4: MFG & Operator
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             _detailText(
//                                               'MFG: ${batchDetailsModel.record!.batchInformation!.displayMFGLabel}',
//                                             ),
//                                             _detailText(
//                                               'Operator: ${batchDetailsModel.record!.batchInformation!.batchOperator}',
//                                             ),
//                                           ],
//                                         ),

//                                         // Row 5: MRP & Packed By
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             _detailText(
//                                               'MRP: ${batchDetailsModel.record!.batchInformation!.batchMRP}',
//                                             ),
//                                             _detailText(
//                                               'Packed By: ${batchDetailsModel.record!.batchInformation!.batchPackedBy}',
//                                             ),
//                                           ],
//                                         ),

//                                         // Row 6: Remark & Batch Code
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Expanded(
//                                               child: _detailText(
//                                                 'Remark: ${batchDetailsModel.record!.batchInformation!.batchRemark}',
//                                                 maxLines: 2,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // Selection Indicator
//                           if (isSelected)
//                             Positioned(
//                               top: 8,
//                               right: 8,
//                               child: Container(
//                                 width: 24,
//                                 height: 24,
//                                 decoration: BoxDecoration(
//                                   color: Colors.blue.shade600,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: const Icon(
//                                   Icons.check,
//                                   color: Colors.white,
//                                   size: 14,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     ),
//   );

//   Widget _detailText(String text, {int maxLines = 1}) {
//     return Text(
//       text,
//       maxLines: maxLines,
//       overflow: TextOverflow.ellipsis,
//       style: TextStyle(
//         fontSize: 11,
//         fontWeight: FontWeight.w700,
//         color: Colors.grey.shade700,
//       ),
//     );
//   }
// }
