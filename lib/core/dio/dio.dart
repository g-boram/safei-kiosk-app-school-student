// lib/core/dio/dio.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../storage/auth_storage_provider.dart';
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

          if (tokens != null) {
            options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
            options.headers['Refresh-Token'] = tokens.refreshToken;
          }
        }

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
      onError: (err, handler) {
        debugPrint('[DIO ERROR] ${err.message}');
        handler.next(err);
      },
    ),
  );

  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
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
