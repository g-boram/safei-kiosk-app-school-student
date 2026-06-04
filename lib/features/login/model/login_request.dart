// lib/features/login/model/login_request.dart

class LoginRequest {
  final String loginId;
  final String crtfcKey;
  final String crtfcSeCd;
  final String loginTy;

  const LoginRequest({
    required this.loginId,
    required this.crtfcKey,
    this.crtfcSeCd = 'PWD',
    this.loginTy = 'MANAGER',
  });

  Map<String, dynamic> toJson() {
    return {
      'loginId': loginId,
      'crtfcKey': crtfcKey,
      'crtfcSeCd': crtfcSeCd,
      'loginTy': loginTy,
    };
  }
}
