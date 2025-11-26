class ReportModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final ReportStatus status;
  final DateTime date;
  final String reporter;
  final List<String> images;

  ReportModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.date,
    required this.reporter,
    this.images = const [],
  });
}

enum ReportStatus {
  pending,
  approved,
  rejected,
  processing,
}

class MonthlyReportData {
  final String month;
  final int count;
  final List<ReportModel> reports;

  MonthlyReportData({
    required this.month,
    required this.count,
    required this.reports,
  });
}

class CategoryData {
  final String category;
  final int count;
  final double percentage;
  final List<ReportModel> reports;

  CategoryData({
    required this.category,
    required this.count,
    required this.percentage,
    required this.reports,
  });
}

class StatusData {
  final ReportStatus status;
  final int count;
  final double percentage;
  final List<ReportModel> reports;

  StatusData({
    required this.status,
    required this.count,
    required this.percentage,
    required this.reports,
  });

  String get statusName {
    switch (status) {
      case ReportStatus.approved:
        return 'Selesai';
      case ReportStatus.processing:
        return 'Sedang Diproses';
      case ReportStatus.pending:
        return 'Menunggu Verifikasi';
      case ReportStatus.rejected:
        return 'Ditolak';
    }
  }
}
