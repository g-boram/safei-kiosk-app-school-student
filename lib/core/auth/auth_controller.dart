import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_state.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final controller = AuthController();

    // 앱 시작 시 저장된 로그인 정보 확인
    controller.initialize();

    return controller;
  },
);

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState.unknown());

  static const _storage = FlutterSecureStorage();

  // 토큰 관련
  static const _tokenKey = 'ACCESS_TOKEN';
  static const _autoLoginKey = 'AUTO_LOGIN';

  // 사용자 정보
  static const _userIdKey = 'USER_ID';
  static const _userNmKey = 'USER_NM';
  static const _loginIdKey = 'LOGIN_ID';
  static const _emailKey = 'EMAIL';
  static const _insttIdKey = 'INSTT_ID';
  static const _insttNmKey = 'INSTT_NM';
  static const _insttTyKey = 'INSTT_TY';
  static const _userSeCdKey = 'USER_SE_CD';

  /// 앱 시작 시 호출
  ///
  /// 자동로그인 체크 여부 확인
  /// 저장된 토큰 확인
  /// 저장된 사용자 정보 복원
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

      // 저장된 사용자 정보 조회
      final userId = await _storage.read(key: _userIdKey);
      final userNm = await _storage.read(key: _userNmKey);
      final loginId = await _storage.read(key: _loginIdKey);
      final email = await _storage.read(key: _emailKey);
      final insttId = await _storage.read(key: _insttIdKey);
      final insttNm = await _storage.read(key: _insttNmKey);
      final insttTy = await _storage.read(key: _insttTyKey);
      final userSeCd = await _storage.read(key: _userSeCdKey);

      debugPrint('===== AUTO LOGIN =====');
      debugPrint('userNm: $userNm');
      debugPrint('email: $email');
      debugPrint('insttNm: $insttNm');
      debugPrint('=======================');

      if (!mounted) return;

      // 로그인 상태 + 사용자 정보 복원
      state = AuthState.authenticated(
        accessToken: token,
        autoLogin: true,
        userId: userId,
        userNm: userNm,
        loginId: loginId,
        email: email,
        insttId: insttId,
        insttNm: insttNm,
        insttTy: insttTy,
        userSeCd: userSeCd,
      );
    } catch (_) {
      if (!mounted) return;

      state = AuthState.unauthenticated();
    }
  }

  /// 로그인 성공
  ///
  /// 현재 로그인 상태를 AuthState에 저장
  /// 자동로그인 체크 시 SecureStorage에도 저장
  Future<void> login({
    required String accessToken,
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
    // 앱 실행 중 사용할 로그인 상태
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

    // 자동로그인 체크한 경우
    if (autoLogin) {
      await _storage.write(key: _tokenKey, value: accessToken);
      await _storage.write(key: _autoLoginKey, value: 'Y');

      await _storage.write(key: _userIdKey, value: userId);
      await _storage.write(key: _userNmKey, value: userNm);
      await _storage.write(key: _loginIdKey, value: loginId);
      await _storage.write(key: _emailKey, value: email);
      await _storage.write(key: _insttIdKey, value: insttId);
      await _storage.write(key: _insttNmKey, value: insttNm);
      await _storage.write(key: _insttTyKey, value: insttTy);
      await _storage.write(key: _userSeCdKey, value: userSeCd);

      debugPrint('===== SAVE USER INFO =====');
      debugPrint('userNm: $userNm');
      debugPrint('email: $email');
      debugPrint('insttNm: $insttNm');
      debugPrint('===========================');
    } else {
      // 자동로그인 체크 안했으면 저장 제거
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _autoLoginKey);

      await _storage.delete(key: _userIdKey);
      await _storage.delete(key: _userNmKey);
      await _storage.delete(key: _loginIdKey);
      await _storage.delete(key: _emailKey);
      await _storage.delete(key: _insttIdKey);
      await _storage.delete(key: _insttNmKey);
      await _storage.delete(key: _insttTyKey);
      await _storage.delete(key: _userSeCdKey);
    }
  }

  /// 로그아웃
  ///
  /// 저장된 자동로그인 정보 삭제
  /// 현재 로그인 상태 초기화
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _autoLoginKey);

    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _userNmKey);
    await _storage.delete(key: _loginIdKey);
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _insttIdKey);
    await _storage.delete(key: _insttNmKey);
    await _storage.delete(key: _insttTyKey);
    await _storage.delete(key: _userSeCdKey);

    state = AuthState.unauthenticated();
  }
}
