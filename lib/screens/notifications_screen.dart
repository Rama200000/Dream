import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'reports_screen.dart';
import 'more_menu_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedIndex = 2;

  // Data notifikasi dengan pesan lebih detail
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: 1,
      sender: 'ADMIN',
      message:
          'Laporan Anda tentang "Plagiarisme Tugas Akhir" telah disetujui dan sedang diproses lebih lanjut oleh tim verifikasi. Anda akan mendapat update dalam 2x24 jam.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      type: NotificationType.approved,
      isRead: false,
    ),
    NotificationItem(
      id: 2,
      sender: 'DEA FAKULTAS',
      message:
          'Laporan kecurangan ujian yang Anda laporkan telah diverifikasi. Kami akan segera melakukan investigasi lebih lanjut dan menghubungi pihak terkait.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      type: NotificationType.approved,
      isRead: false,
    ),
    NotificationItem(
      id: 3,
      sender: 'ADMIN SISTEM',
      message:
          'Laporan Anda dengan nomor #LP2024001 sedang menunggu verifikasi dari Dosen Pembimbing Akademik. Mohon bersabar, proses verifikasi memakan waktu 1-3 hari kerja.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      type: NotificationType.pending,
      isRead: false,
    ),
    NotificationItem(
      id: 4,
      sender: 'TIM VERIFIKASI',
      message:
          'Laporan "Titip Absen di Kelas" sedang dalam tahap investigasi mendalam. Tim kami telah mengumpulkan bukti dan akan melakukan wawancara dengan saksi dalam waktu dekat.',
      timestamp:
          DateTime.now().subtract(const Duration(hours: 14, minutes: 30)),
      type: NotificationType.processing,
      isRead: true,
    ),
    NotificationItem(
      id: 5,
      sender: 'ADMIN',
      message:
          'Laporan Anda ditolak karena kurangnya bukti pendukung yang valid. Silakan melengkapi dokumen pendukung seperti foto, video, atau saksi yang dapat memverifikasi kejadian tersebut.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.rejected,
      isRead: true,
    ),
    NotificationItem(
      id: 6,
      sender: 'SISTEM',
      message:
          'Sistem Academic Report akan menjalani maintenance terjadwal pada hari Minggu, 28 Januari 2025 pukul 00.00-02.00 WIB. Mohon maaf atas ketidaknyamanannya.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.info,
      isRead: true,
    ),
  ];

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua notifikasi ditandai sudah dibaca'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Group notifications by time
    final recentNotifications = _notifications.where((n) {
      final diff = DateTime.now().difference(n.timestamp);
      return diff.inHours < 24;
    }).toList();

    final olderNotifications = _notifications.where((n) {
      final diff = DateTime.now().difference(n.timestamp);
      return diff.inHours >= 24;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header dengan gradient - Full screen
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1453A3), Color(0xFF2E78D4)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Notifikasi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _unreadCount > 0
                                ? '$_unreadCount pesan belum dibaca'
                                : 'Semua pesan sudah dibaca',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_unreadCount > 0)
                      IconButton(
                        icon: const Icon(Icons.done_all, color: Colors.white),
                        tooltip: 'Tandai semua dibaca',
                        onPressed: _markAllAsRead,
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Notification List dengan grouping
          Expanded(
            child: _notifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off_outlined,
                            size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('Tidak ada notifikasi',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600])),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Recent notifications
                      if (recentNotifications.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 12),
                          child: Text(
                            'Terbaru',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ...recentNotifications.map((notification) =>
                            _buildNotificationCard(notification)),
                      ],

                      // Older notifications
                      if (olderNotifications.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 12),
                          child: Text(
                            'Sebelumnya',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ...olderNotifications.map((notification) =>
                            _buildNotificationCard(notification)),
                      ],
                    ],
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    Color iconColor;
    IconData iconData;
    Color bgColor;

    switch (notification.type) {
      case NotificationType.approved:
        iconColor = const Color(0xFF66BB6A);
        iconData = Icons.check_circle;
        bgColor = const Color(0xFF66BB6A);
        break;
      case NotificationType.pending:
        iconColor = const Color(0xFFFFA726);
        iconData = Icons.access_time;
        bgColor = const Color(0xFFFFA726);
        break;
      case NotificationType.processing:
        iconColor = const Color(0xFFFFA726);
        iconData = Icons.autorenew;
        bgColor = const Color(0xFFFFA726);
        break;
      case NotificationType.rejected:
        iconColor = const Color(0xFFE74C3C);
        iconData = Icons.cancel;
        bgColor = const Color(0xFFE74C3C);
        break;
      case NotificationType.info:
        iconColor = const Color(0xFF9575CD);
        iconData = Icons.info;
        bgColor = const Color(0xFF9575CD);
        break;
    }

    return Dismissible(
      key: Key(notification.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete, color: Colors.white, size: 28),
            SizedBox(height: 4),
            Text('Hapus', style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          _notifications.remove(notification);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notifikasi dihapus'),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: 'Undo',
              textColor: Colors.white,
              onPressed: () {
                setState(() {
                  _notifications.add(notification);
                  _notifications
                      .sort((a, b) => b.timestamp.compareTo(a.timestamp));
                });
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : bgColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isRead
                ? Colors.grey[200]!
                : bgColor.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                notification.isRead = true;
              });
              _showNotificationDetail(notification);
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar dengan icon - FIX WARNA
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: bgColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: bgColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(iconData, color: iconColor, size: 26),
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.sender,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                              ),
                            ),
                            if (!notification.isRead)
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: bgColor.withOpacity(0.4),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notification.message,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 13, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(
                              _formatTimestamp(notification.timestamp),
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showNotificationDetail(NotificationItem notification) {
    // ...existing code untuk modal detail...
    Color iconColor;
    IconData iconData;
    Color bgColor;

    switch (notification.type) {
      case NotificationType.approved:
        iconColor = const Color(0xFF66BB6A);
        iconData = Icons.check_circle;
        bgColor = const Color(0xFF66BB6A);
        break;
      case NotificationType.pending:
        iconColor = const Color(0xFFFFA726);
        iconData = Icons.access_time;
        bgColor = const Color(0xFFFFA726);
        break;
      case NotificationType.processing:
        iconColor = const Color(0xFFFFA726);
        iconData = Icons.autorenew;
        bgColor = const Color(0xFFFFA726);
        break;
      case NotificationType.rejected:
        iconColor = const Color(0xFFE74C3C);
        iconData = Icons.cancel;
        bgColor = const Color(0xFFE74C3C);
        break;
      case NotificationType.info:
        iconColor = const Color(0xFF9575CD);
        iconData = Icons.info;
        bgColor = const Color(0xFF9575CD);
        break;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: ListView(
              controller: scrollController,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Detail Notifikasi',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: bgColor.withOpacity(
                          0.15), // FIX: ganti withValues jadi withOpacity
                      shape: BoxShape.circle,
                    ),
                    child: Icon(iconData, color: iconColor, size: 40),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  notification.sender,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _formatTimestamp(notification.timestamp),
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    notification.message,
                    style: TextStyle(
                        fontSize: 15, color: Colors.grey[800], height: 1.6),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1453A3),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Tutup', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays == 1) {
      return 'Kemarin ${timestamp.hour.toString().padLeft(2, '0')}.${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.1), // FIX: ganti withValues jadi withOpacity
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
              // Sudah di Notifications
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MoreMenuScreen()),
              );
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

// Model untuk Notification Item
class NotificationItem {
  final int id;
  final String sender;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.sender,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
}

// Enum untuk tipe notifikasi
enum NotificationType {
  approved,
  pending,
  processing,
  rejected,
  info,
}
