// lib/core/dio/dio.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../storage/storage_provider.dart';
import 'network.dart';

final dioProvider = Provider<Dio>((ref) {
  final authStorage = ref.watch(authStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: resolveBaseUrl(),
      headers: {'Content-Type': 'application/json', 'Accept-Language': 'ko'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final noAuth = options.headers['noAuth'] == true;

        if (!noAuth) {
          final tokens = await authStorage.readTokens();

          debugPrint('===== DIO TOKEN CHECK =====');
          debugPrint('url: ${options.uri}');
          debugPrint('hasTokens: ${tokens != null}');
          debugPrint('===========================');

          if (tokens != null) {
            options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
            options.headers['Refresh-Token'] = tokens.refreshToken;
          }
        }

        // 서버로 전달되지 않도록 내부 플래그 제거
        options.headers.remove('noAuth');

        handler.next(options);
      },
      onResponse: (response, handler) async {
        final newAuth = response.headers.value('Authorization');
        final newRefresh = response.headers.value('Refresh-Token');

        if (newAuth != null && newAuth.isNotEmpty) {
          await authStorage.writeAccessToken(_normalizeAccessToken(newAuth));
        }

        if (newRefresh != null && newRefresh.isNotEmpty) {
          await authStorage.writeRefreshToken(newRefresh);
        }

        handler.next(response);
      },
      onError: (err, handler) async {
        debugPrint('[DIO ERROR] ${err.message}');

        // 에러 응답에도 갱신 토큰이 내려오는 경우 대비
        final newAuth = err.response?.headers.value('Authorization');
        final newRefresh = err.response?.headers.value('Refresh-Token');

        if (newAuth != null && newAuth.isNotEmpty) {
          await authStorage.writeAccessToken(_normalizeAccessToken(newAuth));
        }

        if (newRefresh != null && newRefresh.isNotEmpty) {
          await authStorage.writeRefreshToken(newRefresh);
        }

        handler.next(err);
      },
    ),
  );

  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
      compact: true,
      maxWidth: 120,
    ),
  );

  return dio;
});

String _normalizeAccessToken(String authorizationHeader) {
  final value = authorizationHeader.trim();

  if (value.toLowerCase().startsWith('bearer ')) {
    return value.substring(7).trim();
  }

  return value;
}
