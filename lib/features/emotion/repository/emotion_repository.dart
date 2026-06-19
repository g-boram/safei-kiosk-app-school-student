// lib/features/emotion/repository/emotion_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/dio/api_response.dart';
import '../../../core/dio/dio.dart';
import '../model/emotion_models.dart';

final emotionRepositoryProvider = Provider<EmotionRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return EmotionRepository(dio);
});

class EmotionRepository {
  EmotionRepository(this._dio);

  final Dio _dio;

  /// 감정 목록 조회
  Future<ApiResponse<List<EmotionIdNameDto>>> getEmotionList() async {
    final response = await _dio.post<Map<String, dynamic>>(
      'user/teacher/emotion/list',
    );

    return ApiResponse<List<EmotionIdNameDto>>.fromJson(response.data!, (json) {
      final list = json as List? ?? const [];

      return list
          .map(
            (item) => EmotionIdNameDto.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    });
  }

  /// 감정 단계 조회
  Future<ApiResponse<List<EmotionStepDto>>> getEmotionSteps({
    required String emotionId,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      'user/teacher/emotion/step',
      data: {'emtSeId': emotionId},
    );

    return ApiResponse<List<EmotionStepDto>>.fromJson(response.data!, (json) {
      final list = json as List? ?? const [];

      return list
          .map((item) => EmotionStepDto.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }

  /// 감정 체크 등록
  Future<ApiResponse<dynamic>> registEmotion({
    required String emotionId,
    required int step,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      'user/teacher/emotion/rgst',
      data: {'emtSeId': emotionId, 'emtStep': step},
    );

    return ApiResponse<dynamic>.fromJson(response.data!, (json) => json);
  }
}
