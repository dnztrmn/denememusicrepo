import 'package:google_sign_in/google_sign_in.dart';
import '../config/api_config.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  GoogleSignInAccount? _currentUser;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  GoogleSignInAccount? get currentUser => _currentUser;

  bool get isAdmin =>
      _currentUser != null &&
      APIConfig.ADMIN_EMAILS.contains(_currentUser!.email);

  Future<bool> signIn() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        _currentUser = user;
        return true;
      }
      return false;
    } catch (e) {
      print('Error signing in: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
