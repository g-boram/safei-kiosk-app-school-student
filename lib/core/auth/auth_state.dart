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
  const AuthState({
    required this.status,
    this.accessToken,
    this.autoLogin = false,
  });

  /// 현재 로그인 상태
  final AuthStatus status;

  /// 로그인 성공 후 받은 토큰
  final String? accessToken;

  /// 자동로그인 체크 여부
  final bool autoLogin;

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
  }) {
    return AuthState(
      status: AuthStatus.authenticated,
      accessToken: accessToken,
      autoLogin: autoLogin,
    );
  }

  AuthState copyWith({
    AuthStatus? status,
    String? accessToken,
    bool? autoLogin,
  }) {
    return AuthState(
      status: status ?? this.status,
      accessToken: accessToken ?? this.accessToken,
      autoLogin: autoLogin ?? this.autoLogin,
    );
  }
}
