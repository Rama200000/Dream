import 'dart:io';

class ImageCacheService {
  static final ImageCacheService _instance = ImageCacheService._internal();
  factory ImageCacheService() => _instance;
  ImageCacheService._internal();

  File? _cachedImage;

  void saveImage(File image) {
    _cachedImage = image;
  }

  File? getCachedImage() {
    return _cachedImage;
  }

  void clearCache() {
    _cachedImage = null;
  }

  bool hasImage() {
    return _cachedImage != null;
  }
}
