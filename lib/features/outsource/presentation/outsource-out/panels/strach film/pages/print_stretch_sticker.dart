import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/Assets/assets.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/features/outsource/data/model/stretchfilm_sticker_model.dart';
import 'package:indogrip/features/outsource/presentation/state/bloc.out/inventory_out_bloc.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';

class DetailItem {
  DetailItem(this.label, this.value);

  final String label;
  final String value;
}

class PrintStretchFilmSticker extends StatefulWidget {
  const PrintStretchFilmSticker({super.key, required this.rKey});

  static const String routeName = '/print-stretch-film-Sticker';

  final String rKey;

  @override
  State<PrintStretchFilmSticker> createState() => _PrintStickerState();
}

class _PrintStickerState extends State<PrintStretchFilmSticker> {
  // BatchDetailsModel batchDetailsModel = BatchDetailsModel();
  late final InventoryOutBloc inventoryOutBloc;

  bool isLoading = true;
  bool isMultiSelect = false;
  Set<int> selectedIndices = {};
  TextStyle style = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  final GlobalKey<ScaffoldState> _stateKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    inventoryOutBloc = InventoryOutBloc();
    inventoryOutBloc.add(
      ViewStretchFilmStickerDetailsEvent(inventoryKey: widget.rKey.toString()),
    );
  }

  void toggleItemSelection(int displayIndex) {
    setState(() {
      // Selection logic — we don't need to compute actual index here.

      if (selectedIndices.contains(displayIndex)) {
        selectedIndices.remove(displayIndex);
      } else {
        if (!isMultiSelect) {
          // Single select mode - clear previous selection
          selectedIndices.clear();
        }
        selectedIndices.add(displayIndex);
      }
    });
  }

  // TapeStickerInfoModel stickerInfoModel = TapeStickerInfoModel();

  Future<void> printStickers(StretchFilmStickerModel data) async {
    if (selectedIndices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one sticker to print'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Create PDF document
      final pdf = pw.Document();

      // Load images from assets
      pw.ImageProvider? tapFactoryImage;
      pw.ImageProvider? indogripStickerImage;

      try {
        final indogrip = await rootBundle.load(Assets.indogripSticker);
        final tapFactory = await rootBundle.load(Assets.theTapFactoryLogo);

        // Process tap factory logo (top)
        final tapFactoryBytes = tapFactory.buffer.asUint8List();
        try {
          tapFactoryImage = pw.MemoryImage(tapFactoryBytes);
        } catch (e) {
          developer.log(name: 'Load Tap Factory Error', e.toString());
        }

        // Process indogrip sticker logo (bottom)
        final indogripBytes = indogrip.buffer.asUint8List();
        try {
          indogripStickerImage = pw.MemoryImage(indogripBytes);
        } catch (e) {
          developer.log(name: 'Load Indogrip Sticker Error', e.toString());
        }
      } catch (e) {
        developer.log(name: 'Load Images Error', e.toString());
      }

      // Add pages for each selected sticker
      for (var _ in selectedIndices) {
        pw.TextStyle style = pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.black,
        );

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat(
              PdfPageFormat.inch * 4.9, // width = 4 inches
              PdfPageFormat.inch * 3.4, // height = 6 inches
              marginTop: PdfPageFormat.inch * 0.7,
              marginRight:
                  PdfPageFormat.inch *
                  0.15, // equal margins for centered sticker
              marginLeft:
                  PdfPageFormat.inch *
                  0.15, // equal margins for centered sticker
            ),
            build: (pw.Context context) {
              return pw.Container(
                alignment: pw.Alignment.center,
                padding: pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 1.2),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        if (indogripStickerImage != null)
                          pw.Image(
                            indogripStickerImage,
                            width: 100,
                            height: 30,
                            fit: pw.BoxFit.contain,
                          ),
                        if (tapFactoryImage != null)
                          pw.Image(
                            tapFactoryImage,
                            width: 80,
                            height: 30,
                            fit: pw.BoxFit.contain,
                          ),
                      ],
                    ),

                    // Top logo (tap factory)
                    pw.SizedBox(height: 3),

                    //! Barcode - batchcode
                    pw.Align(
                      alignment: pw.Alignment.center,
                      child: pw.BarcodeWidget(
                        data: data.record!.batchInformation!.batchID.toString(),
                        barcode: pw.Barcode.code128(),
                        textStyle: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        width: PdfPageFormat.inch * 2.8,
                        height: PdfPageFormat.inch * 0.6,
                      ),
                    ),
                    // pw.SizedBox(height: 5),

                    // Sticker details
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Batch Code: ${data.record!.batchInformation!.batchCode.toString()}',
                          style: style,
                        ),
                        pw.Text(
                          'Serial Number: ${data.record!.inventoryInformation!.inventoryCode.toString()}',
                          style: style,
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Mic: ${data.record!.batchInformation!.displayMic.toString()}',
                          style: style,
                        ),
                        pw.Text(
                          'Base: ${data.record!.inventoryInformation!.additionalInfo!.baseLabel}',
                          style: style,
                        ),
                      ],
                    ),

                    // pw.SizedBox(height: 5),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'MFG: ${data.record!.batchInformation!.displayMFGLabel}',
                          style: style,
                        ),
                        pw.Text(
                          'MRP: ${data.record!.batchInformation!.batchMRP}',
                          style: style,
                        ),
                      ],
                    ),

                    // pw.SizedBox(height: 5),
                    // pw.Row(
                    //   mainAxisAlignment: pw.MainAxisAlignment.start,
                    //   children: [pw.Text('Weight: ', style: style)],
                    // ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Size/Width: ${data.record!.inventoryInformation!.additionalInfo!.stretchFilmSize}',
                          style: style,
                        ),

                        pw.Text(
                          'Weight: ${data.record!.inventoryInformation!.additionalInfo!.grossWeight.toString().toString()}',
                          style: style,
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Operation: ${data.record!.inventoryInformation!.additionalInfo!.coreCode.toString()}',
                          style: style,
                        ),
                        pw.Text(
                          'Remark: ${data.record!.batchInformation!.batchRemark.toString()}',
                          style: style,
                        ),
                        // pw.Text(
                        //   'Operation: ${data.record!.inventoryInformation!.additionalInfo!.coreCode.toString()}',
                        //   style: style,
                        // ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }

      // Show printer picker and print
      await Printing.layoutPdf(
        onLayout: (format) {
          return pdf.save();
        },
        name: 'Indogrip Stickers',
        format: PdfPageFormat.a4,
      );

      setState(() {
        selectedIndices.clear();
      });
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error printing stickers: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget get contentBuilder => BlocBuilder(
    bloc: inventoryOutBloc,
    builder: (context, state) {
      switch (state.runtimeType) {
        case InventoryOutLoadingStatus:
          return Center(child: CircularProgressIndicator());
        case StretchFilmStickerDataLoadedSuccessStatus:
          final sticker =
              (state as StretchFilmStickerDataLoadedSuccessStatus).model;
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue.shade50.withOpacity(0.5), Colors.white],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // stickerInformation,
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultHorizontalPadding,
                    vertical: 30,
                  ),
                  child: Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              '${selectedIndices.length} item${selectedIndices.length != 1 ? 's' : ''} selected',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              final totalItems =
                                  state
                                      .model
                                      .record
                                      ?.inventoryInformation
                                      ?.quantity ??
                                  0;

                              // Toggle: if all selected, deselect all; otherwise select all
                              if (selectedIndices.length == totalItems) {
                                // All items selected, so deselect all
                                selectedIndices.clear();
                              } else {
                                // Not all selected, so select all
                                selectedIndices.clear();
                                for (int i = 0; i < totalItems; i++) {
                                  selectedIndices.add(i);
                                }
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedIndices.isNotEmpty
                                ? Colors.blue.shade700
                                : Colors.grey.shade200,
                            foregroundColor: selectedIndices.isNotEmpty
                                ? Colors.white
                                : Colors.grey.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Select All'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: selectedIndices.isNotEmpty
                              ? () => printStickers(state.model)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Print'),
                        ),
                      ),
                    ],
                  ),
                ),
                if (Responsive.isDesktop(context)) ...[
                  Text(
                    'Print Sticker',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select a sticker size template',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 32),
                ],
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.maxWidth > 900
                          ? 3
                          : constraints.maxWidth > 700
                          ? 2
                          : 1;

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.7,
                        ),
                        itemCount:
                            sticker.record?.inventoryInformation?.quantity ?? 0,
                        itemBuilder: (context, index) {
                          final item = state.model.record;
                          final data = state.model;
                          final displayIndex = index + 1;
                          final isSelected = selectedIndices.contains(
                            displayIndex - 1,
                          );

                          return InkWell(
                            onTap: () {
                              toggleItemSelection(displayIndex - 1);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue.shade600
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2.5 : 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isSelected
                                        ? Colors.blue.shade200.withOpacity(0.6)
                                        : Colors.grey.shade200.withOpacity(0.4),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 8,
                                      children: [
                                        // Carton Title
                                        Text(
                                          'Carton $displayIndex',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade700,
                                          ),
                                        ),

                                        const Divider(height: 1),

                                        // Details Content
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              spacing: 6,
                                              children: [
                                                // Row 1: Batch Code & Mic
                                                _buildDetailRow(
                                                  label1: 'Batch Code',
                                                  value1: item!
                                                      .batchInformation!
                                                      .batchCode
                                                      .toString(),
                                                  label2: 'Serial Number',
                                                  value2: data
                                                      .record!
                                                      .inventoryInformation!
                                                      .inventoryCode!
                                                      .toString(),
                                                ),

                                                _buildDetailRow(
                                                  label1: 'Mic',
                                                  value1: item
                                                      .batchInformation!
                                                      .displayMic
                                                      .toString(),
                                                  label2: 'Base',
                                                  value2: item
                                                      .inventoryInformation!
                                                      .additionalInfo!
                                                      .baseLabel
                                                      .toString(),
                                                ),

                                                // Row 2: Base & Mic
                                                _buildDetailRow(
                                                  label1: 'MFG',
                                                  value1: item
                                                      .batchInformation!
                                                      .displayMFGLabel
                                                      .toString(),
                                                  label2: 'MRP',
                                                  value2: item
                                                      .batchInformation!
                                                      .batchMRP
                                                      .toString(),
                                                ),
                                                _buildDetailRow(
                                                  label1: 'Operation',
                                                  value1: data
                                                      .record!
                                                      .inventoryInformation!
                                                      .additionalInfo!
                                                      .coreCode
                                                      .toString(),
                                                  label2: 'Weight',
                                                  value2: item
                                                      .inventoryInformation!
                                                      .additionalInfo!
                                                      .grossWeight
                                                      .toString()
                                                      .toString(),
                                                ),
                                                _buildDetailRow2(
                                                  label1: 'Size/Width',
                                                  value1: item
                                                      .inventoryInformation!
                                                      .additionalInfo!
                                                      .stretchFilmSize
                                                      .toString(),
                                                ),

                                                Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                    border: Border.all(
                                                      color:
                                                          Colors.amber.shade200,
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    spacing: 2,
                                                    children: [
                                                      Text(
                                                        'Remark',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .amber
                                                              .shade700,
                                                        ),
                                                      ),
                                                      Text(
                                                        data
                                                            .record!
                                                            .batchInformation!
                                                            .batchRemark
                                                            .toString(),

                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey
                                                              .shade800,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Selection Indicator
                                  if (isSelected)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade600,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        case StretchFilmStickerDataFailedErrorStatus:
          final errorMessage =
              (state as StretchFilmStickerDataFailedErrorStatus).message;
          return Center(child: Text('Error: $errorMessage'));
        default:
          return Center(child: Text('No Data Available'));
      }
    },
  );

  Widget _buildDetailRow({
    required String label1,
    required String value1,
    required String label2,
    required String value2,
  }) {
    return Row(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 2,
            children: [
              Text(
                '${label1} :',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value1,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 2,
            children: [
              Text(
                '${label2} : ',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value2,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow2({required String label1, required String value1}) {
    return Row(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 2,
            children: [
              Text(
                '${label1} :',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value1,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Colors.white,
          key: _stateKey,
          appBar: !Responsive.isDesktop(context)
              ? MobileAppBar(context, _stateKey, 'Stretch Stickers')
              : DesktopAppBar(context, _stateKey, 'Stretch Stickers', false),
          drawer: !Responsive.isDesktop(context) ? SideMenuWidget() : null,

          body: contentBuilder,
        );
      },
    );
  }
}
