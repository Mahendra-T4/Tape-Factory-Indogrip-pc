import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/widgets/labal_text.dart';
import 'package:indogrip/features/bloc/app_bloc.dart';
import 'package:indogrip/features/dashboard/domain/tape_stock_entity.dart';
import 'package:indogrip/features/global/presentation/widget/base_filter_field.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/widgets/micron_dropdown_widget.dart';
import 'package:indogrip/features/round/presentation/widgets/master_roll_size_widget.dart';
import 'package:indogrip/features/round/presentation/widgets/round_details_box.dart';

class TapeStockWidget extends StatefulWidget {
  const TapeStockWidget({super.key});

  @override
  State<TapeStockWidget> createState() => _TapeStockWidgetState();
}

class _TapeStockWidgetState extends State<TapeStockWidget>
    with SingleTickerProviderStateMixin {
  late final AppBloc appBloc;
  late AnimationController _animationController;
  String? micID, baseID, selectedRoundSize;
  TextEditingController tapLengthController = TextEditingController();
  TextEditingController tapWeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
    appBloc = AppBloc();
    appBloc.add(
      LoadTapeStockDataEvent(
        param: TapeStockEntity(
          baseID: baseID ?? '',
          micID: micID ?? '',
          cutMMMeterID: selectedRoundSize ?? '',
          tapeLength: tapLengthController.text,
          weight: tapWeightController.text,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeOut,
              ),
            ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.blue.shade50],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue.shade100, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.08),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildFiltersSection(),
                const SizedBox(height: 24),
                _buildContentSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2D8FCF), Color(0xFF1E5BA8)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.inventory_2_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tape Carton Stock',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A3A52),
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Manage and track tape inventory levels',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filters',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.grey[700],
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              spacing: Responsive.betweenSpace,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: MasterRoleSizeSelector(
                    onChanged: (value) {
                      setState(() {
                        selectedRoundSize = value;
                      });
                      appBloc.add(
                        LoadTapeStockDataEvent(
                          param: TapeStockEntity(
                            baseID: baseID ?? '',
                            micID: micID ?? '',
                            cutMMMeterID: selectedRoundSize ?? '',
                            tapeLength: tapLengthController.text,
                          ),
                        ),
                      );
                    },
                    isFilter: true,
                    size: 37,
                    selectedRole: selectedRoundSize,
                  ),
                ),
                Expanded(
                  child: BaseFilterDropdownWidget(
                    onChanged: (value) {
                      setState(() {
                        baseID = value;
                      });
                      appBloc.add(
                        LoadTapeStockDataEvent(
                          param: TapeStockEntity(
                            baseID: baseID ?? '',
                            micID: micID ?? '',
                            cutMMMeterID: selectedRoundSize ?? '',
                            tapeLength: tapLengthController.text,
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
                      appBloc.add(
                        LoadTapeStockDataEvent(
                          param: TapeStockEntity(
                            baseID: baseID ?? '',
                            micID: micID ?? '',
                            cutMMMeterID: selectedRoundSize ?? '',
                            tapeLength: tapLengthController.text,
                          ),
                        ),
                      );
                    },
                    isFilter: true,
                    size: 37,
                  ),
                ),
                Expanded(
                  child: _extraSearchTF(
                    (value) {
                      appBloc.add(
                        LoadTapeStockDataEvent(
                          param: TapeStockEntity(
                            baseID: baseID ?? '',
                            micID: micID ?? '',
                            cutMMMeterID: selectedRoundSize ?? '',
                            tapeLength: tapLengthController.text,
                          ),
                        ),
                      );
                    },
                    tapLengthController,
                    'Enter Tape Length',
                    'Tape Length',
                  ),
                ),
                Expanded(
                  child: _extraSearchTF(
                    (value) {
                      appBloc.add(
                        LoadTapeStockDataEvent(
                          param: TapeStockEntity(
                            baseID: baseID ?? '',
                            micID: micID ?? '',
                            cutMMMeterID: selectedRoundSize ?? '',
                            tapeLength: tapLengthController.text,
                          ),
                        ),
                      );
                      //! call event with tape width parameter
                    },
                    tapWeightController,
                    'Enter Tape Weight',
                    'Tape Weight',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return BlocBuilder(
      bloc: appBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case AppLoadingState:
            return Center(
              child: Container(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF2D8FCF),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Loading inventory data...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          case LoadTapeStockDataSuccessAppState:
            final data = (state as LoadTapeStockDataSuccessAppState).model;
            return data.status == 1
                ? Container(
                    height: 70,
                    alignment: Alignment.center,

                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue.shade50, Colors.indigo.shade50],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.blue.shade100,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundDetailBox(
                          totalAvailableCarton: data.availableCarton.toString(),
                          fromInventory: data.inventoryCarton.toString(),
                          fromJumbo: data.roundCarton.toString(),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.orange.shade200,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.info_rounded,
                            color: Colors.orange[700],
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            data.message ?? 'No data available',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.orange[900],
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          case LoadTapeStockDataErrorAppState:
            final message = (state as LoadTapeStockDataErrorAppState).message;
            return Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.red.shade200, width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_rounded,
                      color: Colors.red[700],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      message.toString(),
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.red[900],
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _extraSearchTF(
    void Function(String)? onChanged,
    TextEditingController controller,
    String hint,
    String label,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        LabelText(label),
        Container(
          height: 37,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              prefixIcon: Icon(
                Icons.search,
                color: Color(0xFF2D8FCF),
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF2D8FCF), width: 1.5),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            ),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: ColourPalette.textFieldLabelColor,
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
