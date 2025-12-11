import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ImageCacheService {
  static const String _imagePathKey = 'cached_image_path';
  static const String _videoPathKey = 'cached_video_path';
  static const String _mediaTypeKey = 'cached_media_type';

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
    final mediaType = prefs.getString(_mediaTypeKey);
    
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
}
