import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SidebarPanelBuilder extends StatefulWidget {
  SidebarPanelBuilder({
    super.key,
    required this.currentTap,
    required this.onTap,
    required this.icon,
    required this.title,
    required this.routeName,
    this.panel1,
    this.panel2,
    this.isRolePanel = true,
  });
  final bool currentTap;
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  String? panel1;
  String? panel2;
  final List<String> routeName;
  final bool isRolePanel;

  @override
  State<SidebarPanelBuilder> createState() => _SidebarPanelBuilderState();
}

class _SidebarPanelBuilderState extends State<SidebarPanelBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _iconTurns = _controller.drive(
      Tween<double>(
        begin: 0.0,
        end: 0.5,
      ).chain(CurveTween(curve: Curves.easeInOut)),
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
    _opacityAnimation = _controller.drive(
      Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeInOut)),
    );

    if (widget.currentTap) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(SidebarPanelBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentTap != oldWidget.currentTap) {
      if (widget.currentTap) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: widget.onTap,
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              widget.icon,
              size: 20,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          title: Text(
            widget.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          trailing: RotationTransition(
            turns: _iconTurns,
            child: Icon(
              Icons.expand_more_rounded,
              size: 18,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ),

        SizeTransition(
          sizeFactor: _heightFactor,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Column(
              children: [
                if (widget.isRolePanel)
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white.withOpacity(0.05),
                    ),
                    child: ListTile(
                      onTap: () {
                        context.goNamed(widget.routeName[0]);
                      },
                      leading: Icon(
                        Icons.add_circle_outline,
                        size: 20,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      title: Text(
                        widget.panel1 ?? 'Add',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ),

                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white.withOpacity(0.05),
                  ),
                  child: ListTile(
                    onTap: () {
                      context.goNamed(widget.routeName[1]);
                    },
                    leading: Icon(
                      Icons.remove_red_eye_outlined,
                      size: 20,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    title: Text(
                      widget.panel2 ?? 'View',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
