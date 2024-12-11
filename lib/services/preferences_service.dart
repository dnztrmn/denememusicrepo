import 'package:hive/hive.dart';

class PreferencesService {
  static const String _prefsBox = 'user_preferences';

  static Future<Box> _openBox() async {
    return await Hive.openBox(_prefsBox);
  }

  static Future<void> saveLastPlayedVideo(String videoId) async {
    final box = await _openBox();
    await box.put('last_played', videoId);
  }

  static Future<String?> getLastPlayedVideo() async {
    final box = await _openBox();
    return box.get('last_played');
  }

  static Future<void> saveSearchHistory(List<String> searches) async {
    final box = await _openBox();
    await box.put('search_history', searches);
  }

  static Future<List<String>> getSearchHistory() async {
    final box = await _openBox();
    final history = box.get('search_history', defaultValue: <String>[]);
    return List<String>.from(history);
  }

  static Future<void> addToSearchHistory(String query) async {
    final history = await getSearchHistory();
    if (!history.contains(query)) {
      history.insert(0, query);
      if (history.length > 10) {
        history.removeLast();
      }
      await saveSearchHistory(history);
    }
  }

  static Future<void> clearSearchHistory() async {
    final box = await _openBox();
    await box.delete('search_history');
  }
}
