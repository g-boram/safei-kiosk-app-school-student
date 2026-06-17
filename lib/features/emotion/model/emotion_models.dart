// lib/features/emotion/model/emotion_models.dart

class EmotionIdNameDto {
  final String emtSeId;
  final String emtSeNm;
  final String emtSeCd;

  const EmotionIdNameDto({
    required this.emtSeId,
    required this.emtSeNm,
    required this.emtSeCd,
  });

  factory EmotionIdNameDto.fromJson(Map<String, dynamic> json) {
    return EmotionIdNameDto(
      emtSeId: json['emtSeId']?.toString() ?? '',
      emtSeNm: json['emtSeNm']?.toString() ?? '',
      emtSeCd: json['emtSeCd']?.toString() ?? '',
    );
  }
}

class EmotionStepDto {
  final String emtSeId;
  final int emtStep;
  final String emtStepNm;
  final List<String> emtStepDtlList;

  const EmotionStepDto({
    required this.emtSeId,
    required this.emtStep,
    required this.emtStepNm,
    required this.emtStepDtlList,
  });

  factory EmotionStepDto.fromJson(Map<String, dynamic> json) {
    return EmotionStepDto(
      emtSeId: json['emtSeId']?.toString() ?? '',
      emtStep: int.tryParse(json['emtStep']?.toString() ?? '') ?? 1,
      emtStepNm: json['emtStepNm']?.toString() ?? '',
      emtStepDtlList:
          (json['emtStepDtlList'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}

class EmotionIdName {
  final String id;
  final String name;
  final String code;
  final String? image;
  final int color;

  const EmotionIdName({
    required this.id,
    required this.name,
    required this.code,
    required this.color,
    this.image,
  });
}

class Emotion {
  final String id;
  final String name;
  final String code;
  final String? image;
  final int color;
  final Map<int, List<String>> steps;

  const Emotion({
    required this.id,
    required this.name,
    required this.code,
    required this.color,
    required this.steps,
    this.image,
  });
}
