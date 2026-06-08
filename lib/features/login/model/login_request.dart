// lib/features/login/model/login_request.dart

class LoginRequest {
  final String loginId;
  final String crtfcKey;
  final String loginTy;

  const LoginRequest({
    required this.loginId,
    required this.crtfcKey,
    required this.loginTy,
  });

  Map<String, dynamic> toJson() {
    return {'loginId': loginId, 'crtfcKey': crtfcKey, 'loginTy': loginTy};
  }
}
