import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/widgets/labal_text.dart';

class MachineCalculation extends StatefulWidget {
  const MachineCalculation({super.key});
  static const String routeName = '/machine-calculation';

  @override
  State<MachineCalculation> createState() => _MachineCalculationState();
}

class _MachineCalculationState extends State<MachineCalculation> {
  // late AnimationController _animationController;
  TextEditingController meterController = TextEditingController();
  TextEditingController machine1FirstStepController = TextEditingController();
  TextEditingController machine2FirstStepController = TextEditingController();
  TextEditingController machine1SecondStepController = TextEditingController();
  TextEditingController machine2SecondStepController = TextEditingController();
  TextEditingController machine1ThirdStepController = TextEditingController();
  TextEditingController machine2ThirdStepController = TextEditingController();

  @override
  void initState() {
    // _animationController = AnimationController(
    //   duration: const Duration(milliseconds: 600),
    //   vsync: this,
    // );
    // _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    // _animationController.dispose();
    meterController.dispose();
    machine1FirstStepController.dispose();
    machine2FirstStepController.dispose();
    machine1SecondStepController.dispose();
    machine2SecondStepController.dispose();
    machine1ThirdStepController.dispose();
    machine2ThirdStepController.dispose();
    super.dispose();
  }

  calculateMachine1() {
    double meter = double.tryParse(meterController.text) ?? 0;

    final machine1Result = meter * (100 / 90) * 7.34;

    machine1FirstStepController.text = (machine1Result - 50).toStringAsFixed(2);
    machine1SecondStepController.text = (machine1Result - 11).toStringAsFixed(
      2,
    );
    machine1ThirdStepController.text = machine1Result.toStringAsFixed(2);
    setState(() {});
  }

  calculateMachine2() {
    double meter = double.tryParse(meterController.text) ?? 0;

    final machine2Result = meter * 1.61;

    machine2FirstStepController.text = (machine2Result - 50).toStringAsFixed(2);
    machine2SecondStepController.text = (machine2Result - 11).toStringAsFixed(
      2,
    );
    machine2ThirdStepController.text = machine2Result.toStringAsFixed(2);
    setState(() {});
  }

  final GlobalKey<ScaffoldState> stateKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: stateKey,
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: !Responsive.isDesktop(context)
          ? MobileAppBar(context, stateKey, 'Machine Calculation')
          : DesktopAppBar(context, stateKey, 'Machine Calculation', true),
      drawer: !Responsive.isDesktop(context) ? const SideMenuWidget() : null,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.95),
                Colors.blue.shade50.withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2D8FCF).withOpacity(0.12),
                blurRadius: 32,
                spreadRadius: 4,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 28),
                  _buildFiltersSection(),
                  const SizedBox(height: 28),
                  contentWidget,
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get contentWidget => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    physics: const BouncingScrollPhysics(),
    child: Row(
      spacing: 24,
      children: [
        _buildMachineCard(
          'Machine 1',
          'OLD',
          const [0xFF2D8FCF, 0xFF1E5BA8],
          'machine1',
          0xFF2D8FCF,
        ),
        _buildMachineCard(
          'Machine 2',
          'NEW',
          const [0xFF10B981, 0xFF059669],
          'machine2',
          0xFF10B981,
        ),
      ],
    ),
  );

  Widget _buildMachineCard(
    String machineName,
    String status,
    List<int> gradientColors,
    String machineType,
    int primaryColor,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedHoverCard(
        child: Container(
          width: 360,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(primaryColor).withOpacity(0.15),
                blurRadius: 24,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header with modern design
              _buildModernHeader(machineName, status, gradientColors),
              // Content section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  spacing: 16,
                  children: [
                    _buildMetricRow(
                      'First Step',
                      machineType == 'machine1'
                          ? machine1FirstStepController
                          : machine2FirstStepController,
                      Icons.trending_up_rounded,
                      Color(primaryColor),
                    ),
                    _buildMetricRow(
                      'Second Step',
                      machineType == 'machine1'
                          ? machine1SecondStepController
                          : machine2SecondStepController,
                      Icons.auto_graph_rounded,
                      Color(primaryColor),
                    ),
                    _buildMetricRow(
                      'Final Result',
                      machineType == 'machine1'
                          ? machine1ThirdStepController
                          : machine2ThirdStepController,
                      Icons.check_circle_rounded,
                      Color(primaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader(
    String machineName,
    String status,
    List<int> gradientColors,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(gradientColors[0]), Color(gradientColors[1])],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      machineName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.precision_manufacturing_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(
    String label,
    TextEditingController controller,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.08), color.withOpacity(0.04)],
        ),
        border: Border.all(color: color.withOpacity(0.15), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  controller.text.isEmpty ? '0.00' : controller.text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2D8FCF).withOpacity(0.1),
            const Color(0xFF10B981).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2D8FCF).withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF2D8FCF), const Color(0xFF1E5BA8)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2D8FCF).withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.inventory_2_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  'Machine Calculation',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A3A52),
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Monitor and calculate machine performance metrics in real-time',
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
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.9),
            Colors.blue.shade50.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D8FCF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: Color(0xFF2D8FCF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Enter Meter Reading',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          Row(
            spacing: Responsive.betweenSpace,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: meterTF(
                  (value) {
                    calculateMachine1();
                    calculateMachine2();
                  },
                  meterController,
                  'Enter Meter',
                  'Enter Meter',
                ),
              ),
              Expanded(child: SizedBox()),
              Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget meterTF(
    void Function(String)? onChanged,
    TextEditingController controller,
    String hint,
    String label,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        LabelText(label),
        Container(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.blue.shade50.withOpacity(0.5)],
            ),
            border: Border.all(
              color: Colors.blue.shade200.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.08),
                blurRadius: 8,
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
              filled: false,
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Icon(
                Icons.edit_outlined,
                color: Color(0xFF2D8FCF),
                size: 22,
              ),
              suffixIcon: controller.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        controller.clear();
                        onChanged?.call('');
                      },
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    )
                  : null,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 13,
              ),
            ),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: 0.3,
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

/// Custom widget to provide hover animation effect
class AnimatedHoverCard extends StatefulWidget {
  final Widget child;

  const AnimatedHoverCard({super.key, required this.child});

  @override
  State<AnimatedHoverCard> createState() => _AnimatedHoverCardState();
}

class _AnimatedHoverCardState extends State<AnimatedHoverCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovering = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovering = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -8 * _hoverController.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(_isHovering ? 0.15 : 0.08),
                    blurRadius: _isHovering ? 32 : 20,
                    spreadRadius: _isHovering ? 2 : 0,
                    offset: Offset(0, _isHovering ? 16 : 8),
                  ),
                ],
              ),
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
