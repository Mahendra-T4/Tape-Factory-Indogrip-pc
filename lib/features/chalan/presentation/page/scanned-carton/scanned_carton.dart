import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:indogrip/core/database/init_box.dart';
import 'package:indogrip/core/database/round_db_hive.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/chalan/data/model/round_data_model.dart';
import 'package:indogrip/features/chalan/data/model/round_details_model.dart';
import 'package:indogrip/features/chalan/presentation/page/scanned-carton/miss_record.dart';
import 'package:indogrip/features/chalan/presentation/page/scanned-carton/submittion_success_msg.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';

class ScannedData {
  final String rKey;
  final String clientKey;

  ScannedData({required this.rKey, required this.clientKey});
}

class ScannedCarton extends StatefulWidget {
  const ScannedCarton({super.key, required this.data});
  // final List<ScanData> scannedItems;
  final ScannedData data;
  static const String routeName = '/scanned-carton';

  @override
  State<ScannedCarton> createState() => _ScannedCartonState();
}

class _ScannedCartonState extends State<ScannedCarton> {
  final GlobalKey<ScaffoldState> statekey = GlobalKey<ScaffoldState>();
  List<String> batchCodes = [];
  List<String> batchQty = [];
  bool _isProcessingBarcode = false; // Track barcode processing state

  final TextEditingController addScannedBarcodeController =
      TextEditingController();
  final FocusNode barcodeFocusNode = FocusNode();

