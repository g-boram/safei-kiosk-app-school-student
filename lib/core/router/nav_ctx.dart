// lib/core/router/nav_ctx.dart

import 'package:flutter/material.dart';

/// 앱 전체에서 사용하는 Navigator Key
///
/// context가 없는 곳에서도
/// 화면 이동, 다이얼로그, 스낵바 등을 사용할 때 필요할 수 있습니다.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// 전역 Navigator의 BuildContext를 가져오는 함수
///
/// 예)
/// final context = requireNavCtx();
///
/// 단, 앱이 아직 완전히 그려지기 전에는 context가 없을 수 있으므로
/// null이면 예외를 발생시킵니다.
BuildContext requireNavCtx() {
  final ctx = rootNavigatorKey.currentContext;

  if (ctx == null) {
    throw Exception('rootNavigatorKey.currentContext is null');
  }

  return ctx;
}
