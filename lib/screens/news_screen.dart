import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1453A3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Berita Terkini',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildNewsDetailCard(
            title: 'Politeknik Negeri Lampung Raih Akreditasi Unggul',
            date: '24 Desember 2024',
            category: 'Prestasi',
            content: 'Politeknik Negeri Lampung berhasil meraih akreditasi Unggul dari BAN-PT. Ini merupakan pencapaian tertinggi yang pernah diraih institusi.',
          ),
          const SizedBox(height: 16),
          _buildNewsDetailCard(
            title: 'Workshop Pengembangan Aplikasi Mobile di Polinela',
            date: '22 Desember 2024',
            category: 'Kegiatan',
            content: 'Workshop pengembangan aplikasi mobile menggunakan Flutter diselenggarakan oleh Jurusan Teknik Informatika untuk meningkatkan skill mahasiswa.',
          ),
          const SizedBox(height: 16),
          _buildNewsDetailCard(
            title: 'Mahasiswa Polinela Juara Kompetisi Nasional',
            date: '20 Desember 2024',
            category: 'Prestasi',
            content: 'Tim mahasiswa Polinela berhasil meraih juara 1 dalam kompetisi aplikasi berbasis AI tingkat nasional.',
          ),
        ],
      ),
    );
  }

  Widget _buildNewsDetailCard({
    required String title,
    required String date,
    required String category,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1453A3).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1453A3),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
