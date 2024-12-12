import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

class AuthService extends ChangeNotifier {
  final _box = Hive.box('appBox');
  final _logger = Logger();

  bool get isAdmin {
    final adminEmails = ['admin@example.com']; // Add your admin emails
    final userEmail = _box.get('userEmail');
    return adminEmails.contains(userEmail);
  }

  Future<void> signIn(String email, String password) async {
    try {
      // Implement your authentication logic here
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
}
