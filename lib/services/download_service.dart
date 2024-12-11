import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/video.dart';

class DownloadService {
  static final DownloadService _instance = DownloadService._internal();

  factory DownloadService() {
    return _instance;
  }

  DownloadService._internal();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    final downloadsDir = Directory('${directory.path}/downloads');
    if (!await downloadsDir.exists()) {
      await downloadsDir.create();
    }
    return downloadsDir.path;
  }

  Future<bool> checkPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  Future<File?> downloadVideo(Video video) async {
    try {
      if (!await checkPermission()) {
        throw Exception('Storage permission denied');
      }

      final path = await _localPath;
      final file = File('$path/${video.id}.mp3');

      // Burada YouTube'dan video/ses indirme işlemi yapılacak
      // youtube_explode_dart veya benzeri bir paket kullanılabilir

      return file;
    } catch (e) {
      print('Download error: $e');
      return null;
    }
  }

  Future<List<Video>> getDownloadedVideos() async {
    try {
      final path = await _localPath;
      final dir = Directory(path);
      final List<Video> videos = [];

      await for (var entity in dir.list()) {
        if (entity is File && entity.path.endsWith('.mp3')) {
          // İndirilen dosyaların meta verilerini oku
          // ve Video nesnesine dönüştür
        }
      }

      return videos;
    } catch (e) {
      print('Error getting downloaded videos: $e');
      return [];
    }
  }
}
