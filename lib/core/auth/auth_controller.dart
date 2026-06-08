import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_state.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final controller = AuthController();

    controller.initialize();

    return controller;
  },
);

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState.unknown());

  static const _storage = FlutterSecureStorage();

  static const _tokenKey = 'ACCESS_TOKEN';
  static const _autoLoginKey = 'AUTO_LOGIN';

  /// 앱 시작 시 호출
  ///
  /// 저장된 자동로그인 여부 확인
  /// 저장된 토큰 확인
  Future<void> initialize() async {
    try {
      final autoLogin = await _storage.read(key: _autoLoginKey) == 'Y';

      if (!mounted) return;

      if (!autoLogin) {
        state = AuthState.unauthenticated();
        return;
      }

      final token = await _storage.read(key: _tokenKey);

      if (!mounted) return;

      if (token == null || token.isEmpty) {
        state = AuthState.unauthenticated();
        return;
      }

      state = AuthState.authenticated(accessToken: token, autoLogin: true);
    } catch (_) {
      if (!mounted) return;

      state = AuthState.unauthenticated();
    }
  }

  /// 로그인 성공
  // lib/core/auth/auth_controller.dart

  Future<void> login({
    required String accessToken,
    required bool autoLogin,

    // 프로필 화면에서 사용할 사용자 정보
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

    if (autoLogin) {
      await _storage.write(key: _tokenKey, value: accessToken);
      await _storage.write(key: _autoLoginKey, value: 'Y');
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);

    await _storage.delete(key: _autoLoginKey);

    state = AuthState.unauthenticated();
  }
}
