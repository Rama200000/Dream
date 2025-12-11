import '../models/report_model.dart';

class ReportService {
  // Singleton pattern
  static final ReportService _instance = ReportService._internal();
  factory ReportService() => _instance;
  ReportService._internal();

  // Data laporan dummy
  final List<ReportModel> _reports = [
    ReportModel(
      id: 1,
      title: 'Plagiarisme Tugas Akhir',
      description:
          'Mahasiswa terindikasi melakukan plagiarisme pada tugas akhir dengan tingkat kesamaan 85% dari sumber online.',
      category: 'Plagiarisme',
      status: 'Disetujui',
      date: '15 Januari 2025',
      imageCount: 3,
    ),
    ReportModel(
      id: 2,
      title: 'Kecurangan Ujian Tengah Semester',
      description:
          'Mahasiswa kedapatan membawa contekan saat ujian tengah semester mata kuliah Pemrograman Web.',
      category: 'Menyontek',
      status: 'Diproses',
      date: '12 Januari 2025',
      imageCount: 2,
    ),
    ReportModel(
      id: 3,
      title: 'Titip Absen di Kelas',
      description:
          'Terlihat mahasiswa menitipkan absen kepada teman saat kuliah Basis Data padahal yang bersangkutan tidak hadir.',
      category: 'Titip Absen',
      status: 'Diproses',
      date: '10 Januari 2025',
      imageCount: 1,
    ),
    ReportModel(
      id: 4,
      title: 'Pemalsuan Tanda Tangan Dosen',
      description:
          'Mahasiswa memalsukan tanda tangan dosen pembimbing pada form persetujuan proposal skripsi.',
      category: 'Pemalsuan Data',
      status: 'Ditolak',
      date: '8 Januari 2025',
      imageCount: 0,
    ),
    ReportModel(
      id: 5,
      title: 'Kerjasama Tidak Sah pada Ujian',
      description:
          'Beberapa mahasiswa bekerja sama dalam mengerjakan soal ujian akhir semester.',
      category: 'Kecurangan Ujian',
      status: 'Disetujui',
      date: '5 Januari 2025',
      imageCount: 4,
    ),
  ];

  // Get all reports
  List<ReportModel> getAllReports() {
    return List.from(_reports);
  }

  // Get report by id
  ReportModel? getReportById(int id) {
    try {
      return _reports.firstWhere((report) => report.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add new report
  void addReport(ReportModel report) {
    _reports.insert(0, report);
  }

  // Get next ID
  int getNextId() {
    if (_reports.isEmpty) return 1;
    return _reports.map((r) => r.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  // Get reports by status
  List<ReportModel> getReportsByStatus(String status) {
    return _reports.where((report) => report.status == status).toList();
  }

  // Delete report
  void deleteReport(int id) {
    _reports.removeWhere((report) => report.id == id);
  }
}
