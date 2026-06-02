// lib/core/router/app_router.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_controller.dart';
import '../auth/auth_state.dart';
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

    /// 로그인 권한에 따른 화면 접근 제어
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);

      /// 현재 로그인 여부
      final isLoggedIn = authState.status == AuthStatus.authenticated;

      /// 현재 이동하려는 경로
      final loc = state.matchedLocation;

      /// 로그인 페이지인지 확인
      final isLoginPage = loc == AppPath.login;

      /// 앱 시작 직후 자동로그인 여부 확인 중이면
      /// 아직 어디로도 강제 이동시키지 않습니다.
      if (authState.status == AuthStatus.unknown) {
        return null;
      }

      /// 로그인하지 않은 사용자는 로그인 화면만 접근 가능
      if (!isLoggedIn && !isLoginPage) {
        return AppPath.login;
      }

      /// 이미 로그인한 사용자가 로그인 화면으로 가려고 하면
      /// 홈으로 이동시킵니다.
      if (isLoggedIn && isLoginPage) {
        return AppPath.home;
      }

      /// 그 외에는 이동 허용
      return null;
    },
  );
});
