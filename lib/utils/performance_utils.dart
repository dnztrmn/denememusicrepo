import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class PerformanceUtils {
  static final PerformanceUtils _instance = PerformanceUtils._internal();

  factory PerformanceUtils() {
    return _instance;
  }

  PerformanceUtils._internal();

  Future<void> clearImageCache() async {
    // Resim önbelleğini temizle
    await DefaultCacheManager().emptyCache();
    // Flutter'ın image cache'ini temizle
    PaintingBinding.instance.imageCache.clear();
  }

  Future<void> optimizeMemory() async {
    // Bellek optimizasyonu
    await clearImageCache();
    // Diğer optimizasyon işlemleri
  }

  void enablePerformanceMode() {
    // Yüksek performans modu ayarları
  }

  void disablePerformanceMode() {
    // Normal mod ayarları
  }

  Future<void> preloadResources() async {
    // Gerekli kaynakları önceden yükle
  }
}
