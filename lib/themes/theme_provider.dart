import 'package:flutter/material.dart';
import 'app_themes.dart';

class ThemeProvider extends ChangeNotifier {
  // Default to light theme
  ThemeMode _themeMode = ThemeMode.light;
  
  // Available theme colors
  static const List<Color> themeColors = [
    Color(0xFFFF6B6B),  // Default coral pink
    Color(0xFF6200EA),  // Deep purple
    Color(0xFF00BFA5),  // Teal
    Color(0xFFFFA000),  // Amber
    Color(0xFF2979FF),  // Blue
    Color(0xFFD50000),  // Red
  ];
  
  // Currently selected theme color index (default to 0)
  int _selectedColorIndex = 0;
  
  // Getters
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  Color get primaryColor => themeColors[_selectedColorIndex];
  int get selectedColorIndex => _selectedColorIndex;
  
  // Get the current theme data based on theme mode
  ThemeData getTheme(BuildContext context) {
    return _themeMode == ThemeMode.dark
        ? AppThemes.darkTheme
        : AppThemes.lightTheme;
  }
  
  // Toggle between light and dark theme
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
  
  // Set specific theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
  
  // Set theme color by index
  void setThemeColor(int index) {
    if (index >= 0 && index < themeColors.length) {
      _selectedColorIndex = index;
      // Update AppThemes.primaryColor
      AppThemes.updatePrimaryColor(themeColors[index]);
      notifyListeners();
    }
  }
} 