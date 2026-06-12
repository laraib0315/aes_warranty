import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/main_scaffold.dart';
import '../pages/web_login_page.dart';
import '../pages/web_main_scaffold.dart';

class AppRoutes {
  // Route ke names (String constants)
  static const String login = '/';
  static const String home = '/home';
  static const String webLogin = '/web_login';
  static const String webHome = '/web_home';

  // Mobile aur Web dono ke routes ka map
  static Map<String, WidgetBuilder> routes = {
    // Mobile Version Routes
    login: (context) => const LoginPage(), // mobile login
    home: (context) => const MainScaffold(), // mobile home

    // Web Version Routes
    webLogin: (context) => const WebLoginPage(), // web login
    webHome: (context) => const WebMainScaffold(), // web home
  };
}
