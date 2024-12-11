import 'package:shared_preferences.dart';
import '../models/video.dart';
import 'storage_service.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  final StorageService _storageService = StorageService();
  final String _lastSyncKey = 'last_sync_time';

  factory SyncService() {
    return _instance;
  }

  SyncService._internal();

  Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSync = prefs.getString(_lastSyncKey);
    return lastSync != null ? DateTime.parse(lastSync) : null;
  }

  Future<void> setLastSyncTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncKey, time.toIso8601String());
  }

  Future<void> syncOfflineData() async {
    try {
      // İndirilen videoları kontrol et
      final offlineVideos = await _storageService.getOfflineVideos();

      // Dosya bütünlüğünü kontrol et
      for (var video in offlineVideos) {
        final exists = await _checkFileExists(video);
        if (!exists) {
          // Bozuk veya eksik dosyaları temizle
          await _storageService.deleteOfflineVideo(video.id);
        }
      }

      // Son senkronizasyon zamanını güncelle
      await setLastSyncTime(DateTime.now());
    } catch (e) {
      print('Sync error: $e');
      // Hata durumunda kullanıcıya bildir
    }
  }

  Future<bool> _checkFileExists(Video video) async {
    // Dosya varlığını kontrol et
    return true; // Implement actual file check
  }

  Future<void> cleanupOldData() async {
    // Eski verileri temizle
    final lastSync = await getLastSyncTime();
    if (lastSync != null) {
      final monthAgo = DateTime.now().subtract(Duration(days: 30));
      if (lastSync.isBefore(monthAgo)) {
        // Bir aydan eski verileri temizle
      }
    }
  }
}
