import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'reports_screen.dart';
import 'notifications_screen.dart';
import 'more_menu_screen.dart';
import 'news_screen.dart';
import 'login_screen.dart';
import 'create_report_screen.dart';
import 'profile_screen.dart';
import 'help_support_screen.dart';
import 'settings_screen.dart';
import '../services/google_auth_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  String _userName = 'User Name';
  String _userEmail = 'user@example.com';
  String? _userPhotoUrl; // NEW: Tambah photo URL
  String? _profilePhotoPath; // Foto profil lokal dari SharedPreferences

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadProfilePhoto();
  }

  // Cek status login dan load user info
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Load data dari SharedPreferences
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

      // Jika login dengan email atau Google gagal, gunakan data dari SharedPreferences
      setState(() {
        _userName = userName ?? 'User Name';
        _userEmail = userEmail ?? 'user@example.com';
        _userPhotoUrl = userPhoto;
      });
    } else {
      // Jika belum login, tampilkan guest
      setState(() {
        _userName = 'Guest';
        _userEmail = 'Silakan login untuk membuat laporan';
        _userPhotoUrl = null;
      });
    }
  }

  void _loadUserInfo() {
    final userInfo = _googleAuthService.getUserInfo();
    if (userInfo != null) {
      setState(() {
        _userName = userInfo['displayName'] ?? 'User Name';
        _userEmail = userInfo['email'] ?? 'user@example.com';
        _userPhotoUrl = userInfo['photoUrl']; // NEW: Load photo URL
      });
    } else {
      setState(() {
        _userName = 'Guest';
        _userEmail = 'Silakan login untuk membuat laporan';
      });
    }
  }

  // Memuat foto profil yang tersimpan
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

  void _onNavBarTap(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Sudah di Dashboard
        break;
      case 1:
        // FIX: Ganti CreateReportScreen menjadi ReportsScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReportsScreen()),
        ).then((_) => setState(() => _selectedIndex = 0));
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationsScreen()),
        ).then((_) => setState(() => _selectedIndex = 0));
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MoreMenuScreen()),
        ).then((_) => setState(() => _selectedIndex = 0));
        break;
    }
  }

  // Handle pembuatan laporan - langsung ke create report (cek login nanti saat submit)
  void _handleCreateReport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateReportScreen(),
      ),
    ).then((_) {
      // Refresh user info jika ada perubahan setelah kembali
      _loadUserInfo();
      _loadProfilePhoto();
    });
  }

  void _showLogoutDialog() {
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
              Navigator.pop(context); // Tutup dialog

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
                // Setelah logout, tetap di dashboard sebagai guest
                setState(() {
                  _userName = 'Guest';
                  _userEmail = 'Silakan login untuk membuat laporan';
                  _userPhotoUrl = null;
                  _profilePhotoPath = null;
                });

                // Tampilkan pesan logout sukses
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Logout berhasil! Anda sekarang sebagai Guest'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
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
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF1453A3),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Header - FIX: Gunakan foto profil dari asset
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  // Logo Polinela di pojok kiri
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.shield,
                          size: 45,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Academic Report',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Sistem Siap Polinela',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                      // Reload foto profil setelah kembali dari ProfileScreen
                      _loadProfilePhoto();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: _userPhotoUrl != null && _userPhotoUrl!.isNotEmpty
                          ? CircleAvatar(
                              radius: 23,
                              backgroundImage: _userPhotoUrl!.startsWith('http')
                                  ? NetworkImage(_userPhotoUrl!)
                                  : FileImage(File(_userPhotoUrl!))
                                      as ImageProvider,
                              backgroundColor: Colors.transparent,
                            )
                          : _profilePhotoPath != null &&
                                  _profilePhotoPath!.isNotEmpty
                              ? CircleAvatar(
                                  radius: 23,
                                  backgroundImage:
                                      FileImage(File(_profilePhotoPath!)),
                                  backgroundColor: Colors.transparent,
                                )
                              : const CircleAvatar(
                                  radius: 23,
                                  backgroundImage:
                                      AssetImage('assets/profil.png'),
                                  backgroundColor: Colors.transparent,
                                ),
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tombol Kamera Besar di Tengah
                      Center(
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: InkWell(
                            onTap: () {
                              _handleCreateReport();
                            },
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF1453A3),
                                    Color(0xFF2E78D4)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF1453A3)
                                        .withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 64,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Buat Laporan',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Ketuk untuk membuat laporan baru',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Berita Terkini Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Berita Terkini',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NewsScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Lihat Semua',
                              style: TextStyle(
                                color: Color(0xFF1453A3),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // News Cards
                      _buildNewsCard(
                        title:
                            'Politeknik Negeri Lampung Raih Akreditasi Unggul',
                        date: '24 Desember 2024',
                        category: 'Prestasi',
                        imageUrl: 'https://via.placeholder.com/150',
                      ),
                      const SizedBox(height: 12),
                      _buildNewsCard(
                        title:
                            'Workshop Pengembangan Aplikasi Mobile di Polinela',
                        date: '22 Desember 2024',
                        category: 'Kegiatan',
                        imageUrl: 'https://via.placeholder.com/150',
                      ),
                      const SizedBox(height: 12),
                      _buildNewsCard(
                        title: 'Mahasiswa Polinela Juara Kompetisi Nasional',
                        date: '20 Desember 2024',
                        category: 'Prestasi',
                        imageUrl: 'https://via.placeholder.com/150',
                      ),

                      const SizedBox(height: 30),

                      // Laporan Terbaru Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Laporan Terbaru',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ReportsScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Lihat Semua',
                              style: TextStyle(
                                color: Color(0xFF1453A3),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // List Laporan
                      _buildReportCard(
                        title: 'Kecurangan Ujian Tengah Semester',
                        status: 'Ujian',
                        statusColor: const Color(0xFF9575CD),
                        date: '23 Oktober 2025',
                      ),
                      const SizedBox(height: 12),
                      _buildReportCard(
                        title: 'Plagiarisme Tugas Akhir',
                        status: 'Tugas',
                        statusColor: const Color(0xFF4DD0E1),
                        date: '22 Oktober 2025',
                      ),
                      const SizedBox(height: 12),
                      _buildReportCard(
                        title: 'Kerjasama Tidak Sah',
                        status: 'Kerjasama',
                        statusColor: const Color(0xFFFF8A65),
                        date: '21 Oktober 2025',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String count,
    required String label,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                // FIX: Tambah maxLines dan overflow handling
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11, // Kurangi dari 12 ke 11
                    color: Colors.black54,
                    height: 1.2, // Tambahkan line height
                  ),
                  maxLines: 2, // Max 2 baris
                  overflow:
                      TextOverflow.ellipsis, // Tambah ... jika terlalu panjang
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard({
    required String title,
    required String date,
    required String category,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Icon(
                Icons.newspaper,
                size: 40,
                color: Colors.grey[400],
              ),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1453A3).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF1453A3),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard({
    required String title,
    required String status,
    required Color statusColor,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            date,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
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

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1453A3),
                  Color(0xFF2E78D4),
                ],
              ),
            ),
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // FIX: Foto Profil di Drawer - gunakan asset
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/profil.png'),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _userEmail,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profil Saya'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Beranda'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.file_copy),
                  title: const Text('Laporan Saya'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReportsScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifikasi'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationsScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.newspaper),
                  title: const Text('Berita'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NewsScreen()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Pengaturan'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Bantuan'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpSupportScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Tampilkan Login atau Logout berdasarkan status
          _googleAuthService.isSignedIn()
              ? ListTile(
                  leading: const Icon(Icons.logout, color: Color(0xFFE74C3C)),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Color(0xFFE74C3C)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutDialog();
                  },
                )
              : ListTile(
                  leading: const Icon(Icons.login, color: Color(0xFF1453A3)),
                  title: const Text(
                    'Login',
                    style: TextStyle(color: Color(0xFF1453A3)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ).then((_) {
                      // Refresh user info setelah login
                      _loadUserInfo();
                      _loadProfilePhoto();
                    });
                  },
                ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
