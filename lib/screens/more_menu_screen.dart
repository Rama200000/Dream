import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dashboard_screen.dart';
import 'reports_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'help_support_screen.dart';
import 'news_screen.dart';
import 'login_screen.dart';
import '../services/google_auth_service.dart';

class MoreMenuScreen extends StatefulWidget {
  const MoreMenuScreen({super.key});

  @override
  State<MoreMenuScreen> createState() => _MoreMenuScreenState();
}

class _MoreMenuScreenState extends State<MoreMenuScreen> {
  int _selectedIndex = 3;
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  String _userName = 'User Name';
  String _userEmail = 'user@example.com';
  String? _userPhotoUrl;
  String? _profilePhotoPath;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadProfilePhoto();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Load dari SharedPreferences dulu
      final userName = prefs.getString('userName');
      final userEmail = prefs.getString('userEmail');
      final userPhoto = prefs.getString('userPhoto');
      final loginMethod = prefs.getString('loginMethod');

      // Jika login dengan Google, coba silent sign in
      if (loginMethod == 'google') {
        await _googleAuthService.signInSilently();
        final userInfo = _googleAuthService.getUserInfo();
        if (userInfo != null) {
          setState(() {
            _userName = userInfo['displayName'] ?? userName ?? 'User Name';
            _userEmail = userInfo['email'] ?? userEmail ?? 'user@example.com';
            _userPhotoUrl = userInfo['photoUrl'] ?? userPhoto;
          });
          return;
        }
      }

      // Gunakan data dari SharedPreferences
      setState(() {
        _userName = userName ?? 'User Name';
        _userEmail = userEmail ?? 'user@example.com';
        _userPhotoUrl = userPhoto;
      });
    } else {
      setState(() {
        _userName = 'Guest';
        _userEmail = 'Silakan login untuk akses penuh';
        _userPhotoUrl = null;
      });
    }
  }

  void _loadUserInfo() async {
    await _checkLoginStatus();
  }

  // Method untuk cek apakah user sudah login (dari SharedPreferences atau Google)
  Future<bool> _isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedInSharedPrefs = prefs.getBool('isLoggedIn') ?? false;
    final isLoggedInGoogle = _googleAuthService.isSignedIn();
    return isLoggedInSharedPrefs || isLoggedInGoogle;
  }

  Future<void> _loadProfilePhoto() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPhotoPath = prefs.getString('profile_photo_path');
    if (savedPhotoPath != null && savedPhotoPath.isNotEmpty) {
      final file = File(savedPhotoPath);
      if (await file.exists()) {
        setState(() {
          _profilePhotoPath = savedPhotoPath;
        });
      }
    }
  }

  void _handleLoginLogout() async {
    final isLoggedIn = await _isUserLoggedIn();

    if (!isLoggedIn) {
      // METODE 2: User login dulu sebelum membuat laporan
      // Langsung navigate ke LoginScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      ).then((_) {
        // Setelah kembali dari login, refresh data user
        setState(() {});
        _loadUserInfo();
        _loadProfilePhoto();
      });
    } else {
      // Jika sudah login, tampilkan konfirmasi logout
      _showLogoutConfirmation();
    }
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Sign out dari Google
              await _googleAuthService.signOut();

              // Hapus data login dari SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              await prefs.remove('userEmail');
              await prefs.remove('userName');
              await prefs.remove('userPhoto');
              await prefs.remove('loginMethod');

              if (mounted) {
                Navigator.pop(context); // Tutup dialog
                // Tetap di more menu, hanya refresh data
                setState(() {
                  _userName = 'Guest';
                  _userEmail = 'Silakan login untuk akses penuh';
                  _userPhotoUrl = null;
                  _profilePhotoPath = null;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE74C3C),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1453A3),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                      _loadProfilePhoto();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: _userPhotoUrl != null && _userPhotoUrl!.isNotEmpty
                          ? CircleAvatar(
                              radius: 30,
                              backgroundImage: _userPhotoUrl!.startsWith('http')
                                  ? NetworkImage(_userPhotoUrl!)
                                  : FileImage(File(_userPhotoUrl!))
                                      as ImageProvider,
                              backgroundColor: Colors.transparent,
                            )
                          : _profilePhotoPath != null &&
                                  _profilePhotoPath!.isNotEmpty
                              ? CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      FileImage(File(_profilePhotoPath!)),
                                  backgroundColor: Colors.transparent,
                                )
                              : const CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      AssetImage('assets/profil.png'),
                                  backgroundColor: Colors.transparent,
                                ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _userEmail,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text(
                      'Menu Lainnya',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Profil Menu
                    _buildMenuCard(
                      icon: Icons.person,
                      title: 'Profil Saya',
                      subtitle: 'Kelola informasi profil Anda',
                      color: const Color(0xFF1453A3),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // Berita Menu
                    _buildMenuCard(
                      icon: Icons.newspaper,
                      title: 'Berita',
                      subtitle: 'Lihat berita dan pengumuman terkini',
                      color: const Color(0xFFFFA726),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewsScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // Pengaturan Menu
                    _buildMenuCard(
                      icon: Icons.settings,
                      title: 'Pengaturan',
                      subtitle: 'Atur preferensi aplikasi',
                      color: const Color(0xFF66BB6A),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // Bantuan Menu
                    _buildMenuCard(
                      icon: Icons.help,
                      title: 'Bantuan & Dukungan',
                      subtitle: 'Pusat bantuan dan FAQ',
                      color: const Color(0xFF42A5F5),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HelpSupportScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    // Login/Logout Button
                    InkWell(
                      onTap: _handleLoginLogout,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _userName != 'Guest'
                              ? const Color(0xFFFFEBEE)
                              : const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _userName != 'Guest'
                                ? const Color(0xFFE74C3C).withOpacity(0.3)
                                : const Color(0xFF1453A3).withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _userName != 'Guest'
                                    ? const Color(0xFFE74C3C).withOpacity(0.2)
                                    : const Color(0xFF1453A3).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _userName != 'Guest'
                                    ? Icons.logout
                                    : Icons.login,
                                color: _userName != 'Guest'
                                    ? const Color(0xFFE74C3C)
                                    : const Color(0xFF1453A3),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _userName != 'Guest' ? 'Logout' : 'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: _userName != 'Guest'
                                          ? const Color(0xFFE74C3C)
                                          : const Color(0xFF1453A3),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _userName != 'Guest'
                                        ? 'Keluar dari akun Anda'
                                        : 'Masuk untuk akses penuh',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: _googleAuthService.isSignedIn()
                                  ? const Color(0xFFE74C3C).withOpacity(0.5)
                                  : const Color(0xFF1453A3).withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (_selectedIndex == index) return;

          setState(() {
            _selectedIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DashboardScreen()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ReportsScreen()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationsScreen()),
              );
              break;
            case 3:
              // Sudah di More Menu
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: const Color(0xFF1453A3),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy_outlined),
            activeIcon: Icon(Icons.file_copy),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            activeIcon: Icon(Icons.menu),
            label: 'Lainnya',
          ),
        ],
      ),
    );
  }
}
