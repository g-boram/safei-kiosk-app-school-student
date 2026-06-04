// lib/features/login/model/login_response.dart

class LoginSuccessData {
  final String userId;
  final String userNm;
  final String userSeCd;
  final String loginId;
  final String email;

  final String? insttId;
  final String? insttNm;
  final String? insttTy;
  final String? insttTyCd;

  final String accessToken;
  final String refreshToken;

  final List<String>? authTyCd;
  final String? initPwdAt;
  final String? nation;
  final String? lang;
  final String? tz;
  final String? parentEmail;

  const LoginSuccessData({
    required this.userId,
    required this.userNm,
    required this.userSeCd,
    required this.loginId,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    this.insttId,
    this.insttNm,
    this.insttTy,
    this.insttTyCd,
    this.authTyCd,
    this.initPwdAt,
    this.nation,
    this.lang,
    this.tz,
    this.parentEmail,
  });

  factory LoginSuccessData.fromJson(Map<String, dynamic> json) {
    return LoginSuccessData(
      userId: json['userId']?.toString() ?? '',
      userNm: json['userNm']?.toString() ?? '',
      userSeCd: json['userSeCd']?.toString() ?? '',
      loginId: json['loginId']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      insttId: json['insttId']?.toString(),
      insttNm: json['insttNm']?.toString(),
      insttTy: json['insttTy']?.toString(),
      insttTyCd: json['insttTyCd']?.toString(),
      authTyCd: (json['authTyCd'] as List?)?.map((e) => e.toString()).toList(),
      initPwdAt: json['initPwdAt']?.toString(),
      nation: json['nation']?.toString(),
      lang: json['lang']?.toString(),
      tz: json['tz']?.toString(),
      parentEmail: json['parentEmail']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userNm': userNm,
      'userSeCd': userSeCd,
      'loginId': loginId,
      'email': email,
      'insttId': insttId,
      'insttNm': insttNm,
      'insttTy': insttTy,
      'insttTyCd': insttTyCd,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'authTyCd': authTyCd,
      'initPwdAt': initPwdAt,
      'nation': nation,
      'lang': lang,
      'tz': tz,
      'parentEmail': parentEmail,
    };
  }
}
