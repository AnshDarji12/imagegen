import 'package:flutter/material.dart';
import 'app_themes.dart';

class ThemeProvider extends ChangeNotifier {
  // Theme mode state
  ThemeMode _themeMode = ThemeMode.light;

  // Available theme colors
  static const List<Color> themeColors = [
    Color(0xFFFF6B6B), // Default coral pink
    Color(0xFF6200EA), // Deep purple
    Color(0xFF00BFA5), // Teal
    Color(0xFFFFA000), // Amber
    Color(0xFF2979FF), // Blue
    Color(0xFFD50000), // Red
  ];

  // Theme color state
  int _selectedColorIndex = 0;

  // Image generation states
  bool _isGenerating = false;
  String? _lastGeneratedImage;
  String? _generationError;
  String? _selectedModel;
  bool _showAdvancedOptions = false;

  // Getters for theme
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  Color get primaryColor => themeColors[_selectedColorIndex];
  int get selectedColorIndex => _selectedColorIndex;

  // Getters for image generation
  bool get isGenerating => _isGenerating;
  String? get lastGeneratedImage => _lastGeneratedImage;
  String? get generationError => _generationError;
  String? get selectedModel => _selectedModel;
  bool get showAdvancedOptions => _showAdvancedOptions;

  // Get the current theme data
  ThemeData getTheme(BuildContext context) {
    return _themeMode == ThemeMode.dark
        ? AppThemes.darkTheme
        : AppThemes.lightTheme;
  }

  // Theme management methods
  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setThemeColor(int index) {
    if (index >= 0 && index < themeColors.length) {
      _selectedColorIndex = index;
      AppThemes.updatePrimaryColor(themeColors[index]);
      notifyListeners();
    }
  }

  // Image generation methods
  void setGenerating(bool value) {
    _isGenerating = value;
    notifyListeners();
  }

  void setGeneratedImage(String? imageBase64) {
    _lastGeneratedImage = imageBase64;
    _generationError = null;
    _isGenerating = false;
    notifyListeners();
  }

  void setGenerationError(String error) {
    _generationError = error;
    _lastGeneratedImage = null;
    _isGenerating = false;
    notifyListeners();
  }

  void clearGeneration() {
    _lastGeneratedImage = null;
    _generationError = null;
    _isGenerating = false;
    notifyListeners();
  }

  void setSelectedModel(String model) {
    _selectedModel = model;
    notifyListeners();
  }

  void toggleAdvancedOptions() {
    _showAdvancedOptions = !_showAdvancedOptions;
    notifyListeners();
  }
}