  late final GlobalBloc _globalBloc;
  bool isShowButton = false;
  @override
  void initState() {
    super.initState();
    log('ScannerView initialized with rKey: ${widget.data.clientKey}');
    _globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      barcodeFocusNode.requestFocus();
    });
    loader();
  }

  Future<void> loader() async {
    await Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    addScannedBarcodeController.dispose();
    barcodeFocusNode.dispose();
    super.dispose();
  }

  int _scannedItemCount = 0;
  bool isLoading = true;
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
        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFFF5F7FA),
            key: statekey,
            appBar: !Responsive.isDesktop(context)
                ? MobileAppBar(context, statekey, 'Scanned Cartons')
                : DesktopAppBar(context, statekey, 'Scanned Cartons', false),
            drawer: !Responsive.isDesktop(context)
                ? const SideMenuWidget()
                : null,
            body: isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            primaryColor,
                          ),
                          strokeWidth: 4,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Loading scanned items...',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      children: [
                        buildBarcodeField,
                        Expanded(
                          child: ValueListenableBuilder<Box<RoundDataModel>>(
                            valueListenable: Boxes.roundData().listenable(),
                            builder: (context, box, child) {
                              final scannedData = box.values
                                  .toList()
                                  .cast<RoundDataModel>();
                              final scannedDataByKey = scannedData
                                  .where(
                                    (element) =>
                                        element.rKey == widget.data.rKey,
                                  )
                                  .toList()
                                  .reversed
                                  .toList();
                              final scannedQntByKey = scannedData
                                  .where(
                                    (element) =>
                                        element.quantity.toString() ==
                                        element.quantity,
                                  )
                                  .toList()
                                  .reversed
                                  .toList();
                              // final unitIndexList = scannedData
                              //     .where(
                              //       (element) =>
                              //           element.unitIndex.toString() == element.unitIndex,
                              //     )
                              //     .toList()
                              //     .reversed
                              //     .toList();

                              _scannedItemCount = scannedDataByKey.length;

                              // Update state variables without calling setState during build
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted &&
                                    scannedDataByKey.isNotEmpty &&
                                    !isShowButton) {
                                  setState(() {
                                    isShowButton = true;
                                  });
                                }
                              });

                              batchCodes = scannedDataByKey
                                  .map(
                                    (element) =>
                                        element.batchID?.split(',').join(',') ??
                                        '',
                                  )
                                  .toList();
                              batchQty = scannedQntByKey
                                  .map(
                                    (element) =>
                                        element.quantity
                                            ?.split(',')
                                            .join(',') ??
                                        '',
                                  )
                                  .toList();

                              // unitIndex = unitIndexList
                              //     .map(
                              //       (element) =>
                              //           element.unitIndex?.split(',').join(',') ?? '',
                              //     )
                              //     .toList();
                              return scannedDataByKey.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(24),
                                            decoration: BoxDecoration(
                                              color: primaryColor.withOpacity(
                                                0.1,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.inbox_rounded,
                                              size: 64,
                                              color: primaryColor.withOpacity(
                                                0.5,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            'No Scanned Items',
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Start scanning cartons to see them here',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Stack(
                                      children: [
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                              0.5,
                                          child: ListView.builder(
                                            padding: const EdgeInsets.all(16),
                                            itemCount: scannedDataByKey.length,
                                            itemBuilder: (context, index) {
                                              final item =
                                                  scannedDataByKey[index];

                                              return _buildCartonCard(
                                                item,
                                                index,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
            bottomNavigationBar: _buildBottomSubmitBar(),
          ),
        );
      },
    );
  }

  Widget _buildCartonCard(RoundDataModel item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),

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
            color: const Color(0xFF2D7FD9).withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Theme(
            data: ThemeData(useMaterial3: true),
            child: Material(
              color: Colors.transparent,
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
                  border: Border.all(
                    color: Colors.white.withOpacity(0.6),
                    width: 1.2,
                  ),
                ),
                child: ExpansionTile(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide.none,
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide.none,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF2D7FD9).withOpacity(0.9),
                          const Color(0xFF2D7FD9).withOpacity(0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2D7FD9).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.qr_code_2_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          item.batchCode?.toString() ?? 'N/A',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2D7FD9),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF2D7FD9).withOpacity(0.12),
                              const Color(0xFF2D7FD9).withOpacity(0.06),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF2D7FD9).withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Item ${index + 1}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2D7FD9),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.warning,
                                    color: Colors.orange,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Delete Item?',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            content: Text(
                              'Remove this scanned carton permanently. This action cannot be undone.',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => context.pop(false),
                                child: Text(
                                  'Keep',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => context.pop(true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade500,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Delete',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (shouldDelete == true) {
                          item.delete();
                          setState(() {
                            _scannedItemCount--;
                            if (_scannedItemCount == 0) {
                              isShowButton = false;
                            }
                          });
                        }
                      },
                      icon: Icon(
                        Icons.delete_rounded,
                        color: Colors.red.shade500,
                        size: 22,
                      ),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  const Color(0xFF2D7FD9).withOpacity(0.2),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Details',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF2D7FD9),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailGrid(item),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailGrid(RoundDataModel item) {
    return Column(
      children: [
        _buildDetailRow2(
          'BatchCode',
          item.batchCode,

          item.productType == 1 ? 'Cut MM Meter' : 'Stretch Weight',
          item.productType == 1 ? item.cutMMMeter : item.stretchWeigh,
        ),
        const SizedBox(height: 12),
        _buildDetailRow2(
          'Mic Label',
          item.micLabel,
          'Base Label',
          item.baseLabel,
        ),
        // const SizedBox(height: 12),
        // _buildDetailRow2('Mic ID', item.micID),
        const SizedBox(height: 12),
        item.productType == 1
            ? _buildDetailRow2(
                item.showFor == '1' ? 'Tape Length' : 'Tape Weight',
                item.showFor == '1' ? item.tapeLength : item.tapeWeight,
                'Round Count',
                item.roundCount,
              )
            : _buildDetailRow2(
                'Operation',
                item.operation,
                'Round Count',
                item.roundCount,
              ),
        // const SizedBox(height: 12),
        // _buildDetailRow2(
        //   'So',
        //  ,
        //   'Tape Weight',
        //   ,
        // ),
        const SizedBox(height: 12),
        _buildDetailRow2(
          item.productType == 1 ? 'Pieces Per Carton' : 'Size',
          item.productType == 1 ? item.piecesPerCarton : item.size,

          'Display MFG',
          item.displayMFG,
        ),
        // const SizedBox(height: 12),
        // _buildDetailRow2('Unit', item.unitName, '', ''),

        // const SizedBox(height: 12),
      ],
    );
  }

  String _convertToString(dynamic value) {
    if (value == null) return 'N/A';
    if (value is String) return value;
    if (value is List) {
      return value.join(', ');
    }
    return value.toString();
  }

  Widget _buildDetailRow2(
    String label1,
    dynamic value1,
    String label2,
    dynamic value2,
  ) {
    final displayValue1 = _convertToString(value1);
    final displayValue2 = _convertToString(value2);

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF2D7FD9).withOpacity(0.12),
                  const Color(0xFF2D7FD9).withOpacity(0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF2D7FD9).withOpacity(0.2),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2D7FD9).withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label1,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  displayValue1,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey.shade900,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF2D7FD9).withOpacity(0.12),
                  const Color(0xFF2D7FD9).withOpacity(0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF2D7FD9).withOpacity(0.2),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2D7FD9).withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label2,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  displayValue2,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey.shade900,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSubmitBar() {
    return Container(
      // width: MediaQuery.sizeOf(context).width * 0.5,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 25,
            spreadRadius: 2,
            offset: const Offset(0, -8),
          ),
          BoxShadow(
            color: const Color(0xFF2D7FD9).withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width * 0.5,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF2D7FD9).withOpacity(0.08),
                    Colors.white.withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF2D7FD9).withOpacity(0.15),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scanned Items',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.done_all_rounded,
                            color: Colors.green.shade500,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$_scannedItemCount Carton${_scannedItemCount != 1 ? 's' : ''}',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (isShowButton) submitButton,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get submitButton => BlocConsumer(
    bloc: _globalBloc,
    listener: (context, state) {
      if (state is SubmitRoundScannedDataSuccessStatus) {
        if (state.model.status == 1) {
          ToastService.instance.showSuccess(
            context,
            state.model.message.toString(),
          );

          GoRouter.of(context).pushNamed(
            SubmittingSuccessMsg.routeName,
            extra: state.model.message.toString(),
          );
          final box = Boxes.roundData();
          box.clear();
        } else {
          ToastService.instance.showError(
            context,
            state.model.message.toString(),
          );
          if (state.model.missedRecord != null &&
              state.model.missedRecord!.isNotEmpty) {
            GoRouter.of(
              context,
            ).pushNamed(MissRecordPanel.routeName, extra: state.model);
          }
        }
      }
      if (state is SubmitRoundScannedDataFailureStatus) {
        ToastService.instance.showError(context, state.errorMessage.toString());
      }
    },
    builder: (context, state) {
      if (state is GlobalLoadingStatus) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF2D7FD9).withOpacity(0.9),
                const Color(0xFF2D7FD9),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2D7FD9).withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ),
        );
      }
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D7FD9).withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 3,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            _globalBloc.add(
              SubmitRoundScannedDataEvent(
                batchCodes: batchCodes,
                clientKey: widget.data.clientKey,
                unitIndex: '',
                batchQty: batchQty,
                rKey: widget.data.rKey,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D7FD9),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          icon: Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
          label: Text(
            'Submit',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ),
      );
    },
  );

  Widget get buildBarcodeField => Container(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 25,
          spreadRadius: 2,
          offset: const Offset(0, -8),
        ),
        BoxShadow(
          color: const Color(0xFF2D7FD9).withOpacity(0.15),
          blurRadius: 20,
          spreadRadius: 0,
          offset: const Offset(0, -4),
        ),
      ],
    ),
    child: Row(
      children: [
        // Expanded(child: SizedBox()),
        Expanded(child: SizedBox()),
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: addScannedBarcodeController.text.isNotEmpty
                    ? const Color(0xFF2D8FCF)
                    : const Color(0xFFE5E7EB),
                width: 1.5,
              ),
              boxShadow: addScannedBarcodeController.text.isNotEmpty
                  ? [
                      BoxShadow(
                        color: const Color(0xFF2D8FCF).withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: TextFormField(
              controller: addScannedBarcodeController,
              focusNode: barcodeFocusNode,
              onChanged: (value) {
                // Auto-submit when hardware scanner sends newline character
                if (value.endsWith('\n')) {
                  addScannedBarcodeController.text = value
                      .replaceAll('\n', '')
                      .trim();
                  addScannedBarcodeController.selection =
                      TextSelection.fromPosition(
                        TextPosition(
                          offset: addScannedBarcodeController.text.length,
                        ),
                      );
                  // _addBarcodeWithIsolate();
                }
                // Don't rebuild on every character to preserve focus on table fields
              },
              onFieldSubmitted: (_) {
                // _addBarcodeWithIsolate();
                // Re-request focus immediately since onFieldSubmitted removes it
                barcodeFocusNode.requestFocus();
              },
              decoration: InputDecoration(
                hintText: 'Scan or enter barcode...',
                hintStyle: TextStyle(
                  color: const Color(0xFF9CA3AF),
                  fontSize: 14,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.barcode_reader,
                    color: addScannedBarcodeController.text.isNotEmpty
                        ? const Color(0xFF2D8FCF)
                        : const Color(0xFFD1D5DB),
                    size: 20,
                  ),
                ),
                suffixIcon: addScannedBarcodeController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            addScannedBarcodeController.clear();
                          });
                          barcodeFocusNode.requestFocus();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.close_outlined,
                            color: const Color(0xFF2D8FCF).withOpacity(0.5),
                            size: 20,
                          ),
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF2D8FCF),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: buildModernAddButton()),
        Expanded(child: SizedBox()),
        // Expanded(child: SizedBox()),
      ],
    ),
  );

  String _safeValue(dynamic value, {String defaultValue = 'N/A'}) {
    if (value == null) return defaultValue;
    if (value is String) return value.isEmpty ? defaultValue : value;
    if (value is int || value is double) return value.toString();
    return value.toString();
  }

  Widget buildModernAddButton() {
    return BlocConsumer<GlobalBloc, GlobalState>(
      bloc: _globalBloc,
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
        final isLoading = state is GlobalLoadingStatus;

        return SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: isLoading || addScannedBarcodeController.text.isEmpty
                ? null
                : () {
                    if (addScannedBarcodeController.text.isNotEmpty) {
                      _globalBloc.add(
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
                    'Submit Code',
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

  updateScannedItemCount(int count) {
    setState(() {
      _scannedItemCount = count;
    });
  }

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
                                  rKey: widget.data.rKey.toString(),
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

                                updateScannedItemCount(_scannedItemCount + 1);

                                if (mounted) {
                                  ToastService.instance.showSuccess(
                                    context,
                                    'Round details saved successfully!',
                                  );
                                  GoRouter.of(context).pop();
                                  // setState(() {
                                  //   _scannedItemCount =
                                  //       (_scannedItemCount ?? 0) + 1;
                                  // });
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
