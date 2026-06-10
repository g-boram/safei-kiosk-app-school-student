// lib/core/router/app_router.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_controller.dart';
import '../auth/auth_state.dart';
import '../dialog/global_dialog_controller.dart';
import 'app_routes.dart';
import 'nav_ctx.dart';

/// GoRouter를 새로고침하기 위한 Provider
///
/// authControllerProvider의 상태가 바뀌면
/// notifier.value++가 실행되고,
/// GoRouter의 redirect가 다시 실행됩니다.
///
/// 즉,
/// - 로그인 성공
/// - 로그아웃
/// - 자동로그인 상태 확인 완료
///
/// 이런 상황에서 화면 이동 제어가 다시 동작합니다.
final goRouterRefreshProvider = Provider<ValueNotifier<int>>((ref) {
  final notifier = ValueNotifier<int>(0);

  ref.listen(authControllerProvider, (_, __) {
    notifier.value++;
  });

  return notifier;
});

/// 앱 전체 라우터 Provider
///
/// MaterialApp.router에서 이 Provider를 사용합니다.
final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(goRouterRefreshProvider);

  return GoRouter(
    /// 실제 화면 목록
    routes: appRoutes,

    /// 앱 첫 진입 경로
    ///
    /// 로그인 여부는 redirect에서 판단하므로
    /// 기본값은 홈('/')으로 두어도 됩니다.
    initialLocation: AppPath.home,

    /// 전역 Navigator Key
    navigatorKey: rootNavigatorKey,

    /// debug 모드에서 라우팅 로그 출력
    debugLogDiagnostics: kDebugMode,

    /// auth 상태가 변경되면 redirect 재실행
    refreshListenable: refresh,

    /// 로그인 상태에 따른 접근 제어
    ///
    /// 공개 페이지
    /// - /
    /// - /login
    ///
    /// 보호 페이지
    /// - /profile
    /// - /mypage
    /// - /reservation
    /// - /setting
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);

      final isLoggedIn = authState.status == AuthStatus.authenticated;
      final loc = state.matchedLocation;

      debugPrint('====== Redirect ======');
      debugPrint('loc: $loc');
      debugPrint('authStatus: ${authState.status}');
      debugPrint('isLoggedIn: $isLoggedIn');

      if (authState.status == AuthStatus.unknown) {
        debugPrint('자동 로그인 확인 중이라 이동 허용');
        return null;
      }

      final protectedPaths = <String>{AppPath.profile};

      final isProtectedPage = protectedPaths.contains(loc);

      debugPrint('isProtectedPage: $isProtectedPage');

      if (!isLoggedIn && isProtectedPage) {
        debugPrint('보호 페이지 접근 차단');

        Future.microtask(() {
          ref.read(globalDialogControllerProvider.notifier).showLoginRequired();
        });

        return AppPath.home;
      }

      return null;
    },
  );
});
