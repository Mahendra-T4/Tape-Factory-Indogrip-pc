import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/Assets/assets.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/features/round/presentation/pages/edit/edit_round.dart';
import 'package:indogrip/features/round/presentation/pages/profile/round_profile.dart';

abstract class RoundProfileBuilder extends State<RoundProfile> {
  Widget get contentBuilderWidget {
    final round = widget.round;
    final isMobile = !Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile
              ? 16
              : isTablet
              ? 24
              : 32,
          vertical: isTablet ? 10 : 24,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile
                ? 16
                : isTablet
                ? 24
                : 32,
            vertical: isTablet ? 10 : 24,
          ),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(round),
              SizedBox(height: isMobile ? 24 : 32),
              Row(
                spacing: isMobile ? 12 : 16,
                // runSpacing: isMobile ? 12 : 16,
                children: [
                  _buildInfoCard(
                    icon: Icons.tag,
                    label: 'Roll Number',
                    value: round.rollNumber ?? 'N/A',
                    color: Colors.blue,
                  ),
                  _buildInfoCard(
                    icon: Icons.straighten,
                    label: 'Width',
                    value:
                        '${round.width ?? "N/A"} ${round.width != null ? "mm" : ""}',
                    color: Colors.cyan,
                  ),
                  _buildInfoCard(
                    icon: Icons.circle,
                    label: 'Base',
                    value: round.base ?? 'N/A',
                    color: Colors.teal,
                  ),
                ],
              ),

              Row(
                spacing: isMobile ? 12 : 16,

                children: [
                  _buildInfoCard(
                    icon: Icons.layers,
                    label: 'Micron',
                    value: round.mic ?? 'N/A',
                    color: Colors.green,
                  ),
                  _buildInfoCard(
                    icon: Icons.straight,
                    label: 'Length',
                    value:
                        '${round.length ?? "N/A"} ${round.length != null ? "m" : ""}',
                    color: Colors.lightBlue,
                  ),
                  _buildInfoCard(
                    icon: Icons.format_list_numbered,
                    label: 'Round Count',
                    value: (round.roundCount ?? 0).toString(),
                    color: Colors.orange,
                  ),
                ],
              ),

              Row(
                spacing: isMobile ? 12 : 16,

                children: [
                  _buildInfoCard(
                    icon: Icons.scale,
                    label: 'Total Weight',
                    value:
                        '${round.totalWeight ?? "N/A"} ${round.totalWeight != null ? "kg" : ""}',
                    color: Colors.red,
                  ),
                  _buildInfoCard(
                    icon: Icons.cut,
                    label: 'Cut MM/Meter',
                    value: (round.cutMMMeter ?? 0).toString(),
                    color: Colors.amber,
                  ),
                  _buildInfoCard(
                    icon: Icons.unfold_more,
                    label: 'Tape Length',
                    value: (round.tapeLength ?? 0).toString(),
                    color: Colors.deepOrange,
                  ),
                ],
              ),

              Row(
                spacing: isMobile ? 12 : 16,

                children: [
                  _buildInfoCard(
                    icon: Icons.warning_amber,
                    label: 'Damage Pieces',
                    value: (round.damagePieces ?? 0).toString(),
                    color: Colors.brown,
                  ),
                  _buildInfoCard(
                    icon: Icons.percent,
                    label: 'Used Length',
                    value:
                        '${round.usedLength ?? "N/A"} ${round.usedLength != null ? "m" : ""}',
                    color: Colors.lime,
                  ),
                  _buildInfoCard(
                    icon: Icons.attach_money,
                    label: 'Roll Cost',
                    value:
                        '${round.rollCost ?? "N/A"} ${round.rollCost != null ? "₹" : ""}',
                    color: Colors.green.shade600,
                  ),
                ],
              ),
              Row(
                spacing: isMobile ? 12 : 16,

                children: [
                  _buildInfoCard(
                    icon: Icons.price_check,
                    label: 'Amount Per KG',
                    value:
                        '${round.amountPerKG ?? "N/A"} ${round.amountPerKG != null ? "₹" : ""}',
                    color: Colors.lightGreen,
                  ),
                  _buildInfoCard(
                    icon: Icons.shopping_bag,
                    label: 'Carton Rate',
                    value:
                        '${round.cartonRate ?? "N/A"} ${round.cartonRate != null ? "₹" : ""}',
                    color: Colors.green.shade400,
                  ),
                  _buildInfoCard(
                    icon: Icons.local_shipping,
                    label: 'Carton Material Cost',
                    value:
                        '${round.cartonMaterialCost ?? "N/A"} ${round.cartonMaterialCost != null ? "₹" : ""}',
                    color: Colors.teal.shade400,
                  ),
                ],
              ),

