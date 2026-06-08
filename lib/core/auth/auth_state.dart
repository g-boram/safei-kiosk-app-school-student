/// 로그인 상태 종류
///
/// unknown
///   앱 시작 직후
///   자동로그인 여부 확인중
///
/// unauthenticated
///   로그인 안된 상태
///
/// authenticated
///   로그인 완료 상태
enum AuthStatus { unknown, unauthenticated, authenticated }

/// 로그인 상태 객체
///
/// Riverpod 상태로 사용됨
class AuthState {
  final AuthStatus status;
  final String? accessToken;
  final bool autoLogin;

  // 로그인 성공 후 프로필에서 사용할 사용자 정보
  final String? userId;
  final String? userNm;
  final String? loginId;
  final String? email;
  final String? insttId;
  final String? insttNm;
  final String? insttTy;
  final String? userSeCd;

  const AuthState({
    required this.status,
    this.accessToken,
    this.autoLogin = false,
    this.userId,
    this.userNm,
    this.loginId,
    this.email,
    this.insttId,
    this.insttNm,
    this.insttTy,
    this.userSeCd,
  });

  /// 앱 시작 직후
  factory AuthState.unknown() {
    return const AuthState(status: AuthStatus.unknown);
  }

  /// 로그인 안됨
  factory AuthState.unauthenticated() {
    return const AuthState(status: AuthStatus.unauthenticated);
  }

  /// 로그인 완료
  factory AuthState.authenticated({
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
  }) {
    return AuthState(
      status: AuthStatus.authenticated,
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
  }
}
