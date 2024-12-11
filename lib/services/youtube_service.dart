import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/video.dart';
import '../config/api_config.dart';
import 'api_manager.dart';

class YouTubeService {
  static final YouTubeService _instance = YouTubeService._internal();
  final APIManager _apiManager = APIManager();
  final String _baseUrl = 'https://www.googleapis.com/youtube/v3';

  factory YouTubeService() {
    return _instance;
  }

  YouTubeService._internal();

  Future<List<Video>> searchVideos(String query) async {
    try {
      final apiKey = _apiManager.getCurrentKey();
      if (apiKey == null) throw Exception('No API key available');

      final response = await http.get(
        Uri.parse(
            '$_baseUrl/search?part=snippet&q=$query&type=video&maxResults=20&key=${apiKey.key}'),
      );

      if (response.statusCode == 200) {
        await _apiManager.updateQuotaUsage(
            apiKey.key, APIConfig.QUOTA_COST_SEARCH);
        final data = json.decode(response.body);
        return _parseVideoResults(data);
      } else if (response.statusCode == 403) {
        _apiManager.rotateKey();
        return searchVideos(query); // Retry with next API key
      } else {
        throw Exception('Failed to search videos');
      }
    } catch (e) {
      print('Error searching videos: $e');
      throw e;
    }
  }

  Future<List<Video>> getTrendingMusic() async {
    try {
      final apiKey = _apiManager.getCurrentKey();
      if (apiKey == null) throw Exception('No API key available');

      final response = await http.get(
        Uri.parse(
            '$_baseUrl/videos?part=snippet&chart=mostPopular&videoCategoryId=10&regionCode=TR&maxResults=20&key=${apiKey.key}'),
      );

      if (response.statusCode == 200) {
        await _apiManager.updateQuotaUsage(
            apiKey.key, APIConfig.QUOTA_COST_VIDEO);
        final data = json.decode(response.body);
        return _parseVideoResults(data);
      } else if (response.statusCode == 403) {
        _apiManager.rotateKey();
        return getTrendingMusic();
      } else {
        throw Exception('Failed to get trending music');
      }
    } catch (e) {
      print('Error getting trending music: $e');
      throw e;
    }
  }

  List<Video> _parseVideoResults(Map<String, dynamic> data) {
    List<Video> videos = [];
    for (var item in data['items']) {
      videos.add(Video.fromJson(item));
    }
    return videos;
  }
}
