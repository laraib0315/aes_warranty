import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/database_service.dart';
import 'providers/auth_provider.dart';
import 'providers/data_provider.dart';
import 'providers/settings_provider.dart';
// Removed unused import: 'pages/login_page.dart' (kyunke LoginPage AppRoutes mein use ho raha hai, yahan nahi)
import 'utils/themes.dart';
import 'utils/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await DatabaseService.instance.init();
    runApp(const MyApp());
  } catch (e, _) {
    // stackTrace unused, isliye underscore (_) use kiya
    debugPrint('Init error: $e');
    runApp(ErrorApp(error: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'AES Warranty',
            theme:
                settings.themeMode == ThemeMode.light ? lightTheme : darkTheme,
            darkTheme: darkTheme,
            themeMode: settings.themeMode,
            initialRoute: '/',
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('App Initialization Failed'),
              const SizedBox(height: 8),
              Text(error, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
