// lib/core/router/app_routes.dart

import 'package:go_router/go_router.dart';
import 'package:safei_kiosk_app_school_student/features/setting/view/setting_screen.dart';

import '../../features/emotion/view/emotion_home_screen.dart';
import '../../features/emotion/view/emotion_level_screen.dart';
import '../../features/emotion/view/emotion_select_screen.dart';
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
  // 프로필
  static const profile = 'profile';
  // 설정
  static const setting = 'setting';
  // 감정체크
  static const emotionHome = 'emotionHome';
  static const emotionSelect = 'emotionSelect';
  static const emotionLevel = 'emotionLevel';
}

/// ⭐️ 실제 경로 문자열
///
/// '/' 또는 '/login' 같은 문자열을 코드 여기저기에 직접 쓰지 않기 위해 분리합니다.
sealed class AppPath {
  static const home = '/';
  static const login = '/login';
  // 프로필
  static const profile = '/profile';
  // 설정
  static const setting = '/setting';
  // 감정체크
  static const emotionHome = '/emotion';
  static const emotionSelect = '/emotion/select';
  static const emotionLevel = '/emotion/level/:emotionId';
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
      // 프로필
      GoRoute(
        path: AppPath.profile,
        name: AppRoute.profile,
        builder: (_, __) => const ProfileScreen(),
      ),
      // 설정
      GoRoute(
        path: AppPath.setting,
        name: AppRoute.setting,
        builder: (_, __) => const SettingScreen(),
      ),

      // 감정체크
      GoRoute(
        path: AppPath.emotionHome,
        name: AppRoute.emotionHome,
        builder: (_, __) => const EmotionHomeScreen(),
      ),
      GoRoute(
        path: AppPath.emotionSelect,
        name: AppRoute.emotionSelect,
        builder: (_, __) => const EmotionSelectScreen(),
      ),
      GoRoute(
        path: AppPath.emotionLevel,
        name: AppRoute.emotionLevel,
        builder: (_, state) {
          final emotionId = state.pathParameters['emotionId'] ?? '';
          return EmotionLevelScreen(emotionId: emotionId);
        },
      ),
    ],
  ),
];
