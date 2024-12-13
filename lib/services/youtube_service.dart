import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:logger/logger.dart';

class YoutubeService extends ChangeNotifier {
  final _yt = YoutubeExplode();
  final _logger = Logger();
  final _box = Hive.box('appBox');
  
  List<Video> _searchResults = [];
  List<Video> get searchResults => _searchResults;
  
  List<Video> _savedVideos = [];
  List<Video> get savedVideos => _savedVideos;

  Future<void> search(String query) async {
    try {
      final results = await _yt.search.search(query);
      _searchResults = results.map((video) => video).toList();
      notifyListeners();
    } catch (e) {
      _logger.e('Search error: $e');
      rethrow;
    }
  }

  Future<String> getAudioUrl(String videoId) async {
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(videoId);
      final audioOnly = manifest.audioOnly;
      final audio = audioOnly.withHighestBitrate();
      return audio.url.toString();
    } catch (e) {
      _logger.e('Get audio URL error: $e');
      rethrow;
    }
  }

  Future<void> addPlaylist(String url) async {
    try {
      final playlist = await _yt.playlists.get(url);
      final playlists = _box.get('playlists', defaultValue: []) as List;
      if (!playlists.contains(playlist.id.toString())) {
        playlists.add(playlist.id.toString());
        await _box.put('playlists', playlists);
        await loadSavedVideos();
        notifyListeners();
      }
    } catch (e) {
      _logger.e('Add playlist error: $e');
      rethrow;
    }
  }

  Future<void> removePlaylist(int index) async {
    try {
      final playlists = _box.get('playlists', defaultValue: []) as List;
      playlists.removeAt(index);
      await _box.put('playlists', playlists);
      await loadSavedVideos();
      notifyListeners();
    } catch (e) {
      _logger.e('Remove playlist error: $e');
      rethrow;
    }
  }

  Future<void> loadSavedVideos() async {
    try {
      final playlists = _box.get('playlists', defaultValue: []) as List;
      _savedVideos = [];
      
      for (final playlistId in playlists) {
        final playlist = await _yt.playlists.get(playlistId);
        await for (final video in _yt.playlists.getVideos(playlist.id)) {
          _savedVideos.add(video);
        }
      }
      
      notifyListeners();
    } catch (e) {
      _logger.e('Load saved videos error: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _yt.close();
    super.dispose();
  }
}