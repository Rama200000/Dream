import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:video_player/video_player.dart'; // NEW: Import video player
import 'dashboard_screen.dart';
import '../services/google_auth_service.dart';
import '../services/image_cache_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  File? _selectedImage;
  File? _selectedVideo; // NEW: Video file
  VideoPlayerController? _videoController; // NEW: Video controller
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _obscurePassword = true;
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  final ImageCacheService _imageCacheService = ImageCacheService();

  @override
  void initState() {
    super.initState();
    _checkExistingLogin();
  }

  Future<void> _checkExistingLogin() async {
    final googleUser = await _googleAuthService.signInSilently();
    if (googleUser != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  // NEW: Fungsi untuk pick media (foto atau video)
  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih Media Bukti',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Foto atau Video sebagai bukti laporan',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),

              // Grid Menu untuk Media
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _buildMediaOption(
                    icon: Icons.camera_alt,
                    label: 'Ambil Foto',
                    color: const Color(0xFF1453A3),
                    onTap: () async {
                      Navigator.pop(context);
                      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        setState(() {
                          _selectedImage = File(image.path);
                          _selectedVideo = null;
                          _videoController?.dispose();
                          _videoController = null;
                        });
                      }
                    },
                  ),
                  _buildMediaOption(
                    icon: Icons.photo_library,
                    label: 'Galeri Foto',
                    color: const Color(0xFF2E78D4),
                    onTap: () async {
                      Navigator.pop(context);
                      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() {
                          _selectedImage = File(image.path);
                          _selectedVideo = null;
                          _videoController?.dispose();
                          _videoController = null;
                        });
                      }
                    },
                  ),
                  _buildMediaOption(
                    icon: Icons.videocam,
                    label: 'Rekam Video',
                    color: const Color(0xFFE74C3C),
                    onTap: () async {
                      Navigator.pop(context);
                      final XFile? video = await _picker.pickVideo(
                        source: ImageSource.camera,
                        maxDuration: const Duration(minutes: 2),
                      );
                      if (video != null) {
                        final videoFile = File(video.path);
                        final controller = VideoPlayerController.file(videoFile);

                        try {
                          await controller.initialize();
                          setState(() {
                            _selectedVideo = videoFile;
                            _selectedImage = null;
                            _videoController?.dispose();
                            _videoController = controller;
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error loading video: $e'), backgroundColor: Colors.red),
                          );
                        }
                      }
                    },
                  ),
                  _buildMediaOption(
                    icon: Icons.video_library,
                    label: 'Galeri Video',
                    color: const Color(0xFFFF6B6B),
                    onTap: () async {
                      Navigator.pop(context);
                      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
                      if (video != null) {
                        final videoFile = File(video.path);
                        final controller = VideoPlayerController.file(videoFile);

                        try {
                          await controller.initialize();
                          setState(() {
                            _selectedVideo = videoFile;
                            _selectedImage = null;
                            _videoController?.dispose();
                            _videoController = controller;
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error loading video: $e'), backgroundColor: Colors.red),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMediaOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _saveMediaToCache() {
    if (_selectedImage != null) {
      _imageCacheService.cacheImage(_selectedImage!.path);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto berhasil disimpan! Akan tersedia di halaman laporan.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else if (_selectedVideo != null) {
      _imageCacheService.cacheVideo(_selectedVideo!.path);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Video berhasil disimpan! Akan tersedia di halaman laporan.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Belum ada media yang dipilih!'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _loginWithEmail() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan Password harus diisi!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final googleUser = await _googleAuthService.signInWithGoogle();

      if (googleUser != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Login berhasil! Selamat datang ${googleUser.displayName ?? "User"}'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login gagal: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1453A3), Color(0xFF2E78D4)],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                        child: Column(
                          children: [
                            // Header - FIX: Gunakan asset logo
                            SizedBox(height: screenHeight * 0.02),
                            Row(
                              children: [
                                // Logo SSP dari assets
                                Image.asset(
                                  'assets/images/logo.png',
                                  width: screenWidth * 0.12,
                                  height: screenWidth * 0.12,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: screenWidth * 0.12,
                                      height: screenWidth * 0.12,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE74C3C),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.shield,
                                        color: Colors.white,
                                        size: screenWidth * 0.07,
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(width: screenWidth * 0.025),
                                Text(
                                  'Academic Report',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.03),

                            // FIX: Media Upload Card - Support Foto & Video
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(screenWidth * 0.04),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: _pickMedia, // FIX: Ganti _pickImage jadi _pickMedia
                                    child: Container(
                                      width: double.infinity,
                                      height: screenHeight * 0.18,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F5F5),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
                                      ),
                                      child: _selectedImage == null && _selectedVideo == null
                                          ? Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add_a_photo,
                                                  size: screenWidth * 0.12,
                                                  color: Colors.grey[400],
                                                ),
                                                SizedBox(height: screenHeight * 0.01),
                                                Text(
                                                  'Tap untuk foto atau video',
                                                  style: TextStyle(
                                                    fontSize: screenWidth * 0.035,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.photo, size: 14, color: Colors.grey[500]),
                                                    const SizedBox(width: 4),
                                                    Text('Foto', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                                                    const SizedBox(width: 12),
                                                    Icon(Icons.videocam, size: 14, color: Colors.grey[500]),
                                                    const SizedBox(width: 4),
                                                    Text('Video', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : _selectedImage != null
                                              ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: Image.file(_selectedImage!, fit: BoxFit.cover),
                                                )
                                              : _videoController != null
                                                  ? Stack(
                                                      fit: StackFit.expand,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(10),
                                                          child: VideoPlayer(_videoController!),
                                                        ),
                                                        Center(
                                                          child: Container(
                                                            padding: const EdgeInsets.all(12),
                                                            decoration: BoxDecoration(
                                                              color: Colors.black.withOpacity(0.5),
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: IconButton(
                                                              icon: Icon(
                                                                _videoController!.value.isPlaying
                                                                    ? Icons.pause
                                                                    : Icons.play_arrow,
                                                                color: Colors.white,
                                                                size: 32,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  _videoController!.value.isPlaying
                                                                      ? _videoController!.pause()
                                                                      : _videoController!.play();
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 8,
                                                          left: 8,
                                                          child: Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                            decoration: BoxDecoration(
                                                              color: const Color(0xFFE74C3C).withOpacity(0.9),
                                                              borderRadius: BorderRadius.circular(6),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                const Icon(Icons.videocam, color: Colors.white, size: 14),
                                                                const SizedBox(width: 4),
                                                                Text(
                                                                  '${_videoController!.value.duration.inSeconds}s',
                                                                  style: const TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 11,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : const Center(child: CircularProgressIndicator()),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.015),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: _saveMediaToCache, // FIX: Ganti function
                                      icon: Icon(
                                        _selectedVideo != null ? Icons.videocam : Icons.photo,
                                        size: 20,
                                      ),
                                      label: Text(
                                        _selectedVideo != null ? 'Simpan Video' : 'Simpan Foto',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.036,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF1453A3),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.025),

                            // Sign In Card - Responsive
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(screenWidth * 0.05),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.06,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF212121),
                                    ),
                                  ),

                                  SizedBox(height: screenHeight * 0.025),

                                  // Email Field
                                  TextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      hintText: 'E-mail',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: screenWidth * 0.036,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: Colors.grey[600],
                                        size: screenWidth * 0.05,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFE0E0E0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFE0E0E0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF1453A3), width: 2),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.035,
                                        vertical: screenHeight * 0.018,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFFAFAFA),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),

                                  SizedBox(height: screenHeight * 0.015),

                                  // Password Field
                                  TextField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: screenWidth * 0.036,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.lock_outlined,
                                        color: Colors.grey[600],
                                        size: screenWidth * 0.05,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: Colors.grey[600],
                                          size: screenWidth * 0.05,
                                        ),
                                        onPressed: () => setState(() =>
                                            _obscurePassword =
                                                !_obscurePassword),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFE0E0E0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFE0E0E0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF1453A3), width: 2),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.035,
                                        vertical: screenHeight * 0.018,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFFAFAFA),
                                    ),
                                  ),

                                  // Lupa Password
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.01,
                                          vertical: screenHeight * 0.005,
                                        ),
                                      ),
                                      child: Text(
                                        'Lupa Password?',
                                        style: TextStyle(
                                          color: const Color(0xFF1453A3),
                                          fontSize: screenWidth * 0.033,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: screenHeight * 0.015),

                                  // Login Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed:
                                          _isLoading ? null : _loginWithEmail,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF1453A3),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: EdgeInsets.symmetric(
                                            vertical: screenHeight * 0.018),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      child: _isLoading
                                          ? SizedBox(
                                              height: screenWidth * 0.045,
                                              width: screenWidth * 0.045,
                                              child:
                                                  const CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2),
                                            )
                                          : Text(
                                              'Login',
                                              style: TextStyle(
                                                fontSize: screenWidth * 0.038,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ),
                                  ),

                                  SizedBox(height: screenHeight * 0.02),

                                  // Divider
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Divider(
                                              color: Colors.grey[300],
                                              height: 1)),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.03),
                                        child: Text(
                                          'atau',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: screenWidth * 0.03,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Divider(
                                              color: Colors.grey[300],
                                              height: 1)),
                                    ],
                                  ),

                                  SizedBox(height: screenHeight * 0.02),

                                  // Google Sign In Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      onPressed:
                                          _isLoading ? null : _loginWithGoogle,
                                      icon: Image.network(
                                        'https://lh3.googleusercontent.com/COxitqgJr1sJnIDe8-jiKhxDx1FrYbtRHKJ9z_hELisAlapwE9LUPh6fcXIfb5vwpbMl4xl9H9TRFPc5NOO8Sb3VSgIBrfRYvW6cUA',
                                        height: screenWidth * 0.05,
                                        width: screenWidth * 0.05,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: screenWidth * 0.05,
                                            height: screenWidth * 0.05,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.grey[300]!),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'G',
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFF4285F4),
                                                  fontSize: screenWidth * 0.03,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      label: Text(
                                        'Sign in with Google',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.036,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF212121),
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            vertical: screenHeight * 0.015),
                                        side: BorderSide(
                                            color: Colors.grey[300]!),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.025),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Loading Overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _videoController?.dispose(); // NEW: Dispose video controller
    super.dispose();
  }
}