              Row(
                spacing: isMobile ? 12 : 16,

                children: [
                  _buildInfoCard(
                    icon: Icons.calculate,
                    label: 'Conversion Rate',
                    value: (round.conversionRate ?? 0).toString(),
                    color: Colors.purple,
                  ),
                  _buildInfoCard(
                    icon: Icons.percent,
                    label: 'Wastage %',
                    value:
                        '${round.wastagePercentage ?? "N/A"}${round.wastagePercentage != null ? "%" : ""}',
                    color: Colors.purpleAccent,
                  ),
                  _buildInfoCard(
                    icon: Icons.square,
                    label: 'Total Square Meter',
                    value:
                        '${round.totalSquareMtr ?? "N/A"} ${round.totalSquareMtr != null ? "m²" : ""}',
                    color: Colors.indigo,
                  ),
                ],
              ),
              Row(
                spacing: isMobile ? 12 : 16,

                children: [
                  _buildInfoCard(
                    icon: Icons.square_foot,
                    label: 'Used Square Meter',
                    value:
                        '${round.usedSquareMeter ?? "N/A"} ${round.usedSquareMeter != null ? "m²" : ""}',
                    color: Colors.indigoAccent,
                  ),
                  _buildInfoCard(
                    icon: Icons.trending_up,
                    label: 'Rate Per Sq.Meter',
                    value:
                        '${round.ratePerSquareMeter ?? "N/A"} ${round.ratePerSquareMeter != null ? "₹" : ""}',
                    color: Colors.blue.shade600,
                  ),
                  _buildInfoCard(
                    icon: Icons.inventory,
                    label: 'Pieces Per Carton',
                    value: (round.piecesPerCarton ?? 0).toString(),
                    color: Colors.lightBlue,
                  ),
                ],
              ),

