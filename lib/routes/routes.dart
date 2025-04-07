import 'package:get/get.dart';

import '../screens/home/home_screen.dart';
import '../screens/splash_screen/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';

  static List<GetPage> routes() {
    return [
      GetPage(name: splash, page: () => const SplashScreen()),
      GetPage(name: home, page: () => HomeScreen()),
    ];
  }
}