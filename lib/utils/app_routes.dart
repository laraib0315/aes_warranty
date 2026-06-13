import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/main_scaffold.dart'; // mobile home
import '../pages/web_main_scaffold.dart'; // web home

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String webHome = '/web_home';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    home: (context) => const MainScaffold(), // mobile
    webHome: (context) => const WebMainScaffold(), // web
  };
}
