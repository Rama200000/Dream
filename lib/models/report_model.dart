class ReportModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final String status;
  final String date;
  final int imageCount;

  ReportModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.date,
    this.imageCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'date': date,
      'imageCount': imageCount,
    };
  }
}

// Enum untuk statistik
enum ReportStatus {
  approved,
  processing,
  pending,
  rejected
}

// Model untuk statistik
class MonthlyReportData {
  final String month;
  final int count;
  final List<Map<String, dynamic>> reports;

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
  final List<Map<String, dynamic>> reports;

  CategoryData({
    required this.category,
    required this.count,
    required this.percentage,
    required this.reports,
  });
}
