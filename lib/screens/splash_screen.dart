import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import '../themes/theme_provider.dart';
import 'image_generation_screen.dart'; // Changed this import

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _logoController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Controller for main animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Controller for logo animations
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    // Start animations
    _controller.forward();
    _logoController.forward();

    // Navigate to image generation screen after delay
    Timer(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, animation, __) {
              return FadeTransition(
                opacity: animation,
                child:
                    const ImageGenerationScreen(), // Changed to ImageGenerationScreen
              );
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    // Calculate responsive dimensions
    final logoSize = screenSize.width * 0.4;
    final circleSize = logoSize * 1.2;

    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    isDark
                        ? [const Color(0xFF1E1E1E), const Color(0xFF121212)]
                        : [const Color(0xFFF8F8F8), Colors.white],
              ),
            ),
          ),

          // Decorative elements
          Positioned(
            top: -screenSize.height * 0.1,
            right: -screenSize.width * 0.2,
            child: Container(
                  width: screenSize.width * 0.7,
                  height: screenSize.width * 0.7,
                  decoration: BoxDecoration(
                    color: themeProvider.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .moveY(
                  begin: 0,
                  end: 10,
                  duration: 2000.ms,
                  curve: Curves.easeInOut,
                )
                .then()
                .moveY(
                  begin: 10,
                  end: 0,
                  duration: 2000.ms,
                  curve: Curves.easeInOut,
                ),
          ),

          Positioned(
            bottom: -screenSize.height * 0.05,
            left: -screenSize.width * 0.1,
            child: Container(
                  width: screenSize.width * 0.6,
                  height: screenSize.width * 0.6,
                  decoration: BoxDecoration(
                    color: themeProvider.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .moveY(
                  begin: 0,
                  end: -10,
                  duration: 2400.ms,
                  curve: Curves.easeInOut,
                )
                .then()
                .moveY(
                  begin: -10,
                  end: 0,
                  duration: 2400.ms,
                  curve: Curves.easeInOut,
                ),
          ),

          // Main content with animations
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo animation
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: GlassmorphicContainer(
                      width: circleSize,
                      height: circleSize,
                      borderRadius: circleSize / 2,
                      blur: 20,
                      alignment: Alignment.center,
                      border: 2,
                      linearGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.14),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                      child: Center(
                        child: Lottie.asset(
                          'assets/animations/ai_animation.json',
                          width: logoSize,
                          height: logoSize,
                          controller: _logoController,
                          fit: BoxFit.contain,
                          onLoaded: (composition) {
                            _logoController.duration = composition.duration;
                            _logoController.forward();
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // App name
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Text(
                          'ImageGen',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(
                                  context,
                                ).textTheme.displayMedium?.color,
                            letterSpacing: 1.2,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                        .slide(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                          duration: 600.ms,
                          curve: Curves.easeOut,
                        ),
                  ),
                ),

                const SizedBox(height: 8),

                // Tagline
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Text(
                          'Create AI Art Masterpieces',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        )
                        .animate()
                        .fadeIn(
                          duration: 800.ms,
                          delay: 300.ms,
                          curve: Curves.easeOut,
                        )
                        .slide(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                          duration: 600.ms,
                          delay: 300.ms,
                          curve: Curves.easeOut,
                        ),
                  ),
                ),

                const SizedBox(height: 40),

                // Loading indicator
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SizedBox(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              themeProvider.primaryColor,
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(
                          duration: 800.ms,
                          delay: 500.ms,
                          curve: Curves.easeOut,
                        )
                        .scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1, 1),
                          duration: 600.ms,
                          delay: 500.ms,
                          curve: Curves.easeOut,
                        ),
                  ),
                ),
              ],
            ),
          ),

          // Version info
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Text(
                'Version 1.0.0',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(
                    context,
                  ).textTheme.bodySmall?.color?.withOpacity(0.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
