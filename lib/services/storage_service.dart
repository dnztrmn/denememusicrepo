import 'package:hive/hive.dart';
import '../models/video.dart';

class StorageService {
  static const String _offlineVideosBox = 'offline_videos';
  static const String _playlistsBox = 'playlists';

  Future<Box<Video>> _getOfflineVideosBox() async {
    return await Hive.openBox<Video>(_offlineVideosBox);
  }

  Future<Box> _getPlaylistsBox() async {
    return await Hive.openBox(_playlistsBox);
  }

  Future<void> saveOfflineVideo(Video video) async {
    final box = await _getOfflineVideosBox();
    await box.put(video.id, video);
  }

  Future<List<Video>> getOfflineVideos() async {
    final box = await _getOfflineVideosBox();
    return box.values.toList();
  }

  Future<bool> isVideoDownloaded(String videoId) async {
    final box = await _getOfflineVideosBox();
    return box.containsKey(videoId);
  }

  Future<void> deleteOfflineVideo(String videoId) async {
    final box = await _getOfflineVideosBox();
    await box.delete(videoId);
  }

  Future<void> savePlaylist(String name, List<String> videoIds) async {
    final box = await _getPlaylistsBox();
    await box.put(name, videoIds);
  }

  Future<List<String>> getPlaylist(String name) async {
    final box = await _getPlaylistsBox();
    return List<String>.from(box.get(name, defaultValue: []));
  }
}
