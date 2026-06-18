// lib/core/storage/auth_storage.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 인증/로그인 관련 정보를
/// SecureStorage에 저장하고 조회하는 클래스
///
/// AuthController, Dio Interceptor가
/// 동일한 저장소를 사용하도록 관리한다.
class AuthStorage {
  AuthStorage(this._storage);

  final FlutterSecureStorage _storage;

  // =========================
  // Storage Key
  // =========================

  /// Access Token
  static const accessTokenKey = 'ACCESS_TOKEN';

  /// Refresh Token
  static const refreshTokenKey = 'REFRESH_TOKEN';

  /// 자동 로그인 여부 (Y / N)
  static const autoLoginKey = 'AUTO_LOGIN';

  /// 사용자 정보
  static const userIdKey = 'USER_ID';
  static const userNmKey = 'USER_NM';
  static const loginIdKey = 'LOGIN_ID';
  static const emailKey = 'EMAIL';
  static const insttIdKey = 'INSTT_ID';
  static const insttNmKey = 'INSTT_NM';
  static const insttTyKey = 'INSTT_TY';
  static const userSeCdKey = 'USER_SE_CD';

  // =========================
  // Token
  // =========================

  /// AccessToken / RefreshToken 저장
  ///
  /// 로그인 성공 시 사용
  Future<void> writeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: accessTokenKey, value: accessToken);
    await _storage.write(key: refreshTokenKey, value: refreshToken);
  }

  /// AccessToken만 갱신
  ///
  /// 응답 헤더에서 새 토큰이 내려올 경우 사용
  Future<void> writeAccessToken(String accessToken) async {
    await _storage.write(key: accessTokenKey, value: accessToken);
  }

  /// RefreshToken만 갱신
  ///
  /// 응답 헤더에서 새 RefreshToken이 내려올 경우 사용
  Future<void> writeRefreshToken(String refreshToken) async {
    await _storage.write(key: refreshTokenKey, value: refreshToken);
  }

  /// 저장된 Token 조회
  ///
  /// Dio Interceptor에서 사용
  /// Authorization Header 생성용
  Future<AuthTokens?> readTokens() async {
    final accessToken = await _storage.read(key: accessTokenKey);
    final refreshToken = await _storage.read(key: refreshTokenKey);

    if (accessToken == null ||
        accessToken.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty) {
      return null;
    }

    return AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
  }

  // =========================
  // Login Info
  // =========================

  /// 로그인 정보 전체 저장
  ///
  /// - 토큰 저장
  /// - 자동로그인 여부 저장
  /// - 사용자 프로필 저장
  Future<void> writeLoginInfo({
    required bool autoLogin,
    required String accessToken,
    required String refreshToken,
    String? userId,
    String? userNm,
    String? loginId,
    String? email,
    String? insttId,
    String? insttNm,
    String? insttTy,
    String? userSeCd,
  }) async {
    await writeTokens(accessToken: accessToken, refreshToken: refreshToken);

    await _storage.write(key: autoLoginKey, value: autoLogin ? 'Y' : 'N');

    await _storage.write(key: userIdKey, value: userId);
    await _storage.write(key: userNmKey, value: userNm);
    await _storage.write(key: loginIdKey, value: loginId);
    await _storage.write(key: emailKey, value: email);
    await _storage.write(key: insttIdKey, value: insttId);
    await _storage.write(key: insttNmKey, value: insttNm);
    await _storage.write(key: insttTyKey, value: insttTy);
    await _storage.write(key: userSeCdKey, value: userSeCd);
  }

  /// 자동로그인용 정보 조회
  ///
  /// 앱 시작 시 AuthController.initialize()에서 사용
  Future<StoredLoginInfo?> readLoginInfo() async {
    final autoLogin = await _storage.read(key: autoLoginKey) == 'Y';

    // 자동로그인 미사용
    if (!autoLogin) {
      return null;
    }

    final tokens = await readTokens();

    // 토큰 없음
    if (tokens == null) {
      return null;
    }

    return StoredLoginInfo(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      userId: await _storage.read(key: userIdKey),
      userNm: await _storage.read(key: userNmKey),
      loginId: await _storage.read(key: loginIdKey),
      email: await _storage.read(key: emailKey),
      insttId: await _storage.read(key: insttIdKey),
      insttNm: await _storage.read(key: insttNmKey),
      insttTy: await _storage.read(key: insttTyKey),
      userSeCd: await _storage.read(key: userSeCdKey),
    );
  }

  // =========================
  // Logout
  // =========================

  /// 저장된 로그인 정보 전체 삭제
  ///
  /// 로그아웃 시 사용
  Future<void> clear() async {
    await _storage.delete(key: accessTokenKey);
    await _storage.delete(key: refreshTokenKey);
    await _storage.delete(key: autoLoginKey);

    await _storage.delete(key: userIdKey);
    await _storage.delete(key: userNmKey);
    await _storage.delete(key: loginIdKey);
    await _storage.delete(key: emailKey);
    await _storage.delete(key: insttIdKey);
    await _storage.delete(key: insttNmKey);
    await _storage.delete(key: insttTyKey);
    await _storage.delete(key: userSeCdKey);
  }
}

/// Dio Authorization Header 생성용 Token 객체
class AuthTokens {
  const AuthTokens({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;
}

/// 자동로그인 복원 시 사용하는 사용자 정보 객체
class StoredLoginInfo {
  const StoredLoginInfo({
    required this.accessToken,
    required this.refreshToken,
    this.userId,
    this.userNm,
    this.loginId,
    this.email,
    this.insttId,
    this.insttNm,
    this.insttTy,
    this.userSeCd,
  });

  final String accessToken;
  final String refreshToken;

  final String? userId;
  final String? userNm;
  final String? loginId;
  final String? email;
  final String? insttId;
  final String? insttNm;
  final String? insttTy;
  final String? userSeCd;
}
