import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/Assets/assets.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/features/global/presentation/widget/base_filter_field.dart';
import 'package:indogrip/features/global/presentation/widget/data_filtration.dart';
import 'package:indogrip/features/global/presentation/widget/file_export_button.dart';
import 'package:indogrip/features/global/presentation/widget/multi_delete_button.dart';
import 'package:indogrip/features/global/presentation/widget/refresh_button.dart';
import 'package:indogrip/features/global/presentation/widget/search_field_round.dart';
import 'package:indogrip/features/global/presentation/widget/vendor_list_widget.dart';
import 'package:indogrip/features/jumbo%20roll/data/jumbo_roll_exporter.dart';
import 'package:indogrip/features/jumbo%20roll/data/jumboroll_data_source.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/view_jumbo_roll_model.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/bloc/jumbo_roll_bloc.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/view/view_jumbo_roll.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/widgets/micron_dropdown_widget.dart';

import 'package:indogrip/features/round/presentation/widgets/master_roll_size_widget.dart';
import 'package:indogrip/features/staff/data/models/view_staff_api_param.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

abstract class ViewJumboRollBuilder extends State<ViewJumboRollPanel> {
  late JumboRollBloc jumboRollBloc;
  String pageText = '';
  bool isMultipleSelection = false;
  List<Map<String, dynamic>> selectedItems = [];
  late JumboRollDataSource? dataSource;
  Set<int> selectedIndices = {};
  int? highlightedRowIndex;
  TextEditingController searchController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  int pageNo = 1;
  int pageQty = 1;

  double _fontSize = 9.5;

  List recordList = [
    "All Records",
    "Requested",
    "In-Progress",
    "Approved",
    "Rejected",
    "Block",
  ];
  List filterList = ["Newest", "Oldest"];
  // List entryList = ["10", "25", "50", "100", "500"];
  var recordValue, filterValue, entryValue;
  String? vendorKey, micID, baseID, widthID, stockStatus;

  // Sample data

