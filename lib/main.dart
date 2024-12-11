import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'config/theme_config.dart';
import 'navigation/app_router.dart';
import 'services/auth_service.dart';
import 'services/api_manager.dart';
import 'models/api_key.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive başlatma ve yapılandırma
  await Hive.initFlutter();
  Hive.registerAdapter(APIKeyAdapter());
  await Hive.openBox('user_preferences');

  // Servisleri başlat
  await APIManager().initialize();
  await AuthService().initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider<APIManager>(create: (_) => APIManager()),
      ],
      child: MaterialApp(
        title: 'YouTube Music Clone',
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRouter.home,
        onGenerateRoute: AppRouter.generateRoute,
        home: MainScreen(), // Ana ekran widget'ı
        builder: (context, child) {
          // Hata yakalama ve genel uygulama yapılandırması
          return ScrollConfiguration(
            behavior: ScrollBehavior().copyWith(
              physics: BouncingScrollPhysics(),
            ),
            child: child!,
          );
        },
        localizationsDelegates: [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('tr', 'TR'),
        ],
      ),
    );
  }
}

// Uygulama genelinde kullanılacak global key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Hata yakalama
void handleError(Object error, StackTrace stack) {
  debugPrint('Error: $error');
  debugPrint('Stack trace: $stack');
  // Hata raporlama servisi buraya eklenebilir
}
