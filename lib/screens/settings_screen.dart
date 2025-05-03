import 'package:flutter/material.dart';
import '../themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // Settings toggles
  bool _notificationsEnabled = true;
  bool _autoSaveEnabled = false;
  bool _highQualityEnabled = true;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              _showHelpDialog(context);
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          children: [
            // Theme Settings
            _buildSectionHeader('Appearance'),
            
            // Theme Mode Card
            _buildSettingsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSettingTile(
                    context,
                    title: 'Dark Mode',
                    description: 'Switch between light and dark theme',
                    icon: Icons.dark_mode,
                    trailing: Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                      activeColor: themeProvider.primaryColor,
                    ),
                  ),
                  const Divider(),
                  _buildColorThemeSelector(context),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // General Settings
            _buildSectionHeader('General'),
            
            // Notifications Card
            _buildSettingsCard(
              child: _buildSettingTile(
                context,
                title: 'Notifications',
                description: 'Enable or disable app notifications',
                icon: Icons.notifications,
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Notifications ${value ? 'enabled' : 'disabled'}')),
                    );
                  },
                  activeColor: themeProvider.primaryColor,
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Language Card
            _buildSettingsCard(
              child: _buildSettingTile(
                context,
                title: 'Language',
                description: 'Change app language',
                icon: Icons.language,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('English'),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
                onTap: () {
                  _showLanguageSelector(context);
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Image Generation Settings
            _buildSectionHeader('Image Generation'),
            
            // Image Generation Card
            _buildSettingsCard(
              child: Column(
                children: [
                  _buildSettingTile(
                    context,
                    title: 'Auto-Save Generated Images',
                    description: 'Automatically save all generated images',
                    icon: Icons.save,
                    trailing: Switch(
                      value: _autoSaveEnabled,
                      onChanged: (value) {
                        setState(() {
                          _autoSaveEnabled = value;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Auto-save ${value ? 'enabled' : 'disabled'}')),
                        );
                      },
                      activeColor: themeProvider.primaryColor,
                    ),
                  ),
                  const Divider(),
                  _buildSettingTile(
                    context,
                    title: 'High Quality Generation',
                    description: 'Generate higher quality images (slower)',
                    icon: Icons.high_quality,
                    trailing: Switch(
                      value: _highQualityEnabled,
                      onChanged: (value) {
                        setState(() {
                          _highQualityEnabled = value;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('High quality ${value ? 'enabled' : 'disabled'}')),
                        );
                      },
                      activeColor: themeProvider.primaryColor,
                    ),
                  ),
                  const Divider(),
                  _buildSettingTile(
                    context,
                    title: 'Advanced Settings',
                    description: 'Configure detailed generation parameters',
                    icon: Icons.tune,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Advanced settings (not implemented)')),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // About Section
            _buildSectionHeader('About'),
            
            // About Card
            _buildSettingsCard(
              child: Column(
                children: [
                  _buildSettingTile(
                    context,
                    title: 'App Version',
                    description: 'Current version of the app',
                    icon: Icons.info,
                    trailing: const Text('1.0.0', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const Divider(),
                  _buildSettingTile(
                    context,
                    title: 'Privacy Policy',
                    description: 'Read our privacy policy',
                    icon: Icons.privacy_tip,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Privacy Policy (not implemented)')),
                      );
                    },
                  ),
                  const Divider(),
                  _buildSettingTile(
                    context,
                    title: 'Terms of Service',
                    description: 'Read our terms of service',
                    icon: Icons.description,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Terms of Service (not implemented)')),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Contact Support Button
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.support_agent, color: Colors.white),
                label: const Text(
                  'Contact Support',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contact support (not implemented)')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeProvider.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
  
  // Show help dialog
  void _showHelpDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings Help'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Dark Mode: Toggle between light and dark theme.'),
            SizedBox(height: 8),
            Text('• Notifications: Enable or disable app notifications.'),
            SizedBox(height: 8),
            Text('• Language: Change the app language.'),
            SizedBox(height: 8),
            Text('• Auto-Save: Automatically save generated images.'),
            SizedBox(height: 8),
            Text('• High Quality: Generate higher resolution images.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: themeProvider.primaryColor)),
          ),
        ],
      ),
    );
  }
  
  // Show language selector
  void _showLanguageSelector(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildLanguageOption(context, 'English', isSelected: true),
              _buildLanguageOption(context, 'Spanish'),
              _buildLanguageOption(context, 'French'),
              _buildLanguageOption(context, 'German'),
              _buildLanguageOption(context, 'Chinese'),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeProvider.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  // Language option for bottom sheet
  Widget _buildLanguageOption(BuildContext context, String language, {bool isSelected = false}) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    return ListTile(
      title: Text(language),
      trailing: isSelected 
          ? Icon(Icons.check_circle, color: themeProvider.primaryColor)
          : null,
      onTap: () {
        Navigator.pop(context);
        if (!isSelected) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Language changed to $language (not implemented)')),
          );
        }
      },
    );
  }
  
  // Build Color Theme Selector
  Widget _buildColorThemeSelector(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Theme Color',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              ThemeProvider.themeColors.length,
              (index) => GestureDetector(
                onTap: () {
                  themeProvider.setThemeColor(index);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ThemeProvider.themeColors[index],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: themeProvider.selectedColorIndex == index
                          ? Colors.white
                          : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ThemeProvider.themeColors[index].withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: themeProvider.selectedColorIndex == index
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        )
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Section header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 12),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Divider(
              thickness: 1,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
  
  // Settings card with elevation and rounded corners
  Widget _buildSettingsCard({required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
  
  // Setting tile with icon and description
  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.2)
                    : const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: themeProvider.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFA0A0A0)
                          : const Color(0xFF6A6A6A),
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
} 