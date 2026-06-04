// lib/features/login/repository/login_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/dio/api_response.dart';
import '../../../core/dio/dio.dart';
import '../model/login_request.dart';
import '../model/login_response.dart';

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return LoginRepository(dio);
});

class LoginRepository {
  LoginRepository(this._dio);

  final Dio _dio;

  Future<ApiResponse<LoginSuccessData>> login(LoginRequest body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      'pub/login/general',
      data: body.toJson(),
      options: Options(headers: {'noAuth': true}),
    );

    return ApiResponse<LoginSuccessData>.fromJson(
      response.data!,
      (json) => LoginSuccessData.fromJson(json as Map<String, dynamic>),
    );
  }
}