              Row(
                spacing: isMobile ? 12 : 16,

                children: [
                  _buildInfoCard(
                    icon: Icons.trending_up,
                    label: 'Margin @ 10%',
                    value:
                        '${round.marginWithTenPercentage ?? "N/A"} ${round.marginWithTenPercentage != null ? "₹" : ""}',
                    color: Colors.green.shade700,
                  ),
                  _buildInfoCard(
                    icon: Icons.trending_up,
                    label: 'Margin @ 12%',
                    value:
                        '${round.marginWithTwelvePercentage ?? "N/A"} ${round.marginWithTwelvePercentage != null ? "₹" : ""}',
                    color: Colors.green.shade600,
                  ),
                  _buildInfoCard(
                    icon: Icons.trending_up,
                    label: 'Margin @ 15%',
                    value:
                        '${round.marginWithFifteenPercentage ?? "N/A"} ${round.marginWithFifteenPercentage != null ? "₹" : ""}',
                    color: Colors.green.shade500,
                  ),
                ],
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget get contentBuilderTabletWidget {
    final round = widget.round;
    final isMobile = !Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile
              ? 16
              : isTablet
              ? 24
              : 32,
          vertical: isTablet ? 10 : 24,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile
                ? 16
                : isTablet
                ? 24
                : 32,
            vertical: 10,
          ),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(round),
              SizedBox(height: 5),
              Row(
                spacing: isMobile ? 12 : 16,
                // runSpacing: isMobile ? 12 : 16,
                children: [
                  _buildInfoCard(
                    icon: Icons.tag,
                    label: 'Roll Number',
                    value: round.rollNumber ?? 'N/A',
                    color: Colors.blue,
                  ),
                  _buildInfoCard(
                    icon: Icons.straighten,
                    label: 'Width',
                    value:
                        '${round.width ?? "N/A"} ${round.width != null ? "mm" : ""}',
                    color: Colors.cyan,
                  ),
                ],
              ),

              Row(
                spacing: isMobile ? 12 : 16,
                // runSpacing: isMobile ? 12 : 16,
                children: [
                  _buildInfoCard(
                    icon: Icons.circle,
                    label: 'Base',
                    value: round.base ?? 'N/A',
                    color: Colors.teal,
                  ),
                  _buildInfoCard(
                    icon: Icons.layers,
                    label: 'Micron',
                    value: round.mic ?? 'N/A',
                    color: Colors.green,
                  ),
                ],
              ),

              Row(
                spacing: isMobile ? 12 : 16,

                children: [
                  _buildInfoCard(
                    icon: Icons.straight,
                    label: 'Length',
                    value:
                        '${round.length ?? "N/A"} ${round.length != null ? "m" : ""}',
                    color: Colors.lightBlue,
                  ),
                  _buildInfoCard(
                    icon: Icons.format_list_numbered,
                    label: 'Round Count',
                    value: (round.roundCount ?? 0).toString(),
                    color: Colors.orange,
                  ),
                ],
              ),

              Row(
                spacing: isMobile ? 12 : 16,

                children: [
                  _buildInfoCard(
                    icon: Icons.scale,
                    label: 'Total Weight',
                    value:
                        '${round.totalWeight ?? "N/A"} ${round.totalWeight != null ? "kg" : ""}',
                    color: Colors.red,
                  ),
                  _buildInfoCard(
                    icon: Icons.cut,
                    label: 'Cut MM/Meter',
                    value: (round.cutMMMeter ?? 0).toString(),
                    color: Colors.amber,
                  ),
                ],
              ),

              Row(
                spacing: isMobile ? 12 : 16,

                children: [
                  _buildInfoCard(
                    icon: Icons.unfold_more,
                    label: 'Tape Length',
                    value: (round.tapeLength ?? 0).toString(),
                    color: Colors.deepOrange,
                  ),
                  _buildInfoCard(
                    icon: Icons.warning_amber,
                    label: 'Damage Pieces',
                    value: (round.damagePieces ?? 0).toString(),
                    color: Colors.brown,
                  ),
                ],
              ),

              Row(
                spacing: isMobile ? 12 : 16,

                children: [
                  _buildInfoCard(
                    icon: Icons.percent,
                    label: 'Used Length',
                    value:
                        '${round.usedLength ?? "N/A"} ${round.usedLength != null ? "m" : ""}',
                    color: Colors.lime,
                  ),
                  _buildInfoCard(
                    icon: Icons.attach_money,
                    label: 'Roll Cost',
                    value:
                        '${round.rollCost ?? "N/A"} ${round.rollCost != null ? "₹" : ""}',
                    color: Colors.green.shade600,
                  ),
                ],
              ),
              Row(
                spacing: isMobile ? 12 : 16,

                children: [
                  _buildInfoCard(
                    icon: Icons.price_check,
                    label: 'Amount Per KG',
                    value:
                        '${round.amountPerKG ?? "N/A"} ${round.amountPerKG != null ? "₹" : ""}',
                    color: Colors.lightGreen,
                  ),
                  _buildInfoCard(
                    icon: Icons.shopping_bag,
                    label: 'Carton Rate',
                    value:
                        '${round.cartonRate ?? "N/A"} ${round.cartonRate != null ? "₹" : ""}',
                    color: Colors.green.shade400,
                  ),
                ],
              ),

              Row(
                spacing: isMobile ? 12 : 16,

                children: [
                  _buildInfoCard(
                    icon: Icons.local_shipping,
                    label: 'Carton Material Cost',
                    value:
                        '${round.cartonMaterialCost ?? "N/A"} ${round.cartonMaterialCost != null ? "₹" : ""}',
                    color: Colors.teal.shade400,
                  ),
                  _buildInfoCard(
                    icon: Icons.calculate,
                    label: 'Conversion Rate',
                    value: (round.conversionRate ?? 0).toString(),
                    color: Colors.purple,
                  ),
                ],
              ),

              Row(
                spacing: isMobile ? 12 : 16,

                children: [
                  _buildInfoCard(
                    icon: Icons.percent,
                    label: 'Wastage %',
                    value:
                        '${round.wastagePercentage ?? "N/A"}${round.wastagePercentage != null ? "%" : ""}',
                    color: Colors.purpleAccent,
                  ),
                  _buildInfoCard(
                    icon: Icons.square,
                    label: 'Total Square Meter',
                    value:
                        '${round.totalSquareMtr ?? "N/A"} ${round.totalSquareMtr != null ? "m²" : ""}',
                    color: Colors.indigo,
                  ),
                ],
              ),
              Row(
                spacing: isMobile ? 12 : 16,

                children: [
                  _buildInfoCard(
                    icon: Icons.square_foot,
                    label: 'Used Square Meter',
                    value:
                        '${round.usedSquareMeter ?? "N/A"} ${round.usedSquareMeter != null ? "m²" : ""}',
                    color: Colors.indigoAccent,
                  ),
                  _buildInfoCard(
                    icon: Icons.trending_up,
                    label: 'Rate Per Sq.Meter',
                    value:
                        '${round.ratePerSquareMeter ?? "N/A"} ${round.ratePerSquareMeter != null ? "₹" : ""}',
                    color: Colors.blue.shade600,
                  ),
                ],
              ),

              Row(
                spacing: isMobile ? 12 : 16,

                children: [
                  _buildInfoCard(
                    icon: Icons.inventory,
                    label: 'Pieces Per Carton',
                    value: (round.piecesPerCarton ?? 0).toString(),
                    color: Colors.lightBlue,
                  ),
                  _buildInfoCard(
                    icon: Icons.trending_up,
                    label: 'Margin @ 10%',
                    value:
                        '${round.marginWithTenPercentage ?? "N/A"} ${round.marginWithTenPercentage != null ? "₹" : ""}',
                    color: Colors.green.shade700,
                  ),
                ],
              ),

              Row(
                spacing: isMobile ? 12 : 16,

                children: [
                  _buildInfoCard(
                    icon: Icons.trending_up,
                    label: 'Margin @ 12%',
                    value:
                        '${round.marginWithTwelvePercentage ?? "N/A"} ${round.marginWithTwelvePercentage != null ? "₹" : ""}',
                    color: Colors.green.shade600,
                  ),
                  _buildInfoCard(
                    icon: Icons.trending_up,
                    label: 'Margin @ 15%',
                    value:
                        '${round.marginWithFifteenPercentage ?? "N/A"} ${round.marginWithFifteenPercentage != null ? "₹" : ""}',
                    color: Colors.green.shade500,
                  ),
                ],
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic round) {
    return Container(
      // width: Responsive.isDesktop(context)
      //     ? MediaQuery.sizeOf(context).width * 0.63
      //     : MediaQuery.sizeOf(context).width / 1.3,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.indigo.shade600, Colors.indigo.shade800],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.donut_large,
                  size: 32,
                  color: Colors.indigo.shade600,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Round Profile',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      round.rollNumber ?? 'Unknown Round',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.straighten, size: 16, color: Colors.white70),
                        const SizedBox(width: 6),
                        Text(
                          '${round.width ?? "N/A"} mm × ${round.length ?? "N/A"} m',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // SizedBox(width: MediaQuery.sizeOf(context).width * 0.3),
              if (HiveService.getRole() != '2')
                InkWell(
                  onTap: () {
                    context.pushNamed(
                      EditRoundPanel.routeName,
                      extra: widget.round,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Image.asset(Assets.editUser),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final isMobile = !Responsive.isDesktop(context);

    return Expanded(
      child: Container(
        // width: Responsive.isDesktop(context)
        //     ? MediaQuery.sizeOf(context).width / 6
        //     : null,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(icon, color: color, size: isMobile ? 20 : 24),
            ),
            SizedBox(width: isMobile ? 8 : 12),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: isMobile ? 8 : 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
