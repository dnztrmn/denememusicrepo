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

  Future<void> saveDownload(
      Map<String, dynamic> videoInfo, String audioData) async {
    try {
      final path = await _localPath;
      final file = File('$path/${videoInfo['id']}.mp3');
      await file.writeAsBytes(audioData.codeUnits);

      final downloads = await getDownloads();
      downloads.add({
        ...videoInfo,
        'filePath': file.path,
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

  Future<void> deleteDownload(String id) async {
    try {
      final downloads = await getDownloads();
      final download = downloads.firstWhere((d) => d['id'] == id);

      final file = File(download['filePath']);
      if (await file.exists()) {
        await file.delete();
      }

      downloads.removeWhere((d) => d['id'] == id);
      await _box.put('downloads', downloads);
      _logger.i('Download deleted: ${download['title']}');
    } catch (e) {
      _logger.e('Delete download error: $e');
      rethrow;
    }
  }
}
