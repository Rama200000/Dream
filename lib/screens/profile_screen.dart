import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user_model.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
import 'change_password_screen.dart';
import 'help_support_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Data user dari login
  UserModel user = UserModel(
    name: 'Guest',
    email: '',
    phone: '',
    nim: '',
    jurusan: '',
  );

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Memuat data user dari SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load data login
    final userName = prefs.getString('userName') ?? 'Guest';
    final userEmail = prefs.getString('userEmail') ?? '';
    final userPhoto = prefs.getString('userPhoto') ?? '';

    // Load data profil tambahan (jika ada)
    final phone = prefs.getString('userPhone') ?? '';
    final nim = prefs.getString('userNim') ?? '';
    final jurusan = prefs.getString('userJurusan') ?? '';

    setState(() {
      user = UserModel(
        name: userName,
        email: userEmail,
        phone: phone,
        nim: nim,
        jurusan: jurusan,
        photoUrl: userPhoto.isNotEmpty ? userPhoto : null,
      );
    });

    // Jika foto dari Google, tidak perlu load dari local file
    if (userPhoto.isEmpty) {
      await _loadProfilePhoto();
    }
  }

  // Memuat foto profil yang tersimpan locally
  Future<void> _loadProfilePhoto() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPhotoPath = prefs.getString('profile_photo_path');
    if (savedPhotoPath != null && savedPhotoPath.isNotEmpty) {
      // Cek apakah file masih ada
      final file = File(savedPhotoPath);
      if (await file.exists()) {
        setState(() {
          user.photoUrl = savedPhotoPath;
        });
      }
    }
  }

  // Menyimpan foto profil
  Future<void> _saveProfilePhoto(String photoPath) async {
    try {
      // Salin file ke direktori aplikasi agar permanen
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = File('${appDir.path}/$fileName');

      // Salin file
      await File(photoPath).copy(savedImage.path);

      // Simpan path ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_photo_path', savedImage.path);
      await prefs.setString('userPhoto', savedImage.path);

      return;
    } catch (e) {
      debugPrint('Error saving profile photo: $e');
    }
  }

  // Menghapus foto profil
  Future<void> _deleteProfilePhoto() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPhotoPath = prefs.getString('profile_photo_path');

      // Hapus file jika ada
      if (savedPhotoPath != null) {
        final file = File(savedPhotoPath);
        if (await file.exists()) {
          await file.delete();
        }
      }

      // Hapus dari SharedPreferences
      await prefs.remove('profile_photo_path');
    } catch (e) {
      debugPrint('Error deleting profile photo: $e');
    }
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
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
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

  Future<void> _changeProfilePhoto() async {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ubah Foto Profil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF1453A3)),
              title: const Text('Ambil Foto'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? photo =
                    await picker.pickImage(source: ImageSource.camera);
                if (photo != null) {
                  await _saveProfilePhoto(photo.path);
                  await _loadProfilePhoto();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Foto profil berhasil disimpan'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                }
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: Color(0xFF1453A3)),
              title: const Text('Pilih dari Galeri'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? photo =
                    await picker.pickImage(source: ImageSource.gallery);
                if (photo != null) {
                  await _saveProfilePhoto(photo.path);
                  await _loadProfilePhoto();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Foto profil berhasil disimpan'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                }
              },
            ),
            if (user.photoUrl != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Hapus Foto'),
                onTap: () async {
                  Navigator.pop(context);
                  await _deleteProfilePhoto();
                  setState(() {
                    user.photoUrl = null;
                  });
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Foto profil berhasil dihapus'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1453A3),
                    Color(0xFF2E78D4),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // App bar
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Profil Saya',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProfileScreen(user: user),
                              ),
                            );
                            if (result != null && result is UserModel) {
                              setState(() {
                                user = result;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  // FIX: Foto Profil dengan asset default
                  GestureDetector(
                    onTap: _changeProfilePhoto,
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child:
                              user.photoUrl != null && user.photoUrl!.isNotEmpty
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          user.photoUrl!.startsWith('http')
                                              ? NetworkImage(user.photoUrl!)
                                              : FileImage(File(user.photoUrl!))
                                                  as ImageProvider,
                                      backgroundColor: Colors.transparent,
                                    )
                                  : const CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          AssetImage('assets/profil.png'),
                                      backgroundColor: Colors.transparent,
                                    ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF1453A3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // User Info
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.nim,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Profile Details
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildInfoCard(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      value: user.email,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.phone_outlined,
                      title: 'Nomor Telepon',
                      value: user.phone,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.school_outlined,
                      title: 'Jurusan',
                      value: user.jurusan,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.badge_outlined,
                      title: 'NIM',
                      value: user.nim,
                    ),

                    const SizedBox(height: 30),

                    // Action Buttons
                    _buildActionButton(
                      icon: Icons.lock_outline,
                      title: 'Ubah Password',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      icon: Icons.help_outline,
                      title: 'Bantuan & Dukungan',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HelpSupportScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      icon: Icons.info_outline,
                      title: 'Tentang Aplikasi',
                      onTap: () {
                        _showAboutDialog();
                      },
                    ),
        

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _showLogoutDialog,
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE74C3C),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1453A3).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1453A3),
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
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF1453A3)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tentang Aplikasi'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Academic Report',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Versi 1.0.0'),
            SizedBox(height: 16),
            Text(
              'Sistem Pelaporan Pelanggaran Akademik Politeknik Negeri Lampung',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              '© 2024 Politeknik Negeri Lampung',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
