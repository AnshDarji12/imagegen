import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../themes/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: themeProvider.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      themeProvider.primaryColor,
                      themeProvider.primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative elements
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: -20,
                      bottom: 0,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Edit profile (not implemented)'),
                      backgroundColor: themeProvider.primaryColor,
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                  _showProfileOptions(context);
                },
              ),
            ],
          ),
          
          // Profile Header
          SliverToBoxAdapter(
            child: _buildProfileHeader(context),
          ),
          
          // Tab Bar
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: themeProvider.primaryColor,
                unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
                indicatorColor: themeProvider.primaryColor,
                tabs: const [
                  Tab(text: 'STATS'),
                  Tab(text: 'CREATIONS'),
                ],
              ),
            ),
            pinned: true,
          ),
          
          // Tab Bar View
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Stats Tab
                _buildStatsTab(context),
                
                // Creations Tab
                _buildCreationsTab(context),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Create a new image (not implemented)'),
              backgroundColor: themeProvider.primaryColor,
            ),
          );
        },
        backgroundColor: themeProvider.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
  
  // Show profile options in a bottom sheet
  void _showProfileOptions(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white30 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Title
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'Profile Options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // Option list
              _buildOptionItem(
                context,
                icon: Icons.edit,
                color: themeProvider.primaryColor,
                label: 'Edit Profile',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Edit profile (not implemented)'),
                      backgroundColor: themeProvider.primaryColor,
                    ),
                  );
                },
              ),
              _buildOptionItem(
                context,
                icon: Icons.share,
                color: themeProvider.primaryColor,
                label: 'Share Profile',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Share profile (not implemented)'),
                      backgroundColor: themeProvider.primaryColor,
                    ),
                  );
                },
              ),
              _buildOptionItem(
                context,
                icon: Icons.privacy_tip,
                color: themeProvider.primaryColor,
                label: 'Privacy Settings',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Privacy settings (not implemented)'),
                      backgroundColor: themeProvider.primaryColor,
                    ),
                  );
                },
              ),
              _buildOptionItem(
                context,
                icon: Icons.settings,
                color: themeProvider.primaryColor,
                label: 'Account Settings',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Account settings (not implemented)'),
                      backgroundColor: themeProvider.primaryColor,
                    ),
                  );
                },
              ),
              _buildOptionItem(
                context,
                icon: Icons.help_outline,
                color: themeProvider.primaryColor,
                label: 'Help & Support',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Help & support (not implemented)'),
                      backgroundColor: themeProvider.primaryColor,
                    ),
                  );
                },
              ),
              _buildOptionItem(
                context,
                icon: Icons.logout,
                color: Colors.red,
                label: 'Logout',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Logout (not implemented)'),
                      backgroundColor: themeProvider.primaryColor,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildProfileHeader(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    return Container(
      transform: Matrix4.translationValues(0, -40, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Profile picture with elevated container
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Hero(
              tag: 'profile-picture',
              child: CircleAvatar(
                radius: 50,
                backgroundColor: themeProvider.primaryColor,
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
          ).animate()
            .fadeIn(duration: 600.ms)
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 600.ms),
          
          const SizedBox(height: 16),
          
          // User name with verified badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.verified,
                color: themeProvider.primaryColor,
                size: 20,
              ),
            ],
          ).animate()
            .fadeIn(duration: 600.ms, delay: 200.ms)
            .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 200.ms, curve: Curves.easeOutQuad),
          
          const SizedBox(height: 8),
          
          // User Email
          Text(
            'john.doe@example.com',
            style: TextStyle(
              fontSize: 16,
              color: isDark
                  ? const Color(0xFFA0A0A0)
                  : const Color(0xFF6A6A6A),
            ),
          ).animate()
            .fadeIn(duration: 600.ms, delay: 300.ms)
            .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 300.ms, curve: Curves.easeOutQuad),
          
          const SizedBox(height: 16),
          
          // User Bio with quote styling
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF2C2C2C)
                  : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.format_quote,
                  color: themeProvider.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Digital artist and AI enthusiast passionate about creating stunning imagery with the power of AI',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: isDark
                          ? const Color(0xFFA0A0A0)
                          : const Color(0xFF6A6A6A),
                    ),
                  ),
                ),
              ],
            ),
          ).animate()
            .fadeIn(duration: 600.ms, delay: 400.ms)
            .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 400.ms, curve: Curves.easeOutQuad),
          
          const SizedBox(height: 16),
          
          // Quick action buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildQuickActionButton(
                  context,
                  icon: Icons.edit,
                  label: 'Edit Profile',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Edit profile (not implemented)'),
                        backgroundColor: themeProvider.primaryColor,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _buildQuickActionButton(
                  context,
                  icon: Icons.image,
                  label: 'New Image',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('New image creation (not implemented)'),
                        backgroundColor: themeProvider.primaryColor,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _buildQuickActionButton(
                  context,
                  icon: Icons.share,
                  label: 'Share',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Share profile (not implemented)'),
                        backgroundColor: themeProvider.primaryColor,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _buildQuickActionButton(
                  context,
                  icon: Icons.settings,
                  label: 'Settings',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Profile settings (not implemented)'),
                        backgroundColor: themeProvider.primaryColor,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _buildQuickActionButton(
                  context,
                  icon: Icons.bookmark,
                  label: 'Saved',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Saved images (not implemented)'),
                        backgroundColor: themeProvider.primaryColor,
                      ),
                    );
                  },
                ),
              ],
            ),
          ).animate()
            .fadeIn(duration: 600.ms, delay: 500.ms)
            .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 500.ms, curve: Curves.easeOutQuad),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
  
  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: themeProvider.primaryColor,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatsTab(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    // Sample stats data
    final stats = [
      {'label': 'Images Created', 'value': '28'},
      {'label': 'Likes Received', 'value': '143'},
      {'label': 'Followers', 'value': '56'},
      {'label': 'Following', 'value': '21'},
    ];
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Stats grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(
                    color: isDark 
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.05),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      stats[index]['value']!,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      stats[index]['label']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ).animate()
                .fadeIn(duration: 600.ms, delay: Duration(milliseconds: 100 * index))
                .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), 
                      duration: 600.ms, delay: Duration(milliseconds: 100 * index));
            },
          ),
          
          const SizedBox(height: 24),
          
          // Activity section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildActivityItem(
                context,
                icon: Icons.image,
                color: themeProvider.primaryColor,
                text: 'Created a new artwork',
                time: '2 hours ago',
              ),
              _buildActivityItem(
                context,
                icon: Icons.favorite,
                color: Colors.red,
                text: 'Liked an artwork by Sarah',
                time: '5 hours ago',
              ),
              _buildActivityItem(
                context,
                icon: Icons.person_add,
                color: Colors.blue,
                text: 'Followed David',
                time: '1 day ago',
              ),
              _buildActivityItem(
                context,
                icon: Icons.comment,
                color: Colors.orange,
                text: 'Commented on Alex\'s artwork',
                time: '2 days ago',
              ),
              _buildActivityItem(
                context,
                icon: Icons.star,
                color: Colors.amber,
                text: 'Added artwork to favorites',
                time: '3 days ago',
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildCreationsTab(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    // Sample images - would be replaced with actual user created images
    final sampleImages = [
      'https://via.placeholder.com/300/FF6B6B/FFFFFF?text=AI+Art+1',
      'https://via.placeholder.com/300/4ECDC4/FFFFFF?text=AI+Art+2',
      'https://via.placeholder.com/300/FFD93D/000000?text=AI+Art+3',
      'https://via.placeholder.com/300/6C63FF/FFFFFF?text=AI+Art+4',
      'https://via.placeholder.com/300/FF6584/FFFFFF?text=AI+Art+5',
      'https://via.placeholder.com/300/43A047/FFFFFF?text=AI+Art+6',
    ];
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter options
          Container(
            height: 40,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(context, 'All', isSelected: true),
                  _buildFilterChip(context, 'Recent'),
                  _buildFilterChip(context, 'Popular'),
                  _buildFilterChip(context, 'Favorites'),
                  _buildFilterChip(context, 'Landscape'),
                  _buildFilterChip(context, 'Portrait'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Content categories
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Creations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // View all
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: themeProvider.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          // Image grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: sampleImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // View image details
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('View image details (not implemented)'),
                        backgroundColor: themeProvider.primaryColor,
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      // Image with shadow
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(sampleImages[index]),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      
                      // Image info overlay at bottom
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right:.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.favorite, color: Colors.white, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    '${42 + index}',
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                              Text(
                                '${DateTime.now().subtract(Duration(days: index)).day}/${DateTime.now().subtract(Duration(days: index)).month}',
                                style: TextStyle(color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Options button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _showImageOptions(context);
                            },
                            child: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate()
                  .fadeIn(duration: 400.ms, delay: Duration(milliseconds: 50 * index))
                  .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: Duration(milliseconds: 50 * index));
              },
            ),
          ),
        ],
      ),
    );
  }
  
  // Show image options
  void _showImageOptions(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white30 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Title
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'Image Options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // Option list
              _buildOptionItem(
                context,
                icon: Icons.edit,
                color: themeProvider.primaryColor,
                label: 'Edit Image',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Edit image (not implemented)'),
                      backgroundColor: themeProvider.primaryColor,
                    ),
                  );
                },
              ),
              _buildOptionItem(
                context,
                icon: Icons.share,
                color: themeProvider.primaryColor,
                label: 'Share Image',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Share image (not implemented)'),
                      backgroundColor: themeProvider.primaryColor,
                    ),
                  );
                },
              ),
              _buildOptionItem(
                context,
                icon: Icons.download,
                color: themeProvider.primaryColor,
                label: 'Download',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Download image (not implemented)'),
                      backgroundColor: themeProvider.primaryColor,
                    ),
                  );
                },
              ),
              _buildOptionItem(
                context,
                icon: Icons.favorite_border,
                color: Colors.pink,
                label: 'Add to Favorites',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Added to favorites (not implemented)'),
                      backgroundColor: themeProvider.primaryColor,
                    ),
                  );
                },
              ),
              _buildOptionItem(
                context,
                icon: Icons.copy,
                color: themeProvider.primaryColor,
                label: 'Duplicate',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Image duplicated (not implemented)'),
                      backgroundColor: themeProvider.primaryColor,
                    ),
                  );
                },
              ),
              _buildOptionItem(
                context,
                icon: Icons.delete,
                color: Colors.red,
                label: 'Delete',
                onTap: () {
                  Navigator.pop(context);
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Image?'),
                      content: const Text('This action cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Image deleted (not implemented)'),
                                backgroundColor: themeProvider.primaryColor,
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  // Option item for bottom sheets
  Widget _buildOptionItem(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(label),
      onTap: onTap,
    );
  }
  
  // Activity item widget
  Widget _buildActivityItem(BuildContext context, {
    required IconData icon,
    required Color color,
    required String text,
    required String time,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.6),
                width: 1.5,
              ),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
            onPressed: () {
              // View activity details
            },
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 600.ms, delay: text.contains('new') ? 200.ms : text.contains('Liked') ? 400.ms : 600.ms)
      .slideX(begin: 0.1, end: 0, duration: 600.ms, delay: text.contains('new') ? 200.ms : text.contains('Liked') ? 400.ms : 600.ms);
  }
  
  // Filter chip widget
  Widget _buildFilterChip(BuildContext context, String label, {bool isSelected = false}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : null,
          fontWeight: isSelected ? FontWeight.bold : null,
          fontSize: 13,
        ),
        backgroundColor: Theme.of(context).cardColor,
        selectedColor: themeProvider.primaryColor,
        checkmarkColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        onSelected: (value) {
          // Would update the filter in a real app
        },
      ),
    );
  }
}

// Delegate for SliverPersistentHeader to host the tab bar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  
  _SliverAppBarDelegate(this._tabBar);
  
  @override
  double get minExtent => _tabBar.preferredSize.height;
  
  @override
  double get maxExtent => _tabBar.preferredSize.height;
  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }
  
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
} 