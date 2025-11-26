import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class GoogleSignInScreen extends StatelessWidget {
  const GoogleSignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            // Logo Academic Report
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE74C3C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.school_outlined,
                color: Colors.white,
                size: 40,
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Title
            const Text(
              'Pilih Akun',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 8),
            
            const Text(
              'untuk melanjutkan ke Academic Report',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // List Akun Google
            _buildAccountItem(
              context,
              name: 'Dea',
              email: 'dea123@gmail.com',
              avatar: 'D',
            ),
            
            const SizedBox(height: 16),
            
            _buildAccountItem(
              context,
              name: 'Dhey',
              email: 'dea1290@gmail.com',
              avatar: 'D',
            ),
            
            const SizedBox(height: 16),
            
            _buildAccountItem(
              context,
              name: 'Tipi',
              email: 'dea124@gmail.com',
              avatar: 'T',
            ),
            
            const Spacer(),
            
            // Tambah Akun
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person_add_outlined),
              label: const Text('Gunakan akun lain'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1453A3),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountItem(
    BuildContext context, {
    required String name,
    required String email,
    required String avatar,
  }) {
    return InkWell(
      onTap: () {
        // Navigate ke dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFF1453A3),
              child: Text(
                avatar,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Name and Email
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
