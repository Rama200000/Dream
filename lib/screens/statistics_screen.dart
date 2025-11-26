import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dashboard_screen.dart';
import 'reports_screen.dart';
import 'notifications_screen.dart';
import '../models/report_model.dart';
import 'report_detail_screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 1;
  int? _selectedMonthIndex;

  // Data dummy untuk demonstrasi
  final List<MonthlyReportData> _monthlyData = [
    MonthlyReportData(
      month: 'Jan',
      count: 16,
      reports: List.generate(
        16,
        (index) => ReportModel(
          id: index + 1,
          title: 'Plagiarisme Tugas ${index + 1}',
          description: 'Detail laporan plagiarisme...',
          category: 'Plagiarisme',
          status: ReportStatus.approved,
          date: DateTime(2025, 1, index + 1),
          reporter: 'User ${index + 1}',
        ),
      ),
    ),
    MonthlyReportData(
      month: 'Feb',
      count: 24,
      reports: List.generate(
        24,
        (index) => ReportModel(
          id: index + 17,
          title: 'Menyontek Ujian ${index + 1}',
          description: 'Detail laporan menyontek...',
          category: 'Menyontek',
          status: ReportStatus.processing,
          date: DateTime(2025, 2, index + 1),
          reporter: 'User ${index + 17}',
        ),
      ),
    ),
    MonthlyReportData(
      month: 'Mar',
      count: 20,
      reports: List.generate(
        20,
        (index) => ReportModel(
          id: index + 41,
          title: 'Titip Absen ${index + 1}',
          description: 'Detail laporan titip absen...',
          category: 'Titip Absen',
          status: ReportStatus.pending,
          date: DateTime(2025, 3, index + 1),
          reporter: 'User ${index + 41}',
        ),
      ),
    ),
    MonthlyReportData(
      month: 'Apr',
      count: 18,
      reports: List.generate(
        18,
        (index) => ReportModel(
          id: index + 61,
          title: 'Kecurangan ${index + 1}',
          description: 'Detail laporan kecurangan...',
          category: 'Kecurangan',
          status: ReportStatus.approved,
          date: DateTime(2025, 4, index + 1),
          reporter: 'User ${index + 61}',
        ),
      ),
    ),
    MonthlyReportData(
      month: 'Mei',
      count: 24,
      reports: List.generate(
        24,
        (index) => ReportModel(
          id: index + 79,
          title: 'Plagiarisme ${index + 1}',
          description: 'Detail laporan plagiarisme...',
          category: 'Plagiarisme',
          status: ReportStatus.rejected,
          date: DateTime(2025, 5, index + 1),
          reporter: 'User ${index + 79}',
        ),
      ),
    ),
    MonthlyReportData(
      month: 'Jun',
      count: 32,
      reports: List.generate(
        32,
        (index) => ReportModel(
          id: index + 103,
          title: 'Menyontek ${index + 1}',
          description: 'Detail laporan menyontek...',
          category: 'Menyontek',
          status: ReportStatus.approved,
          date: DateTime(2025, 6, index + 1),
          reporter: 'User ${index + 103}',
        ),
      ),
    ),
  ];

  final List<CategoryData> _categoryData = [
    CategoryData(
      category: 'Plagiarisme',
      count: 25,
      percentage: 62.5,
      reports: List.generate(
        25,
        (index) => ReportModel(
          id: index + 1,
          title: 'Plagiarisme Kasus ${index + 1}',
          description: 'Mahasiswa melakukan plagiarisme pada tugas...',
          category: 'Plagiarisme',
          status: ReportStatus.approved,
          date: DateTime.now().subtract(Duration(days: index)),
          reporter: 'Admin',
        ),
      ),
    ),
    CategoryData(
      category: 'Menyontek',
      count: 10,
      percentage: 25.0,
      reports: List.generate(
        10,
        (index) => ReportModel(
          id: index + 26,
          title: 'Menyontek Kasus ${index + 1}',
          description: 'Mahasiswa menyontek saat ujian...',
          category: 'Menyontek',
          status: ReportStatus.processing,
          date: DateTime.now().subtract(Duration(days: index + 10)),
          reporter: 'Dosen',
        ),
      ),
    ),
    CategoryData(
      category: 'Titip Absen',
      count: 5,
      percentage: 12.5,
      reports: List.generate(
        5,
        (index) => ReportModel(
          id: index + 36,
          title: 'Titip Absen Kasus ${index + 1}',
          description: 'Mahasiswa titip absen...',
          category: 'Titip Absen',
          status: ReportStatus.pending,
          date: DateTime.now().subtract(Duration(days: index + 20)),
          reporter: 'Pengawas',
        ),
      ),
    ),
  ];

  final List<StatusData> _statusData = [
    StatusData(
      status: ReportStatus.approved,
      count: 60,
      percentage: 60.0,
      reports: [],
    ),
    StatusData(
      status: ReportStatus.processing,
      count: 25,
      percentage: 25.0,
      reports: [],
    ),
    StatusData(
      status: ReportStatus.pending,
      count: 15,
      percentage: 15.0,
      reports: [],
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan gradient
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
                              Text(
                                'Visualisasi Data Pelanggaran',
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

                  // Tab bar
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      labelColor: const Color(0xFF1453A3),
                      unselectedLabelColor: Colors.white,
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: const [
                        Tab(text: 'Grafik'),
                        Tab(text: 'Kategori'),
                        Tab(text: 'Status'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),

            // Content
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
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildGrafikTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Chart Card
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
                const SizedBox(height: 30),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: 8,
                        verticalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey[300]!,
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.grey[300]!,
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          );
                        },
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
                            reservedSize: 30,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
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
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: 5,
                      minY: 0,
                      maxY: 32,
                      lineTouchData: LineTouchData(
                        enabled: true,
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
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Statistics Cards
          Container(
            padding: const EdgeInsets.all(24),
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
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '32',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[400],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Bulan Ini',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '+ 18%',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[400],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pertumbuhan',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '24',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Rata-rata',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
              children: [
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 0,
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          if (event is FlTapUpEvent && pieTouchResponse != null) {
                            final sectionIndex = pieTouchResponse.touchedSection?.touchedSectionIndex;
                            if (sectionIndex != null) {
                              _showCategoryDetail(_categoryData[sectionIndex]);
                            }
                          }
                        },
                      ),
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

                const SizedBox(height: 30),

                // Legend Items dengan tap handler
                ...List.generate(_categoryData.length, (index) {
                  final category = _categoryData[index];
                  final colors = [
                    const Color(0xFFFFB74D),
                    const Color(0xFFB39DDB),
                    const Color(0xFF81C784),
                  ];
                  
                  return Column(
                    children: [
                      if (index > 0) const Divider(height: 30),
                      InkWell(
                        onTap: () => _showCategoryDetail(category),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: _buildLegendItem(
                            color: colors[index],
                            label: category.category,
                            value: category.count.toString(),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryData.category,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${categoryData.count} laporan (${categoryData.percentage}%)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
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

  Widget _buildReportListItem(ReportModel report) {
    Color statusColor;
    switch (report.status) {
      case ReportStatus.approved:
        statusColor = const Color(0xFF66BB6A);
        break;
      case ReportStatus.processing:
        statusColor = const Color(0xFFFFA726);
        break;
      case ReportStatus.pending:
        statusColor = const Color(0xFF42A5F5);
        break;
      case ReportStatus.rejected:
        statusColor = const Color(0xFFE74C3C);
        break;
    }

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
          report.title,
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
              report.category,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${report.date.day}/${report.date.month}/${report.date.year}',
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
            report.status.toString().split('.').last,
            style: TextStyle(
              fontSize: 11,
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportDetailScreen(report: report),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 16),
            child: Text(
              'Status Laporan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          // Pie Chart Card
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
              children: [
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
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Legend Items
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
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        if (value.isNotEmpty)
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          
          // Navigasi berdasarkan index
          switch (index) {
            case 0:
              // Kembali ke Dashboard
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DashboardScreen()),
              );
              break;
            case 1:
              // Sudah di halaman Grafik, tidak perlu navigasi
              break;
            case 2:
              // Ke halaman Laporan
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ReportsScreen()),
              );
              break;
            case 3:
              // Ke halaman Notifikasi
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
            icon: Icon(Icons.show_chart_outlined),
            activeIcon: Icon(Icons.show_chart),
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
}
