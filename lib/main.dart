import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/auth_service.dart';
import 'services/api_manager.dart';
import 'models/api_key.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'config/theme_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(APIKeyAdapter());

  final apiManager = APIManager();
  await apiManager.initialize();

  await AuthService().initialize();

  runApp(MyApp(apiManager: apiManager));
}

class MyApp extends StatelessWidget {
  final APIManager apiManager;

  const MyApp({Key? key, required this.apiManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider.value(value: apiManager),
      ],
      child: MaterialApp(
        title: 'MobApp',
        theme: ThemeConfig.lightTheme,
        home: Consumer<AuthService>(
          builder: (context, auth, _) {
            return auth.user != null
                ? const HomeScreen()
                : const LoginScreen(); // const eklendi
          },
        ),
      ),
    );
  }
}