  Widget get searchFields => RoundSearchFields(
    isStatus: true,
    controller: searchController,
    onSearch: (keyword) {
      // setState(() {
      //   searchController.text = keyword;
      // });
      jumboRollBloc.add(
        FetchViewJumboRollRecordEvent(
          param: ViewRecordApiParam(
            keyword: keyword,
            filterBy: recordValue?.toString() ?? '',
            orderBy: filterValue?.toString() ?? '',
            pageNo: pageNo.toString(),
            sortBy: entryValue?.toString() ?? '',
            vendorKey: vendorKey,
            micID: micID,
            baseID: baseID,
            widthID: widthID,
            fromDate: fromDateController.text,
            toDate: toDateController.text,
          ),
        ),
      );
    },
    orderByValue: filterValue,
    onChangedStatus: (status) {
      setState(() {
        recordValue = status;
      });
      jumboRollBloc.add(
        FetchViewJumboRollRecordEvent(
          param: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue?.toString() ?? '',
            orderBy: filterValue?.toString() ?? '',
            pageNo: pageNo.toString(),
            sortBy: entryValue?.toString() ?? '',
            vendorKey: vendorKey,
            micID: micID,
            baseID: baseID,
            widthID: widthID,
            fromDate: fromDateController.text,
            toDate: toDateController.text,
          ),
        ),
      );
    },
    onChangedOrder: (order) {
      setState(() {
        filterValue = order;
      });
      jumboRollBloc.add(
        FetchViewJumboRollRecordEvent(
          param: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue?.toString() ?? '',
            orderBy: filterValue?.toString() ?? '',
            pageNo: pageNo.toString(),
            sortBy: entryValue?.toString() ?? '',
            vendorKey: vendorKey,
            micID: micID,
            baseID: baseID,
            widthID: widthID,
            fromDate: fromDateController.text,
            toDate: toDateController.text,
          ),
        ),
      );
    },
    onChangedSort: (sortBy) {
      setState(() {
        entryValue = sortBy ?? 10;
      });
      jumboRollBloc.add(
        FetchViewJumboRollRecordEvent(
          param: ViewRecordApiParam(
            keyword: searchController.text,
            filterBy: recordValue?.toString() ?? '',
            orderBy: filterValue?.toString() ?? '',
            pageNo: pageNo.toString(),
            sortBy: entryValue?.toString() ?? '',
            vendorKey: vendorKey,
            micID: micID,
            baseID: baseID,
            widthID: widthID,
            fromDate: fromDateController.text,
            toDate: toDateController.text,
          ),
        ),
      );
    },
  );

  void toggleMultipleSelection() {
    setState(() {
      isMultipleSelection = !isMultipleSelection;
      if (!isMultipleSelection) {
        selectedItems.clear();
      }
    });
  }

  void handleSelectionChanged(List<Map<String, dynamic>> items) {
    setState(() {
      selectedItems = items;
    });
  }

  Future<void> JumboPrintMultipleStickers(
    List<Map<String, dynamic>> selectedItems,
  ) async {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No items selected for printing'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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

    try {
      // Create PDF document with multiple pages
      final pdf = pw.Document();

      // Add a page for each selected item
      for (final item in selectedItems) {
        final jumboRollData = JumboRollRecord.fromJson(item);

        if (jumboRollData.jumboID == null) continue;

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat(
              PdfPageFormat.inch * 4.9, // width = 4 inches
              PdfPageFormat.inch * 3.4, // height = 6 inches
              marginTop: PdfPageFormat.inch * 0.7,
              marginRight: PdfPageFormat.inch * 0.15,
              marginLeft: PdfPageFormat.inch * 0.15,
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
                    pw.SizedBox(height: 3),
                    pw.Align(
                      alignment: pw.Alignment.center,
                      child: pw.BarcodeWidget(
                        textStyle: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        data: jumboRollData.jumboID?.toString() ?? '',
                        barcode: pw.Barcode.code128(),
                        width: PdfPageFormat.inch * 2.8,
                        height: PdfPageFormat.inch * 0.5,
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Bill Number: ${jumboRollData.jBillNumber ?? ''}',
                          style: pw.TextStyle(
                            fontSize: _fontSize,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                        pw.Text(
                          'Roll Number: ${jumboRollData.jRollNumber ?? ''}',
                          style: pw.TextStyle(
                            fontSize: _fontSize,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Width: ${jumboRollData.jWidth ?? ''}',
                          style: pw.TextStyle(
                            fontSize: _fontSize,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                        pw.Text(
                          'Base: ${jumboRollData.baseLabel ?? ''}',
                          style: pw.TextStyle(
                            fontSize: _fontSize,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Mic: ${jumboRollData.micLabel ?? ''}',
                          style: pw.TextStyle(
                            fontSize: _fontSize,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                        pw.Text(
                          'Length: ${jumboRollData.jLength ?? ''}',
                          style: pw.TextStyle(
                            fontSize: _fontSize,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'RollCost: ${jumboRollData.rollCost ?? ''}',
                          style: pw.TextStyle(
                            fontSize: _fontSize,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                        pw.Text(
                          'Weight: ${jumboRollData.jWeight ?? ''}',
                          style: pw.TextStyle(
                            fontSize: _fontSize,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Remark: ${jumboRollData.jRemark ?? ''}',
                          style: pw.TextStyle(
                            fontSize: _fontSize,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }

      // Show printer picker and print all pages at once
      await Printing.layoutPdf(
        onLayout: (format) {
          return pdf.save();
        },
        name: 'Jumbo Roll Stickers (${selectedItems.length} items)',
        format: PdfPageFormat(PdfPageFormat.inch * 4, PdfPageFormat.inch * 6),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully sent ${selectedItems.length} stickers to printer',
          ),
          backgroundColor: Colors.green,
        ),
      );
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

  Future<void> JumboPrintStickers(JumboRollRecord jumboRollData) async {
    if (jumboRollData == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No data available for printing'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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

    try {
      // Create PDF document
      final pdf = pw.Document();

      // Add page for the sticker
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(
            PdfPageFormat.inch * 4.9, // width = 4 inches
            PdfPageFormat.inch * 3.4, // height = 6 inches
            marginTop: PdfPageFormat.inch * 0.7,
            marginRight:
                PdfPageFormat.inch * 0.15, // equal margins for centered sticker
            marginLeft:
                PdfPageFormat.inch *
                0.15, // equal margins for centered stickersticker
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
                  pw.SizedBox(height: 3),

                  pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.BarcodeWidget(
                      textStyle: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      data: jumboRollData.jumboID?.toString() ?? '',
                      barcode: pw.Barcode.code128(),
                      width: PdfPageFormat.inch * 2.8, // 2.0 inches wide
                      height: PdfPageFormat.inch * 0.5, // 0.8 inches tall
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Bill Number: ${jumboRollData.jBillNumber ?? ''}',
                        style: pw.TextStyle(
                          fontSize: _fontSize,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.Text(
                        'Roll Number: ${jumboRollData.jRollNumber ?? ''}',
                        style: pw.TextStyle(
                          fontSize: _fontSize,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Width: ${jumboRollData.jWidth ?? ''}',
                        style: pw.TextStyle(
                          fontSize: _fontSize,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.Text(
                        'Base: ${jumboRollData.baseLabel ?? ''}',
                        style: pw.TextStyle(
                          fontSize: _fontSize,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Mic: ${jumboRollData.micLabel ?? ''}',
                        style: pw.TextStyle(
                          fontSize: _fontSize,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.Text(
                        'Length: ${jumboRollData.jLength ?? ''}',
                        style: pw.TextStyle(
                          fontSize: _fontSize,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'RollCost: ${jumboRollData.rollCost ?? ''}',
                        style: pw.TextStyle(
                          fontSize: _fontSize,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.Text(
                        'Weight: ${jumboRollData.jWeight ?? ''}',
                        style: pw.TextStyle(
                          fontSize: _fontSize,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Remark: ${jumboRollData.jRemark ?? ''}',
                        style: pw.TextStyle(
                          fontSize: _fontSize,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Show printer picker and print
      await Printing.layoutPdf(
        onLayout: (format) {
          return pdf.save();
        },
        name: 'Jumbo Roll Sticker',
        format: PdfPageFormat(PdfPageFormat.inch * 4, PdfPageFormat.inch * 6),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully sent sticker to printer'),
          backgroundColor: Colors.green,
        ),
      );
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

  // String? vendorKey;

  Widget get extraFilterFields => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: kDefaultHorizontalPadding - 5,
    ),
    child: Row(
      spacing: 16,
      children: [
        Expanded(
          child: VendorListWidget(
            onChanged: (value) {
              setState(() {
                vendorKey = value;
              });
              jumboRollBloc.add(
                FetchViewJumboRollRecordEvent(
                  param: ViewRecordApiParam(
                    keyword: searchController.text,
                    filterBy: recordValue?.toString() ?? '',
                    orderBy: filterValue?.toString() ?? '',
                    pageNo: pageNo.toString(),
                    sortBy: entryValue?.toString() ?? '',
                    vendorKey: vendorKey,
                    micID: micID,
                    baseID: baseID,
                    widthID: widthID,
                    fromDate: fromDateController.text,
                    toDate: toDateController.text,
                  ),
                ),
              );
            },
            isFilter: true,
          ),
        ),

        Expanded(
          child: BaseFilterDropdownWidget(
            onChanged: (value) {
              setState(() {
                baseID = value;
              });
              jumboRollBloc.add(
                FetchViewJumboRollRecordEvent(
                  param: ViewRecordApiParam(
                    keyword: searchController.text,
                    filterBy: recordValue?.toString() ?? '',
                    orderBy: filterValue?.toString() ?? '',
                    pageNo: pageNo.toString(),
                    sortBy: entryValue?.toString() ?? '',
                    vendorKey: vendorKey,
                    micID: micID,
                    baseID: baseID,
                    widthID: widthID,
                    fromDate: fromDateController.text,
                    toDate: toDateController.text,
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: MicronDropdownWidget(
            onChanged: (value) {
              setState(() {
                micID = value;
              });
              jumboRollBloc.add(
                FetchViewJumboRollRecordEvent(
                  param: ViewRecordApiParam(
                    keyword: searchController.text,
                    filterBy: recordValue?.toString() ?? '',
                    orderBy: filterValue?.toString() ?? '',
                    pageNo: pageNo.toString(),
                    sortBy: entryValue?.toString() ?? '',
                    vendorKey: vendorKey,
                    micID: micID,
                    baseID: baseID,
                    widthID: widthID,
                    fromDate: fromDateController.text,
                    toDate: toDateController.text,
                  ),
                ),
              );
            },
            isFilter: true,
            size: 37,
          ),
        ),
        Expanded(
          child: MasterRoleSizeSelector(
            onChanged: (value) {
              setState(() {
                widthID = value;
              });
              jumboRollBloc.add(
                FetchViewJumboRollRecordEvent(
                  param: ViewRecordApiParam(
                    keyword: searchController.text,
                    filterBy: recordValue?.toString() ?? '',
                    orderBy: filterValue?.toString() ?? '',
                    pageNo: pageNo.toString(),
                    sortBy: entryValue?.toString() ?? '',
                    vendorKey: vendorKey,
                    micID: micID,
                    baseID: baseID,
                    widthID: widthID,
                    fromDate: fromDateController.text,
                    toDate: toDateController.text,
                  ),
                ),
              );
            },
            isFilter: true,
            size: 37,
            selectedRole: widthID,
          ),
        ),
      ],
    ),
  );

  Widget get refreshButton => SizedBox(
    width: MediaQuery.sizeOf(context).width * .15,
    height: 35,
    child: RefreshButton(
      onPressed: () {
        setState(() {
          pageNo = 1;
        });
        jumboRollBloc.add(
          FetchViewJumboRollRecordEvent(
            param: ViewRecordApiParam(
              keyword: searchController.text,
              filterBy: recordValue?.toString() ?? '',
              orderBy: filterValue?.toString() ?? '',
              pageNo: pageNo.toString(),
              sortBy: entryValue?.toString() ?? '',
              vendorKey: vendorKey,
              micID: micID,
              baseID: baseID,
              widthID: widthID,
              fromDate: fromDateController.text,
              toDate: toDateController.text,
            ),
          ),
        );
      },
    ),
  );

  Widget get buildFilterFieldsDesktop => Column(
    children: [
      DateFiltration(
        fromDateController: fromDateController,
        toDateController: toDateController,
        onFromChanged: (value) {
          setState(() {
            fromDateController.text = value;
          });
          jumboRollBloc.add(
            FetchViewJumboRollRecordEvent(
              param: ViewRecordApiParam(
                keyword: searchController.text,
                filterBy: recordValue?.toString() ?? '',
                orderBy: filterValue?.toString() ?? '',
                pageNo: pageNo.toString(),
                sortBy: entryValue?.toString() ?? '',
                vendorKey: vendorKey,
                micID: micID,
                baseID: baseID,
                widthID: widthID,
                fromDate: fromDateController.text,
                toDate: toDateController.text,
              ),
            ),
          );
        },
        onToChanged: (value) {
          setState(() {
            toDateController.text = value;
          });
          jumboRollBloc.add(
            FetchViewJumboRollRecordEvent(
              param: ViewRecordApiParam(
                keyword: searchController.text,
                filterBy: recordValue?.toString() ?? '',
                orderBy: filterValue?.toString() ?? '',
                pageNo: pageNo.toString(),
                sortBy: entryValue?.toString() ?? '',
                vendorKey: vendorKey,
                micID: micID,
                baseID: baseID,
                widthID: widthID,
                fromDate: fromDateController.text,
                toDate: toDateController.text,
              ),
            ),
          );
        },
      ),
      searchFields,
      // SizedBox(height: 15),
      extraFilterFields,
      SizedBox(height: 15),

      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          refreshButton,

          if (isMultipleSelection) buildSelectionActions(),
          SizedBox(width: 10),
          FileExportButton(
            onPressed: () async {
              await JumboRollExporter.exportJumboRollExcelFile(
                context: context,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: toggleMultipleSelection,
                icon: Icon(
                  isMultipleSelection
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: Colors.blue,
                ),
                label: Text(
                  isMultipleSelection
                      ? 'Multiple Selection'
                      : 'Single Selection',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 15),
    ],
  );

  Widget buildSelectionActions() {
    if (!isMultipleSelection || selectedItems.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              await JumboPrintMultipleStickers(selectedItems);
            },
            icon: const Icon(Icons.print),
            label: const Text('Print Stickers'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          MultiDeleteButton(
            selectedItems: selectedItems,
            panel: 'view-jumbo-roll',
            onPressed: () {
              setState(() {
                isMultipleSelection = false;
                selectedItems.clear();
              });
            },
          ),
        ],
      ),
    );
  }

  String formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void handleBulkDelete() {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No items selected'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Implement bulk delete functionality
    print('Bulk deleting ${selectedItems.length} items');
  }

  void handleBulkEdit() {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No items selected'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Implement bulk edit functionality
    print('Bulk editing ${selectedItems.length} items');
  }

  Widget buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search jumbo rolls...',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey[400]),
              ),
              onChanged: (value) {
                // Implement search functionality
              },
            ),
          ),
          const SizedBox(width: 16),
          // Toggle selection mode button
          TextButton.icon(
            onPressed: () {
              setState(() {
                isMultipleSelection = !isMultipleSelection;
              });
            },
            icon: Icon(
              isMultipleSelection
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: Colors.blue,
            ),
            label: Text(
              isMultipleSelection ? 'Multiple Selection' : 'Single Selection',
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  //! tablet
}
