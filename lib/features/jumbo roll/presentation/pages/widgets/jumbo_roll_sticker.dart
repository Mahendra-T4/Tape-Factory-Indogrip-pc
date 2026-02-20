import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/features/round/data/models/batch_details_model.dart';
import 'package:indogrip/features/round/data/models/view_round_modeld.dart';

class DetailItem {
  final String label;
  final String value;

  DetailItem(this.label, this.value);
}

class JumboPrintSticker extends StatefulWidget {
  final ViewRoundModel record;
  const JumboPrintSticker({super.key, required this.record});
  static const String routeName = '/JumboPrintSticker';

  @override
  State<JumboPrintSticker> createState() => _JumboPrintStickerState();
}

class _JumboPrintStickerState extends State<JumboPrintSticker> {
  BatchDetailsModel batchDetailsModel = BatchDetailsModel();
  final GlobalKey<ScaffoldState> _stateKey = GlobalKey<ScaffoldState>();
  Set<int> selectedIndices = {};
  bool isMultiSelect = false;

  void toggleItemSelection(int displayIndex) {
    setState(() {
      // Convert display index to actual index using modulo
      final recordLength = widget.record.record?.length ?? 1;
      final actualIndex = displayIndex % recordLength;

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

  bool isLoading = true;

  Future<void> fetchBatchDetails() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await DioService.dioPostApiCall(
        data: FormData.fromMap({
          'activity': 'round-details',
          'userKey': HiveService.getUserId(),
          'roundKey': widget.record.record!.first.rKey,
        }),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          batchDetailsModel = BatchDetailsModel.fromJson(response.data);
        });
        if (batchDetailsModel.status == 1) {
          setState(() {
            isLoading = false;
          });
        }
        developer.log(
          name: 'Fetch Batch Details Response',
          batchDetailsModel.message.toString(),
        );
      } else {
        developer.log(
          name: 'Fetch Batch Details Failed',
          'Failed to Load Data From Server',
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      developer.log(name: 'Fetch Batch Details Error', e.toString());
    }
  }

  Future<void> JumboPrintStickers() async {
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
      // Convert display indices to actual record indices
      final recordLength = widget.record.record?.length ?? 1;
      final selectedStickers = selectedIndices.map((displayIndex) {
        final actualIndex = displayIndex % recordLength;
        return widget.record.record![actualIndex];
      }).toList();

      // Create PDF document
      final pdf = pw.Document();

      // Add pages for each selected sticker
      for (var displayIndex in selectedIndices) {
        final recordLength = widget.record.record?.length ?? 1;
        final actualIndex = displayIndex % recordLength;
        final sticker = widget.record.record![actualIndex];

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat(
              PdfPageFormat.inch * 4, // width = 4 inches
              PdfPageFormat.inch * 6, // height = 6 inches
              marginAll: PdfPageFormat.inch * 0.2, // 0.2 inch margins
            ),
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.BarcodeWidget(
                      data: batchDetailsModel
                          .record!
                          .batchInformation!
                          .batchCode
                          .toString(),
                      barcode: pw.Barcode.code128(),
                      width: PdfPageFormat.inch * 2.5, // 2.5 inches wide
                      height: PdfPageFormat.inch * 0.8, // 0.8 inches tall
                    ),
                  ),

                  // pw.SizedBox(height: 10),
                  // pw.Center(
                  //   child: pw.Text(
                  //     batchDetailsModel.record!.batchInformation!.batchCode
                  //         .toString(),
                  //     style: pw.TextStyle(fontSize: 14),
                  //   ),
                  // ),
                  pw.SizedBox(height: 20),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Batch No: ${batchDetailsModel.record!.batchInformation!.batchCode.toString()}',
                      ),
                      pw.Text(
                        'Jumbo Roll: ${widget.record.record!.first.rollNumber}',
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Pieces/Carton: ${sticker.piecesPerCarton}'),
                      pw.Text(
                        'Cut MM Meter: ${widget.record.record!.first.cutMMMeter}',
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Mic: ${sticker.mic}'),
                      pw.Text('Base: ${sticker.base}'),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      if (batchDetailsModel
                              .record!
                              .batchInformation!
                              .showLabel ==
                          'Length')
                        pw.Text(
                          'Length: ${batchDetailsModel.record!.batchInformation!.displayValue}',
                        ),

                      if (batchDetailsModel
                              .record!
                              .batchInformation!
                              .showLabel ==
                          'Weight')
                        pw.Text(
                          'Weight: ${batchDetailsModel.record!.batchInformation!.displayValue}',
                        ),
                      pw.Text(
                        'Remark: ${batchDetailsModel.record!.batchInformation!.batchRemark.toString()}',
                      ),
                    ],
                  ),

                  // pw.SizedBox(height: 5),
                ],
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

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully sent ${selectedStickers.length} sticker(s) to printer',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Clear selection after printing
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

  @override
  void initState() {
    super.initState();
    fetchBatchDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _stateKey,
      appBar: !Responsive.isDesktop(context)
          ? MobileAppBar(context, _stateKey, 'Sticker Print')
          : null,
      drawer: !Responsive.isDesktop(context) ? const SideMenuWidget() : null,
      body: batchDetailsModel.record?.batchInformation != null
          ? Column(
              children: [
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
                              isMultiSelect = !isMultiSelect;
                              if (!isMultiSelect) {
                                selectedIndices.clear();
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isMultiSelect
                                ? Colors.blue.shade700
                                : Colors.grey.shade200,
                            foregroundColor: isMultiSelect
                                ? Colors.white
                                : Colors.grey.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Multi Select'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: selectedIndices.isNotEmpty
                              ? () => JumboPrintStickers()
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

               
              ],
            )
          : Center(
              child: Text(
                batchDetailsModel.message.toString(),
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
            ),
    );
  }

  

  
}
