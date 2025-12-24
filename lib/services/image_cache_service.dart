import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ImageCacheService {
  static const String _imagePathKey = 'cached_image_path';
  static const String _videoPathKey = 'cached_video_path';
  static const String _mediaTypeKey = 'cached_media_type';
  static const String _reportTitleKey = 'cached_report_title';
  static const String _reportDescriptionKey = 'cached_report_description';
  static const String _reportCategoryKey = 'cached_report_category';
  static const String _reportLocationKey = 'cached_report_location';

  // Save image from login
  Future<void> cacheImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imagePathKey, imagePath);
    await prefs.setString(_mediaTypeKey, 'image');
  }

  // Save video from login
  Future<void> cacheVideo(String videoPath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_videoPathKey, videoPath);
    await prefs.setString(_mediaTypeKey, 'video');
  }

  // Get cached image
  Future<File?> getCachedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(_imagePathKey);

    if (imagePath != null && File(imagePath).existsSync()) {
      return File(imagePath);
    }
    return null;
  }

  // Alias untuk backward compatibility
  Future<File?> getCachedImageAsync() async {
    return await getCachedImage();
  }

  // Get cached video
  Future<File?> getCachedVideo() async {
    final prefs = await SharedPreferences.getInstance();
    final videoPath = prefs.getString(_videoPathKey);

    if (videoPath != null && File(videoPath).existsSync()) {
      return File(videoPath);
    }
    return null;
  }

  // Get media type
  Future<String?> getMediaType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_mediaTypeKey);
  }

  // Check if has image
  Future<bool> hasImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(_imagePathKey);
    return imagePath != null && File(imagePath).existsSync();
  }

  // Alias untuk backward compatibility
  Future<bool> hasImageAsync() async {
    return await hasImage();
  }

  // Check if has media (image or video)
  Future<bool> hasMedia() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(_imagePathKey);
    final videoPath = prefs.getString(_videoPathKey);

    return (imagePath != null && File(imagePath).existsSync()) ||
        (videoPath != null && File(videoPath).existsSync());
  }

  // NEW: Check if there's any cached media
  Future<bool> hasCachedMedia() async {
    return await hasMedia();
  }

  // NEW: Get all cached media info
  Future<Map<String, dynamic>?> getCachedMediaInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(_imagePathKey);
    final videoPath = prefs.getString(_videoPathKey);

    if (imagePath != null && File(imagePath).existsSync()) {
      return {
        'path': imagePath,
        'type': 'image',
        'file': File(imagePath),
      };
    } else if (videoPath != null && File(videoPath).existsSync()) {
      return {
        'path': videoPath,
        'type': 'video',
        'file': File(videoPath),
      };
    }

    return null;
  }

  // Clear cache
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_imagePathKey);
    await prefs.remove(_videoPathKey);
    await prefs.remove(_mediaTypeKey);
  }

  // Cache report data before login
  Future<void> cacheReportData({
    required String title,
    required String description,
    required String category,
    String? customCategory,
    String? selectedDate,
    String? location,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_reportTitleKey, title);
    await prefs.setString(_reportDescriptionKey, description);
    await prefs.setString(_reportCategoryKey, category);
    if (customCategory != null) {
      await prefs.setString('_cachedCustomCategory', customCategory);
    }
    if (selectedDate != null) {
      await prefs.setString('_cachedSelectedDate', selectedDate);
    }
    if (location != null) {
      await prefs.setString(_reportLocationKey, location);
    }
  }

  // Get cached report data
  Future<Map<String, String>?> getCachedReportData() async {
    final prefs = await SharedPreferences.getInstance();
    final title = prefs.getString(_reportTitleKey);
    final description = prefs.getString(_reportDescriptionKey);
    final category = prefs.getString(_reportCategoryKey);
    final customCategory = prefs.getString('_cachedCustomCategory');
    final selectedDate = prefs.getString('_cachedSelectedDate');
    final location = prefs.getString(_reportLocationKey);

    if (title != null && description != null && category != null) {
      return {
        'title': title,
        'description': description,
        'category': category,
        if (customCategory != null) 'customCategory': customCategory,
        if (selectedDate != null) 'selectedDate': selectedDate,
        if (location != null) 'location': location,
      };
    }
    return null;
  }

  // Clear report data
  Future<void> clearReportData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_reportTitleKey);
    await prefs.remove(_reportDescriptionKey);
    await prefs.remove(_reportCategoryKey);
    await prefs.remove('_cachedCustomCategory');
    await prefs.remove('_cachedSelectedDate');
    await prefs.remove(_reportLocationKey);
  }

  // Check if has cached report data
  Future<bool> hasCachedReportData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_reportTitleKey);
  }
}
