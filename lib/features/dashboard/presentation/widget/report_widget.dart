import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildModernCard(
                title: 'Sales Report',
                accentColor: Color(0xFFE67E22),
                child: _buildSalesChart(),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: _buildModernCard(
                title: 'Top Buyers',
                accentColor: Color(0xFF3498DB),
                child: _buildTopBuyersChart(),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: _buildModernCard(
                title: 'Top Vendors',
                accentColor: Color(0xFF9B59B6),
                child: _buildTopVendorsChart(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernCard({
    required String title,
    required Color accentColor,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(
          top: BorderSide(color: accentColor.withOpacity(0.2), width: 3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with accent line and title
            Row(
              children: [
                Container(
                  width: 6,
                  height: 28,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C3E50),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 225000,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Color(0xFFE8EEF5),
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return Text('0');
                  case 225000:
                    return Text('225K');
                  case 450000:
                    return Text('450K');
                  case 675000:
                    return Text('675K');
                  case 900000:
                    return Text('900K');
                }
                return Text('');
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return Text('2022');
                  case 1:
                    return Text('2023');
                  case 2:
                    return Text('2024');
                  case 3:
                    return Text('2025');
                  case 4:
                    return Text('2026');
                }
                return Text('');
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 4,
        minY: 0,
        maxY: 900000,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 900000),
              FlSpot(1, 600000),
              FlSpot(2, 300000),
              FlSpot(3, 100000),
              FlSpot(4, 0),
            ],
            isCurved: true,
            color: Color(0xFFE67E22),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: Color(0xFFE67E22),
                  strokeColor: Colors.white,
                  strokeWidth: 2,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Color(0xFFE67E22).withOpacity(0.15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBuyersChart() {
    return PieChart(
      PieChartData(
        sectionsSpace: 8,
        centerSpaceRadius: 50,
        sections: [
          PieChartSectionData(
            color: Color(0xFF3498DB),
            value: 100,
            title: 'Stolkom',
            radius: 55,
            titleStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            badgePositionPercentageOffset: 1.15,
          ),
        ],
      ),
    );
  }

  Widget _buildTopVendorsChart() {
    return PieChart(
      PieChartData(
        sectionsSpace: 8,
        centerSpaceRadius: 50,
        sections: [
          PieChartSectionData(
            color: Color(0xFF9B59B6),
            value: 83.49,
            title: '',
            radius: 55,
          ),
          PieChartSectionData(
            color: Color(0xFFE67E22),
            value: 16.51,
            title: 'Angira\nArt',
            radius: 55,
            titleStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            badgePositionPercentageOffset: 1.2,
          ),
        ],
      ),
    );
  }
}
