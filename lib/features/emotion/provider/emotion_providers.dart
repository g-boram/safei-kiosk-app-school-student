// lib/features/emotion/provider/emotion_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/emotion_models.dart';
import '../repository/emotion_repository.dart';
import '../utils/emotion_assets.dart';
import '../utils/emotion_palette.dart';

final emotionListProvider = FutureProvider<List<EmotionIdName>>((ref) async {
  final repository = ref.watch(emotionRepositoryProvider);
  final response = await repository.getEmotionList();

  if (!response.isSuccess) {
    throw Exception(response.userMessage(fallback: '감정 목록을 불러오지 못했어요.'));
  }

  final list = response.data ?? const <EmotionIdNameDto>[];

  return list.map((dto) {
    final color = EmotionPalette.byCode(dto.emtSeCd);

    return EmotionIdName(
      id: dto.emtSeId,
      name: dto.emtSeNm,
      code: dto.emtSeCd,
      image: EmotionAssets.imageByCode(dto.emtSeCd),
      color: color.value,
    );
  }).toList();
});

final emotionDetailProvider = FutureProvider.family<Emotion, String>((
  ref,
  emotionId,
) async {
  final repository = ref.watch(emotionRepositoryProvider);

  final list = await ref.watch(emotionListProvider.future);
  final base = list.firstWhere((e) => e.id == emotionId);

  final response = await repository.getEmotionSteps(emotionId: emotionId);

  if (!response.isSuccess) {
    throw Exception(response.userMessage(fallback: '감정 단계를 불러오지 못했어요.'));
  }

  final stepDtos = response.data ?? const <EmotionStepDto>[];
  final steps = <int, List<String>>{};

  for (final step in stepDtos) {
    steps[step.emtStep] = step.emtStepDtlList;
  }

  return Emotion(
    id: base.id,
    name: base.name,
    code: base.code,
    image: base.image,
    color: base.color,
    steps: steps,
  );
});
