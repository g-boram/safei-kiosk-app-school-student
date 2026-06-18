// lib/core/auth/auth_controller.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/auth_storage.dart';
import '../storage/storage_provider.dart';
import 'auth_state.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final authStorage = ref.watch(authStorageProvider);
    final controller = AuthController(authStorage);

    controller.initialize();

    return controller;
  },
);

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._authStorage) : super(AuthState.unknown());

  final AuthStorage _authStorage;

  /// 앱 시작 시 자동로그인 정보 복원
  Future<void> initialize() async {
    try {
      final saved = await _authStorage.readLoginInfo();

      if (!mounted) return;

      if (saved == null) {
        state = AuthState.unauthenticated();
        return;
      }

      state = AuthState.authenticated(
        accessToken: saved.accessToken,
        autoLogin: true,
        userId: saved.userId,
        userNm: saved.userNm,
        loginId: saved.loginId,
        email: saved.email,
        insttId: saved.insttId,
        insttNm: saved.insttNm,
        insttTy: saved.insttTy,
        userSeCd: saved.userSeCd,
      );
    } catch (e) {
      debugPrint('[AuthController] initialize error: $e');

      if (!mounted) return;
      state = AuthState.unauthenticated();
    }
  }

  /// 로그인 성공 처리
  ///
  /// - 앱 실행 중 로그인 상태 갱신
  /// - 토큰은 API 통신에 필요하므로 항상 저장
  /// - autoLogin 값은 앱 재실행 시 복원 여부만 결정
  Future<void> login({
    required String accessToken,
    required String refreshToken,
    required bool autoLogin,
    String? userId,
    String? userNm,
    String? loginId,
    String? email,
    String? insttId,
    String? insttNm,
    String? insttTy,
    String? userSeCd,
  }) async {
    state = AuthState.authenticated(
      accessToken: accessToken,
      autoLogin: autoLogin,
      userId: userId,
      userNm: userNm,
      loginId: loginId,
      email: email,
      insttId: insttId,
      insttNm: insttNm,
      insttTy: insttTy,
      userSeCd: userSeCd,
    );

    await _authStorage.writeLoginInfo(
      autoLogin: autoLogin,
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
      userNm: userNm,
      loginId: loginId,
      email: email,
      insttId: insttId,
      insttNm: insttNm,
      insttTy: insttTy,
      userSeCd: userSeCd,
    );

    debugPrint('===== SAVE LOGIN INFO =====');
    debugPrint('autoLogin: $autoLogin');
    debugPrint('hasAccessToken: ${accessToken.isNotEmpty}');
    debugPrint('hasRefreshToken: ${refreshToken.isNotEmpty}');
    debugPrint('userNm: $userNm');
    debugPrint('email: $email');
    debugPrint('insttNm: $insttNm');
    debugPrint('===========================');
  }

  /// 로그아웃
  Future<void> logout() async {
    await _authStorage.clear();
    state = AuthState.unauthenticated();
  }
}
