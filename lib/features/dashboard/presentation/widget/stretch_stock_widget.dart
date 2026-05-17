import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/features/bloc/app_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/base_filter_field.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/widgets/micron_dropdown_widget.dart';
import 'package:indogrip/features/outsource/presentation/widget/master_stretch_film_widget.dart';
import 'package:indogrip/features/outsource/presentation/widget/stretch_detail_box.dart';
import 'package:indogrip/features/round/presentation/widgets/core_dropdown.dart';

class StretchStockWidget extends StatefulWidget {
  const StretchStockWidget({super.key});

  @override
  State<StretchStockWidget> createState() => _StretchStockWidgetState();
}

class _StretchStockWidgetState extends State<StretchStockWidget>
    with SingleTickerProviderStateMixin {
  late final AppBloc appBloc;
  late AnimationController _animationController;
  String? baseID;
  String? filmSizeID;
  String? coreID;
  String? stretchMicID;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _animationController.forward();
    appBloc = AppBloc()
      ..add(
        LoadStretchStockDataEvent(
          baseID: baseID ?? '',
          filmSizeID: filmSizeID ?? '',
          coreID: coreID ?? '',
          micID: stretchMicID ?? '',
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
              colors: [Colors.white, Colors.purple.shade50],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.purple.shade100, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.08),
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
            padding: const EdgeInsets.all(28),
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
              colors: [Color(0xFFA855F7), Color(0xFF7E22CE)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.library_add_rounded,
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
                'Stretch Carton Stock',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF3F0F5C),
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Monitor and manage stretch film inventory',
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
                child: CoreDropdown(
                  size: 37,
                  onChanged: (value) {
                    setState(() {
                      coreID = value;
                    });
                    appBloc.add(
                      LoadStretchStockDataEvent(
                        baseID: baseID ?? '',
                        filmSizeID: filmSizeID ?? '',
                        coreID: coreID ?? '',
                        micID: stretchMicID ?? '',
                      ),
                    );
                  },
                  isFilter: true,
                  selectedCore: '',
                ),
              ),
              Expanded(
                child: MasterStretchFilmWidget(
                  onChanged: (value) {
                    setState(() {
                      filmSizeID = value;
                    });
                    appBloc.add(
                      LoadStretchStockDataEvent(
                        baseID: baseID ?? '',
                        filmSizeID: filmSizeID ?? '',
                        coreID: coreID ?? '',
                        micID: stretchMicID ?? '',
                      ),
                    );
                  },
                  isFilter: true,
                  size: 37,
                ),
              ),
              Expanded(
                child: MicronDropdownWidget(
                  onChanged: (value) {
                    setState(() {
                      stretchMicID = value;
                    });
                    appBloc.add(
                      LoadStretchStockDataEvent(
                        baseID: baseID ?? '',
                        filmSizeID: filmSizeID ?? '',
                        coreID: coreID ?? '',
                        micID: stretchMicID ?? '',
                      ),
                    );
                  },
                  isFilter: true,
                  size: 37,
                ),
              ),
              Expanded(
                child: BaseFilterDropdownWidget(
                  onChanged: (value) {
                    setState(() {
                      baseID = value;
                    });
                    appBloc.add(
                      LoadStretchStockDataEvent(
                        baseID: baseID ?? '',
                        filmSizeID: filmSizeID ?? '',
                        coreID: coreID ?? '',
                        micID: stretchMicID ?? '',
                      ),
                    );
                  },
                ),
              ),

              Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return BlocBuilder<AppBloc, AppState>(
      bloc: appBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case AppStretchLoadingState:
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
                          Color(0xFFA855F7),
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
          case LoadStretchStockDataSuccessAppState:
            final successState = state as LoadStretchStockDataSuccessAppState;
            return successState.model.status == 1
                ? Container(
                    alignment: Alignment.center,
                    // padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.purple.shade50, Colors.pink.shade50],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.purple.shade100,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StretchDetailBox(
                          availableCarton: successState.model.availableCarton
                              .toString(),
                          totalNetWeight: successState.model.totalNetWeight
                              .toString(),
                          totalGrossWeight: successState.model.totalGrossWeight
                              .toString(),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.orange.shade200,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
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
                            successState.model.message ?? 'try again later',
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
          case LoadStretchStockDataErrorAppState:
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
                  const Expanded(
                    child: Text(
                      'Failed to load stretch stock data',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                        color: Color(0xFFD32F2F),
                      ),
                    ),
                  ),
                ],
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
