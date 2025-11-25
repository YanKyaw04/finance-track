enum AppRoute { splash, login, register, home, dashboard, transactions, budget, settings, reports, category, aboutUs }

extension AppRoutePath on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.splash:
        return '/';
      case AppRoute.login:
        return '/login';
      case AppRoute.register:
        return '/register';
      case AppRoute.home:
        return '/home';
      case AppRoute.dashboard:
        return '/dashboard';
      case AppRoute.transactions:
        return '/transactions';
      case AppRoute.budget:
        return '/budget';
      case AppRoute.reports:
        return '/report';
      case AppRoute.settings:
        return '/settings';
      case AppRoute.category:
        return '/category';
      case AppRoute.aboutUs:
        return '/about-us';
    }
  }
}
