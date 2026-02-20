import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/Assets/assets.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/features/auth/presentation/view/login_panel.dart';
import 'package:indogrip/features/dashboard/presentation/page/deshboard.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _setupAnimations();
    _startAnimationAndNavigation();
  }

  void _setupAnimations() {
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutBack),
      ),
    );
  }

  Future<void> _startAnimationAndNavigation() async {
    await _controller.forward();
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    try {
      final isLoggedIn = await HiveService.isLoggedIn;
      if (!mounted) return;

      if (isLoggedIn) {
        GoRouter.of(context).go(IndoGripDashboard.routeName);
      } else {
        GoRouter.of(context).go(IndoGripLoginPanel.routeName);
      }
    } catch (e) {
      log('Splash Screen Error: $e');
      if (!mounted) return;
      GoRouter.of(context).go(IndoGripLoginPanel.routeName);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8F1),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double logoSize = constraints.maxWidth > 600 ? 250 : 200;

            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: logoSize,
                          width: logoSize,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.asset(
                            Assets.indoGripLogoImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'IndoGrip',
                          style: TextStyle(
                            fontSize: constraints.maxWidth > 600 ? 40 : 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Inventory Management System',
                          style: TextStyle(
                            fontSize: constraints.maxWidth > 600 ? 24 : 18,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: constraints.maxWidth > 600 ? 100 : 60,
                          height: constraints.maxWidth > 600 ? 100 : 60,
                          child: Lottie.asset(
                            Assets.loader,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
