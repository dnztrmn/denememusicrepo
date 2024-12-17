import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'dart:io';

class DownloadService {
  final _box = Hive.box('appBox');
  final _logger = Logger();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> saveDownload(String videoId, Map<String, dynamic> videoInfo,
      List<int> audioData) async {
    try {
      final path = await _localPath;
      final file = File('$path/$videoId.mp3');
      await file.writeAsBytes(audioData);

      final downloads = await getDownloads();
      downloads.add({
        'id': videoId,
        'title': videoInfo['title'],
        'artist': videoInfo['artist'],
        'thumbnailUrl': videoInfo['thumbnailUrl'],
        'filePath': file.path,
        'downloadDate': DateTime.now().toIso8601String(),
      });

      await _box.put('downloads', downloads);
      _logger.i('Download saved: ${videoInfo['title']}');
    } catch (e) {
      _logger.e('Save download error: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getDownloads() async {
    try {
      final downloads = _box.get('downloads', defaultValue: []);
      return List<Map<String, dynamic>>.from(downloads);
    } catch (e) {
      _logger.e('Get downloads error: $e');
      return [];
    }
  }

  Future<void> deleteDownload(String videoId) async {
    try {
      final downloads = await getDownloads();
      final download = downloads.firstWhere((d) => d['id'] == videoId);

      final file = File(download['filePath']);
      if (await file.exists()) {
        await file.delete();
      }

      downloads.removeWhere((d) => d['id'] == videoId);
      await _box.put('downloads', downloads);
      _logger.i('Download deleted: ${download['title']}');
    } catch (e) {
      _logger.e('Delete download error: $e');
      rethrow;
    }
  }

  Future<bool> isDownloaded(String videoId) async {
    try {
      final downloads = await getDownloads();
      return downloads.any((d) => d['id'] == videoId);
    } catch (e) {
      _logger.e('Check download error: $e');
      return false;
    }
  }

  Future<String?> getLocalFilePath(String videoId) async {
    try {
      final downloads = await getDownloads();
      final download = downloads.firstWhere((d) => d['id'] == videoId);
      return download['filePath'];
    } catch (e) {
      return null;
    }
  }
}
