import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Base URL untuk Laravel backend
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api'; // Android Emulator
    } else if (Platform.isIOS) {
      return 'http://localhost:8000/api'; // iOS Simulator
    } else {
      return 'http://192.168.1.100:8000/api'; // Real Device
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_token', token);
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('api_token');
  }

  // Auth - Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success']) {
      await _saveToken(data['data']['token']);
      return data;
    } else {
      throw Exception(data['message'] ?? 'Login gagal');
    }
  }

  // Auth - Register
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success']) {
        await _saveToken(data['data']['token']);
        return data;
      } else {
        throw Exception(data['message'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Auth - Logout
  Future<void> logout() async {
    try {
      final token = await _getToken();
      
      await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      await _removeToken();
    } catch (e) {
      await _removeToken(); // Remove token even if request fails
    }
  }

  // Reports - Get All
  Future<List<dynamic>> getReports({String? status, String? category, String? search}) async {
    try {
      final token = await _getToken();
      
      var url = '$baseUrl/reports?';
      if (status != null) url += 'status=$status&';
      if (category != null) url += 'category=$category&';
      if (search != null) url += 'search=$search&';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return data['data']['data']; // Paginated data
      } else {
        throw Exception('Gagal mengambil data laporan');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Reports - Create
  Future<Map<String, dynamic>> createReport({
    required String title,
    required String description,
    required String category,
    String? reporterName,
    String? reporterEmail,
    List<File>? images,
  }) async {
    try {
      final token = await _getToken();
      
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/reports'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['category'] = category;
      if (reporterName != null) request.fields['reporter_name'] = reporterName;
      if (reporterEmail != null) request.fields['reporter_email'] = reporterEmail;

      // Add images
      if (images != null) {
        for (var image in images) {
          request.files.add(await http.MultipartFile.fromPath(
            'images[]',
            image.path,
          ));
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success']) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Gagal membuat laporan');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Reports - Get Statistics
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final token = await _getToken();
      
      final response = await http.get(
        Uri.parse('$baseUrl/reports/statistics'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return data['data'];
      } else {
        throw Exception('Gagal mengambil statistik');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Notifications - Get All
  Future<List<dynamic>> getNotifications() async {
    try {
      final token = await _getToken();
      
      final response = await http.get(
        Uri.parse('$baseUrl/notifications'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return data['data']['data'];
      } else {
        throw Exception('Gagal mengambil notifikasi');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
