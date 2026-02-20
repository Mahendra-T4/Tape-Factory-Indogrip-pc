import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/custom_textfield.dart';
import 'package:indogrip/features/dashboard/data/model/show_static_model.dart';
import 'package:indogrip/features/dashboard/presentation/bloc/home_bloc.dart';
import 'package:indogrip/features/dashboard/presentation/page/deshboard.dart';
import 'package:indogrip/features/dashboard/presentation/widget/base_dasboard_widget.dart';
import 'package:indogrip/features/dashboard/presentation/widget/dashboard_kpi_card.dart';
import 'package:indogrip/features/dashboard/presentation/widget/dashboard_section_header.dart';
import 'package:indogrip/features/dashboard/presentation/widget/filmsize_dashboard_widget.dart';
import 'package:indogrip/features/dashboard/presentation/widget/master_carton_type_db.dart';
import 'package:indogrip/features/dashboard/presentation/widget/master_core_db_widget.dart';
import 'package:indogrip/features/dashboard/presentation/widget/master_cuttmmmeter_db_widget.dart';
import 'package:indogrip/features/dashboard/presentation/widget/width_db_widget.dart';
import 'package:indogrip/features/global/presentation/widget/refresh_button.dart';
import 'package:indogrip/features/outsource/presentation/widget/master_product_type_model.dart';

abstract class DashboardBuilder extends State<IndoGripDashboard> {
  late final HomeBloc homeBloc;
  String? selectedProduct;
  final TextEditingController amountPerKg = TextEditingController();
  final TextEditingController wastagePercentage = TextEditingController();
  final TextEditingController conversionRate = TextEditingController();

  @override
  void initState() {
    homeBloc = HomeBloc();
    homeBloc.add(FetchDashboardStaticsEvent());
    super.initState();
  }

