import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

class AuthService extends ChangeNotifier {
  final _box = Hive.box('appBox');
  final _logger = Logger();

  bool get isAdmin {
    final adminEmails = [
      'admin@example.com'
    ]; // Admin e-postalarını buraya ekleyin
    final userEmail = _box.get('userEmail');
    return adminEmails.contains(userEmail);
  }

  bool get isLoggedIn {
    return _box.get('userEmail') != null;
  }

  String? get userEmail {
    return _box.get('userEmail');
  }

  Future<void> signIn(String email, String password) async {
    try {
      // Gerçek uygulamada burada API çağrısı yapılacak
      await _box.put('userEmail', email);
      _logger.i('User signed in: $email');
      notifyListeners();
    } catch (e) {
      _logger.e('Sign in error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _box.delete('userEmail');
      _logger.i('User signed out');
      notifyListeners();
    } catch (e) {
      _logger.e('Sign out error: $e');
      rethrow;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> userData) async {
    try {
      await _box.put('userData', userData);
      _logger.i('Profile updated');
      notifyListeners();
    } catch (e) {
      _logger.e('Update profile error: $e');
      rethrow;
    }
  }
}
