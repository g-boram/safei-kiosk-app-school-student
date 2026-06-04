// lib/core/router/app_routes.dart

import 'package:go_router/go_router.dart';

import '../../features/home/view/home_screen.dart';
import '../../features/login/view/login_screen.dart';
import '../../features/profile/view/profile_screen.dart';
import '../layout/app_shell.dart';

/// ⭐️ 라우트 이름
///
/// context.goNamed(AppRoute.home)
sealed class AppRoute {
  static const home = 'home';
  static const login = 'login';
  static const profile = 'profile';
}

/// ⭐️ 실제 경로 문자열
///
/// '/' 또는 '/login' 같은 문자열을 코드 여기저기에 직접 쓰지 않기 위해 분리합니다.
sealed class AppPath {
  static const home = '/';
  static const login = '/login';
  static const profile = '/profile';
}

/// ⭐️ 앱에서 사용하는 화면 목록
///
final List<RouteBase> appRoutes = [
  ShellRoute(
    builder: (context, state, child) {
      return AppShell(child: child);
    },
    routes: [
      GoRoute(
        path: AppPath.home,
        name: AppRoute.home,
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: AppPath.login,
        name: AppRoute.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppPath.profile,
        name: AppRoute.profile,
        builder: (_, __) => const ProfileScreen(),
      ),
    ],
  ),
];
