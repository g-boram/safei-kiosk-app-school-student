// lib/features/emotion/model/emotion_record.dart

class EmotionRecord {
  final int id;
  final DateTime date;
  final String time;
  final String emoji;
  final String emotionName;
  final int level;
  final String description;
  final String? memo;

  const EmotionRecord({
    required this.id,
    required this.date,
    required this.time,
    required this.emoji,
    required this.emotionName,
    required this.level,
    required this.description,
    this.memo,
  });

  EmotionRecord copyWith({
    int? id,
    DateTime? date,
    String? time,
    String? emoji,
    String? emotionName,
    int? level,
    String? description,
    String? memo,
  }) {
    return EmotionRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      emoji: emoji ?? this.emoji,
      emotionName: emotionName ?? this.emotionName,
      level: level ?? this.level,
      description: description ?? this.description,
      memo: memo ?? this.memo,
    );
  }
}
