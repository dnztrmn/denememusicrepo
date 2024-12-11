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

  Future<void> clearAll() async {
    await _keysBox.clear();
  }
}
