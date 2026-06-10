import 'package:flutter/material.dart';
import '../pages/web_login_page.dart';
import '../pages/web_main_scaffold.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String webLogin = '/web_login';
  static const String webHome = '/web_home';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const WebLoginPage(), // Use web version by default
    home: (context) => const WebMainScaffold(),
    webLogin: (context) => const WebLoginPage(),
    webHome: (context) => const WebMainScaffold(),
  };
}
