import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/player/player_screen.dart';
import '../screens/admin/admin_screen.dart';
import '../models/video.dart';

class AppRouter {
  static const String home = '/';
  static const String search = '/search';
  static const String player = '/player';
  static const String admin = '/admin';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case search:
        return MaterialPageRoute(builder: (_) => SearchScreen());

      case player:
        final video = settings.arguments as Video;
        return MaterialPageRoute(
          builder: (_) => PlayerScreen(video: video),
          fullscreenDialog: true,
        );

      case admin:
        return MaterialPageRoute(builder: (_) => AdminScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route not found!'),
            ),
          ),
        );
    }
  }
}
