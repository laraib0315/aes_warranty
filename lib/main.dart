import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/database_service.dart';
import 'providers/auth_provider.dart';
import 'providers/data_provider.dart';
import 'providers/settings_provider.dart';
import 'utils/themes.dart';
import 'utils/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.init();
  runApp(const MyApp());
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
