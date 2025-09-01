import 'package:get/get.dart';
import 'package:typing_speed/screens/dashboard_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/typing_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String dashboard = '/dashboard';
  static const String typing = '/typing';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: dashboard, page: () => const DashboardScreen()),
    GetPage(name: typing, page: () => TypingScreen()),
  ];
}
