import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dashboard_screen.dart';
import 'reports_screen.dart';
import 'notifications_screen.dart';
import '../models/report_model.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 1;
  int? _selectedMonthIndex;

  // Data dummy untuk demonstrasi - GUNAKAN MAP BIASA
  final List<MonthlyReportData> _monthlyData = [
    MonthlyReportData(
      month: 'Jan',
      count: 16,
      reports: List.generate(16, (index) => {
        'id': index + 1,
        'title': 'Plagiarisme Tugas ${index + 1}',
        'description': 'Detail laporan plagiarisme...',
        'category': 'Plagiarisme',
        'status': 'Disetujui',
        'date': '${index + 1} Januari 2025',
      }),
    ),
    MonthlyReportData(
      month: 'Feb',
      count: 24,
      reports: List.generate(24, (index) => {
        'id': index + 17,
        'title': 'Menyontek Ujian ${index + 1}',
        'description': 'Detail laporan menyontek...',
        'category': 'Menyontek',
        'status': 'Diproses',
        'date': '${index + 1} Februari 2025',
      }),
    ),
    MonthlyReportData(
      month: 'Mar',
      count: 20,
      reports: List.generate(20, (index) => {
        'id': index + 41,
        'title': 'Titip Absen ${index + 1}',
        'description': 'Detail laporan titip absen...',
        'category': 'Titip Absen',
        'status': 'Menunggu Review',
        'date': '${index + 1} Maret 2025',
      }),
    ),
    MonthlyReportData(
      month: 'Apr',
      count: 18,
      reports: List.generate(18, (index) => {
        'id': index + 61,
        'title': 'Kecurangan ${index + 1}',
        'description': 'Detail laporan kecurangan...',
        'category': 'Kecurangan',
        'status': 'Disetujui',
        'date': '${index + 1} April 2025',
      }),
    ),
    MonthlyReportData(
      month: 'Mei',
      count: 24,
      reports: List.generate(24, (index) => {
        'id': index + 79,
        'title': 'Plagiarisme ${index + 1}',
        'description': 'Detail laporan plagiarisme...',
        'category': 'Plagiarisme',
        'status': 'Ditolak',
        'date': '${index + 1} Mei 2025',
      }),
    ),
    MonthlyReportData(
      month: 'Jun',
      count: 32,
      reports: List.generate(32, (index) => {
        'id': index + 103,
        'title': 'Menyontek ${index + 1}',
        'description': 'Detail laporan menyontek...',
        'category': 'Menyontek',
        'status': 'Disetujui',
        'date': '${index + 1} Juni 2025',
      }),
    ),
  ];

  // Data dummy untuk demonstrasi - KATEGORI
  final List<CategoryData> _categoryData = [
    CategoryData(
      category: 'Plagiarisme',
      count: 25,
      percentage: 62.5,
      reports: List.generate(25, (index) => {
        'id': index + 1,
        'title': 'Plagiarisme Kasus ${index + 1}',
        'description': 'Mahasiswa melakukan plagiarisme pada tugas...',
        'category': 'Plagiarisme',
        'status': 'Disetujui',
        'date': '${DateTime.now().subtract(Duration(days: index)).day} Januari 2025',
      }),
    ),
    CategoryData(
      category: 'Menyontek',
      count: 10,
      percentage: 25.0,
      reports: List.generate(10, (index) => {
        'id': index + 26,
        'title': 'Menyontek Kasus ${index + 1}',
        'description': 'Mahasiswa menyontek saat ujian...',
        'category': 'Menyontek',
        'status': 'Diproses',
        'date': '${DateTime.now().subtract(Duration(days: index + 10)).day} Februari 2025',
      }),
    ),
    CategoryData(
      category: 'Titip Absen',
      count: 5,
      percentage: 12.5,
      reports: List.generate(5, (index) => {
        'id': index + 36,
        'title': 'Titip Absen Kasus ${index + 1}',
        'description': 'Mahasiswa titip absen...',
        'category': 'Titip Absen',
        'status': 'Menunggu Review',
        'date': '${DateTime.now().subtract(Duration(days: index + 20)).day} Maret 2025',
      }),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
              padding: const EdgeInsets.all(20),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Grafik & Statistik',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Visualisasi Data Laporan',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // FIX: Tab Bar - Ukuran lebih proporsional
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  labelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[600],
                  indicator: BoxDecoration(
                    color: const Color(0xFF1453A3),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1453A3).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Grafik'),
                    Tab(text: 'Kategori'),
                    Tab(text: 'Status'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGrafikTab(),
                  _buildKategoriTab(),
                  _buildStatusTab(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildGrafikTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Laporan Bulanan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Trend Laporan 6 Bulan Terakhir',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                // Chart
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: 8,
                        verticalInterval: 1,
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 8,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun'];
                              if (value.toInt() >= 0 && value.toInt() < months.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    months[value.toInt()],
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            const FlSpot(0, 16),
                            const FlSpot(1, 24),
                            const FlSpot(2, 20),
                            const FlSpot(3, 18),
                            const FlSpot(4, 24),
                            const FlSpot(5, 32),
                          ],
                          isCurved: true,
                          color: const Color(0xFF1453A3),
                          barWidth: 3,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: _selectedMonthIndex == index ? 6 : 4,
                                color: const Color(0xFF1453A3),
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        enabled: true,
                        handleBuiltInTouches: true,
                        touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                          if (event is FlTapUpEvent && response != null && response.lineBarSpots != null) {
                            final spot = response.lineBarSpots!.first;
                            setState(() {
                              _selectedMonthIndex = spot.x.toInt();
                            });
                            _showMonthDetail(spot.x.toInt());
                          }
                        },
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                            return touchedBarSpots.map((barSpot) {
                              final monthData = _monthlyData[barSpot.x.toInt()];
                              return LineTooltipItem(
                                '${monthData.month}\n${monthData.count} laporan',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // FIX: Statistics Cards - Row dengan spacing yang lebih baik
                Row(
                  children: [
                    Expanded(
                      child: _buildStatisticsCard('32', 'Bulan\nIni', Colors.purple[400]!),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatisticsCard('+ 18%', 'Pertum\nbuhan', Colors.green[400]!),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatisticsCard('24', 'Rata-\nrata', Colors.blue[700]!),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // FIX: Statistics Card - Ukuran lebih proporsional
  Widget _buildStatisticsCard(String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildKategoriTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
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
                const Text(
                  'Distribusi Kategori',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                // Pie Chart
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 0,
                      sections: [
                        PieChartSectionData(
                          color: const Color(0xFFFFB74D),
                          value: 25,
                          title: '62.5%',
                          radius: 100,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          color: const Color(0xFFB39DDB),
                          value: 10,
                          title: '25%',
                          radius: 100,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          color: const Color(0xFF81C784),
                          value: 5,
                          title: '12.5%',
                          radius: 100,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Legend Items
                Column(
                  children: [
                    _buildLegendItem(
                      color: const Color(0xFFFFB74D),
                      label: 'Plagiarisme',
                      value: '62.5%',
                    ),
                    const Divider(height: 30),
                    _buildLegendItem(
                      color: const Color(0xFFB39DDB),
                      label: 'Menyontek',
                      value: '25%',
                    ),
                    const Divider(height: 30),
                    _buildLegendItem(
                      color: const Color(0xFF81C784),
                      label: 'Titip Absen',
                      value: '12.5%',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required String value,
  }) {
    return InkWell(
      onTap: () {
        // Find category data and show detail
        final categoryData = _categoryData.firstWhere(
          (cat) => cat.category == label,
          orElse: () => _categoryData[0],
        );
        _showCategoryDetail(categoryData);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                ),
              ),
            ),
            if (value.isNotEmpty)
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, size: 20, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _showCategoryDetail(CategoryData categoryData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Kategori: ${categoryData.category}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Total: ${categoryData.count} laporan (${categoryData.percentage.toStringAsFixed(1)}%)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: categoryData.reports.length,
                  itemBuilder: (context, index) {
                    final report = categoryData.reports[index];
                    return _buildReportListItem(report);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
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
                const Text(
                  'Status Laporan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                // Pie Chart
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 0,
                      sections: [
                        PieChartSectionData(
                          color: const Color(0xFFFFB74D),
                          value: 60,
                          title: '60%',
                          radius: 100,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          color: const Color(0xFF81C784),
                          value: 25,
                          title: '25%',
                          radius: 100,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          color: const Color(0xFFB39DDB),
                          value: 15,
                          title: '15%',
                          radius: 100,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Legend Items
                Column(
                  children: [
                    _buildLegendItem(
                      color: const Color(0xFFFFB74D),
                      label: 'Selesai',
                      value: '',
                    ),
                    const Divider(height: 30),
                    _buildLegendItem(
                      color: const Color(0xFF81C784),
                      label: 'Sedang Diproses',
                      value: '',
                    ),
                    const Divider(height: 30),
                    _buildLegendItem(
                      color: const Color(0xFFB39DDB),
                      label: 'Menunggu Verifikasi',
                      value: '',
                    ),
                  ],
                ),
              ],
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
        onTap: (index) {
          if (_selectedIndex == index) return;

          setState(() {
            _selectedIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DashboardScreen()),
              );
              break;
            case 1:
              // Sudah di Statistics
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ReportsScreen()),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              );
              break;
          }
        },
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
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Grafik',
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
        ],
      ),
    );
  }

  void _showMonthDetail(int monthIndex) {
    final monthData = _monthlyData[monthIndex];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Laporan ${monthData.month} 2025',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Total: ${monthData.count} laporan',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: monthData.reports.length,
                  itemBuilder: (context, index) {
                    final report = monthData.reports[index];
                    return _buildReportListItem(report);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportListItem(Map<String, dynamic> report) {
    Color statusColor = _getStatusColorFromString(report['status'] as String);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          report['title'] as String,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              report['category'] as String,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              report['date'] as String,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            report['status'] as String,
            style: TextStyle(
              fontSize: 11,
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () {
          _showReportDetailModal(report);
        },
      ),
    );
  }

  Color _getStatusColorFromString(String status) {
    switch (status) {
      case 'Disetujui':
        return const Color(0xFF66BB6A);
      case 'Diproses':
        return const Color(0xFFFFA726);
      case 'Menunggu Review':
        return const Color(0xFF42A5F5);
      case 'Ditolak':
        return const Color(0xFFE74C3C);
      default:
        return Colors.grey;
    }
  }

  void _showReportDetailModal(Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      report['title'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRowModal('Kategori', report['category'] as String),
              const SizedBox(height: 12),
              _buildDetailRowModal('Status', report['status'] as String),
              const SizedBox(height: 12),
              _buildDetailRowModal('Tanggal', report['date'] as String),
              const SizedBox(height: 20),
              const Text(
                'Deskripsi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                report['description'] as String,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRowModal(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
