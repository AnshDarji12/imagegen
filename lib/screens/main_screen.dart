import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../themes/theme_provider.dart';
import '../themes/app_themes.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _promptController = TextEditingController();
  
  // States for image generation
  bool _hasGeneratedImage = false;
  bool _isGenerating = false;
  
  // UI Animation state
  double _generateButtonScale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _promptController.dispose();
    super.dispose();
  }
  
  // Simulate image generation
  void _generateImage() {
    if (_isGenerating) return; // Prevent multiple generations
    
    setState(() {
      _isGenerating = true;
      _hasGeneratedImage = false;
    });
    
    // Show loading indicator
    _showLoadingIndicator();
    
    // Simulate a delay for image generation
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _hasGeneratedImage = true;
        });
      }
    });
  }
  
  // Show loading indicator dialog
  void _showLoadingIndicator() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Lottie.network(
          'https://assets9.lottiefiles.com/packages/lf20_kk62um4v.json',
          width: 150,
          height: 150,
        ),
      ),
    );
    
    // Hide dialog after successful image generation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    });
  }
  
  // Show success message
  void _showSuccessMessage(String message) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: themeProvider.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    // Get screen dimensions for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ImageGen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ).animate()
          .fadeIn(duration: 600.ms)
          .slideY(begin: -0.2, end: 0),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            padding: const EdgeInsets.only(right: 16.0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              
              // App heading
              const Text(
                'Create AI Art',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ).animate()
                .fadeIn(duration: 600.ms, delay: 200.ms)
                .slideY(begin: 0.2, end: 0),
              
              const SizedBox(height: 8),
              
              // Subheading
              Text(
                'Turn your ideas into stunning images',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ).animate()
                .fadeIn(duration: 600.ms, delay: 300.ms)
                .slideY(begin: 0.2, end: 0),
              
              const SizedBox(height: 32),
              
              // Image display area (simple version)
              if (_hasGeneratedImage)
                Stack(
                  children: [
                    Container(
                      width: screenWidth - 40,
                      height: screenWidth * 0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          image: NetworkImage('https://via.placeholder.com/800x600/1a1a1a/aaaaaa?text=AI+Generated+Image'),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: themeProvider.primaryColor.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                    ).animate()
                      .fadeIn(duration: 800.ms)
                      .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
                    // Add back button to close image
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _hasGeneratedImage = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    // Add save button
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          _showSuccessMessage('Image saved to gallery');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: themeProvider.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.save_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ).animate()
                        .fadeIn(duration: 600.ms, delay: 500.ms)
                        .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),
                    ),
                  ],
                ),
                
              const SizedBox(height: 24),
              
              // Input box
              TextField(
                controller: _promptController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Describe the image you want to create...',
                  filled: true,
                  fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ).animate()
                .fadeIn(duration: 600.ms, delay: 400.ms)
                .slideY(begin: 0.2, end: 0),
              
              const SizedBox(height: 20),
              
              // Generate button
              GestureDetector(
                onTap: _isGenerating ? null : _generateImage,
                onTapDown: _isGenerating ? null : (_) {
                  setState(() {
                    _generateButtonScale = 0.95;
                  });
                },
                onTapUp: _isGenerating ? null : (_) {
                  setState(() {
                    _generateButtonScale = 1.0;
                  });
                },
                onTapCancel: _isGenerating ? null : () {
                  setState(() {
                    _generateButtonScale = 1.0;
                  });
                },
                child: AnimatedScale(
                  scale: _generateButtonScale,
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    width: screenWidth - 40,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: themeProvider.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: themeProvider.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _isGenerating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                              ),
                        const SizedBox(width: 8),
                        Text(
                          _isGenerating ? 'Generating...' : 'Generate Image',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate()
                .fadeIn(duration: 600.ms, delay: 500.ms)
                .slideY(begin: 0.2, end: 0),
              
              const SizedBox(height: 16),
              
              // History button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      _showSuccessMessage('History feature coming soon');
                    },
                    icon: const Icon(
                      Icons.history,
                      size: 18,
                    ),
                    label: const Text('View History'),
                    style: TextButton.styleFrom(
                      foregroundColor: themeProvider.primaryColor,
                    ),
                  ),
                ],
              ).animate()
                .fadeIn(duration: 600.ms, delay: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
} 