import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/api_key.dart';

class APIManager {
  late final Box<APIKey> _keysBox;

  Future<void> initialize() async {
    _keysBox = await Hive.openBox<APIKey>('api_keys');
  }

  ValueListenable<Box<APIKey>> get keysBoxListenable => _keysBox.listenable();

  Future<void> addKey(APIKey key) async {
    await _keysBox.put(key.id, key);
  }

  Future<void> removeKey(String id) async {
    await _keysBox.delete(id);
  }

  List<APIKey> get allKeys => _keysBox.values.toList();

  APIKey? getKey(String id) => _keysBox.get(id);

  Future<void> updateKey(APIKey key) async {
    await _keysBox.put(key.id, key);
  }

  Future<void> updateKeyStatus(String key, bool status) async {
    final apiKey = getKey(key);
    if (apiKey != null) {
      apiKey.isActive = status;
      await updateKey(apiKey);
    }
  }

  Future<void> removeAPIKey(String key) async {
    await removeKey(key);
  }

  Future<void> addAPIKey(String key, String name) async {
    final newKey = APIKey(id: key, name: name);
    await addKey(newKey);
  }

  APIKey? getCurrentKey() {
    return allKeys.firstWhere((key) => key.isActive,
        orElse: () => allKeys.first);
  }

  Future<void> updateQuotaUsage(String key, int usage) async {
    final apiKey = getKey(key);
    if (apiKey != null) {
      apiKey.quotaUsed += usage;
      await updateKey(apiKey);
    }
  }

  void rotateKey() {
    final currentKey = getCurrentKey();
    if (currentKey != null) {
      final keys = allKeys;
      final currentIndex = keys.indexOf(currentKey);
      final nextIndex = (currentIndex + 1) % keys.length;
      keys[currentIndex].isActive = false;
      keys[nextIndex].isActive = true;
      updateKey(keys[currentIndex]);
      updateKey(keys[nextIndex]);
    }
  }
}
