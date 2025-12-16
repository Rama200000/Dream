import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _reportStatusUpdates = true;
  bool _newsUpdates = false;
  String _language = 'Bahasa Indonesia';
  String _theme = 'Terang';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _emailNotifications = prefs.getBool('email_notifications') ?? true;
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
      _reportStatusUpdates = prefs.getBool('report_status_updates') ?? true;
      _newsUpdates = prefs.getBool('news_updates') ?? false;
      _language = prefs.getString('language') ?? 'Bahasa Indonesia';
      _theme = prefs.getString('theme') ?? 'Terang';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool('email_notifications', _emailNotifications);
    await prefs.setBool('push_notifications', _pushNotifications);
    await prefs.setBool('report_status_updates', _reportStatusUpdates);
    await prefs.setBool('news_updates', _newsUpdates);
    await prefs.setString('language', _language);
    await prefs.setString('theme', _theme);
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
          'Pengaturan',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notifikasi Section
            _buildSectionHeader('Notifikasi'),
            const SizedBox(height: 12),
            _buildSettingCard(
              child: Column(
                children: [
                  _buildSwitchTile(
                    icon: Icons.notifications_active,
                    iconColor: const Color(0xFF1453A3),
                    title: 'Aktifkan Notifikasi',
                    subtitle: 'Terima semua notifikasi aplikasi',
                    value: _notificationsEnabled,
                    onChanged: (value) async {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                      await _saveSettings();
                    },
                  ),
                  if (_notificationsEnabled) ...[
                    const Divider(),
                    _buildSwitchTile(
                      icon: Icons.email,
                      iconColor: Colors.orange,
                      title: 'Email Notifikasi',
                      subtitle: 'Terima notifikasi via email',
                      value: _emailNotifications,
                      onChanged: (value) async {
                        setState(() {
                          _emailNotifications = value;
                        });
                        await _saveSettings();
                      },
                    ),
                    const Divider(),
                    _buildSwitchTile(
                      icon: Icons.phone_android,
                      iconColor: Colors.green,
                      title: 'Push Notifikasi',
                      subtitle: 'Terima notifikasi push',
                      value: _pushNotifications,
                      onChanged: (value) async {
                        setState(() {
                          _pushNotifications = value;
                        });
                        await _saveSettings();
                      },
                    ),
                    const Divider(),
                    _buildSwitchTile(
                      icon: Icons.report,
                      iconColor: Colors.blue,
                      title: 'Update Status Laporan',
                      subtitle: 'Notifikasi perubahan status laporan',
                      value: _reportStatusUpdates,
                      onChanged: (value) async {
                        setState(() {
                          _reportStatusUpdates = value;
                        });
                        await _saveSettings();
                      },
                    ),
                    const Divider(),
                    _buildSwitchTile(
                      icon: Icons.newspaper,
                      iconColor: Colors.purple,
                      title: 'Berita & Update',
                      subtitle: 'Notifikasi berita terbaru',
                      value: _newsUpdates,
                      onChanged: (value) async {
                        setState(() {
                          _newsUpdates = value;
                        });
                        await _saveSettings();
                      },
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tampilan Section
            _buildSectionHeader('Tampilan'),
            const SizedBox(height: 12),
            _buildSettingCard(
              child: Column(
                children: [
                  _buildSelectTile(
                    icon: Icons.brightness_6,
                    iconColor: Colors.amber,
                    title: 'Tema',
                    subtitle: _theme,
                    onTap: () {
                      _showThemeDialog();
                    },
                  ),
                  const Divider(),
                  _buildSelectTile(
                    icon: Icons.language,
                    iconColor: Colors.teal,
                    title: 'Bahasa',
                    subtitle: _language,
                    onTap: () {
                      _showLanguageDialog();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Privasi & Keamanan Section
            _buildSectionHeader('Privasi & Keamanan'),
            const SizedBox(height: 12),
            _buildSettingCard(
              child: Column(
                children: [
                  _buildActionTile(
                    icon: Icons.security,
                    iconColor: Colors.red,
                    title: 'Keamanan Akun',
                    subtitle: 'Kelola keamanan akun Anda',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Keamanan Akun - Coming Soon'),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  _buildActionTile(
                    icon: Icons.privacy_tip,
                    iconColor: Colors.indigo,
                    title: 'Privasi',
                    subtitle: 'Pengaturan privasi data',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Privasi - Coming Soon'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Lainnya Section
            _buildSectionHeader('Lainnya'),
            const SizedBox(height: 12),
            _buildSettingCard(
              child: Column(
                children: [
                  _buildActionTile(
                    icon: Icons.storage,
                    iconColor: Colors.cyan,
                    title: 'Kelola Penyimpanan',
                    subtitle: 'Hapus cache & data sementara',
                    onTap: () {
                      _showClearCacheDialog();
                    },
                  ),
                  const Divider(),
                  _buildActionTile(
                    icon: Icons.info,
                    iconColor: Colors.grey,
                    title: 'Versi Aplikasi',
                    subtitle: 'v1.0.0',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSettingCard({required Widget child}) {
    return Container(
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
      child: child,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF1453A3),
      ),
    );
  }

  Widget _buildSelectTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
      trailing: subtitle == 'v1.0.0' ? null : const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Terang'),
              value: 'Terang',
              groupValue: _theme,
              onChanged: (value) async {
                setState(() {
                  _theme = value!;
                });
                await _saveSettings();
                if (mounted) Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Gelap'),
              value: 'Gelap',
              groupValue: _theme,
              onChanged: (value) async {
                setState(() {
                  _theme = value!;
                });
                await _saveSettings();
                if (mounted) Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Sistem'),
              value: 'Sistem',
              groupValue: _theme,
              onChanged: (value) async {
                setState(() {
                  _theme = value!;
                });
                await _saveSettings();
                if (mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Bahasa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Bahasa Indonesia'),
              value: 'Bahasa Indonesia',
              groupValue: _language,
              onChanged: (value) async {
                setState(() {
                  _language = value!;
                });
                await _saveSettings();
                if (mounted) Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _language,
              onChanged: (value) async {
                setState(() {
                  _language = value!;
                });
                await _saveSettings();
                if (mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Cache'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus semua cache dan data sementara?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache berhasil dihapus'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1453A3),
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
