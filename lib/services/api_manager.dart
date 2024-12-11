import 'package:hive/hive.dart';
import '../models/api_key.dart';
import '../config/api_config.dart';

class APIManager {
  static final APIManager _instance = APIManager._internal();
  late Box<APIKey> _apiBox;
  int _currentKeyIndex = 0;

  factory APIManager() {
    return _instance;
  }

  APIManager._internal();

  Future<void> initialize() async {
    _apiBox = await Hive.openBox<APIKey>(APIConfig.API_BOX_NAME);
    _resetDailyQuotas();
  }

  void _resetDailyQuotas() {
    for (var apiKey in _apiBox.values) {
      apiKey.resetQuota();
      _apiBox.put(apiKey.key, apiKey);
    }
  }

  Future<bool> addAPIKey(String key, String name) async {
    if (_apiBox.length >= APIConfig.MAX_API_KEYS) {
      throw Exception('Maximum API key limit reached');
    }

    if (_apiBox.containsKey(key)) {
      throw Exception('API key already exists');
    }

    final newKey = APIKey(
      key: key,
      name: name,
    );

    await _apiBox.put(key, newKey);
    return true;
  }

  Future<void> removeAPIKey(String key) async {
    await _apiBox.delete(key);
  }

  APIKey? getCurrentKey() {
    if (_apiBox.isEmpty) return null;

    var keys = _apiBox.values.where((key) => 
      key.isActive && !key.isQuotaExceeded
    ).toList();

    if (keys.isEmpty) return null;

    _currentKeyIndex = _currentKeyIndex % keys.length;
    return keys[_currentKeyIndex];
  }

  void rotateKey() {
    _currentKeyIndex++;
  }

  Future<void> updateQuotaUsage(String key, int quota) async {
    var apiKey = _apiBox.get(key);
    if (apiKey != null) {
      apiKey.quotaUsed += quota;
      apiKey.lastUsed = DateTime.now();
      await _apiBox.put(key, apiKey);
    }
  }

  List<APIKey> getAllKeys() {
    return _apiBox.values.toList();
  }

  Future<void> updateKeyStatus(String key, bool isActive) async {
    var apiKey = _apiBox.get(key);
    if (apiKey != null) {
      apiKey.isActive = isActive;
      await _apiBox.put(key, apiKey);
    }
  }

  bool hasAvailableKeys() {
    return _apiBox.values.any((key) => 
      key.isActive && !key.isQuotaExceeded
    );
  }
}