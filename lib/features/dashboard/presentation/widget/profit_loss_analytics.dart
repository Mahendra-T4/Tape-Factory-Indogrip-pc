import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/features/dashboard/presentation/widget/analytics_dropdown_widget.dart';
import 'package:indogrip/features/dashboard/presentation/widget/product_type_widget_db.dart';
import 'package:indogrip/features/global/data/model/profit_loss_modeld.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'dart:math' as math;

import 'package:intl/intl.dart';

class ProfitandLossAnalyticsWidget extends StatefulWidget {
  ProfitandLossAnalyticsWidget({
    super.key,
    required this.fromDateController,
    required this.toDateController,
    this.productType,
  });

  final TextEditingController fromDateController;
  final TextEditingController toDateController;
  String? productType;
  // void Function(String)? onToChanged;
  // void Function(String)? onFromChanged;

  @override
  State<ProfitandLossAnalyticsWidget> createState() =>
      _ProfitandLossAnalyticsWidgetState();
}

class _ProfitandLossAnalyticsWidgetState
    extends State<ProfitandLossAnalyticsWidget> {
  late final GlobalBloc globalBloc;
  String selectedPeriod = 'This Month';

  final List<String> timeRanges = ['Today', 'Weekly', 'Monthly', 'Yearly'];

  @override
  void initState() {
    super.initState();
    globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository())
      ..add(
        ProfitAndLossGetterEvent(
          toDate: widget.toDateController.text,
          fromDate: widget.fromDateController.text,
          productType: widget.productType ?? '',
        ),
      );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
    void Function(String)? onChanged,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        controller.text = formattedDate;
      });
      onChanged?.call(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.greenAccent.shade100, width: 1.5),
      ),
      child: Column(
        children: [
          buildFilterationWidget,
          const SizedBox(height: 28),
          BlocBuilder(
            bloc: globalBloc,
            builder: (context, state) {
              switch (state.runtimeType) {
                case GlobalLoadingStatus:
                  return const Center(child: CircularProgressIndicator());

                case ProfitAndLossGetterSuccessStatus:
                  final data =
                      (state as ProfitAndLossGetterSuccessStatus).model;
                  return data.status == 1
                      ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeader(
                                title:
                                    data.overallProgress?.overallHeading ??
                                    'try again',
                                subtitle:
                                    data.overallProgress?.overallTagline ??
                                    'try again',
                              ),
                              const SizedBox(height: 28),
                              // buildFilterationWidget,
                              // const SizedBox(height: 24),
                              _buildKPICards(
                                revenue:
                                    data.overallProgress?.absoluteRevenue ??
                                    '0',
                                expenses:
                                    data.overallProgress?.absoluteExpenses ??
                                    '0',
                                profit:
                                    data.overallProgress?.absoluteNetProfit ??
                                    '0',
                                profitMargin:
                                    data
                                        .overallProgress
                                        ?.absoluteProfitMargin ??
                                    '0',
                                revanuePercent:
                                    data.overallProgress?.revenuePercentage,
                                expensesPercent:
                                    data.overallProgress?.expensesPercentage,
                                profitPercent:
                                    data.overallProgress?.netProfitPercentage,
                                profitMarginPercent: data
                                    .overallProgress
                                    ?.profitMarginPercentage,
                              ),
                              const SizedBox(height: 28),
                              // _buildTrendChart(),
                              // const SizedBox(height: 28),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  data.expensesList == null
                                      ? Expanded(child: const SizedBox())
                                      : Expanded(
                                          flex: 3,
                                          child: _buildExpenseBreakdown(
                                            data.expensesList!,
                                          ),
                                        ),
                                  const SizedBox(width: 24),
                                  data.revenueList == null
                                      ? Expanded(child: const SizedBox())
                                      : Expanded(
                                          flex: 2,
                                          child: _buildExpensePieChart(
                                            data.revenueList!,
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Text(
                            data.message ?? 'failed to load data try again',
                          ),
                        );
                case ProfitAndLossGetterFailureStatus:
                  final error =
                      (state as ProfitAndLossGetterFailureStatus).errorMessage;
                  return Center(child: Text('Error: $error'));
                default:
                  return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget get buildFilterationWidget => Row(
    spacing: 16,
    children: [
      Expanded(
        child: Container(
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
            controller: widget.fromDateController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Select From Date',
              hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              prefixIcon: const Icon(
                Icons.calendar_today,
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
                borderSide: const BorderSide(
                  color: Color(0xFF2D8FCF),
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 0,
              ),
            ),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: ColourPalette.textFieldLabelColor,
            ),
            readOnly: true,
            onChanged: (value) {
              globalBloc.add(
                ProfitAndLossGetterEvent(
                  toDate: widget.toDateController.text,
                  fromDate: value,
                  productType: widget.productType ?? '',
                ),
              );
            },
            onTap: () =>
                _selectDate(context, widget.fromDateController, (value) {
                  globalBloc.add(
                    ProfitAndLossGetterEvent(
                      toDate: widget.toDateController.text,
                      fromDate: value,
                      productType: widget.productType ?? '',
                    ),
                  );
                }),
          ),
        ),
      ),
      // const SizedBox(height: 16),
      Expanded(
        child: Container(
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
            controller: widget.toDateController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Select To Date',
              hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              prefixIcon: const Icon(
                Icons.calendar_today,
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
                borderSide: const BorderSide(
                  color: Color(0xFF2D8FCF),
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 0,
              ),
            ),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: ColourPalette.textFieldLabelColor,
            ),
            readOnly: true,
            onChanged: (value) {
              globalBloc.add(
                ProfitAndLossGetterEvent(
                  toDate: value,
                  fromDate: widget.fromDateController.text,
                  productType: widget.productType ?? '',
                ),
              );
            },
            onTap: () => _selectDate(context, widget.toDateController, (value) {
              globalBloc.add(
                ProfitAndLossGetterEvent(
                  toDate: value,
                  fromDate: widget.fromDateController.text,
                  productType: widget.productType ?? '',
                ),
              );
            }),
          ),
        ),
      ),
      Expanded(
        child: MasterProductTypeDBWidget(
          onChanged: (value) {
            setState(() {
              widget.productType = value;
            });
            globalBloc.add(
              ProfitAndLossGetterEvent(
                toDate: widget.toDateController.text,
                fromDate: widget.fromDateController.text,
                productType: widget.productType ?? '',
              ),
            );
          },
        ),
      ),
      Expanded(child: SizedBox()),
      Expanded(child: SizedBox()),
    ],
  );

  Widget _buildHeader({required String title, String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF202124),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle.toString(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF5f6368),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildKPICards({
    required dynamic revenue,
    required dynamic expenses,
    required dynamic profit,
    required dynamic profitMargin,
    required dynamic revanuePercent,
    required dynamic expensesPercent,
    required dynamic profitPercent,
    required dynamic profitMarginPercent,
  }) {
    return Row(
      spacing: 16,
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Revenue',
            value: revenue.toString(),
            growth: revanuePercent.toString() != 'null'
                ? double.tryParse(revanuePercent.toString()) ?? 0
                : 0,
            backgroundColor: const Color(0xFFF3F3F3),
            accentColor: revanuePercent.toString().contains('-')
                ? const Color.fromARGB(255, 255, 39, 39)
                : const Color(0xFF2ca02c),
          ),
        ),

        Expanded(
          child: _buildMetricCard(
            title: 'Expenses',
            value: expenses.toString(),
            growth: expensesPercent.toString() != 'null'
                ? double.tryParse(expensesPercent.toString()) ?? 0
                : 0,
            backgroundColor: const Color(0xFFF3F3F3),
            accentColor: expensesPercent.toString().contains('-')
                ? const Color.fromARGB(255, 255, 39, 39)
                : const Color(0xFF2ca02c),
          ),
        ),

        Expanded(
          child: _buildMetricCard(
            title: 'Net Profit',
            value: profit.toString(),
            growth: profitPercent.toString() != 'null'
                ? double.tryParse(profitPercent.toString()) ?? 0
                : 0,
            backgroundColor: const Color(0xFFF3F3F3),
            accentColor: profitPercent.toString().contains('-')
                ? const Color.fromARGB(255, 255, 39, 39)
                : const Color(0xFF2ca02c),
          ),
        ),

        Expanded(
          child: _buildMetricCard(
            title: 'Profit Margin',
            value: '$profitMargin%',
            growth: profitMarginPercent.toString() != 'null'
                ? double.tryParse(profitMarginPercent.toString()) ?? 0
                : 0,
            backgroundColor: const Color(0xFFF3F3F3),
            accentColor: profitMarginPercent.toString().contains('-')
                ? const Color.fromARGB(255, 255, 39, 39)
                : const Color(0xFF2ca02c),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required double growth,
    required Color backgroundColor,
    required Color accentColor,
  }) {
    return Container(
      // width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF5f6368),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF202124),
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_up, color: accentColor, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${growth.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseBreakdown(ExpensesList result) {
    // final categories = analyticsData['categories'] as List<dynamic>;
    // final totalExpenses = analyticsData['expenses'] as int;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            result.expensesHeading.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF202124),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 321,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: result.expensesResult?.length ?? 0,
              itemBuilder: (context, index) {
                final expense = result.expensesResult![index];
                final colorList = List.from(
                  expense.expensesColorCode
                      .toString()
                      .split(',')
                      .map((code) => _hexToColor(code.trim())),
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  expense.expensesLabel.toString(),
                                  style: const TextStyle(
                                    color: Color(0xFF202124),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${expense.expensesValue}',
                                style: const TextStyle(
                                  color: Color(0xFF202124),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${expense.expensesPercentage}% of total',
                                style: const TextStyle(
                                  color: Color(0xFF9aa0a6),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: expense.expensesPercentage != null
                              ? (double.tryParse(
                                          expense.expensesPercentage.toString(),
                                        ) ??
                                        0) /
                                    100
                              : 0,
                          minHeight: 5,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorList[index % colorList.length],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensePieChart(RevenueList data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            data.revenueHeading.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF202124),
            ),
          ),
          const SizedBox(height: 20),
          PieChartWithTooltip(
            revenueResults: data.revenueResult ?? [],
            hexToColor: _hexToColor,
          ),
          const SizedBox(height: 20),
          // Legend with color codes from RevenueList
          if (data.revenueResult != null && data.revenueResult!.isNotEmpty)
            Wrap(
              spacing: 16,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: data.revenueResult!
                  .map(
                    (item) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _hexToColor(item.revenueColorCode),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${item.revenueLabel} (${item.revenuePercentage}%)',
                            style: const TextStyle(
                              color: Color(0xFF5f6368),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Color _hexToColor(String? hexCode) {
    if (hexCode == null || hexCode.isEmpty) {
      return const Color(0xFF1f77b4); // Default blue color
    }
    try {
      // Remove '#' if present
      String cleanHex = hexCode.replaceFirst('#', '').trim();

      // Handle different hex formats
      if (cleanHex.length == 6) {
        // 6-digit hex (RGB) - add FF for full opacity
        cleanHex = 'FF' + cleanHex;
      } else if (cleanHex.length == 8) {
        // 8-digit hex (ARGB) - use as is
        cleanHex = cleanHex;
      } else {
        return const Color(0xFF1f77b4); // Default if invalid format
      }

      return Color(int.parse('0x$cleanHex'));
    } catch (e) {
      return const Color(0xFF1f77b4); // Default on any error
    }
  }

  //   dynamic _formatCurrency(dynamic value) {
  //     // Convert string to int if necessary
  //     int intValue;
  //     try {
  //       if (value is String) {
  //         intValue = int.parse(value);
  //       } else if (value is int) {
  //         intValue = value;
  //       } else {
  //         intValue = 0;
  //       }
  //     } catch (e) {
  //       intValue = 0;
  //     }

  //     if (intValue >= 100000) {
  //       return '${(intValue / 100000).toStringAsFixed(1)}L';
  //     } else if (intValue >= 1000) {
  //       return '${(intValue / 1000).toStringAsFixed(1)}K';
  //     }
  //     return intValue;
  //   }
}

// Custom Line Chart Painter
class LineChartPainter extends CustomPainter {
  final List<dynamic> data;
  final Color revenueColor;
  final Color expenseColor;

  LineChartPainter({
    required this.data,
    required this.revenueColor,
    required this.expenseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 0.5;

    // Draw grid
    final gridCount = 4;
    for (int i = 0; i <= gridCount; i++) {
      final y = (size.height / gridCount) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Safely extract revenues and expenses
    final revenues = <double>[];
    final expenses = <double>[];

    for (var item in data) {
      final map = item as Map<String, dynamic>;
      revenues.add(((map['revenue'] ?? 0) as num).toDouble());
      expenses.add(((map['expenses'] ?? 0) as num).toDouble());
    }

    if (revenues.isEmpty) return;

    final maxRevenue = revenues.reduce((a, b) => a > b ? a : b);
    if (maxRevenue == 0) return;

    final spacing = data.length > 1 ? size.width / (data.length - 1) : 0;

    // Draw revenue line
    paint.color = revenueColor;
    paint.style = PaintingStyle.stroke;
    for (int i = 0; i < revenues.length - 1; i++) {
      dynamic x1 = spacing * i;
      final y1 = size.height - (revenues[i] / maxRevenue) * (size.height - 40);
      dynamic x2 = spacing * (i + 1);
      final y2 =
          size.height - (revenues[i + 1] / maxRevenue) * (size.height - 40);
      if (y1.isFinite && y2.isFinite) {
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
      }
    }

    // Draw revenue points
    final circlePaint = Paint()
      ..color = revenueColor
      ..style = PaintingStyle.fill;
    for (int i = 0; i < revenues.length; i++) {
      dynamic x = spacing * i;
      final y = size.height - (revenues[i] / maxRevenue) * (size.height - 40);
      if (y.isFinite) {
        canvas.drawCircle(Offset(x, y), 4, circlePaint);
      }
    }

    // Draw month labels
    final textPainter = TextPainter(textDirection: null);
    for (int i = 0; i < data.length; i++) {
      final x = spacing * i;
      final month = (data[i] as Map)['month'] as String? ?? '';
      textPainter.text = TextSpan(
        text: month,
        style: const TextStyle(color: Color(0xFF5f6368), fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height + 5),
      );
    }
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) => false;
}

// Custom Pie Chart Painter
class PieChartPainter extends CustomPainter {
  final List<RevenueResult> revenueResults;
  final Function(String?) hexToColor;

  PieChartPainter({required this.revenueResults, required this.hexToColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    double startAngle = -math.pi / 2;

    for (int index = 0; index < revenueResults.length; index++) {
      final result = revenueResults[index];
      final percentageValue = result.revenuePercentage;

      // Parse percentage as double
      double percentage = 0;
      if (percentageValue is int) {
        percentage = (percentageValue as int) / 100;
      } else if (percentageValue is double) {
        percentage = (percentageValue as double) / 100;
      } else if (percentageValue is String) {
        percentage = (double.tryParse(percentageValue) ?? 0) / 100;
      }

      final sweepAngle = percentage * 2 * math.pi;
      final color = (hexToColor as Color Function(String?))(
        result.revenueColorCode,
      );

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Draw center white circle for donut effect
    final donutPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.6, donutPaint);
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) => false;
}

// Pie Chart with Tooltip Widget
class PieChartWithTooltip extends StatefulWidget {
  final List<RevenueResult> revenueResults;
  final Function(String?) hexToColor;

  const PieChartWithTooltip({
    required this.revenueResults,
    required this.hexToColor,
  });

  @override
  State<PieChartWithTooltip> createState() => _PieChartWithTooltipState();
}

class _PieChartWithTooltipState extends State<PieChartWithTooltip> {
  int? selectedIndex;
  Offset? tooltipPosition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _handleTap(details.localPosition);
      },
      child: Stack(
        children: [
          SizedBox(
            height: 255,
            width: 160,
            child: CustomPaint(
              painter: PieChartPainter(
                revenueResults: widget.revenueResults,
                hexToColor: widget.hexToColor,
              ),
            ),
          ),
          if (selectedIndex != null && tooltipPosition != null)
            Positioned(
              left: _getTooltipX(),
              top: _getTooltipY(),
              child: _buildTooltip(widget.revenueResults[selectedIndex!]),
            ),
        ],
      ),
    );
  }

  double _getTooltipX() {
    final tooltipX = (tooltipPosition?.dx ?? 0) - 50;
    return tooltipX.clamp(0, 60);
  }

  double _getTooltipY() {
    final tooltipY = (tooltipPosition?.dy ?? 0) - 80;
    return tooltipY.clamp(0, 175);
  }

  Widget _buildTooltip(RevenueResult result) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            result.revenueLabel ?? 'N/A',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            result.revenueValue ?? 'N/A',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${result.revenuePercentage}%',
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _handleTap(Offset position) {
    final center = Offset(80, 127.5); // Center of the pie chart (160/2, 255/2)
    final radius = 63.5; // Radius of the pie chart
    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;
    final distance = math.sqrt(dx * dx + dy * dy);

    // Check if tap is within the pie chart (excluding donut hole)
    if (distance < radius && distance > radius * 0.6) {
      final angle = math.atan2(dy, dx);
      final normalizedAngle = angle + math.pi / 2;
      final adjustedAngle = normalizedAngle < 0
          ? normalizedAngle + (2 * math.pi)
          : normalizedAngle % (2 * math.pi);

      double currentAngle = 0;
      for (int i = 0; i < widget.revenueResults.length; i++) {
        final result = widget.revenueResults[i];
        final percentageValue = result.revenuePercentage;

        double percentage = 0;
        if (percentageValue is int) {
          percentage = (percentageValue as int) / 100;
        } else if (percentageValue is double) {
          percentage = (percentageValue as double) / 100;
        } else if (percentageValue is String) {
          percentage = (double.tryParse(percentageValue) ?? 0) / 100;
        }

        final sweepAngle = percentage * 2 * math.pi;

        if (adjustedAngle >= currentAngle &&
            adjustedAngle < currentAngle + sweepAngle) {
          setState(() {
            selectedIndex = i;
            tooltipPosition = position;
          });
          return;
        }

        currentAngle += sweepAngle;
      }

      setState(() {
        selectedIndex = null;
      });
    } else {
      setState(() {
        selectedIndex = null;
      });
    }
  }
}
