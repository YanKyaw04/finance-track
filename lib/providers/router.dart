import 'package:fintrack/router.dart';
import 'package:fintrack/screens/about_us/index.dart';
import 'package:fintrack/screens/category/index.dart';
import 'package:fintrack/screens/dashboard/index.dart';
import 'package:fintrack/screens/login/index.dart';
import 'package:fintrack/screens/splash/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider.autoDispose((ref) {
  return GoRouter(
    routes: [
      GoRoute(path: AppRoute.splash.path, builder: (context, state) => const SplashScreen()),
      GoRoute(path: AppRoute.login.path, builder: (context, state) => const LoginScreen()),
      GoRoute(path: AppRoute.dashboard.path, builder: (context, state) => const DashboardScreen()),
      GoRoute(path: AppRoute.category.path, builder: (context, state) => const CategoryScreen()),
      GoRoute(path: AppRoute.aboutUs.path, builder: (context, state) => const AboutUsScreen()),
    ],
  );
});