  Widget buildJumboRollStatics({
    required int? totalRolls,
    required int? thisMonth,
    required int? inStock,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF3498DB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.assignment_rounded,
                  color: Color(0xFF3498DB),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Jumbo Roll',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          buildStatRow('Total Rolls', totalRolls?.toString() ?? '0'),
          SizedBox(height: 12),
          buildStatRow('This Month', thisMonth?.toString() ?? '0'),
          SizedBox(height: 12),
          buildStatRow('In Stock', inStock?.toString() ?? '0'),
        ],
      ),
    );
  }

  Widget buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF7F8C8D),
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xFF3498DB).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBatchInfoStatics({
    required int? totalBatch,
    required int? thisMonth,
    required int? inStock,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF27AE60).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.batch_prediction_rounded,
                  color: Color(0xFF27AE60),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Batch Info',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          buildStatRow('Total Batch', totalBatch?.toString() ?? '0'),
          SizedBox(height: 12),
          buildStatRow('This Month', thisMonth?.toString() ?? '0'),
          SizedBox(height: 12),
          buildStatRow('In Stock', inStock?.toString() ?? '0'),
        ],
      ),
    );
  }

  Widget buildCartonStatics({
    required int? small,
    required int? medium,
    required int? large,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFE74C3C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.inventory_2_rounded,
                  color: Color(0xFFE74C3C),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Carton Stock',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          buildCoreTypeRow(
            'Small',
            small?.toString() ?? '0',
            Color(0xFFF1C40F),
          ),
          SizedBox(height: 12),
          buildCoreTypeRow(
            'Medium',
            medium?.toString() ?? '0',
            Color(0xFFE67E22),
          ),
          SizedBox(height: 12),
          buildCoreTypeRow(
            'Large',
            large?.toString() ?? '0',
            Color(0xFFE74C3C),
          ),
        ],
      ),
    );
  }

  // Widget get defaultSettings => Container(
  //   margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
  //   padding: const EdgeInsets.all(24),
  //   decoration: BoxDecoration(
  //     color: Colors.white,
  //     borderRadius: BorderRadius.circular(16),
  //     border: Border.all(color: Colors.grey[200]!, width: 1),
  //     boxShadow: [
  //       BoxShadow(
  //         color: Colors.black.withOpacity(0.04),
  //         blurRadius: 12,
  //         offset: const Offset(0, 4),
  //       ),
  //     ],
  //   ),
  //   child: Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Default Settings',
  //         style: const TextStyle(
  //           fontSize: 18,
  //           fontWeight: FontWeight.bold,
  //           color: Color(0xFF2C3E50),
  //           letterSpacing: -0.5,
  //         ),
  //       ),
  //       const SizedBox(height: 4),
  //       Text(
  //         'Configure default values for inventory calculations',
  //         style: TextStyle(
  //           fontSize: 13,
  //           color: Colors.grey[600],
  //           fontWeight: FontWeight.w400,
  //         ),
  //       ),
  //       const SizedBox(height: 24),
  //       Row(
  //         spacing: 24,
  //         children: [
  //           Expanded(
  //             child: _buildSettingField(
  //               label: 'Amount Per KG',
  //               controller: amountPerKg,
  //               icon: Icons.currency_rupee,
  //             ),
  //           ),
  //           Expanded(
  //             child: _buildSettingField(
  //               label: 'Wastage Percentage',
  //               controller: wastagePercentage,
  //               icon: Icons.percent,
  //             ),
  //           ),
  //           Expanded(
  //             child: _buildSettingField(
  //               label: 'Conversion Rate',
  //               controller: conversionRate,
  //               icon: Icons.trending_up,
  //             ),
  //           ),
  //         ],
  //       ),
  //       Row(
  //         spacing: 20,
  //         children: [
  //           Expanded(child: SizedBox()),
  //           Expanded(child: SizedBox()),
  //           Expanded(child: SizedBox()),
  //           Expanded(
  //             child: CustomButton(label: 'Submit', onPressed: () {}),
  //           ),
  //         ],
  //       ),
  //     ],
  //   ),
  // );

  Widget _buildSettingField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color(0xFF3498DB).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: Color(0xFF3498DB)),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CustomTextField(controller: controller),
      ],
    );
  }

  Widget stockManagementWidget(
    CartonStockInformation data,
    CoreStockInformation core,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Master',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C3E50),
        ),
      ),
      SizedBox(height: 20),
      Row(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: buildCartonStatics(
              small: data.small,
              medium: data.medium,
              large: data.large,
            ),
          ),
          Expanded(
            child: buildCoreStatics(
              regular: core.regular,
              heavy: core.heavy,
              extraHeavy: core.extraHeavy,
            ),
          ),
        ],
      ),
    ],
  );

  Widget buildSizeRow(String size, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            SizedBox(width: 8),
            Text(
              size,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF7F8C8D),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCoreStatics({
    required int? regular,
    required int? heavy,
    required int? extraHeavy,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF16A085).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.donut_large_rounded,
                  color: Color(0xFF16A085),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Core Stock',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          buildCoreTypeRow(
            'Regular',
            regular?.toString() ?? '0',
            Color(0xFF1ABC9C),
          ),
          SizedBox(height: 12),
          buildCoreTypeRow(
            'Heavy',
            heavy?.toString() ?? '0',
            Color(0xFF16A085),
          ),
          SizedBox(height: 12),
          buildCoreTypeRow(
            'Extra Heavy',
            extraHeavy?.toString() ?? '0',
            Color(0xFF0E6655),
          ),
        ],
      ),
    );
  }

  Widget buildCoreTypeRow(String type, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            type,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF2C3E50),
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get productWidget => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      spacing: 35,
      children: [
        Expanded(
          child: MasterProductTypeWidget(
            value: selectedProduct,
            onChanged: (val) => setState(() => selectedProduct = val),
          ),
        ),
        // Expanded(child: SizedBox()),
        SizedBox(width: 210),
        Expanded(child: SizedBox()),
      ],
    ),
  );

  // Widget get refreshButton =>

  Widget get desktopWidgetWrapper => BlocBuilder(
    bloc: homeBloc,
    builder: (context, state) {
      if (state is HomeLoadingStatus) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is HomeDashboardStaticsSuccessStatus) {
        final data = state.showStaticModel;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // KPI Metrics Section
              // if (Responsive.isDesktop(context)) _buildKPIMetrics(data),
              // SizedBox(height: Responsive.isDesktop(context) ? 32 : 20),

              // Configuration Section
              // defaultSettings,
              SizedBox(height: Responsive.isDesktop(context) ? 32 : 20),

              // Stock Overview Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DashboardSectionHeader(
                  title: 'Stock Management',
                  subtitle: 'Real-time stock status across categories',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildInventoryOverview(data),
              ),
              SizedBox(height: Responsive.isDesktop(context) ? 32 : 20),

              // Master Data Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DashboardSectionHeader(
                  title: 'Master Data Management',
                  subtitle: 'Manage and monitor all product configurations',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildMasterDataGrid(data),
              ),
              SizedBox(height: Responsive.isDesktop(context) ? 32 : 20),

              // Analytics Section
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: DashboardSectionHeader(
              //     title: 'Detailed Analytics',
              //     subtitle: 'In-depth analysis of batch and micron information',
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: _buildAnalyticsSection(data),
              // ),
            ],
          ),
        );
      } else if (state is HomeDashboardStaticsErrorStatus) {
        return Center(
          child: RefreshButton(
            onPressed: () {
              homeBloc.add(FetchDashboardStaticsEvent());
            },
          ),
        );
      }
      return const SizedBox.shrink();
    },
  );

  Widget _buildKPIMetrics(ShowStaticModel data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardSectionHeader(
            title: 'Key Performance Indicators',
            subtitle: 'Monitor your business metrics at a glance',
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              DashboardKPICard(
                title: 'Total Jumbo Rolls',
                value: data.jumboInformation?.totalJumboRoll.toString() ?? '0',
                subtitle: 'In all categories',
                icon: Icons.assignment_rounded,
                accentColor: const Color(0xFF3498DB),
                trend: '+12%',
              ),
              DashboardKPICard(
                title: 'Total Batches',
                value: data.batchInformation?.totalBatch.toString() ?? '0',
                subtitle: 'This month',
                icon: Icons.batch_prediction_rounded,
                accentColor: const Color(0xFF27AE60),
                trend: '+8%',
              ),
              DashboardKPICard(
                title: 'In Stock Items',
                value:
                    ((data.cartonStockInformation?.small ?? 0) +
                            (data.cartonStockInformation?.medium ?? 0) +
                            (data.cartonStockInformation?.large ?? 0))
                        .toString(),
                subtitle: 'Carton stock',
                icon: Icons.inventory_2_rounded,
                accentColor: const Color(0xFFE67E22),
                trend: '-3%',
              ),
              DashboardKPICard(
                title: 'Core Stock',
                value:
                    ((data.coreStockInformation?.regular ?? 0) +
                            (data.coreStockInformation?.heavy ?? 0) +
                            (data.coreStockInformation?.extraHeavy ?? 0))
                        .toString(),
                subtitle: 'All types',
                icon: Icons.donut_large_rounded,
                accentColor: const Color(0xFF16A085),
                trend: '+5%',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryOverview(ShowStaticModel data) {
    return Row(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(child: MasterCartonTypeDropDownDB()),
        Flexible(child: CoreDropdownDB()),

        Expanded(child: WidthDropdownDBWidget()),
      ],
    );
  }

  Widget _buildStockSummaryItem(String label, int value, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterDataGrid(ShowStaticModel data) {
    return Column(
      spacing: 20,
      children: [
        Row(
          spacing: 20,
          children: [
            Expanded(
              child: _buildMasterDataCard(
                title: 'Roll Sizes',
                icon: Icons.aspect_ratio,
                color: const Color(0xFF3498DB),
                child: MasterRoleSizeDBSelector(),
              ),
            ),
            Expanded(
              child: _buildMasterDataCard(
                title: 'Micron Details',
                icon: Icons.category,
                color: const Color(0xFF27AE60),
                child: _buildMicronDetailsTable(data),
              ),
            ),
            Expanded(
              child: _buildMasterDataCard(
                title: 'Base Type',
                icon: Icons.donut_large_rounded,
                color: const Color(0xFF16A085),
                child: BaseDashboardWidget(),
              ),
            ),
            // _buildMasterDataCard(
            //   title: 'Width Options',
            //   icon: Icons.width_full,
            //   color: const Color(0xFF9B59B6),
            //   child: WidthDropdownDBWidget(),
            // ),
          ],
        ),
        Row(
          spacing: 20,
          children: [
            Expanded(
              child: _buildMasterDataCard(
                title: 'Film Sizes',
                icon: Icons.aspect_ratio,
                color: const Color(0xFF3498DB),
                child: MasterStretchFilmDashboardWidget(),
              ),
            ),
            Expanded(child: SizedBox()),
            Expanded(child: SizedBox()),
            // _buildMasterDataCard(
            //   title: 'Width Options',
            //   icon: Icons.width_full,
            //   color: const Color(0xFF9B59B6),
            //   child: WidthDropdownDBWidget(),
            // ),
          ],
        ),
      ],
    );
  }

  Widget _buildMasterDataCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      height: 550,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 15),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(padding: const EdgeInsets.all(12), child: child),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSection(ShowStaticModel data) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B59B6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: Color(0xFF9B59B6),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Micron Batch Analytics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(height: 450, child: _buildMicronDetailsTable(data)),
        ],
      ),
    );
  }

  Widget _buildMicronDetailsTable(ShowStaticModel data) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF9B59B6).withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Micron',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF9B59B6),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Tape',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF9B59B6),
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Stretch',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF9B59B6),
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.micBatchInformation?.length ?? 0,
          itemBuilder: (context, index) {
            final item = data.micBatchInformation![index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: index.isEven
                    ? const Color(0xFF9B59B6).withOpacity(0.03)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!, width: 0.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.mic.toString(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.batch.toString(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C3E50),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.piece.toString(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C3E50),
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
