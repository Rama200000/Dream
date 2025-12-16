import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Future<void> _launchWhatsApp() async {
    final Uri whatsappUrl = Uri.parse('https://wa.me/6285233740141');
    if (!await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch WhatsApp');
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailUrl = Uri.parse('mailto:support@polinela.ac.id?subject=Bantuan Aplikasi Academic Report');
    if (!await launchUrl(emailUrl)) {
      throw Exception('Could not launch email');
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneUrl = Uri.parse('tel:+6285233740141');
    if (!await launchUrl(phoneUrl)) {
      throw Exception('Could not launch phone');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1453A3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bantuan & Dukungan',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1453A3), Color(0xFF1976D2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.support_agent, color: Colors.white, size: 40),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Butuh Bantuan?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kami siap membantu Anda',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Contact Options
            const Text(
              'Hubungi Kami',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            _buildContactCard(
              icon: Icons.phone,
              iconColor: Colors.green,
              title: 'Telepon',
              subtitle: '+62 852-3374-0141',
              onTap: () async {
                try {
                  await _launchPhone();
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tidak dapat membuka aplikasi telepon'),
                      ),
                    );
                  }
                }
              },
            ),

            const SizedBox(height: 12),

            _buildContactCard(
              icon: Icons.chat,
              iconColor: const Color(0xFF25D366),
              title: 'WhatsApp',
              subtitle: 'Chat dengan tim support',
              onTap: () async {
                try {
                  await _launchWhatsApp();
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tidak dapat membuka WhatsApp'),
                      ),
                    );
                  }
                }
              },
            ),

            const SizedBox(height: 12),

            _buildContactCard(
              icon: Icons.email,
              iconColor: Colors.red,
              title: 'Email',
              subtitle: 'support@polinela.ac.id',
              onTap: () async {
                try {
                  await _launchEmail();
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tidak dapat membuka aplikasi email'),
                      ),
                    );
                  }
                }
              },
            ),

            const SizedBox(height: 24),

            // FAQ Section
            const Text(
              'Pertanyaan Umum (FAQ)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            _buildFAQCard(
              question: 'Bagaimana cara membuat laporan?',
              answer: 'Klik tombol "Tambah Laporan" di halaman utama, isi formulir dengan lengkap, dan submit laporan Anda.',
            ),

            const SizedBox(height: 12),

            _buildFAQCard(
              question: 'Berapa lama waktu verifikasi laporan?',
              answer: 'Laporan akan diverifikasi dalam waktu maksimal 2x24 jam oleh tim akademik.',
            ),

            const SizedBox(height: 12),

            _buildFAQCard(
              question: 'Bagaimana cara mengubah profil?',
              answer: 'Buka halaman Profil, klik tombol "Edit Profil", lalu ubah data yang diperlukan dan simpan.',
            ),

            const SizedBox(height: 12),

            _buildFAQCard(
              question: 'Apakah data saya aman?',
              answer: 'Ya, semua data Anda terenkripsi dan tersimpan dengan aman. Kami menjaga privasi dan keamanan informasi Anda.',
            ),

            const SizedBox(height: 12),

            _buildFAQCard(
              question: 'Bagaimana cara reset password?',
              answer: 'Gunakan fitur "Lupa Password" di halaman login, atau ubah password melalui menu "Ubah Password" di halaman profil.',
            ),

            const SizedBox(height: 24),

            // Jam Operasional
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF1453A3).withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: const Color(0xFF1453A3),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Jam Operasional',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildScheduleRow('Senin - Jumat', '08:00 - 16:00 WIB'),
                  const SizedBox(height: 4),
                  _buildScheduleRow('Sabtu', '08:00 - 12:00 WIB'),
                  const SizedBox(height: 4),
                  _buildScheduleRow('Minggu & Libur', 'Tutup'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 24),
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQCard({
    required String question,
    required String answer,
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
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 8),
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Text(
            answer,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(String day, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
        Text(
          time,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
