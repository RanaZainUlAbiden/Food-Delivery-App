import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _scaleAnim = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.restaurant,
                      color: AppColors.primary,
                      size: 60,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  'The Stone Oves',
                  style: AppTextStyles.h1.copyWith(
                    color: Colors.white,
                    fontSize: 30,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Fresh. Hot. Delivered.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'by DevInfantary',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white.withOpacity(0.5),
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 60),

                SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    color: Colors.white.withOpacity(0.6),
                    strokeWidth: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}